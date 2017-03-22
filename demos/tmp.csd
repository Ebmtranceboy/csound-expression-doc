<CsoundSynthesizer>

<CsOptions>

--output=dac --nodisplays

</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0
girgfree_vco = 103
ir11 = girgfree_vco
ir13 vco2init 1, ir11
girgfree_vco = ir13
ir16 = girgfree_vco
ir18 vco2init 8, ir16
girgfree_vco = ir18
ir21 = girgfree_vco
ir23 vco2init 16, ir21
girgfree_vco = ir23
giPort init 1
opcode FreePort, i, 0
xout giPort
giPort = giPort + 1
endop


; Zero Delay Feedback Filters
; 
; Based on code by Will Pirkle, presented in:
;
; http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf
; 
; and in his book "Designing software synthesizer plug-ins in C++ : for 
; RackAFX, VST3, and Audio Units"
;
; ZDF using Trapezoidal integrator by Vadim Zavalishin, presented in "The Art 
; of VA Filter Design" (https://www.native-instruments.com/fileadmin/ni_media/
; downloads/pdf/VAFilterDesign_1.1.1.pdf)
;
; UDO versions by Steven Yi (2016.xx.xx)


;; 1-pole (6dB) lowpass/highpass filter
;; takes in a a-rate signal and cutoff value in frequency
opcode zdf_1pole, aa, ak
  ain, kcf  xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kg  = kwa * iT/2 

  ; big combined value
  kG  = kg / (1.0 + kg)

  ahp init 0
  alp init 0

  ;; state for integrators
  kz1 init 0

  kindx = 0
  while kindx < ksmps do
    ; do the filter, see VA book p. 46 
    ; form sub-node value v(n) 
    kin = ain[kindx]
    kv = (kin - kz1) * kG 

    ; form output of node + register 
    klp = kv + kz1 
    khp = kin - klp 

    ; z1 register update
    kz1 = klp + kv  

    alp[kindx] = klp
    ahp[kindx] = khp
    kindx += 1
  od

  xout alp, ahp
endop


;; 1-pole (6dB) lowpass/highpass filter
;; takes in a a-rate signal and cutoff value in frequency
opcode zdf_1pole, aa, aa
  ain, acf  xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  iT  = 1/sr 

  ahp init 0
  alp init 0

  ;; state for integrators
  kz1 init 0

  kindx = 0
  while kindx < ksmps do
    ; pre-warp the cutoff- these are bilinear-transform filters
    kwd = 2 * $M_PI * acf[kindx]
    kwa = (2/iT) * tan(kwd * iT/2) 
    kg  = kwa * iT/2 

    ; big combined value
    kG  = kg / (1.0 + kg)

    ; do the filter, see VA book p. 46 
    ; form sub-node value v(n) 
    kin = ain[kindx]
    kv = (kin - kz1) * kG 

    ; form output of node + register 
    klp = kv + kz1 
    khp = kin - klp 

    ; z1 register update
    kz1 = klp + kv  

    alp[kindx] = klp
    ahp[kindx] = khp
    kindx += 1
  od

  xout alp, ahp
endop

;; 1-pole allpass filter
;; takes in an a-rate signal and corner frequency where input
;; phase is shifted -90 degrees
opcode zdf_allpass_1pole, a, ak
  ain, kcf xin
  alp, ahp zdf_1pole ain, kcf
  aout = alp - ahp
  xout aout
endop


;; 1-pole allpass filter
;; takes in an a-rate signal and corner frequency where input
;; phase is shifted -90 degrees
opcode zdf_allpass_1pole, a, aa
  ain, acf xin
  alp, ahp zdf_1pole ain, acf
  aout = alp - ahp
  xout aout
endop


