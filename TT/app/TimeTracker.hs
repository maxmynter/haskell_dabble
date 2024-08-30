module TimeTracker where

import Data.Time
import Data.Time.Clock.POSIX

data Task = Task
  { name :: String,
    project :: Maybe String,
    message :: Maybe String,
    startTime :: UTCTime,
    endTime :: Maybe UTCTime
  }

data TimeTracker = TimeTracker
  { currentTask :: Maybe Task,
    completedTasks :: [Task]
  }
  deriving (Show, Eq)

startTask :: String -> IO Task
startTask name = do
  now <- getCurrentTime
  return $ Task name Nothing Nothing now Nothing

stopTask :: Task -> String -> String -> String -> IO Task
stopTask task project msg = do
  now <- getCurrentTime
  return $ task {endTime = Just now, project = Just project, message = Just msg}

taskDuration :: Task -> Maybe NominalDiffTime
taskDuration task = do
  end <- endTime task
  return $ diffUTCTime end (startTime task)
