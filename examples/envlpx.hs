import Csound.Base
import Data.List(transpose)
f = 
  [gen 10 [1,0.5,0.333,0.25,0.2,0.166,0.142,0.125,0.111,0.1,0.09,0.083,0.076,0.071,0.066,0.062], 
   gen 5 [0.001,128,0.8,128,0.6,256,1],
   gen 5 [0.01,64,1,64,0.5,64,0.99,64,0.6,64,0.98,64,0.7,64,0.97,32,0.8,32,1]]

delays = let starts = [0,2,4,6,8,8.2,8.4,8.6] 
           in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [2,2,2,2,5,5,5,5]
amps = map double $ [73,76,77,82,75,74,70,68]
freqs = map double $ [6.09,6.08,6.06,6.04,5.09,6.04,7.01,8.09]
funAttacks = map (f!!) $ take 8 $ cycle [1,2]

track = map (\ (xs, ys) -> temp (xs !! 0, xs !! 1, xs !! 2, ys)) $ zip (transpose [durs,amps,freqs]) funAttacks

instr120 (dur,amp,freq,funAttack) = 
  let frq = cpspch freq
      ramp = envlpx (ampdb amp) 0.5 dur 1 funAttack 0.7 0.01
      sig3 = oscil ramp (frq*0.99) (f!!0)
      sig2 = oscil ramp (frq*1.01) (f!!0)
      sig1 = oscil ramp frq (f!!0)
  in (sig1 + sig2 + sig3) / 30000

main = dac $ mix $ sco (return . instr120 . (\(a,b,c,d)->(a,sig b,sig c,d))) $ mel $ zipWith del delays $ zipWith str durs track

