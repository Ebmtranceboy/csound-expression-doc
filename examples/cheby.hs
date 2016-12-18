import Csound.Base
import P12

instr1 dur = 
  let -- According to the GEN13 manual entry,
      -- the pattern + - - + + - - for the signs of 
      -- the chebyshev coefficients has nice properties.
      k1 = lfo uosc 1 2
      k2 = linseg [-0.5 , dur, 0]
      k3 = linseg [-1/3, dur, -1]
      k4 = linseg [0, dur, 0.5]
      k5 = linseg [0, dur, 0.7]
      k6 = linseg [0, dur, -10]
      ax = oscili 1 256 (gen 10 [1])
      ay = chebyshevpoly ax [ 0, k1, k2, k3, k4, k5, k6]
      adec = linseg [0.0, 0.05, 1.0, dur - 0.1, 1.0, 0.05, 0.0]
  in 0.5 * adec * ay

duratedRest :: Sco D
duratedRest = str 10 a

perf = dac $ mix $ sco (return . instr1) duratedRest
main = perf
