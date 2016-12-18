import Csound.Base
import Control.Monad (join)

trigSig freq = 
    do 
       let dph = sig $ 2*pi*freq/getSampleRate
       s <- join $ fmap readRef $ newGlobalRef (0 :: Sig)
       iref <- newGlobalRef (0 :: D)
       pref <- newGlobalRef (0 :: Sig)
       
       i <- readRef iref
       untilDoD (i Csound.Base.>=* getBlockSize) 
             (do
                 phase <- readRef pref
                 vaset ((/3) $ sin phase) (sig i) s
                 writeRef pref (dph + phase)
                 writeRef iref (1 + i)
                 i <- readRef iref
                 return ()
             )
       writeRef iref 0
       return s
       
main = dac $ midi $ onMsg trigSig
