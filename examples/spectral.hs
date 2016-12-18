import Csound.Base
import Data.List(transpose)

f = [gen 10 [1], -- sine
     gen 19 [0.5,1,270,1] -- weighted sum of partials + offset
     ]

durs = [5,8,13]
freqs = map double [200,100,50]
pluckDurs = map double [0.3,0.4,0.3]
fmRises = map double [0.2,0.35,0.2]
fmDecs = map double [0.35,0.35,0.4]
indexes = map double [8,7,6]
vibRates = map double [5,6,4]
frmtRises = map double [0.5,0.7,0.6]

track = map (\xs->temp(xs!!0,xs!!1,xs!!2,xs!!3,xs!!4,xs!!5,xs!!6,xs!!7)) $ transpose 
   [durs,freqs,pluckDurs,fmRises,fmDecs
     ,indexes,vibRates,frmtRises]

instr13 (dur,freq,pluckDur_,fmRise_,fmDec_,index,vibRate,frmtRise_) = 
  let amp = (/3) $ ampdb 80
      pluckDur = dur * pluckDur_
      pluckOff = dur - pluckDur
      fmRise = dur * fmRise_
      fmDec = dur * fmDec_
      fmOff = dur - (fmRise + fmDec)
      frmtRise = dur * frmtRise_
      frmtDec = dur - frmtRise
      
      rampPluck = linseg [0.8, pluckDur,0,pluckOff,0]
      pluck1 = pluck amp (sig freq) freq (f!!0) 1
      pluck2 = pluck amp (1.003*sig freq) (1.003*freq) (f!!0) 1
      sigPluck = rampPluck * (pluck1 + pluck2)
      
      rampFm = linseg [0, fmRise, 0.7, fmDec,0,fmOff,0]
      idx = index * rampFm
      fm1 = foscil amp (sig freq) 1 2 idx (f!!0)
      fm2 = foscil amp (1.003*sig freq) 1.003 2.003 idx (f!!0)
      sigFm = rampFm * (fm1 + fm2)
      
      rampFrmt = linseg [0, frmtRise, 3, frmtDec,0]
      vib = oscil 1 vibRate (f!!0)
      frmt1 = fof amp (sig freq + vib) 650 0  40 0.003 0.017 0.007 4 (f!!0) (f!!1) dur
      frmt2 = fof amp ((1.001 * sig freq) + (0.009 * vib)) 650 0 40  0.003 0.017 0.007 10 (f!!0) (f!!1) dur
      sigFrmt = rampFrmt * (frmt1 + frmt2)
  in (/30000) $ sigPluck + sigFm + sigFrmt

main = dac $ mix $ sco (return . instr13 . (\(a,b,c,d,e,f,g,h)->(a,b,c,d,e,sig f,sig g,h))) $ mel $ zipWith str durs track
