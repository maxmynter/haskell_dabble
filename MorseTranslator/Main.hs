module Main where

import Data.Char (toUpper)
import Data.Map qualified as Map
import Mapping (toMorse, toText)

charToMorse :: Char -> Maybe String
charToMorse c = Map.lookup (toUpper c) toMorse

stringToMorse :: String -> Maybe String
stringToMorse s = case traverse charToMorse s of
  Nothing -> Nothing
  Just morse -> Just (unwords morse)

morseToChar :: String -> Maybe Char
morseToChar m = Map.lookup m toText

morseToString :: String -> Maybe String
morseToString = traverse morseToChar . words

translateLoop :: IO ()
translateLoop = do
  putStrLn "type `tm` to translate text to morse code, `mt` to translate morse to text."
  choice <- getLine
  case choice of
    "tm" -> do
      putStrLn "Enter Text:   "
      input <- getLine
      case stringToMorse input of
        Just morse -> putStrLn morse
        Nothing -> putStrLn "Error parsing text"
      translateLoop
    "mt" -> do
      putStrLn "Enter Morse Code:  "
      input <- getLine
      case morseToString input of
        Just text -> putStrLn text
        Nothing -> putStrLn "Error parsing morse code"
      translateLoop
    _ -> do
      putStrLn "Invalid choice, try again"
      translateLoop

main :: IO ()
main = do
  putStrLn "Morse Code Translator"
  translateLoop
