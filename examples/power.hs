import Csound.Base

instr freq =
  let iamp = 4096
      kcps = freq
      semitone' x = 2**(x/12)
      mkCps n xs = semitone' (-24) : (concatMap (\(y,y') -> [n*(lenD-2*transD)/((size-1)*lenD),y,n*2*transD/((size-1)*lenD),y']) $ zip xs (tail xs))
      mkEnv n xs = iamp : (take (8 * (length xs -1)) $ cycle [n*audD/((size-1)*lenD),iamp,n*transD/((size-1)*lenD),0.01,n*(lenD-audD-2*transD)/((size-1)*lenD),0.01,n*transD/((size-1)*lenD),iamp])
      mkVco n xs = 0.99 : (take (4 * (length xs -1)) $ cycle [n*audD/((size-1)*lenD),0.048,n*(lenD-audD)/((size-1)*lenD),0.99])
      lenD, transD, audD :: Double
      (lenD, transD, audD) = (0.5 , 0.001,3* lenD / 4)
      [len, trans, aud] = map double [lenD, transD, audD]
      size = fromIntegral $ length arps
      arps = let a = [0,0,0,1,0,0,0,0,12,0,0,0] in a ++ tail (reverse a)
      kclock = phasor 0.15
      tabsizeD = 65536.0
      tabsize = double tabsizeD
      kcpstab' = (table kclock $ skipNorm $ gen 07 $ mkCps tabsizeD (map (semitone' . subtract 24) arps)) `withD` 1
      kcpstab = ifB (kcpstab' ==* 0) (sig $ semitone (-24)) kcpstab'
      kenvtab = (table kclock $ skipNorm $ gen 07 $ mkEnv tabsizeD arps) `withD` 1
      kvcotab = (table kclock $ skipNorm $ gen 05 $ mkVco tabsizeD arps) `withD` 1
      avco = vco kenvtab (kcpstab * kcps) 2 kvcotab `withTab` (gen 10 [1])
   in avco/30000

half = 2.43
durs = repeat $ 2 * half
[sco1,sco2,sco3] = map (mel . map (del half) . zipWith str durs . take 2 . repeat . temp . cpspch) [8.02,8.08,8.05]

main = dac $ mix $ sco (return . instr . sig) $ har [sco1, del half sco2, del (2*half) sco3]
