import Csound.Base
import P12

-- volume level

v0 :: D
v0 = 1

-- instruments

bow (amp, pch) = 
  (/300) $ env * wgbowedbar amp pch 0.5 0.6 0.995
        where env = linsegr [0, idur * 0.1, 1,  idur * 0.9, 1] 1 0  

oscilla (amp, pch) = 
 (/300) $ env * oscils amp pch 0
    where env = linsegr [0, idur * 0.1, 1,  idur * 0.9, 1] 1 0  

mfuse :: D -> Sco D -> Sco (D,D)
mfuse a = fmap ((,) a)

--chords

ch4 = [high d, g, e]
ch3 = map (fmap ( + 0.02)) ch1
ch2 = [high a, a, high cs]
ch1 = [high fs, b, g]

chSeqB = [ch1, ch2, ch3, ch4]
chSeqO = [ch4, ch3, ch2, ch1]

bowChord = mel . map (mfuse v0) . concat . replicate 3

oscChord = mel . map (mfuse v0) . concat . replicate 3

-- scores
main = dac $ mix $ str 0.5 $ har [sco (return . bow .(\(a,b)->(sig a, sig b))) $ mel $ map bowChord chSeqB,  sco (return . oscilla) $ mel $ map oscChord chSeqO]

