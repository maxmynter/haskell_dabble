module Main where

newtype Entry = Entry String

newtype Entries = Entries [Entry]

printEntries :: Entries -> IO ()
printEntries (Entries (Entry a) : (Entries b)) = do
  putStrLn a
  printEntries b
  return ()

entryLoop :: Entries -> IO Entries
entryLoop (Entries entries) = do
  putStrLn "Type Something"
  inpt <- getLine
  allEntries <- Entries (entries ++ [Entry inpt])
  putStrLn $ "You typed " ++ inpt
  entryLoop allEntries

main :: IO Entries
main = entryLoop $ Entries []
