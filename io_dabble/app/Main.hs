module Main where

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
      | indx == 0 = Task (description t) (not $ done t) (idx t) : ts
      | indx > 0 = [t] <> toggleAt ts (indx - 1)
      | otherwise = t : ts

entryLoop :: Entries -> IO ()
entryLoop entries = do
  putStrLn "Menu!"
  putStrLn "Type..."
  putStrLn "entry to add to entries"
  putStrLn "`:q` to quit"
  putStrLn "`:l` to list entries"
  putStrLn "`:<n>` to toggle done status of task n"
  input <- getLine
  case input of
    ":q" -> putStrLn "Good Bye"
    ":l" -> do
      printEntries entries
      entryLoop entries
    ':' : n -> do
      entryLoop $ entriesToggleDoneAt entries (read n)
    typed -> do
      putStrLn "Entries: "
      entryLoop $ addTask entries (Task typed False (1 + entriesLength entries))

main :: IO ()
main = entryLoop $ Entries []
