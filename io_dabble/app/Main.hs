module Main where

newtype Entry = Entry String deriving (Show)

newtype Entries = Entries [Entry] deriving (Show)

printEntry :: Entry -> IO ()
printEntry (Entry s) = putStrLn s

printEntries :: Entries -> IO ()
printEntries (Entries []) = return ()
printEntries (Entries es) = do
  printEntry $ head es
  printEntries $ Entries $ tail es

entryLoop :: Entries -> IO ()
entryLoop (Entries entries) = do
  putStrLn "Type Something"
  input <- getLine
  let allEntries = Entries (entries ++ [Entry input])
  putStrLn "All entries so far: "
  printEntries allEntries
  entryLoop allEntries

main :: IO ()
main = entryLoop $ Entries []
