import Csound.Base

globalSig = newGlobalRef (0 :: Sig)
globalIndex = newGlobalRef (0 :: D)
globalPhs = newGlobalRef (0 :: Sig)

globalKsmps = newGlobalRef (getSampleRate/getControlRate)

trigSig freq = 
    do 
       sref <- globalSig
       s <- readRef sref
       iref <- globalIndex
       i <- readRef iref
       pref <- globalPhs
       let dph = sig $ 2*pi*freq/getSampleRate
       kref <- globalKsmps
       ksmps <- readRef kref
       
       untilDoD (i Csound.Base.>=* ksmps) 
             (do
                 phase <- readRef pref
                 writeRef pref (dph + phase)
                 phase <- readRef pref
                 vaset ((/3) $ sin phase) (sig i) s
                 writeRef iref (1 + i)
                 i <- readRef iref
                 ksamps <- readRef kref
                 return ()
             )
       writeRef iref 0
       return s
       
main = dac $ midi $ onMsg trigSig
