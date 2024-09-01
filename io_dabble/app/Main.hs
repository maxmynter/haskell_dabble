module Main where

import Text.Read (readMaybe)

data UserAction = Quit | Help | ListEntries | ToggleN Int | AddTask String

newtype Task = Task {unTask :: (String, Bool, Int)} deriving (Show)

newtype Entries = Entries [Task] deriving (Show)

instance Semigroup Entries where
  (Entries t1) <> (Entries t2) = Entries (t1 ++ t2)

entriesLength :: Entries -> Int
entriesLength (Entries entries) = length entries

printTaskCheckbox :: Task -> String
printTaskCheckbox task = if getDone task then "-- [" ++ "x" ++ "] " else "-- [ ] "

printTask :: Task -> IO ()
printTask task = putStrLn $ printTaskCheckbox task ++ getDescription task

printEntries :: Entries -> IO ()
printEntries (Entries []) = return ()
printEntries (Entries es) = do
  printTask $ head es
  printEntries $ Entries $ tail es

addTask :: Entries -> Task -> Entries
addTask (Entries entries) entry = Entries (entries ++ [entry])

updateTask :: Task -> (String -> String) -> (Bool -> Bool) -> (Int -> Int) -> Task
updateTask (Task (desc, done, idx)) upDesc upDone upIdx = Task (upDesc desc, upDone done, upIdx idx)

getDescription :: Task -> String
getDescription = (\(d, _, _) -> d) . unTask

getDone :: Task -> Bool
getDone = (\(_, d, _) -> d) . unTask

getIdx :: Task -> Int
getIdx = (\(_, _, i) -> i) . unTask

entriesToggleDoneAt :: Entries -> Int -> Entries
entriesToggleDoneAt (Entries es) n = Entries (toggleAt es n)
  where
    toggleAt [] _ = []
    toggleAt (t : ts) indx
      | indx == 0 = updateTask t id not id : ts
      | indx > 0 = [t] <> toggleAt ts (indx - 1)
      | otherwise = t : ts

printActions :: IO ()
printActions = do
  putStrLn "Type task and Return to submit."
  putStrLn "'?' for help."

printHelp :: IO ()
printHelp = do
  putStrLn "Commands are preceeded by a colon (:). Available commands"
  putStrLn "`:q` to quit"
  putStrLn "`:l` to list entries"
  putStrLn "`:<n>` to toggle done status of task n"

castUserAction :: String -> Maybe UserAction
castUserAction actionStr = case actionStr of
  ':' : cmd -> case cmd of
    "q" -> Just Quit
    "l" -> Just ListEntries
    n -> do
      case readMaybe n of
        Just num -> Just $ ToggleN num
        Nothing -> Nothing
  "?" -> Just Help
  task -> Just $ AddTask task

entryLoop :: Entries -> IO ()
entryLoop entries = do
  printActions
  input <- getLine
  case castUserAction input of
    Just Quit -> putStrLn "Good Bye"
    Just Help -> do
      printHelp
      entryLoop entries
    Just ListEntries -> do
      printEntries entries
      entryLoop entries
    Just (ToggleN n) -> entryLoop $ entriesToggleDoneAt entries n
    Just (AddTask task) -> entryLoop $ addTask entries (Task (task, False, 1 + entriesLength entries))
    Nothing -> do
      putStrLn $ "Invalid Input " ++ input
      putStrLn "Type '?' for help."
      entryLoop entries

main :: IO ()
main = entryLoop $ Entries []
