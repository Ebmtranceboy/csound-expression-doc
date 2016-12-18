module P12 where
import Csound.Base

--c,cs,d,ds,e,f,fs,g,gs,a,as,b :: Double
--[c,cs,d,ds,e,f,fs,g,gs,a,as,b] = map ((/2**0.75) . (*440) . (2**) . (/12)) [0,1,2,3,4,5,6,7,8,9,10,11]
c,cs,d,ds,e,f,fs,g,gs,a,as,b :: Track D D
[c,cs,d,ds,e,f,fs,g,gs,a,as,b] = map (temp . cpspch . (+8) . (/100)) [0,1,2,3,4,5,6,7,8,9,10,11]

high, low :: (Num a, Fractional a, SigOrD a) => Sco a -> Sco a
higher :: (Num a, Fractional a, SigOrD a) => Int -> Sco a -> Sco a
--high, low :: Double -> Double
--higher :: Int -> Double -> Double
high = fmap (*2)
low = fmap (*0.5)
higher n = fmap (* 2^n)
step semi = fmap (* 2**(fromIntegral (toInteger semi)/12))


bn, wn, hn, qn, en, sn, tn  :: Sco D -> Sco D
--bn, wn, hn, qn, en, sn, tn  :: Track D Double -> Track D Double

bn = str 2
wn = id
hn = str $ 1/2
qn = str $ 1/4
en = str $ 1/8
sn = str $ 1/16
tn = str $ 1/32

-- TODO
accent _ = id
mf' = id
p' = id
ppp' = id
