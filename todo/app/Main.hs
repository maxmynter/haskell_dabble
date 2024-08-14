module Main (main) where

import System.Directory (doesFileExist)
import System.IO (hFlush, stdout)

type Task = (Int, String, Bool)

main :: IO ()
main = do
  tasks <- loadTasks
  menuLoop tasks

loadTasks :: IO [Task]
loadTasks = do
  fileExists <- doesFileExist "tasks.txt"
  if fileExists
    then do
      contents <- readFile "tasks.txt"
      return $ read contents
    else do
      writeFile "tasks.txt" "[]"
      return []

saveTasks :: [Task] -> IO ()
saveTasks tasks = writeFile "tasks.txt" (show tasks)

menuLoop :: [Task] -> IO ()
menuLoop tasks = do
  putStrLn "\n--- ToDo ---"
  putStrLn "1. Add"
  putStrLn "2. View"
  putStrLn "3. Complete"
  putStrLn "4. Exit"
  hFlush stdout
  choice <- getLine
  case choice of
    "1" -> addTask tasks
    "2" -> viewTasks tasks
    "3" -> completeTask tasks
    "4" -> saveTasks tasks >> putStrLn "Cheers!"
    _ -> putStrLn "Invalid Choide" >> menuLoop tasks

viewTasks :: [Task] -> IO ()
viewTasks tasks = do
  putStrLn "\nCurrent Tasks:"
  mapM_ (\(taskId, desc, done) -> putStrLn $ show taskId ++ ". [" ++ (if done then "x" else " ") ++ "]" ++ desc) tasks
  menuLoop tasks

completeTask :: [Task] -> IO ()
completeTask tasks = do
  putStr "Enter task ID to complete: "
  hFlush stdout
  idStr <- getLine
  let taskId = read idStr
  let newTasks = map (\(tid, desc, done) -> if tid == taskId then (tid, desc, True) else (tid, desc, done)) tasks
  putStrLn "Completed"
  menuLoop newTasks

addTask :: [Task] -> IO ()
addTask tasks = do
  putStr "Enter new Task"
  hFlush stdout
  desc <- getLine
  let newId = if null tasks then 1 else maximum (map (\(tid, _, _) -> tid) tasks) + 1
  let newTasks = tasks ++ [(newId, desc, False)]
  putStrLn "Added"
  menuLoop newTasks
