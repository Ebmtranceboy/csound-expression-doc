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
ir11 = (sr / kr)
gkrgg4 init ir11
gargg3 init 0.0
gkrgg2 init 0.0
gargg1 init 0.0
gargg0 init 0.0
giPort init 1
opcode FreePort, i, 0
xout giPort
giPort = giPort + 1
endop




instr 22

endin

instr 21
 event_i "i", 20, 604800.0, 1.0e-2
endin

instr 20
 turnoff2 19, 0.0, 0.0
 turnoff2 18, 0.0, 0.0
 exitnow 
endin

instr 19
ar0 = gargg1
kr0 = gkrgg2
kr1 = gkrgg4
until (kr0 >= kr1) do
    ar1 = gargg3
    ir11 cpsmidi 
    kr1 = (6.283185307179586 * ir11)
    kr2 = (kr1 / sr)
    ar2 upsamp kr2
    ar3 = gargg3
    ar4 = (ar2 + ar3)
    gargg3 = ar4
    ar2 = gargg3
    ar3 = gargg3
    kr1 downsamp ar3
    kr2 = sin(kr1)
    kr1 = (kr2 / 3.0)
    kr2 = gkrgg2
     vaset kr1, kr2, ar0
    kr1 = (1.0 + kr0)
    gkrgg2 = kr1
    kr0 = gkrgg2
    kr1 = gkrgg4
od
gkrgg2 = 0.0
ar3 = gargg0
ir39 active p1
ar4 upsamp k(ir39)
ar5 = sqrt(ar4)
ar4 = (1.0 / ar5)
if (ir39 < 2.0) then
    ar5 = 1.0
else
    ar5 = ar4
endif
ir43 ampmidi 1.0
ar4 upsamp k(ir43)
ar6 = (ar4 * ar0)
ar0 = (ar5 * ar6)
ar4 = (ar3 + ar0)
gargg0 = ar4
endin

instr 18
ar0 = gargg0
gargg0 = 0.0
arl0 init 0.0
ir7 = 1.0
ar1 upsamp k(ir7)
ir8 = 0.0
ir9 = 90.0
ir10 = 100.0
ar2 compress ar0, ar1, ir8, ir9, ir9, ir10, ir8, ir8, 0.0
ar0 = (ar2 * 0.8)
arl0 = ar0
ar0 = arl0
 out ar0
endin

</CsInstruments>

<CsScore>



f0 604800.0

i 22 0.0 -1.0 
i 21 0.0 -1.0 
i 18 0.0 -1.0 

</CsScore>



</CsoundSynthesizer>