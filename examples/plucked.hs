import Csound.Base
import Data.List(transpose)

f = [gen 10 [1], -- sine
     gen 10 [1,0.5,0.3,0.25,0.2,0.167,0.14,0.125,0.111], -- sawtooth
     gen 10 [1,0,0.3,0,0.2,0,0.14,0,0.111], -- square
     gen 10 [1,1,1,1,0.7,0.5,0.3,0.1]] -- pulse

durs = map double [2,2,2,4]
ampsdb = map double [86,86,86,86]
freqs = map double $ map ((+9) . (/100)) $ [0,2,4,5]
attacks = map double $ map (/100) [3,3,3,3]
releases = map double $ map (/10) [1,1,1,1]
vibRates = map double [6,6,6,6]
vibDepths = map double [5,5,5,5]
vibDelays = map double [0.4,0.4,0.4,0.4]
forms = [f!!0,f!!1,f!!2,f!!3]

track6 = map (\(xs, ys) -> temp (xs!!0, xs!!1, xs!!2, xs!!3, (xs!!4, xs!!5, xs!!6, xs!!7, ys)))  $ zip (transpose 
   [durs,ampsdb,freqs,attacks,releases ,vibRates,vibDepths,vibDelays]) forms

instr6 (dur, adb, freq, attack, (release, rate, depth, delay, form)) = 
  let rel = 0.01
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
  in (a1 + a2 + a3) / 32000

data Info = Given {raw :: Double} | M {-Missing-} deriving (Eq,Show)

instance Num Info where
  (+) = undefined
  (-) = undefined
  (*) = undefined
  signum = undefined
  abs = undefined
  fromInteger n = Given $ fromInteger n

instance Fractional Info where
  fromRational n = Given $ fromRational n
  recip = undefined

interpol :: [Info] -> [Double]
interpol infos =
  let ds = map raw $ filter (/= M) infos
      f _ [] acc = reverse acc
      f n (Given _:is) acc = f 0 is (n:acc)
      f n (M:is) acc = f (n+1) is acc
      zs = zip ds $ f 0 infos []
      g [] acc = acc
      g ((d,n):zs) acc = 
       let d' = last acc
           step = (d - d') / (n + 1)
       in g zs (acc ++ [d' + i* step | i <- [1..n+1]])
 in g (tail zs) [head ds]

pluckDurs = map double $ replicate 12 1 ++ [8]
pluckAmps = map double $ interpol [70,M,M,90,M,M,70,90,M,M,M,70,90]
pluckFreqs = map double $ interpol [100,M,M,800,M,M,100,1000,M,M,M,M,50]

track11 = map (\xs -> temp (xs!!0, xs !! 1)) $ transpose [pluckAmps,pluckFreqs]

instr11 (amp, freq) = 
  let sig1 = pluck ((/2) $ ampdb amp) (sig freq) freq (f!!0) 1
      sig2 = pluck ((/2) $ ampdb amp) (1.0003*sig freq) (1.0003*freq) (f!!0) 1
  in (sig1 + sig2) / 40000

sco6 = sco (return . instr6 . (\(d,a,f,t,(r,e,p,l,o))->(d,sig a,sig f,t,(r,sig e,p,l,o)))) $ mel $ zipWith str durs track6
sco11 = sco (return . instr11 . (\(a,f)->(sig a, f))) $ mel $ zipWith str pluckDurs track11
main = dac $ mix $ sco11 =:= sco6
