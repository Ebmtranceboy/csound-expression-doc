import Csound.Base
import Data.List(transpose)

f1 = gen 10 [1]

delays = let starts = [0,4.5,8,12,12,12] 
            in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [3,3,3,10,10,10]
freqs = map double $ [440,220,110,130.8,311.1,440]
attacks = map double $ [1,2,0.01,0.01,8,5]
releases = map double $ [1,0.1,0.01,0.01,1,0.5]
harm1s = map double $ [30,2,20,1,33,3]
harm2s = map double $ [2,30,6,15,2,11]

track = map(\xs->temp (xs!!0,xs!!1,xs!!2,xs!!3,xs!!4,xs!!5)) $ transpose 
   [durs,freqs,attacks,releases,harm1s,harm2s]

instr115 (dur, freq,attack,release,harm1,harm2) = 
  let ramp = linen 10000 attack dur release
      src = expon harm1 dur harm2
      sig = buzz 1 freq (1 + src) f1
  in ramp * sig / 30000

main = dac $ mix $ sco (return . instr115 . (\(a,b,c,d,e,f) -> (a,sig b,c,d,e,f))) $ mel $ zipWith del delays $ zipWith str durs track

