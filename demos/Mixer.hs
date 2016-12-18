module Main where

import Csound.Base
import Csound.Sam

main = dac $ do
   (g, res) <- mixer $ 
          fmap (\x -> mixMono 
                 (show x) 
                 (osc $ sig $ int x)) 
               [220, 330, 440]
   win "mixer" (600, 300) g
   return $ mul 0.5 $ res
