
import Csound.Base

instr freq =
  let q = 50 -- filter Q
      fmin = 400 -- min filter freq
      fmax = 4000 -- max filter freq
      envAmp = linenr 1 0.05 0.5 0.01 -- enveloppe
      envMod = linseg [fmax, 0.9, fmin]
      a1 = oscili envAmp freq $ gen 10 [1,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0.08,0.07,0.06,0.05,0.04,0.03,0.02]
      aout = reson a1 envMod (envMod/q) -- filter
      in aout/2000

main = dac $ midi $ onMsg instr

