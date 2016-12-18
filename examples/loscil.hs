import Csound.Base
import Data.List(transpose)

f = [
  gen 20 [2,1], -- 
  gen 01 [1,0,4,0], -- sing.aiff
  gen 01 [2,0,4,0], -- "hellorcb.aif"
  gen 07[0,10,1,1000,1,14,0], -- linear enveloppe
  gen 07 [0,128,1,128,0.6,512,6,256,0], -- durs sum up to 1024
  gen 05 [0.01,256,1,192,0.5,256,0.5,64,0.01] -- exponential enveloppe
  ]

delays = let starts = [0,3,8,8.3,8.8,11,11,11.5,12,14] 
           in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [2.31,4.62,2.28,2.28,2.1,4.62,4.62,2.31,2.31,3]
amps = map double $ map (*10000) $ [3,3] ++ replicate 7 1 ++ [2]
freq1s = map double $ [440,220,442,438,450,219,440,554.4,659.2,440]
samples = map (f!!) [1,1,2,2,2,1,1,1,1,2]
envs = map (f!!) [4,5,3,3,3,0,4,5,4,3]
freq2s = map double $ [430,225,444,441,460,221,438,550,640,439]
freq3s = map double $ [450,215,438,435,445,218,442,560,666,441]

track = map (\(xs,ys,zs) -> temp (xs!!0,xs!!1,xs!!2,xs!!3,xs!!4,ys,zs))$ zip3 (transpose [durs,amps,freq1s,freq2s,freq3s]) samples envs

instr118 (dur,amp, freq1,freq2,freq3,fsample,fenv) = 
  let ramp = oscil amp (1/sig dur) fenv
      ctrl = expseg [freq1,dur/3,freq2,dur/3,freq3,dur/3,freq1]
      in (/30000) $ ar1 $ loscil ramp ctrl fsample

main = dac $ mix $ sco (return . instr118 . (\(a,b,c,d,e,f,g)->(a,sig b,c,d,e,f,g))) $ mel $ zipWith del delays $ zipWith str durs track

