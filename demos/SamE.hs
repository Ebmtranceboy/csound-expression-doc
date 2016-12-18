module SamE where


import Data.Foldable(Foldable(foldMap))
import Data.Traversable hiding (mapM)
import Control.Arrow(first, second)

import Csound.Base
import qualified Csound.Sam as S
import Csound.Sam 
------------------------------------------------------

main = dac $ 	
	at (smallRoom2) $ S.runSam (120 * 4) $ sum [
		 samCharToggle Nothing 'q' f
		, samCharCycle Nothing '5' "6" [w, f]
		, samCharTrig Nothing "s" "x" (mul 0.3 d)
		,  mul 0.5 $ samCharTrig Nothing "a" "zx" w
		, samCharGroup Nothing [('1', mul (fades 0.5 0.5) w), ('2', f)] "3x"
		, samCharTap 1 "i" t11
		, samCharTap 1 "o" t12
		, samCharTap 1 "p" t13
		, samCharTap 1 "k" t21 
		, samCharTap 1 "l" t22
		, samCharTap 1 "u" t31
		, samCharTap 1 "j" t32 
		, samCharTap 1 "y" t33
		]

w = loop $ S.wav "sample/Jazz Thing Submarine.wav"
d = S.wav "sample/Owl.wav"
f = loop $ S.wav "sample/Worries Soundboy.wav"
g = mul 2.5 $ S.wav "sample/Let Roll Vox.wav"
h = mul 1.5 $ S.wav "sample/Radio.wav"

tap = S.wav . ("sample/drum-82/" ++ )

t11 = tap "hihat.wav"
t12 = tap "bass.wav"
t13 = tap "bass drum.wav"
t21 = tap "Hey.wav"
t22 = tap "perc.wav"
t31 = tap "shaker.wav"
t32 = tap "sitars.wav"
t33 = tap "snare.wav"

