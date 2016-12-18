import Csound.Base
import Data.List(transpose)

delays = let starts = [0,2,3.5,4.5,5,9] 
          in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [1.2,1.4,2.28,2.28,2.28,2.28]
amps = map double $ [0.5,0.5,0.5,0.5,0.5,0.7]
attacks = map double $ map (/100) [2,3,90,120,20,10]
releases = map double $ map (/10) [1,1,1,1,1,1]
pans = map double $ [1,0,0.5,0,1,0.5]
revSends = map double $ [0.2,0.3,0.1,0.2,0.3,0.03]

track = map (\xs-> temp (xs!!0,xs!!1,xs!!2,xs!!3,xs!!4,xs!!5)) $ transpose 
  [durs,amps,attacks,releases,pans,revSends]

instr9 (dur, amp, attack, release, pan, revSend) = 
  let ramp = linen amp attack dur release
      sig = ar1 $ soundin $ text "beats.wav"
      ampsig = ramp * sig 
      rev = reverb ampsig 2.2
   in (rev * pan, rev *(1 - pan))

main = dac $ mix $ sco (return . instr9 . (\(a,b,c,d,e,f)->(a,sig b,c,d,sig e,f))) $ mel $ zipWith del delays $ zipWith str durs track
