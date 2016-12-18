
import Csound.Base
import P12

oscilla amp pch = oscils amp pch 0

instr x = oscil myLfo (sig x) $ gen 10 [1]
  where myLfo = lfo uosc 0.7 2

ch1 = [a, g]
ch2 = [higher 1 a, higher 1 g, fs]

chSeq = [ch1,ch2]

s1 = str 0.9 $ sco (return . oscilla 0.1) $ har $ map mel chSeq
s2 = sco (return . instr) $ mel [d, f , a , high d]

main = dac $ mix $ s1 =:= s2
