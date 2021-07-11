module Main where

import Prelude
import Data.String (length)
import Debug (spy, traceM)
import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = do
  log "🍝"
  log $ show $ concatAndMeasure "First you'll see the spy" "then you'll see the length logged by log"
  traceM [ 1, 2, 3, 4 ]

concatAndMeasure :: String -> String -> Int -- Žádný Effekt, zato tady máme warning, abychom tam ten debug nezapomněli
concatAndMeasure a b = length (spy "a bylo" a <> spy "b bylo" b)
