import Csound.Base
import Data.List(transpose)

f1 = gen 10 [1] -- sine

delays = let starts = [0,2.5,3.5,4] 
          in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [1,0.1,0.2,1]
amps = map double [120,122,127,127]

track = map (\xs->temp (xs!!0,xs!!1)) $ transpose [durs,amps]

veloc2amp vel maxamp = maxamp * (0.0039 + vel^2/16192)

bassDrum (dur,amp') = 
  let scl =   1 :: Sig -- amp scale
      rel =   0.08 :: D -- release time
      bsfrq = 5.08 :: D  -- base freq (MIDI note)
      frqs  = 4 :: D -- start freq / base freq
      frqt  = 0.007 :: D  -- freq enveop half-time
      lpfrq = 3000 :: Sig -- lowpass filter freq
      dect  = 0.25 :: D -- decay half-time
      
      xtim = 0.2 + rel
      p3 = dur + xtim
      amp = veloc2amp (sig amp') scl
      
      cps = sig $ cpspch bsfrq
      kcps = cps * linseg [frqs, frqt, 1]
      a1 = butterlp (oscil 1 kcps f1) lpfrq
      aenv = expon 1 dect 0.5
      aenv2 = linsegr [1,dur,1,rel,0] 1 0
      
      in a1 * amp * aenv * aenv2^2

main = dac $ mix $ sco (return . bassDrum) $ mel $ zipWith del delays $ zipWith str durs track

