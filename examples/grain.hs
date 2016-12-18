import Csound.Base
import Data.List(transpose)

f1 = gen 10 [1] -- sine
f3 = gen 20 [2,1] -- 

delays = let starts = [0,6] 
         in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [5,10]
amps = map double $ [1000,4000]
freqs = map double $ [470,1760]
attacks = map double $ [1,5]
bends = map double $ [430,60]
dens1s = map double $ [12000,5]
dens2s = map double $ [4000,200]
ampOf1s = map double $ [120,500]
ampOf2s = map double $ [50,1000]
pchOf1s = map double $ [0.01,10]
pchOf2s = map double $ [0.05,20000]
gdur1s = map double $ [0.1,1]

track = map (\xs-> temp (xs!!0,xs!!1,xs!!2,xs!!3,xs!!4,xs!!5,(xs!!6,xs!!7,xs!!8,xs!!9,xs!!10,xs!!11))) $ transpose 
  [durs,amps,freqs,attacks,bends, dens1s,dens2s,ampOf1s,ampOf2s,pchOf1s,pchOf2s,gdur1s]

instr115 (dur,amp, freq,attack,bend,dens1,(dens2,ampOf1,ampOf2,pchOf1,pchOf2,gdur1)) = 
  let ramp = linseg [freq, dur/2,bend,dur/2,freq]
      ctrl1 = linseg [dens1, dur, dens2]
      ctrl2 = linseg [ampOf1, dur, ampOf2]
      src1 = expseg [pchOf1, dur, pchOf2]
      src2 = expseg [gdur1, dur, 0.01]
      sig = grain amp ramp ctrl1 ctrl2 src1 src2 f1 f3 1
  in (linen sig attack dur 0.1) /30000

main = dac $ mix $ sco (return . instr115 . (\(a,b,c,d,e,f,(g,h,i,j,k,l)) -> (a,sig b,c,d,e,f,(g,h,i,j,k,l)))) $ mel $ zipWith del delays $ zipWith str durs track

