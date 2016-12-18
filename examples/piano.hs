import Csound.Base

instr car_frq =
  let len    = 0.5
      amp    = 1 / 4
      atck    = 0.001
      kenv = linsegr [0,atck*len, 1,0.05*len,0.6,0.1*len,0.3,0.25*len,0.15,0.5*len,0.07,(0.1-atck)*len,0] 1 0

      mod1_frq    = car_frq * 1
      mod2_frq    = car_frq * 4

      indx1 = 17 * (8 - (log (car_frq))) / (log (car_frq))^2
      indx2 = 20 * (8 - (log (car_frq))) / car_frq

      mod1_amp    = mod1_frq * indx1
      mod2_amp    = mod2_frq * indx2

      s = car_frq/200
      f1 = gen 10 [1]
      aoscil1 =  oscili mod1_amp (mod1_frq +s) f1
      aoscil2 =  oscili mod2_amp (mod2_frq +s) f1

   in reverb (oscili (kenv*amp) (car_frq + aoscil1 + aoscil2) f1) 0.6

main = dac $ midi $ onMsg instr

