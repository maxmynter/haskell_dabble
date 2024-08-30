module Main where

import System.Environment (getArgs)
import TimeTracker

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["start"] -> startTracking tracker
    ["stop"] -> stopTracking tracker
    _ -> printUsage

startTracking :: TimeTracker -> IO ()
startTracking tracker = case currentTask tracker of
  Just _ -> putStrLn "Currently working on task. Stop it before starting a new one"
  Nothing -> do
    task <- createTask "Untitled Task"
    let updatedTracker = tracker {currentTask = Just task}
    saveTracker updatedTracker
    putStrLn "Tracking Time"

stopTracking :: TimeTracker -> IO ()
stopTracking tracker = case currentTask tracker of
  Nothing -> putStrLn "No task in progress"
  Just task -> do
    putStrLn "Enter project Name"
    project <- getLine
    putStr "Enter activity: "
    activity <- getLine
    stoppedTask <- stopTask task project activity
    let updatedTracker = addCompletedTask (tracker {currentTask = Nothing}) stoppedTask
    putStrLn "Stopped Task"
