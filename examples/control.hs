import Csound.Base
import Data.List(transpose)

f 1 = gen 10 [1] -- sine
f 2 = skipNorm $ gen 2 $ map ((+8).(/100)) [0,2,4,5,7,9,11,100] -- C major

durs = replicate 11 0.5 ++ [2.5] ++ replicate 15 2 ++ [5]
indexes = [7,6..0] ++ [0,2,4,7] ++ replicate 16 0
methods = replicate 12 1 ++ replicate 5 2 ++ replicate 11 3
lfoRates = replicate 12 0 ++ [1,2,4,8,16] ++ [2,3,4,7,11,18,29,47,76,123,199]

track =  map (\xs -> temp (xs !! 0, xs !! 1, xs !! 2, xs !! 3)) $ transpose 
  $ map (map double) [durs,indexes,methods,lfoRates]

instr12 (dur,index,method,lfoRate) = 
  let amp = ampdb 86
      ramp = linseg [0, dur * 0.1, amp, dur *0.9, 0]
      pitch m serand =
       (m-2)*(m-3) * (table index (f 2)) / 2
       + (1-m) * (m-3) * (let idx = phasor lfoRate
                               in table (idx * 8) (f 2))
       + (1-m) * (2-m) * (let idx = serand
                               in table (abs idx) (f 2)) / 2
      sig = fmap (flip (oscil ramp) (f 1)) (fmap cpspch $ fmap (pitch method) (randh index 2)) 
  in sig / 30000

main = dac $ mix $ sco (instr12 . (\(d,i,m,l)->(d, sig i, sig m, sig l))) $ mel track
