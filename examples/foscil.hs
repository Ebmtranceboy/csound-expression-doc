import Csound.Base
import Data.List(transpose)
f1 = gen 10 [1] -- sine

delays = let starts = [0,1.5,3,3.5,4,4.5] 
	  in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [1,1,3,2.5,2,1.5]
amps = map double $ map (*1000) [10,20,10,10,5,6]
freqs = map double $ [440,220,110,130.8,329.6,440]
ms = map double $ [2,0.5,1,2.001,3.003,5.005]
indexes = map double $ [3,8,13,8,5,3]

track = map (\xs->temp (xs!!0,xs!!1,xs!!2,xs!!3,xs!!4)) $ transpose 
 [durs,amps,freqs,ms,indexes]

instr108 (dur, amp, freq,m,index) = 
  (/30000) $ foscil amp freq 1 m index f1
  
main = dac $ mix $ sco (return . instr108 . (\(a,b,c,d,e)->(a,sig b,sig c,sig d,sig e))) $ mel $ zipWith del delays $ zipWith str durs track

