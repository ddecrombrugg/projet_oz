local
   P1 = [e3 g3 duration(seconds:2.0 [[a3 e a]]) c d stretch(factor:0.4 [e d]) stretch(factor:0.8 [c b3]) duration(seconds:2.0 [[a3 e a]]) silence(duration:0.3) e3 a3 b3 duration(seconds:2.0 [b3])  c d stretch(factor:0.8 [c b3]) duration(seconds:2.0 [[a3 e a]]) silence(duration:0.3)]
   P2 = [e3 g3 duration(seconds:2.0 [[a3 e a]]) silence(duration:0.3) c d stretch(factor:0.8 [c b3]) g3 duration(seconds:2.0 [[a3 e a]]) silence(duration:0.3) e3 a3 b3 b3 duration(seconds:1.5 [b3]) c d stretch(factor:0.8 [c b3]) a3 duration(seconds:2.0 [b3]) silence(duration:0.3) c d b3 duration(seconds:2.0 [e]) c d a3 duration(seconds:2.0 [b3]) e3 g3 b3 c duration(seconds:2.0 [c]) b3 g3 duration(seconds:2.0 [[a3 e a]])]
   P4 = [stretch(factor:0.7 {Append P1 P2})]
   M1 = [wave('/Users/adrienbanse/Documents/projet_oz/ozplayer/wave/instruments/bee_long_b3.wav')]
   M2 = [wave('/Users/adrienbanse/Documents/projet_oz/ozplayer/wave/instruments/bee_long_e4.wav')]
   M3 = [wave('/Users/adrienbanse/Documents/projet_oz/ozplayer/wave/instruments/bee_long_c4.wav')]
   M4 = [wave('/Users/adrienbanse/Documents/projet_oz/ozplayer/wave/instruments/bee_long_a3.wav')]
   M = [partition([silence(duration:2.0)])
	fade(start:0.0 out:1.0 M4)
	partition([silence(duration:4.4)])
	fade(start:0.0 out:1.0 M4)
	partition([silence(duration:3.3)])
	fade(start:0.0 out:1.0 M1)
	partition([silence(duration:3.6)])
	fade(start:0.0 out:1.0 M4)
	partition([silence(duration:2.3)])
	fade(start:0.0 out:1.0 M4)
	partition([silence(duration:4.9)])
	fade(start:0.0 out:1.0 M4)
	partition([silence(duration:4.3)])
	fade(start:0.0 out:1.0 M1)
	partition([silence(duration:4.6)])
	fade(start:0.0 out:1.0 M1)
	partition([silence(duration:3.3)])
	fade(start:0.0 out:1.0 M2)
	partition([silence(duration:3.0)])
	fade(start:0.0 out:1.0 M1)
	partition([silence(duration:4.0)])
	fade(start:0.0 out:1.0 M3)
	partition([silence(duration:2.0)])
	fade(start:0.0 out:1.0 M4)]
   
in
   M
end
