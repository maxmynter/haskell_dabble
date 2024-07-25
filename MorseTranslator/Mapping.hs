module Mapping (toMorse, toText) where

import Data.Map qualified as Map

toMorse :: Map.Map Char String
toMorse =
  Map.fromList
    [ ('A', ".-"),
      ('B', "-..."),
      ('C', "-.-."),
      ('D', "-.."),
      ('E', "."),
      ('F', "..-."),
      ('G', "--."),
      ('H', "...."),
      ('I', ".."),
      ('J', ".---"),
      ('K', "-.-"),
      ('L', ".-.."),
      ('M', "--"),
      ('N', "-."),
      ('O', "---"),
      ('P', ".--."),
      ('Q', "--.-"),
      ('R', ".-."),
      ('S', "..."),
      ('T', "-"),
      ('U', "..-"),
      ('V', "...-"),
      ('W', ".--"),
      ('X', "-..-"),
      ('Y', "-.--"),
      ('Z', "--.."),
      ('0', "-----"),
      ('1', ".----"),
      ('2', "..---"),
      ('3', "...--"),
      ('4', "....-"),
      ('5', "....."),
      ('6', "-...."),
      ('7', "--..."),
      ('8', "---.."),
      ('9', "----."),
      (' ', " "), -- space
      ('.', ".-.-.-"),
      (',', "--..--"),
      ('?', "..--.."),
      ('!', "-.-.--"),
      ('/', "-..-."),
      ('(', "-.--."),
      (')', "-.--.-"),
      ('&', ".-..."),
      (':', "---..."),
      (';', "-.-.-."),
      ('=', "-...-"),
      ('+', ".-.-."),
      ('-', "-....-"),
      ('_', "..--.-"),
      ('"', ".-..-."),
      ('$', "...-..-"),
      ('@', ".--.-.")
    ]

toText :: Map.Map String Char
toText = Map.fromList $ map (\(a, b) -> (b, a)) $ Map.toList toMorse
