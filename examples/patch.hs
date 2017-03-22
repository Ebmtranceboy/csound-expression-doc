import Csound.Base
import Csound.Patch 

instr (amp, cps) = mul (0.45 * sig amp * fades 0.01 0.1) $
      fmap (fromMono . mlp (5500 * leg 0.001 0.22 0.001 0.2) 0.7) $
      rndSaw (sig cps) + rndTri (2.01 * sig cps)
      
fxs = [fxSpec 0.75 (return . smallHall2)]

main = dac $ atMidi $ deepPad $ FxChain fxs (polySynt instr)