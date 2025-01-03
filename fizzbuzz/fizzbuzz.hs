crackle :: String
crackle = "Crackle"

pop :: String
pop = "Pop"

cracklePopify :: Int -> String
cracklePopify n = case (n `mod` 3, n `mod` 5) of
  (0, 0) -> crackle ++ pop
  (0, _) -> crackle
  (_, 0) -> pop
  _ -> show n

generateSequence :: Int -> [String]
generateSequence = map cracklePopify . enumFromTo 1

main :: IO ()
main = do
  let cracklePops = generateSequence 100
  putStrLn . unlines $ cracklePops
