
import Csound.Base
import P12

-- instruments

oscilla cps = 
  env * oscils 0.1 cps 0
    where env = linsegr [0, 0.1, 1, 0.9, 1] 1 0  

--chords

ch1 = [high d, g, e]
ch2 = map (fmap (+ 0.02)) ch1
ch3 = [high a, a, high cs]
ch4 = [high fs, b, g]

chSeq = map mel [ch1, ch2, ch3, ch4]

-- scores

scoG = sco (return . oscilla) $ mel chSeq


intro  = har [scoG, del (3*30) scoG]
chords = loopBy 3 $ har [scoG] 

main = dac $ mix $ str 0.17 $ intro +:+ chords


