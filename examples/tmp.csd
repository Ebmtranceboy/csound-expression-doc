<CsoundSynthesizer>

<CsOptions>

--output=dac --midi-device=a --nodisplays

</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0
 massign 0, 19
gargg1 init 0.0
gargg0 init 0.0
girgfree_vco = 101
ir17 = girgfree_vco
ir19 vco2init 1, ir17
girgfree_vco = ir19
ir22 = girgfree_vco
ir24 vco2init 16, ir22
girgfree_vco = ir24
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
ir1 = 1.0
ir2 = rnd(ir1)
ir4 = rnd(ir1)
ir6 = rnd(ir1)
ir8 = rnd(ir1)
ar0 = gargg0
ar1 = gargg1
ir14 active p1
ar2 upsamp k(ir14)
ar3 = sqrt(ar2)
ar2 = (1.0 / ar3)
if (ir14 < 2.0) then
    ar3 = 1.0
else
    ar3 = ar2
endif
ir18 ampmidi 1.0
ar2 upsamp k(ir18)
ar4 = (0.45 * ar2)
kr0 linseg 0.0, 1.0e-2, 1.0, 1.0, 1.0
ar2 upsamp kr0
kr0 linsegr 1.0, 1.0, 1.0, 0.1, 0.0
ar5 upsamp kr0
ar6 = (ar2 * ar5)
ar2 = (ar4 * ar6)
ir24 cpsmidi 
kr0 = (ir24 * 1.0)
kr1 vco2ft kr0, 0
ar4 oscilikt ir1, kr0, kr1, ir2
kr1 = (2.01 * kr0)
kr0 vco2ft kr1, 4
ar5 oscilikt ir1, kr1, kr0, ir4
ar6 = (ar4 + ar5)
ar4 madsr 1.0e-3, 0.22, 1.0e-3, 0.2
ar5 = (5500.0 * ar4)
ir34 = 0.7
ar4 moogvcf ar6, ar5, ir34
ar6 = (ar2 * ar4)
ar4 = (0.75 * ar6)
kr0 = (ir24 * 0.5)
kr1 vco2ft kr0, 0
ar6 oscilikt ir1, kr0, kr1, ir6
kr1 = (2.01 * kr0)
kr0 vco2ft kr1, 4
ar7 oscilikt ir1, kr1, kr0, ir8
ar8 = (ar6 + ar7)
ar6 moogvcf ar8, ar5, ir34
ar5 = (ar2 * ar6)
ar2 = (0.375 * ar5)
ar5 = (ar4 + ar2)
ar2 = (ar3 * ar5)
ar3 = (ar0 + ar2)
gargg0 = ar3
ar0 = (ar1 + ar2)
gargg1 = ar0
endin

instr 18
ar0 = gargg0
ar1 = gargg1
gargg0 = 0.0
gargg1 = 0.0
arl0 init 0.0
arl1 init 0.0
ar2 = (0.25 * ar0)
ir14 = 0.8
ir15 = 12000.0
ar3, ar4 reverbsc ar0, ar1, ir14, ir15
ar5 = (ar0 + ar3)
ar0 = (0.75 * ar5)
ar3 = (ar2 + ar0)
ir21 = 1.0
ar0 upsamp k(ir21)
ir22 = 0.0
ir23 = 90.0
ir24 = 100.0
ar2 compress ar3, ar0, ir22, ir23, ir23, ir24, ir22, ir22, 0.0
ar3 = (ar2 * 0.8)
arl0 = ar3
ar2 = (0.25 * ar1)
ar3 = (ar1 + ar4)
ar1 = (0.75 * ar3)
ar3 = (ar2 + ar1)
ar1 compress ar3, ar0, ir22, ir23, ir23, ir24, ir22, ir22, 0.0
ar0 = (ar1 * 0.8)
arl1 = ar0
ar0 = arl0
ar1 = arl1
 outs ar0, ar1
endin

</CsInstruments>

<CsScore>



f0 604800.0

i 22 0.0 -1.0 
i 21 0.0 -1.0 
i 18 0.0 -1.0 

</CsScore>



</CsoundSynthesizer>