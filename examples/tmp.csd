<CsoundSynthesizer>

<CsOptions>

--output=dac --nodisplays

</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 1
0dbfs = 1.0
giPort init 1
opcode FreePort, i, 0
xout giPort
giPort = giPort + 1
endop




instr 21

endin

instr 20
 event_i "i", 19, 604800.0, 1.0e-2
endin

instr 19
 turnoff2 18, 0.0, 0.0
 exitnow 
endin

instr 18
arl0 init 0.0
ir3 = 1.0
ar0 upsamp k(ir3)
ir4 = 6.11
ir5 = cpspch(ir4)
ir6 = 7.0
ir7 = cpspch(ir6)
kr0 linseg ir5, 2.0, ir5, 0.3, ir7, 0.8, ir7, 1.0, ir7
ar1 oscil3 ir3, kr0, 2
ar2 = (ar1 / 5.0)
ir11 = 7.03
ir12 = cpspch(ir11)
ir13 = 7.04
ir14 = cpspch(ir13)
kr0 linseg ir12, 2.0, ir12, 0.3, ir14, 0.8, ir14, 1.0, ir14
ar1 oscil3 ir3, kr0, 2
ar3 = (ar1 / 5.0)
ar1 = (ar2 + ar3)
ir19 = 7.06
ir20 = cpspch(ir19)
ir21 = 7.08
ir22 = cpspch(ir21)
kr0 linseg ir20, 2.0, ir20, 0.3, ir22, 0.8, ir22, 1.0, ir22
ar2 oscil3 ir3, kr0, 2
ar3 = (ar2 / 5.0)
ar2 = (ar1 + ar3)
ir27 = 7.1
ir28 = cpspch(ir27)
ir29 = 7.09
ir30 = cpspch(ir29)
kr0 linseg ir28, 2.0, ir28, 0.3, ir30, 0.8, ir30, 1.0, ir30
ar1 oscil3 ir3, kr0, 2
ar3 = (ar1 / 5.0)
ar1 = (ar2 + ar3)
ir35 = 8.0
ir36 = cpspch(ir35)
ir37 = 8.02
ir38 = cpspch(ir37)
kr0 linseg ir36, 2.0, ir36, 0.3, ir38, 0.8, ir38, 1.0, ir38
ar2 oscil3 ir3, kr0, 2
ar3 = (ar2 / 5.0)
ar2 = (ar1 + ar3)
ir43 = 0.0
ir44 = 90.0
ir45 = 100.0
ar1 compress ar2, ar0, ir43, ir44, ir44, ir45, ir43, ir43, 0.0
ar0 = (ar1 * 0.8)
arl0 = ar0
ar0 = arl0
 out ar0
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