
import Csound.Base
import Data.List(transpose)

f = [gen 10 [1], -- sine
     gen 10 [1,0.5,0.3,0.25,0.2,0.167,0.14,0.125,0.111,0.1,0.09], -- sawtooth
     gen 10 [1,0,0.3,0,0.2,0,0.14,0,0.111], -- square
     gen 10 [1,1,1,1,0.7,0.5,0.3,0.1]]-- pulse

durs = map double [5,5,18]
ampsdb = map double [96,96,96]
freqs = map double $ map ((+8) . (/100)) $ [7,9,7]
attacks = map double $ map (/100) [3,3,3]
releases = map double $ map (/10) [1,1,1]
vibRates = map double [3,13,3]
vibDepths = map double [1.6,4.6,1.6]
vibDelays = map double [0.99,0.99,0.99]
initials = [f!!1, f!!2, f!!3]
finals = [f!!0, f!!0, f!!0]
fadeTimes = map double [0.51,0.62,0.55]

track =  map (\(xs,ys,zs) -> temp (xs !! 0, xs !! 1, xs !! 2, xs !! 3, xs !! 4, (xs !! 5, xs !! 6, xs !! 7, xs !! 8, ys, zs))) $ 
     zip3 (transpose [durs, ampsdb, freqs, vibRates,   releases,
                      attacks, vibDepths, vibDelays, fadeTimes])  initials finals

instr7 (dur, adb, freq, rate, release,  sextet) = 
  let (attack , depth, delay, fadeTime, initial, final) = sextet
      fad1 = dur * fadeTime
      fad2 = dur - fad1
      
      rel = 0.01
      del1 = dur * delay
      sus = dur - (del1 + rel)
      
      amp = ampdb adb
      scale = amp * 0.166
      note = cpspch freq

      rampFreq = linseg [0,del1,depth,sus,depth,rel,0]
      k2 = 10 * oscil rampFreq rate (f!!0)
      rampAmp = linen scale attack dur release

      a6 = oscil rampAmp (note*0.998 + k2) final
      a5 = oscil rampAmp (note*1.002 + k2) final
      a4 = oscil rampAmp (note + k2) final
      a3 = oscil rampAmp (note*0.997 + k2) initial
      a2 = oscil rampAmp (note*1.003 + k2) initial
      a1 = oscil rampAmp (note + k2) initial
      
      rampFade = linseg [1,fad1,0.5,fad2,0]
      out1 = rampFade * (a1 + a2 + a3)
      out2 = (1 - rampFade) * (a4 + a5 + a6)
  in (out1 + out2) / 30000

main = dac $ mix $ sco (return . instr7 . (\(d,a,f,e,r,sextet) -> (d,sig a, sig f,sig e,  r,sextet))) $ mel $ zipWith str durs track
