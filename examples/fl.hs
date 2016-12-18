import Csound.Base
freq  = slider "frequency" (linSpan 30 2000) 0.5
main = dac $ do { (gui, f) <- freq; panel gui; return (0.3 * osc f) }

