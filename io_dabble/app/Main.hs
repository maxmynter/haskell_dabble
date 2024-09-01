module Main where

data UserAction = Quit | Help | ListEntries | ToggleN Int | AddTask String

data Task = Task {description :: String, done :: Bool, idx :: Int} deriving (Show)

newtype Entries = Entries [Task] deriving (Show)

instance Semigroup Entries where
  (Entries t1) <> (Entries t2) = Entries (t1 ++ t2)

entriesLength :: Entries -> Int
entriesLength (Entries entries) = length entries

printTaskCheckbox :: Task -> String
printTaskCheckbox task = if done task then "-- [" ++ "x" ++ "] " else "-- [ ] "

printTask :: Task -> IO ()
printTask task = putStrLn $ printTaskCheckbox task ++ description task

printEntries :: Entries -> IO ()
printEntries (Entries []) = return ()
printEntries (Entries es) = do
  printTask $ head es
  printEntries $ Entries $ tail es

addTask :: Entries -> Task -> Entries
addTask (Entries entries) entry = Entries (entries ++ [entry])

entriesToggleDoneAt :: Entries -> Int -> Entries
entriesToggleDoneAt (Entries es) n = Entries (toggleAt es n)
  where
    toggleAt [] _ = []
    toggleAt (t : ts) indx
      | indx == 0 = t {done = not (done t)} : ts
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

castUserAction :: String -> UserAction
castUserAction actionStr = case actionStr of
  ':' : cmd -> case cmd of
    "q" -> Quit
    "l" -> ListEntries
    n -> ToggleN $ read n
  "?" -> Help
  task -> AddTask task

entryLoop :: Entries -> IO ()
entryLoop entries = do
  printActions
  input <- getLine
  case castUserAction input of
    Quit -> putStrLn "Good Bye"
    Help -> do
      printHelp
      entryLoop entries
    ListEntries -> do
      printEntries entries
      entryLoop entries
    ToggleN n -> entryLoop $ entriesToggleDoneAt entries n
    AddTask task -> entryLoop $ addTask entries (Task task False (1 + entriesLength entries))

main :: IO ()
main = entryLoop $ Entries []
