<CsoundSynthesizer>

<CsOptions>

--output=dac --midi-device=a --nodisplays

</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 1
0dbfs = 1.0
 massign 0, 19
gargg3 init 0.0
gkrgg2 init 1.0
gkrgg1 init 0.0
gkrgg0 init 0.0
girgfree_vco = 103
ir21 = girgfree_vco
ir23 vco2init 1, ir21
girgfree_vco = ir23
giPort init 1
opcode FreePort, i, 0
xout giPort
giPort = giPort + 1
endop


FLpanel "", 205, 65, -1, -1, 0, 0
gkrgg0, girgh0 FLbutton "osc", 1, 0, 22, 75, 35, 15, 15, -1



FLsetTextSize 15, girgh0



gkrgg1, girgh1 FLbutton "instr", 1, 0, 22, 75, 35, 115, 15, -1



FLsetTextSize 15, girgh1


FLsetVal_i 1.0, girgh1
FLpanelEnd 
FLrun

instr 22

endin

instr 21
 event_i "i", 20, 604800.0, 1.0e-2
endin

instr 20
ir1 = 19
ir2 = 0.0
 turnoff2 ir1, ir2, ir2
ir5 = 18
 turnoff2 ir5, ir2, ir2
 exitnow 
endin

instr 19
arl0 init 0.0
arl0 = 0.0
kr0 = gkrgg2
if (0.0 == kr0) then
    ir8 ampmidi 1.0
    ar0 upsamp k(ir8)
    ir9 = 1.0
    ir10 cpsmidi 
    ir11 cpsmidi 
    kr1 vco2ft ir11, 0
    ar1 oscilikt ir9, ir10, kr1
    ar2 = (ar0 * ar1)
    arl0 = ar2
endif
ar0 = arl0
arl1 init 0.0
arl1 = 0.0
if (1.0 == kr0) then
    ir27 ampmidi 1.0
    ar1 upsamp k(ir27)
    kr0 linseg 0.0, 0.2, 1.0, 1.0, 1.0
    ar2 upsamp kr0
    kr0 linsegr 1.0, 1.0, 1.0, 0.2, 0.0
    ar3 upsamp kr0
    ar4 = (ar2 * ar3)
    ir31 = 1.0
    ir32 cpsmidi 
    ar2 oscil3 ir31, ir32, 2
    ar3 = (ar4 * ar2)
    ar2 = (ar1 * ar3)
    arl1 = ar2
endif
ar1 = arl1
ar2 = gargg3
ir44 active p1
ar3 upsamp k(ir44)
ar4 = sqrt(ar3)
ar3 = (1.0 / ar4)
if (ir44 < 2.0) then
    ar4 = 1.0
else
    ar4 = ar3
endif
ar3 = (ar0 + ar1)
ar0 = (ar4 * ar3)
ar1 = (ar2 + ar0)
gargg3 = ar1
endin

instr 18
kr0 = gkrgg2
ir3 = girgh0
if (kr0 == 0.0) then
    kr1 = 1.0
else
    kr1 = 0.0
endif
kr2 changed kr1
 FLsetVal kr2, kr1, ir3
ir9 = girgh1
if (kr0 == 1.0) then
    kr1 = 1.0
else
    kr1 = 0.0
endif
kr2 changed kr1
 FLsetVal kr2, kr1, ir9
kr1 changed gkrgg0
if (kr1 == 1.0) then
    if (gkrgg0 == 1.0) then
        gkrgg2 = 0.0
    endif
    if ((gkrgg0 == 0.0) && (kr0 == 0.0)) then
        gkrgg2 = 0.0
    endif
endif
kr1 changed gkrgg1
if (kr1 == 1.0) then
    if (gkrgg1 == 1.0) then
        gkrgg2 = 1.0
    endif
    if ((gkrgg1 == 0.0) && (kr0 == 1.0)) then
        gkrgg2 = 1.0
    endif
endif
kr0 = gkrgg2
ar0 = gargg3
gargg3 = 0.0
arl0 init 0.0
ir57 = 1.0
ar1 upsamp k(ir57)
ir58 = 0.0
ir59 = 90.0
ir60 = 100.0
ar2 compress ar0, ar1, ir58, ir59, ir59, ir60, ir58, ir58, 0.0
ar0 = (ar2 * 0.8)
arl0 = ar0
ar0 = arl0
 out ar0
endin

</CsInstruments>

<CsScore>

f2 0 8192 10  1.0

f0 604800.0

i 22 0.0 -1.0 
i 21 0.0 -1.0 
i 18 0.0 -1.0 

</CsScore>



</CsoundSynthesizer>