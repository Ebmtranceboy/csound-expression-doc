
import Csound.Base

oct = 6
b1 = cpspch $ oct + 1 + 0.11
c2 = cpspch $ oct + 2 + 0.00
e2 = cpspch $ oct + 2 + 0.04
ds2 = cpspch $ oct + 2 + 0.03
gs2 = cpspch $ oct + 2 + 0.08
fs2 = cpspch $ oct + 2 + 0.06
as2 = cpspch $ oct + 2 + 0.10
a2 = cpspch $ oct + 2 + 0.09
c3 = cpspch $ oct + 3 + 0.00
d3 = cpspch $ oct + 3 + 0.02

porta ini fin = (/5) $ osc $ linseg [ini, 2, ini, 0.3, fin, 0.8, fin]

main = dac $ sum [porta b1 c2
                 ,porta ds2 e2
                 ,porta fs2 gs2
                 ,porta as2 a2
                 ,porta c3 d3
      ]
