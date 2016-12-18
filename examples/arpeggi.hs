-- radiohead - weird fishes (intro)

import Csound.Base
import Orchestra
import P12 

-- accent every fourth beat
beat = cycle [accent 0.5, id, id, id]

-- chords

-- guitar 1

guitarChord1 = mel . zipWith ($) beat . map en . concat . replicate 10

wholeTone = 2

ch11 = [high d, g, e]
ch12 = map (step wholeTone) ch11
ch13 = [high a, a, high cs]
ch14 = [high fs, b, g]

chSeq1 = [ch11, ch12, ch13, ch14]

-- guitar 2

guitarChord2 = 
    mel . zipWith ($) beat . map en . 
    concat . replicate 6 . arpeggi . map high
       where arpeggi x = x ++ take 2 x


ch21 = [low g, d, e]
ch22 = map (step wholeTone) ch21
ch23 = [cs, e, a]
ch24 = [d, g, e]

chSeq2 = [ch21, ch22, ch23, ch24]

-- guitar 3

guitarChord3 = 
    mel . zipWith ($) beat . map en . 
    concat . replicate 6 . arpeggi . map high
       where arpeggi x = take 2 x ++ x

ch31 = [e, g, b]
ch32 = map (step wholeTone) ch31
ch33 = [fs, a, high cs]
ch34 = [high d, g, b]

chSeq3 = [ch31, ch32, ch33, ch34]

-- score

scoG1 = mf'  $ mel $ map guitarChord1 chSeq1
scoG2 = p'   $ mel $ map guitarChord2 chSeq2
scoG3 = ppp' $ mel $ map guitarChord3 chSeq3

--scoG2intro = slice (3*30/8) (4*30/8) scoG2
--intro  = fmap double $ har [scoG1, scoG3, del (3*30/8) scoG2intro]
intro  = har [scoG1, scoG3, del (3*30/8) scoG2]
chords = loopBy 3 $ har [scoG1, scoG2, scoG3] 

main = dac $ mix $ sco (return . guitar ) $ intro +:+ chords

