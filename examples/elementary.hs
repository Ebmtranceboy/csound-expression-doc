import Csound.Base

oscilla x = oscil 1000 x $ gen 10 [1]
env   = linseg [1, 1, 0]

q1 x = osc x * env
q2 x = env * osc x

score1 = temp 440
score2 = temp $ cpspch 8.00

main = dac $ mix $ mel [sco (return . q1 . sig) $ score1 +:+ score2, sco (return . q2 . sig) $ score1 +:+ score2] 