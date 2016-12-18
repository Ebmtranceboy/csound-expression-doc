import Csound.Base
import Data.List(transpose)

delays10 = let starts = [0,3,5,8,8,9,11,12,13,15] 
            in 0 : zipWith (-) (zipWith (-) (tail starts) starts) durs10
durs10 = map double [2,1,2,2,0.5,0.5,0.5,0.5,0.5,0.5]
amps = map double $ replicate 9 0.01 ++ [0.005]
sweepStarts = map double [5000,1500, 850,1100,5000,1000, 500,2100,1700,8000]
sweepEnds =    map double [500,5000,1100,8000,1000,8000,2100,1220,3500, 800]
bandWidths =    map double [20,  30,  40,  50,  30,  40,  50,  75, 100,  60]
pans = map double $ map (/100) [15,95,45,5,35,75,14,96,45,85]

track = map (\x-> temp (x!!0,x!!1,x!!2,x!!3,x!!4,x!!5)) $ transpose 
   [durs10,amps,sweepStarts,sweepEnds,bandWidths, pans]

instr10 (dur, amp, sweepStart, sweepEnd, bandWidth, pan) = 
  let ramp = linen amp 0.01 dur 0.2
      rampSweep = linseg [sweepStart, dur, sweepEnd]
      sig = rand 22050
      filt = fmap (flip (flip reson rampSweep) bandWidth) sig
      ampsig = fmap ((ramp *) . (/150000)) filt
  in do
        left <- fmap  (pan *) ampsig
        right <- fmap ((1 - pan) *) ampsig
        return (left, right)

rvbTimes = [1.1,5]

dry = mix $ sco (instr10 . (\(a,b,c,d,e,f)->(a,sig b,c,d,sig e,sig f))) $ mel $ zipWith del delays10 $ zipWith str durs10 track
main = dac $ sum $ [dry] ++ (map ((\ eff -> (eff $ fst dry, eff $ snd dry)) . reverTime) rvbTimes)
