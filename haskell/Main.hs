module Main (main) where

import Data.Complex
import qualified Data.ByteString.Lazy as B
import Data.Text.Lazy.Encoding (encodeUtf8)
import Text.Printf (printf)
import Data.Text.Lazy (pack)

i_n :: Int
i_n = 128

side :: Int
side = 1024


center :: Complex Float
center = 0.4 :+ 0.4

scale :: Float
scale = 0.3

(/.) :: Int -> Int -> Float
a /. b = fromIntegral a / fromIntegral b

solvePixel :: Int -> Float
solvePixel n = res / fromIntegral i_n
  where
    mvax a = a /. side * 2 * scale - scale
    x = n `mod` side
    y = n `div` side
    c = (mvax x :+  mvax y) + center
    steps = iterate (\z -> z ** 2 + c) 0
    res = fromIntegral . length . takeWhile  ((< 2) . magnitude) . take i_n $ steps

main :: IO ()
main = do
  let floats = concatMap (replicate 3) $  (+ 1) . negate . solvePixel <$> [0..side*side-1]
  let bytes = B.pack $ floor . (* 255 ) <$>  floats
  print $ "Length " <> show (B.length bytes)
  B.writeFile "out.ppm" $ B.append ( encodeUtf8 . pack $ printf "P6 %d %d 255 " side side ) bytes
