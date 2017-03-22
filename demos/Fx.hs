module Main where

import Csound.Base
import Csound.Sam

main = dac $ do
   (gui, fx) <- fxHor
      [ uiFilter False 0.5 0.5 0.5
      , uiChorus False 0.5 0.5 0.5 0.5
      , uiPhaser True 0.5 0.5 0.5 0.5
      , uiReverb True 0.5 0.5
      , uiGain 0.5
      ]
 
   win "main" (900, 400) gui
   fx $ fromMono $ saw 110
