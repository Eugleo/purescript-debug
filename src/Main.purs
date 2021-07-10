module Main where

import Prelude
import Data.String (length)
import Debug (spy, traceM)
import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = do
  log "🍝"
  log $ show $ someFunc "First you'll see the spy" "then you'll see the length logged by log"
  traceM [ 1, 2, 3, 4 ]

{-
  Typ "printu" je log :: String -> Effect Unit.

  Ten "Effekt" tam je jako taková nálepka, která říká "Pozor, tady se děje něco nekalého",
  konkrétně "Interakce se světem" (to je vždycky nekalé, protože nevíte, co se kde pokazí).

  Je to tedy pro bezpečnost — když interagujete se světem, jde to jen za vytvoření Effektu,
  a téhle nálepky se by design nedá zbavit.
  Jinak by to byla houby záruka bezpečnosti, kdybyste ji mohli odignorovat.

  Co když ale chcete jen něco někde dočasně vyprintovat, aniž byste tu funkci (a všechny nad ní)
  zabalovali do Effektu? Představuji vám modul Debug.
-}
concatAndMeasure :: String -> String -> Int -- Žádný Effekt, zato tady máme warning, abychom tam ten debug nezapomněli
concatAndMeasure a b = length (spy "a bylo" a <> spy "b bylo" b)

-- https://pursuit.purescript.org/packages/purescript-debug/5.0.0/docs/Debug