;; 2-pole (12dB) lowpass/highpass/bandpass filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole,aaa,aKK

  ain, kcf, kQ     xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kG  = kwa * iT/2 
  kR  = 1 / (2 * kQ)

  ;; output signals
  alp init 0
  ahp init 0
  abp init 0

  ;; state for integrators
  kz1 init 0
  kz2 init 0

  ;;
  kindx = 0
  while kindx < ksmps do
    khp = (ain[kindx] - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
    kbp = kG * khp + kz1
    klp = kG * kbp + kz2

    ; z1 register update
    kz1 = kG * khp + kbp  
    kz2 = kG * kbp + klp  

    alp[kindx] = klp
    ahp[kindx] = khp
    abp[kindx] = kbp
    kindx += 1
  od

  xout alp, abp, ahp

endop


;; 2-pole (12dB) lowpass/highpass/bandpass filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole,aaa,aaa

  ain, acf, aQ     xin

  iT  = 1/sr 

  ;; output signals
  alp init 0
  ahp init 0
  abp init 0

  ;; state for integrators
  kz1 init 0
  kz2 init 0

  ;;
  kindx = 0
  while kindx < ksmps do

    ; pre-warp the cutoff- these are bilinear-transform filters
    kwd = 2 * $M_PI * acf[kindx]
    kwa = (2/iT) * tan(kwd * iT/2) 
    kG  = kwa * iT/2 

    kR = 1 / (2 * aQ[kindx]) 

    khp = (ain[kindx] - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
    kbp = kG * khp + kz1
    klp = kG * kbp + kz2

    ; z1 register update
    kz1 = kG * khp + kbp  
    kz2 = kG * kbp + klp 

    alp[kindx] = klp
    ahp[kindx] = khp
    abp[kindx] = kbp
    kindx += 1
  od

  xout alp, abp, ahp

endop

;; 2-pole (12dB) lowpass/highpass/bandpass/notch filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole_notch,aaaa,aKK

  ain, kcf, kQ     xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kG  = kwa * iT/2 
  kR  = 1 / (2 * kQ)

  ;; output signals
  alp init 0
  ahp init 0
  abp init 0
  anotch init 0

  ;; state for integrators
  kz1 init 0
  kz2 init 0

  ;;
  kindx = 0
  while kindx < ksmps do
    kin = ain[kindx]
    khp = (kin - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
    kbp = kG * khp + kz1
    klp = kG * kbp + kz2
    knotch = kin - (2 * kR * kbp)

    ; z1 register update
    kz1 = kG * khp + kbp  
    kz2 = kG * kbp + klp  

    alp[kindx] = klp
    ahp[kindx] = khp
    abp[kindx] = kbp
    anotch[kindx] = knotch
    kindx += 1
  od

  xout alp, abp, ahp, anotch

endop

;; 2-pole (12dB) lowpass/highpass/bandpass/notch filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole_notch,aaaa,aaa

  ain, acf, aQ     xin

  iT  = 1/sr 

  ;; output signals
  alp init 0
  ahp init 0
  abp init 0
  anotch init 0

  ;; state for integrators
  kz1 init 0
  kz2 init 0

  ;;
  kindx = 0
  while kindx < ksmps do

    ; pre-warp the cutoff- these are bilinear-transform filters
    kwd = 2 * $M_PI * acf[kindx]
    kwa = (2/iT) * tan(kwd * iT/2) 
    kG  = kwa * iT/2 

    kR = 1 / (2 * aQ[kindx])

    kin = ain[kindx]
    khp = (kin - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
    kbp = kG * khp + kz1
    klp = kG * kbp + kz2
    knotch = kin - (2 * kR * kbp)

    ; z1 register update
    kz1 = kG * khp + kbp  
    kz2 = kG * kbp + klp 

    alp[kindx] = klp
    ahp[kindx] = khp
    abp[kindx] = kbp
    anotch[kindx] = knotch
    kindx += 1
  od

  xout alp, abp, ahp, anotch

endop

;; moog ladder

opcode zdf_ladder, a, akk

  ain, kcf, kres     xin
  aout init 0

  kR = limit(1 - kres, 0.025, 1)

  kQ = 1 / (2 * kR) 

  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kg  = kwa * iT/2 

  kk = 4.0*(kQ - 0.707)/(25.0 - 0.707)

  kg_2 = kg * kg
  kg_3 = kg_2 * kg

  ; big combined value
  ; for overall filter
  kG  = kg_2 * kg_2  
  ; for individual 1-poles
  kG_pole = kg/(1.0 + kg)

  ;; state for each 1-pole's integrator 
  kz1 init 0
  kz2 init 0
  kz3 init 0
  kz4 init 0

  kindx = 0
  while kindx < ksmps do
    ;; processing
    kin = ain[kindx]

    kS = kg_3 * kz1 + kg_2 * kz2 + kg * kz3 + kz4
    ku = (kin - kk *  kS) / (1 + kk * kG)

    ;; 1st stage
    kv = (ku - kz1) * kG_pole 
    klp = kv + kz1
    kz1 = klp + kv

    ;; 2nd stage
    kv = (klp - kz2) * kG_pole 
    klp = kv + kz2
    kz2 = klp + kv

    ;; 3rd stage
    kv = (klp - kz3) * kG_pole 
    klp = kv + kz3
    kz3 = klp + kv

    ;; 4th stage
    kv = (klp - kz4) * kG_pole 
    klp = kv + kz4
    kz4 = klp + kv

    aout[kindx] = klp

    kindx += 1
  od

  xout aout
endop


opcode zdf_ladder, a, aaa

  ain, acf, ares     xin
  aout init 0

  iT  = 1/sr 

  ;; state for each 1-pole's integrator 
  kz1 init 0
  kz2 init 0
  kz3 init 0
  kz4 init 0

  kindx = 0
  while kindx < ksmps do

    kR = limit(1 - ares[kindx], 0.025, 1)

    kQ = 1 / (2 * kR) 

    kwd = 2 * $M_PI * acf[kindx]
    kwa = (2/iT) * tan(kwd * iT/2) 
    kg  = kwa * iT/2 

    kk = 4.0*(kQ - 0.707)/(25.0 - 0.707)

    kg_2 = kg * kg
    kg_3 = kg_2 * kg

    ; big combined value
    ; for overall filter
    kG  = kg_2 * kg_2  
    ; for individual 1-poles
    kG_pole = kg/(1.0 + kg)

    ;; processing
    kin = ain[kindx]

    kS = kg_3 * kz1 + kg_2 * kz2 + kg * kz3 + kz4
    ku = (kin - kk *  kS) / (1 + kk * kG)

    ;; 1st stage
    kv = (ku - kz1) * kG_pole 
    klp = kv + kz1
    kz1 = klp + kv

    ;; 2nd stage
    kv = (klp - kz2) * kG_pole 
    klp = kv + kz2
    kz2 = klp + kv

    ;; 3rd stage
    kv = (klp - kz3) * kG_pole 
    klp = kv + kz3
    kz3 = klp + kv

    ;; 4th stage
    kv = (klp - kz4) * kG_pole 
    klp = kv + kz4
    kz4 = klp + kv

    aout[kindx] = klp

    kindx += 1
  od

  xout aout
endop

;; 4-pole

opcode zdf_4pole, aaaaaa, akk
  ain, kcf, kres xin

  alp2, abp2, ahp2 zdf_2pole ain, kcf, kres

  abp4 init 0
  abl4 init 0
  alp4 init 0

  xout alp2, abp2, ahp2, alp4, abl4, abp4
endop

opcode zdf_4pole, aaaaaa, aaa
  ain, acf, ares xin

  alp2, abp2, ahp2 zdf_2pole ain, acf, ares
  abp4 init 0
  abl4 init 0
  alp4 init 0

  xout alp2, abp2, ahp2, alp4, abl4, abp4
endop


opcode zdf_4pole_hp, aaaaaa, akk
  ain, kcf, kres xin

  alp2, abp2, ahp2 zdf_2pole ain, kcf, kres

  ahp4 init 0
  abh4 init 0
  abp4 init 0

  xout alp2, abp2, ahp2, abp4, abh4, ahp4
endop

opcode zdf_4pole_hp, aaaaaa, aaa
  ain, acf, ares xin

  alp2, abp2, ahp2 zdf_2pole ain, acf, ares

  ahp4 init 0
  abh4 init 0
  abp4 init 0

  xout alp2, abp2, ahp2, abp4, abh4, ahp4
endop

;; TODO - implement
opcode zdf_peak_eq, a, akkk
  ain, kcf, kres, kdB xin

  aout init 0

  xout aout
endop

opcode zdf_high_shelf_eq, a, akk
  ain, kcf, kdB xin

  ;; TODO - convert db to K, check if reusing zdf_1pole is sufficient
  kK init 0

  alp, ahp zdf_1pole ain, kcf

  aout = ain + kK * ahp

  xout aout
endop

opcode zdf_low_shelf_eq, a, akk
  ain, kcf, kdB xin

  ;; TODO - convert db to K, check if reusing zdf_1pole is sufficient
  kK init 0

  alp, ahp zdf_1pole ain, kcf

  aout = ain + kK * alp

  xout aout
endop



instr 21

endin

instr 20
 event_i "i", 19, 604800.0, 1.0e-2
endin

instr 19
ir1 = 18
ir2 = 0.0
 turnoff2 ir1, ir2, ir2
 exitnow 
endin

instr 18
arl0 init 0.0
arl1 init 0.0
ir5 = 5.0e-2
ir6 = 0.0
ir7 = 1.0
ar0 upsamp k(ir7)
kr0 loopseg ir5, ir6, 0.0, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir7, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6
ir9 = 1.0e-3
kr1 portk kr0, ir9
ar1 upsamp kr1
ar2 = (0.35 * ar1)
ir12 = 1430.0
kr0 vco2ft ir12, 4
ar1 oscilikt ir7, ir12, kr0
ir15 = 8.0
kr0 vco2ft ir15, 3
ar3 oscilikt ir7, ir15, kr0
ar4 = (0.5 * ar3)
ar3 = (0.5 + ar4)
ir20 = 1650.0
kr0 vco2ft ir20, 4
ar4 oscilikt ir7, ir20, kr0
ar5 = (ar3 * ar4)
ar4 = (ar1 + ar5)
ar1 = (ar2 * ar4)
ir26 = 0.15
ar2 oscil3 ir7, ir26, 2
ar4 = (0.5 * ar2)
ar2 = (0.5 + ar4)
ar4 = (0.25 * ar2)
ar5 = (0.2 + ar4)
ar4, ar6 pan2 ar1, ar5
ir34 = 0.125
kr0 lpshold ir34, ir6, 0.0, ir7, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir26, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7
kr1 portk kr0, ir9
ar1 upsamp kr1
ar5 = (0.2 * ar1)
ir38 = 770.0
kr0 vco2ft ir38, 4
ar1 oscilikt ir7, ir38, kr0
ar7 = (ar5 * ar1)
ar1 = (0.10000000000000003 * ar2)
ar2 = (0.45 + ar1)
ar1, ar5 pan2 ar7, ar2
ar2 = (ar4 + ar1)
kr0 lpshold ir5, ir6, 0.0, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir7, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7, ir6, ir7
kr1 portk kr0, ir9
ar1 upsamp kr1
ar4 = (0.4 * ar1)
ir50 = 1210.0
kr0 vco2ft ir50, 4
ar1 oscilikt ir7, ir50, kr0
ar7 = (ar4 * ar1)
ar4 = (0.36 * ar7)
ir55 = 1.5
ar8 upsamp k(ir55)
ir56 = 0.75
ar9 flanger ar7, ar8, ir56, 1.505
ar8 = (ar7 + ar9)
ar7 = (0.64 * ar8)
ar8 = (ar4 + ar7)
kr0 oscil3 ir7, ir7, 2
kr1 = (0.5 * kr0)
kr0 = (0.5 + kr1)
ar4 upsamp kr0
ar7 = (0.39999999999999997 * ar4)
ar9 = (0.3 + ar7)
ar7, ar10 pan2 ar8, ar9
ar8 = (ar2 + ar7)
ir69 = 3.8461538461538464e-2
ir70 = 0.5
ir71 = 0.2
kr1 loopseg ir69, ir6, 0.0, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir70, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir71, ir6
kr2 portk kr1, ir9
ar2 upsamp kr2
ar7 = (0.35 * ar2)
kr1 vco2ft ir15, 4
ar2 oscilikt ir7, ir15, kr1
ar9 = (0.5 * ar2)
ar2 = (0.5 + ar9)
ir79 = 1540.0
kr1 vco2ft ir79, 4
ar9 oscilikt ir7, ir79, kr1
ar11 = (ar2 * ar9)
ar2 = (ar1 + ar11)
ir84 = 9.0
kr1 vco2ft ir84, 4
ar1 oscilikt ir7, ir84, kr1
ar9 = (0.5 * ar1)
ar1 = (0.5 + ar9)
ir89 = 1760.0
kr1 vco2ft ir89, 4
ar9 oscilikt ir7, ir89, kr1
ar11 = (ar1 * ar9)
ar1 = (ar2 + ar11)
ar2 = (ar7 * ar1)
ir95 = 0.25
kr1 oscil3 ir7, ir95, 2
kr2 = (0.5 * kr1)
kr1 = (0.5 + kr2)
ar1 upsamp kr1
ar7 = (0.1499999999999999 * ar1)
ar9 = (0.8 + ar7)
ar7, ar11 pan2 ar2, ar9
ar2 = (ar8 + ar7)
ir104 = 2.9411764705882353e-2
kr2 loopseg ir104, ir6, 0.0, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir56, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir6, ir6, ir6, ir7, ir71, ir6, ir6, ir7, ir6, ir6
kr3 portk kr2, ir9
ar7 upsamp kr3
ir107 = 6.0
kr2 vco2ft ir107, 3
ar8 oscilikt ir7, ir107, kr2
ar9 = (0.5 * ar8)
ar8 = (0.5 + ar9)
kr2 vco2ft ir50, 0
ar9 oscilikt ir7, ir50, kr2
ar12 = (ar8 * ar9)
kr2 vco2ft ir20, 0
ar8 oscilikt ir7, ir20, kr2
ar9 = (ar3 * ar8)
ar3 = (ar12 + ar9)
ir119 = 7.0
kr2 vco2ft ir119, 3
ar8 oscilikt ir7, ir119, kr2
ar9 = (0.5 * ar8)
ar8 = (0.5 + ar9)
kr2 vco2ft ir89, 3
ar9 oscilikt ir7, ir89, kr2
ar12 = (ar8 * ar9)
ar8 = (ar3 + ar12)
ar3 = (ar7 * ar8)
ir129 = 0.18
ar7 oscil3 ir7, ir129, 2
ar8 = (0.5 * ar7)
ar7 = (0.5 + ar8)
ar8 = (0.15000000000000002 * ar7)
ar7 = (0.5 + ar8)
ar8, ar9 pan2 ar3, ar7
ar3 = (ar2 + ar8)
ir138 = 0.1
ar2 oscil3 ir7, ir138, 2
ar7 = (0.5 * ar2)
ar2 = (0.5 + ar7)
ar7 = (0.8 * ar2)
ar2 = (0.2 + ar7)
ar7 = (1.0 - ar2)
ir145 = 0.12
ar8 oscil3 ir7, ir145, 2, 0.3
ar12 = (0.5 * ar8)
ar8 = (0.5 + ar12)
ar12 = (0.8 * ar8)
ar8 = (0.2 + ar12)
ar12 = (1.0 - ar8)
ar13 = (ar7 * ar12)
ir153 = 43.0
ar14 oscil3 ir7, ir153, 2
ir155 = 23.0
ar15 oscil3 ir7, ir155, 2
ir157 = 85.0
ar16 oscil3 ir7, ir157, 2
ir159 = 60.0
ar17 oscil3 ir7, ir159, 2
kr2 loopseg ir56, ir6, 0.0, ir6, ir7, ir7, ir7, ir6, ir7, ir70, ir7, ir6, ir7, ir71, ir7, ir6, ir7, ir138, ir7, ir6, ir6, ir6
kr3 portk kr2, ir9
ar18 upsamp kr3
ir163 = 220.0
ar19 oscil3 ir7, ir163, 2
ar20 oscil3 ir7, ir71, 2
ar21 = (1.3 * ar20)
ar20 = (220.0 + ar21)
ar21 oscil3 ir7, ar20, 2
ar20 = (ar19 + ar21)
ar19 = (6.0 * ar4)
ar4 = (220.0 + ar19)
ar19 oscil3 ir7, ar4, 2
ar4 = (ar20 + ar19)
ir174 = 223.5
ar19 oscil3 ir7, ir174, 2
ar20 = (ar4 + ar19)
ar4 = (ar20 / 4.0)
ar19 = (ar18 * ar4)
ar4 = (ar17 * ar19)
ar17 = (ar16 * ar4)
ar4 = (ar15 * ar17)
ar15 = (ar14 * ar4)
ir183 = 110.0
kr2 vco2ft ir183, 4
ar4 oscilikt ir7, ir183, kr2
ar14 = (1.0e-2 * ar4)
ar4 = (ar15 + ar14)
ar14 = (ar13 * ar4)
ar13 = (ar2 * ar12)
ir190 = 750.0
ar12 moogvcf ar4, ir190, ir138
ar15 = (ar13 * ar12)
ar12 = (ar14 + ar15)
ar13 = (ar2 * ar8)
ir195 = 450.0
ar2 moogladder ar4, ir195, ir71
ar14 = (ar13 * ar2)
ar2 = (ar12 + ar14)
ar12 = (ar7 * ar8)
ir200 = 1660.0
kr2 lpshold ir5, ir6, 0.0, ir6, ir7, ir6, ir7, ir7, ir7, ir6, ir7, ir6, ir7
kr3 portk kr2, ir9
kr2 = (0.2 * kr0)
kr0 = (0.2 + kr2)
kr2 = (kr3 * kr0)
kr0 = (kr2 * kr1)
kr1 = (0.7 + kr0)
kr0 = (3.5 * kr1)
kr1 = (0.5 + kr0)
ar7 tbvcf ar4, ir200, ir70, kr1, ir70
ar4 = (ar12 * ar7)
ar7 = (ar2 + ar4)
ar2 = (ar3 + ar7)
ir214 = 0.27
ar3 oscil3 ir7, ir214, 2
ar4 = (0.5 * ar3)
ar3 = (0.5 + ar4)
ar4 = (ar1 + ar3)
ar1 = (100.0 * ar4)
ar3 = (350.0 + ar1)
ir221 = 0.17
ar1 oscil3 ir7, ir221, 2
ar4 = (0.5 * ar1)
ar1 = (0.5 + ar4)
ar4 = (0.3 * ar1)
ar1 = (0.2 + ar4)
ar4 zdf_ladder ar2, ar3, ar1
ir228 = 95.0
ar2 buthp ar4, ir228
ar4 = (0.75 * ar2)
ar8 = (ar6 + ar5)
ar5 = (ar8 + ar10)
ar6 = (ar5 + ar11)
ar5 = (ar6 + ar9)
ar6 = (ar5 + ar7)
ar5 zdf_ladder ar6, ar3, ar1
ar1 buthp ar5, ir228
ir243 = 0.99
ir244 = 12000.0
ar3, ar5 reverbsc ar2, ar1, ir243, ir244
ar6 = (ar2 + ar3)
ar2 = (0.25 * ar6)
ar3 = (ar4 + ar2)
ar2 = (5.5 * ar3)
ir251 = 90.0
ir252 = 100.0
ar3 compress ar2, ar0, ir6, ir251, ir251, ir252, ir6, ir6, 0.0
ar2 = (ar3 * 0.8)
arl0 = ar2
ar2 = (0.75 * ar1)
ar3 = (ar1 + ar5)
ar1 = (0.25 * ar3)
ar3 = (ar2 + ar1)
ar1 = (5.5 * ar3)
ar2 compress ar1, ar0, ir6, ir251, ir251, ir252, ir6, ir6, 0.0
ar0 = (ar2 * 0.8)
arl1 = ar0
ar0 = arl0
ar1 = arl1
 outs ar0, ar1
endin

</CsInstruments>

<CsScore>

f2 0 8192 10  1.0

f0 604800.0

i 21 0.0 -1.0 
i 20 0.0 -1.0 
i 18 0.0 -1.0 

</CsScore>



</CsoundSynthesizer>