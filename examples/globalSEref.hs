

module G where

import Csound.Base

main = dac $ do
    ref <- newGlobalRef (440 :: D)

    midi_ $ \msg -> writeRef ref (cpsmidi msg)
    let instr _ =  fmap (mul (fades 0.01 0.05) . osc . sig) $ readRef ref

    return $ sched instr $ withDur 0.2 $ metro 1

