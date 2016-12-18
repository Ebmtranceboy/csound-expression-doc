import Csound.Base
import Data.List(transpose)

f = [gen 10 [1], -- sine
     gen 10 [1,0.5,0.3,0.25,0.2,0.167,0.14,0.125,0.111], -- sawtooth
     gen 10 [1,0,0.3,0,0.2,0,0.14,0,0.111], -- square
     gen 10 [1,1,1,1,0.7,0.5,0.3,0.1]] -- pulse

durs = map double [2,2,2,3]
freqs = map double $ map ((+10) . (/100)) $ [0,2,4,5]
attacks = map double $ map (/100) [3,3,3,3]
releases = map double $ map (/10) [7,7,7,7]
vibRates = map double [6,6,6,6]
vibDepths = map double [9,9,9,9]
vibDelays = map double [0.8,0.8,0.8,0.8]
forms = [f!!0,f!!1,f!!2,f!!3]

track = map (\ (xs, ys) -> temp (xs !! 0, xs !! 1, xs !! 2, xs !! 3, xs !! 4, xs !! 5, xs !! 6, ys)) $ zip (transpose [durs,freqs,attacks,releases
  ,vibRates,vibDepths,vibDelays])  forms


instr6 (dur,  freq, attack, release, rate, depth, delay, form) = 
  let adb = 86
      rel = 0.01
      del1 = dur * delay
      sus = dur - (del1 + rel)
      
      amp = ampdb adb
      scale = amp * 0.333
      note = cpspch freq

      rampFreq = linseg [0,del1,depth,sus,depth,rel,0]
      k2 = oscil rampFreq rate (f!!0)
      rampAmp = linen scale attack dur release

      a3 = oscil rampAmp (note*0.999 + k2) form
      a2 = oscil rampAmp (note*1.005 + k2) form
      a1 = oscil rampAmp (note + k2) form
  in (a1 + a2 + a3) /33000

main = dac $ mix $ sco (return . instr6 . (\(d,f,a,r,t,p,l,o) -> (d,sig f,a,r,sig t,p,l,o))) $ mel $ zipWith str durs track


