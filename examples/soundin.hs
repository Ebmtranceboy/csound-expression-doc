import Csound.Base
import Data.List(transpose)

delays = let starts = [0,3,5,7.5,10] 
          in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs
durs = [2.28,1.6,2.28,2.28,2.28]
amps = map double [0.3,0.3,0.3,0.4,0.5]
attacks = map double $ map (/100) [3,10,50,1,1]
releases = map double $ map (/10) [1,1,1,1.0001,1]
skips = map double [0,1.6,0,0,1.1]
revTimes = map double [9.5,1.1,2.1,1.1,0.1]
revGains = map double [0.3,0.4,0.2,0.1,0.1]

track = map (\xs->temp(xs!!0,xs!!1,xs!!2,xs!!3,xs!!4,xs!!5,xs!!6)) $ transpose 
  [durs,amps,attacks,releases,skips
  ,revTimes,revGains]

instr8 (dur, amp, attack, release, skip, time,gain) = 
  let ramp = linen amp attack dur release
      sig = ar1 $ soundin $ text "beats.wav"
      ampsig = ramp * sig
      effect = reverb sig time
      affect = effect * gain
  in ampsig + affect

main = dac $ mix $ sco (return .instr8 .  (\(a,b,c,d,e,f,g)->(a,sig b,c,d,e,sig f,sig g))) $ mel $ zipWith del delays $ zipWith str durs track
