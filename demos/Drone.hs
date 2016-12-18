import Csound.Base

drone =  mul 0.25 $  
        mul (port (usqr 8 + usqr 2) 0.01) $ 
        mapSig (mlp 800 (0.2 + 0.6 * uosc 0.1)) $ 
        return (saw 50 + osc 54 + osc 101 + uosc 0.25 * osc (202)) 
             + mul (1.3 + 2 * uosc 0.1) pink

shs = mul (stepSeq [1, 1, 0, 0.5, 0.5, 0, 1, 0] 1) $ 
       mapSig (hp (1000 + 9000 * uosc 0.1) 7) $ pink

beat1 = cfd (usqr 0.25) a1 a2 
      where 
                a1 = mul (sawSeq [1, 0.5, 0.25, 1, 0.5, 0.2, 1, 0.2] 8) $ pink
                a2 = mul (sawSeq [1, 0.5, 0.25, 1, 0.5, 0.2, 0.7, 0.8] 8) $ pink

beat2 = mul (isawExpSeq [0, 0, 1, 0] 4) $ white

beat3 = mul (sawSeq [1, 0, 0, 0, 0, 0, 0, 1, 0.6, 0, 0, 0] 8) 
        $ at (hp 400 10) $ pink

beat4 = mul (usqr 0.25) $ 
       mul (port (sqrSeq [0, 0, 0, 0, 1, 1, 0, 1] 8) 0.01) $ tri 330

beatAll = sum [beat1, beat2, beat3, return beat4]

main = dac $ sum [drone, shs, beatAll] / 4

genSeq mkTab mkList as cps = 
        oscBy (skipNorm $ gp $ mkTab $ mkList as) (cps / (sig $ int $ length as))

expVal a 
    | abs a < 0.0001 = (if (a < 0 ) then (-1) else 1) * 0.0001
    | otherwise      = a

isawExpSeq = genSeq exps mkList
    where 
        mkList xs = case fmap expVal xs of
            []   -> []
            a:as -> 0.0001 : 1 : a : 0 : mkList as 
