module Main where

import Csound.Base
import Csound.Dynamic
import Csound.Typed

hocico ::  D -> D -> (Sig, Sig)
hocico b1 b2 = pureTuple $ f <$> unD b1 <*> unD b2 
    where f a1 a2 = mopcs "hocico" ([Ar,Ar],[Ir,Ir]) [a1,a2]

main = dac $ fmap(rever2 0.9 . fmap (* linsegr [1] 1 0)) $ midi $ onMsg $ \x -> fmap (linsegr [1] 1 0 *) $ hocico x 0.8