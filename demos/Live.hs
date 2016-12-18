module Main where

import Csound.Base
import Csound.Sam

b1 = infSig1 $ sqr 220
b2 = infSig1 $ sqr 330
b3 = infSig1 $ sqr 440

c1 = infSig1 $ tri 220
c2 = infSig1 $ tri 330
c3 = infSig1 $ tri 440

main = dac $ do
    (g, sam) <- live 4 ["triangle", "square"]
       [ c1, b1
       , c2, b3
       , c3, b3]
    panel g
    mul 0.3 $ runSam 120 sam
