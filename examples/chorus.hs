import Csound.Base
import Data.List (transpose)

durs = replicate 6 1 ++ [2]
ampsdb = [75,70,75,70,85,80,90]
pchs = map ((+8) . (/100)) [4, 2, 0, 2, 4, 4, 4]
attacks = map (/100) [10,7,5,5,10,5,3]
releases = map (/10) [7,8,5,4,5,5,10]

track = map (\xs -> temp (xs !! 0, xs !! 1, xs !! 2, xs !! 3, xs !! 4)) $ transpose $ map (map double) [durs,ampsdb,pchs,attacks,releases]

f1 = gen 10 [1]

instr4 (dur, adb, pch, attack, release) = 
  let amp = ampdb adb
      scale = amp * 0.333
      ramp = linen scale attack dur release
      freq = cpspch pch
      a1 = oscil ramp (freq*0.996) f1
      a2 = oscil ramp (freq*1.004) f1
      a3 = oscil ramp freq f1
  in (a1 + a2 + a3) / 30000

main = dac $ mix $ sco (return . instr4 . (\(d,b,p,a,r) -> (d, sig b, sig p, a, r))) $ mel track
