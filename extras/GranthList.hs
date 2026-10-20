-- Standalone sample; not part of the app build.
module Main where

granths :: [String]
granths = ["Gita", "Kabir Sagar", "Ved"]

main :: IO ()
main = mapM_ (\(i, g) -> putStrLn (show i ++ ". " ++ g)) (zip [1 :: Int ..] granths)
-- Granth list sample — prints titles in order.
