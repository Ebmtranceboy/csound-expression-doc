-- | csound instruments
module Orchestra
where

import Csound.Base

ftsin = gen 10 [1]

-- csound instruments

bassDrum (amp, pch) = oscil env cps ftsin
    where env = amp * expon 1 0.2 0.001
          cps = expon pch 0.2 20

openHiHat amp = fmap (flip buthp 7000) sig
    where sig = noise env 0
          env = amp * expon 1 1.5 0.001  

pluckInstr (amp, pch) = env * wgpluck2 0.75 amp pch 0.75 0.5
    where env = linsegr [0, idur * 0.05, 1,  idur * 0.9, 1] 1 0  


pipeOrgan (amp, cps) = sig
    where ft = ftsin
          outch1 = 1
          outch2 = 2
          atk    = 10
          op1f   = cps
          op2f   = 2.01 * cps
          op3f   = 3.99 * cps
          op4f   = 8 * cps
          op5f   = 0.5 * cps
          op7f   = 16 * cps
          dclick = linseg [0, 0.001, amp, idur-0.002, amp, 0.001, 0]
          amp1   = linseg [0, 0.01, 1, idur-0.02, 1, 0.01, 0]
          amp2   = linseg [0, 0.05, 1, 0.1, 0.7, idur-0.16, 0.7, 0.01, 0]
          amp3   = linseg [0, 0.03, 0.8, 0.05, 0, 0.01, 0]
          amp4   = linseg [0, 0.1, 0.3, 0.1, 0.05, idur-0.3, 0.1, 0.1, 0]
          op8    = oscil amp4 op5f ft
          p1     = op8 + 1
          op1    = oscil amp1 (op1f * p1) ft
          op2    = oscil amp2 (op2f * p1) ft
          op3    = oscil amp2 (op3f) ft
          op4    = oscil amp2 (op4f) ft
          op5    = oscil amp3 (op5f * 5) ft
          op7    = oscil amp2 (op7f) ft
          sig    = (dclick *) $ op1 + op2 + op3 + op3 + op4 + op5 + op7


bassDrum'  = bassDrum (1e3, 1.5 * 1e4)
openHiHat' = openHiHat 1e3

pipeOrgan' = pipeOrgan (1e2, 5*1e3)
guitar  cps   = pluckInstr (1, cps) -- . lower 1


