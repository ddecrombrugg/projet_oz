local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Translate a note to the extended notation.
   fun {NoteToExtended Note}
      case Note
      of Name#Octave then
	 note(name:Name
	      octave:Octave
	      sharp:true
	      duration:1.0
	      instrument:none)
      [] Atom then
         case {AtomToString Atom}
         of [_] then
	    note(name:Atom
		 octave:4
		 sharp:false
		 duration:1.0
		 instrument:none)
         [] [N O] then
            note(name:{StringToAtom [N]}
                 octave:{StringToInt [O]}
                 sharp:false
                 duration:1.0
                 instrument: none)
         end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Create a list of Notes (Chord) in a list of ExtendedNotes (ExtendedChord)
   fun {CreateListNotesNE Chord}
      case Chord of nil then nil
      [] H|T then
	 {NoteToExtended H}|{CreateListNotesNE T}
      else nil
      end
   end

   fun {TransposeInt1 Alias Semitones OctaveAcc}
      if Semitones==0 then [Alias OctaveAcc]
      else	 
	 if (Alias==1) andthen (Semitones<0) then
	    {TransposeInt1 (12) (Semitones+1) (OctaveAcc-1)}
	 elseif (Alias==12) andthen (Semitones>0) then
	    {TransposeInt1 (1) (Semitones-1) (OctaveAcc+1)}
	 else
	    if Semitones>0 then
	       {TransposeInt1 (Alias+1) (Semitones-1) OctaveAcc}
	    else
	       {TransposeInt1 (Alias-1) (Semitones+1) OctaveAcc}
	    end
	 end
      end
   end

   fun {TransposeInt2 L Semitones}
      case L of H|T then
	 case {Label H} of 'note' then
	    local L1 in
	       L1 = {TransposeInt1 H.name Semitones 0}
	       note(name:L1.1
		    octave:H.octave + L1.2.1
		    sharp:H.sharp
		    duration:H.duration
		    instrument:H.instrument)|{TransposeInt2 T Semitones}
	    end
	 [] 'silence' then
	    silence(duration:H.duration)|{TransposeInt2 T Semitones}
	 else
	    case H of H2|T2 then
	       local L1 L2 in
		  case {Label H2} of 'note' then
		     L1 = {TransposeInt1 H2.name Semitones 0}
		     L2 = note(name:L1.1
			       octave:H2.octave + L1.2.1
			       sharp:H2.sharp
			       duration:H2.duration
			       instrument:H2.instrument)|{TransposeInt2 T2 Semitones}
		     L2|{TransposeInt2 T Semitones}
		  [] 'silence' then
		     L2 = silence(duration:H2.duration)|{TransposeInt2 T2 Semitones}
		     L2|{TransposeInt2 T Semitones}
		  else nil
		  end
	       end
	    else nil
	    end
	 end
      else nil
      end
   end
	    

   fun {Link1 L}
      local R in
	 R = allnotes(c:1 d:3 e:5 f:6 g:8 a:10 b:12)
	 case L of nil then nil
	 [] H|T then
	    case {Label H} of 'note' then
	       if H.sharp then
		  note(name:(R.(H.name)+1)
		       octave:H.octave
		       sharp:H.sharp
		       duration:H.duration
		       instrument:H.instrument)|{Link1 T}
	       else
		  note(name:(R.(H.name))
		       octave:H.octave
		       sharp:H.sharp
		       duration:H.duration
		       instrument:H.instrument)|{Link1 T}
	       end
	    [] 'silence' then
	       silence(duration:H.duration)|{Link1 T}
	    else
	       case H of H2|T2 then
		  local L2 in
		     case {Label H2} of 'note' then
			if H2.sharp then
			   L2 = note(name:(R.(H2.name)+1)
				     octave:H2.octave
				     sharp:H2.sharp
				     duration:H2.duration
				     instrument:H2.instrument)|{Link1 T2}
			else
			   L2 = note(name:(R.(H2.name))
				     octave:H2.octave
				     sharp:H2.sharp
				     duration:H2.duration
				     instrument:H2.instrument)|{Link1 T2}
			end
			L2|{Link1 T}
		     [] 'silence' then
			L2 = silence(duration:H2.duration)|{Link1 T2}
			L2|{Link1 T}
		     else nil
		     end
		  end
	       else nil
	       end	       
	    end
	 else nil
	 end
      end
   end

   fun {Link2 L}
      local R in
	 R = allnotes(1:c 2:c 3:d 4:d 5:e 6:f 7:f 8:g 9:g 10:a 11:a 12:b)
	 case L of nil then nil
	 [] H|T then
	    case {Label H} of 'note' then
	       if (H.name==2) orelse (H.name==4) orelse (H.name==7) orelse (H.name==9) orelse (H.name==11) then
		  note(name:R.(H.name)
		       octave:H.octave
		       sharp:true
		       duration:H.duration
		       instrument:H.instrument)|{Link2 T}
	       else
		  note(name:R.(H.name)
		       octave:H.octave
		       sharp:false
		       duration:H.duration
		       instrument:H.instrument)|{Link2 T}
	       end
	    [] 'silence' then
	       silence(duration:H.duration)|{Link2 T}
	    else
	       case H of H2|T2 then
		  local L2 in
		     case {Label H2} of 'note' then 
			if (H2.name==2) orelse (H2.name==4) orelse (H2.name==7) orelse (H2.name==9) orelse (H2.name==11) then
			   L2 = note(name:R.(H2.name)
				     octave:H2.octave
				     sharp:true
				     duration:H2.duration
				     instrument:H2.instrument)|{Link2 T2}
			else
			   L2 = note(name:R.(H2.name)
				     octave:H2.octave
				     sharp:false
				     duration:H2.duration
				     instrument:H2.instrument)|{Link2 T2}
			end
		     L2|{Link2 T}
		     [] 'silence' then
			L2 = silence(duration:H2.duration)|{Link2 T2}
			L2|{Link2 T}
		     else nil
		     end
		  end
	       else nil
	       end	       
	    end
	 else nil
	 end
      end
   end

   % Multiply every partition-item duration in a partition (L) by a factor (Factor)
   fun {Stretch Factor L}
      case L of nil then nil
      [] H|T then
	 case {Label H} of 'note' then
	    note(name:H.name
		 octave:H.octave
		 sharp:H.sharp
		 duration:Factor*H.duration
		 instrument:H.instrument)|{Stretch Factor T}
	 [] 'silence' then
	    silence(duration:Factor*H.duration)|{Stretch Factor T}
	 else
	    case H of H2|T2 then
	       local L2 in
		  case {Label H2} of 'note' then
		     L2 = note(name:H2.name
			       octave:H2.octave
			       sharp:H2.sharp
			       duration:Factor*H2.duration
			       instrument:H2.instrument)|{Stretch Factor T2}
		     L2|{Stretch Factor T}
		  []'silence' then
		     L2 = silence(duration:Factor*H2.duration)|{Stretch Factor T2}
		     L2|{Stretch Factor T}
		  else nil
		  end
	       end
	    else nil
	    end
	 end
      else nil
      end
   end

   % Multiply
   fun {Multiply Sound Amount}
      if Amount==0 then nil
      else
	 Sound|{Multiply Sound Amount-1}
      end
   end
   
   % Calculate the total duration of a partition (L)
   fun {FindTotDuration L Acc}
      case L of nil then Acc
      [] H|T then
	 case {Label H} of 'note' then
	    {FindTotDuration T Acc+H.duration}
	 [] 'silence' then
	    {FindTotDuration T Acc+H.duration}
	 else
	    case H of H2|T2 then
	       {FindTotDuration T Acc+H2.duration}
	    else 0.0
	    end
	 end
      else 0.0
      end
   end

   fun {PartitionToTimedList Partition}
      case Partition of nil then nil
      [] H|T then
	 case {Label H} of 'silence' then
	    H|{PartitionToTimedList T}
	 [] 'note' then
	    H|{PartitionToTimedList T}
	 [] 'duration' then
	    local L in
	       L = {Stretch (H.seconds / {FindTotDuration {PartitionToTimedList H.1} 0.0}) {PartitionToTimedList H.1}}
	       {Append L {PartitionToTimedList T}}
	    end
	 [] 'stretch' then
	    local L in
	       L = {Stretch H.factor {PartitionToTimedList H.1}}
	       {Append L {PartitionToTimedList T}}
	    end
	 [] 'drone' then
	    local L in
	       L = {Multiply {PartitionToTimedList [H.note]}.1 H.amount}
	       {Append L {PartitionToTimedList T}}
	    end
	 [] 'transpose' then
	    local L in
	       L = {TransposeInt2 {Link1 {PartitionToTimedList H.1}} H.semitones}
	       {Append {Link2 L} {PartitionToTimedList T}}
	    end
	 else
	    case H of H2|T2 then
	       case {Label H2} of 'note' then
		  H|{PartitionToTimedList T}
	       else
		  {CreateListNotesNE H}|{PartitionToTimedList T}
	       end
	    [] Atom then
	       {NoteToExtended H}|{PartitionToTimedList T}
	    else nil
	    end
	 end
      else nil
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {Height EN}
      local Ref in
	 Ref = 58.0
	 case {Label EN} of 'silence' then 0.0
	 [] 'note' then
	    ({IntToFloat EN.octave}*12.0) + {IntToFloat EN.name} - Ref
	 else 0.0
	 end
      end
   end

   fun {NoteToSample EN Acc}
      local F in
	 if Acc==0 then nil
	 else
	    case {Label EN} of 'silence' then
	       F = 0.0
	    else
	       F = {Pow 2.0 {Height EN}/12.0}*440.0
	    end
	    (0.5*{Sin 2.0*3.14159265359*F*({IntToFloat {FloatToInt EN.duration*44100.0}-(Acc-1)}/44100.0)})|{NoteToSample EN Acc-1}
	 end
      end
   end

   fun {Sum L1 L2}
      if L1==nil andthen L2==nil then nil
      else
	 case L1 of H1|T1 then
	    if L2==nil then
	       H1|{Sum T1 L2}
	    else
	       case L2 of H2|T2 then
		  H1+H2|{Sum T1 T2}
	       end
	    end
	 else
	    case L2 of H2|T2 then
	       H2|{Sum L1 T2}
	    end
	 end
      end
   end

   fun {Divide L N}
      case L of H|T then
	 (H/N)|{Divide T N}
      else nil
      end
   end

   fun {Merge P2T L}
      case L of H|T then
	 case H of F#M then
	    {Sum {List.map {Mix P2T M} fun{$ I} I*F end} {Merge P2T T}}
	 else nil
	 end
      else nil
      end
   end

   fun {Multiply2 Music Amount}
      if Amount==0 then nil
      else
	 {Append Music {Multiply2 Music Amount-1}}
      end
   end

   fun {Cut S F L Acc}
      if Acc==S-1 then nil
      else
	 if (F-Acc+S+1)>{List.length L} then
	    0.0|{Cut S F L Acc-1}
	 else	 
	    {List.nth L F-Acc+S+1}|{Cut S F L Acc-1}
	 end
      end
   end

   fun {IntDivision A B}
      if A/B > {IntToFloat {FloatToInt A/B}} then
	 {IntToFloat {FloatToInt A/B}}
      else
	 {IntToFloat {FloatToInt A/B}-1}
      end
   end

   fun {Clip L Bplus Bminus}
      case L of H|T then
	 if H>Bplus then
	    Bplus|{Clip T Bplus Bminus}
	 elseif H<Bminus then
	    Bminus|{Clip T Bplus Bminus}
	 else
	    H|{Clip T Bplus Bminus}
	 end
      else nil
      end
   end

   fun {Fade L D IO Acc}
      if IO==0 then
	 if Acc>1.0 then nil
	 else
	    case L of H|T then
	       H*Acc|{Fade T D IO Acc+(1.0/D)}
	    else nil
	    end
	 end
      else
	 if Acc<0.0 then nil
	 else
	    case L of H|T then
	       H*Acc|{Fade T D IO Acc-(1.0/D)}
	    else nil
	    end
	 end
      end
   end

   fun {Mix P2T Music}
      case Music of nil then nil
      [] H|T then
	 case {Label H} of 'samples' then
	    {Append H.1 {Mix P2T T}}
	 [] 'partition' then
	    local Flat in
	       Flat = {Link1 {P2T H.1}}
	       case Flat of H2|T2 then
		  case {Label H2} of 'note' then
		     local L in
			L = {Append {NoteToSample H2 {FloatToInt H2.duration*44100.0}} {Mix P2T [partition({Link2 T2})]}}
			{Append L {Mix P2T T}}
		     end
		  [] 'silence' then
		     local L in
			L = {Append {NoteToSample H2 {FloatToInt H2.duration*44100.0}} {Mix P2T [partition({Link2 T2})]}}
			{Append L {Mix P2T T}}
		     end
		  else
		     case H2 of H3|T3 then
			local L11 L12 L2 in
			   L11 = {Sum {NoteToSample H3 {FloatToInt H3.duration*44100.0}} {Mix P2T [partition({Link2 T3})]}}
			   L12 = {Divide L11 {IntToFloat {List.length H2 $}}}
			   L2 = {Append L12 {Mix P2T [partition({Link2 T2})]}}
			   {Append L2 {Mix P2T T}}
			end
		     else nil
		     end
		  end
	       else nil
	       end
	    end
	 [] 'wave' then
	    {Project.readFile H.1}
	 [] 'merge' then
	    {Append {Merge P2T H.1} {Mix P2T T}}
	 [] 'reverse' then
	    {Append {List.reverse {Mix P2T H.1}} {Mix P2T T}}
	 [] 'repeat' then
	    {Append {Multiply2 {Mix P2T H.1} H.amount} {Mix P2T T}}
	 [] 'loop' then
	    local D A B L Mu in
	       Mu = {Mix P2T H.1}
	       D = {IntToFloat {List.length Mu}}/44100.0
	       A = {IntDivision H.seconds D}
	       B = H.seconds/D - A
	       L = {Append {Multiply2 Mu {FloatToInt A}} {Cut 0 {FloatToInt B*{IntToFloat {List.length Mu}}} Mu {FloatToInt B*{IntToFloat {List.length Mu}}}}}
	       {Append L {Mix P2T T}}
	    end
	 [] 'clip' then
	    if H.low >= H.high then
	       {Append {Mix P2T H.1} {Mix P2T T}}
	    else
	       {Append {Clip {Mix P2T H.1} H.high H.low} {Mix P2T T}}
	    end
	 [] 'echo' then
	    local M L Echo in
	       M = {Mix P2T H.1}
	       Echo = [samples({Append {Multiply 0.0 {FloatToInt H.delay*44100.0}} M})]
	       L = {Merge P2T [H.decay#Echo 1.0#[samples(M)]]}
	       {Append L {Mix P2T T}}
	    end
	 [] 'fade' then
	    local M S Start Out Mid L1 L2 in
	       M = {Mix P2T H.1}
	       S = {List.length M}
	       Start = {Cut 0 {FloatToInt H.start*44100.0} M {FloatToInt H.start*44100.0}}
	       Out = {Cut S-{FloatToInt H.out*44100.0}-1 S-1 M S-1}
	       Mid = {Cut {FloatToInt H.start*44100.0}+1 S-{FloatToInt H.out*44100.0}-2 M S-{FloatToInt H.out*44100.0}-2}
	       L1 = {Append {Fade Start H.start*44100.0 0 0.0} Mid}
	       L2 = {Append L1 {Fade Out H.out*44100.0 1 1.0}}
	       {Append L2 {Mix P2T T}}
	    end
	 [] 'cut' then
	    {Append {Cut {FloatToInt H.start*44100.0} {FloatToInt H.finish*44100.0} {Mix P2T H.1} {FloatToInt H.finish*44100.0}} {Mix P2T T}}
	 else nil
	 end
      else nil
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %Music = {Project.load 'joy.dj.oz'}
   %Start

   % Uncomment next line to insert your tests.
   %\insert 'Documents/projet_oz/ozplayer/tests.oz'
   % !!! Remove this before submitting.
in
   % Tests persos
	    
   local Music Mu1 Mu2 in
      Mu1 = [partition([note(name:a
	       octave:4
	       sharp:false
	       duration:0.0003
	       instrument:none)])]
      Music = [fade(start:0.0001 out:0.0001 Mu1)]
      {Browse {Mix PartitionToTimedList Music}}
      {Browse {Mix PartitionToTimedList Mu1}}
   end	    

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %Tests PVR
   
   %Start = {Time}

   % Uncomment next line to run your tests.
   %{Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   %{ForAll [NoteToExtended Music] Wait}
   
   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
   %{Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
   
   % Shows the total time to run your code.
   %{Browse {IntToFloat {Time}-Start} / 1000.0}
end