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
	 else
	    case H of H2|T2 then
	       local L1 L2 in
		  L1 = {TransposeInt1 H2.name Semitones 0}
		  L2 = note(name:L1.1
			    octave:H2.octave + L1.2.1
			    sharp:H2.sharp
			    duration:H2.duration
			    instrument:H2.instrument)|{TransposeInt2 T2 Semitones}
		  L2|{TransposeInt2 T Semitones}
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
	    else
	       case H of H2|T2 then
		  local L2 in
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
	    else
	       case H of H2|T2 then
		  local L2 in
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
	 else
	    case H of H2|T2 then
	       local L2 in
		  L2 = note(name:H2.name
			    octave:H2.octave
			    sharp:H2.sharp
			    duration:Factor*H2.duration
			    instrument:H2.instrument)|{Stretch Factor T2}
		  L2|{Stretch Factor T}
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
	 else
	    case H of H2|T2 then
	       {FindTotDuration T Acc+H2.duration}
	    else 0.0
	    end
	 end
      else 0.0
      end
   end

   % Append
   fun {Append Xs Ys}
      case Xs
      of nil then Ys
      [] X|Xr then X|{Append Xr Ys}
      else nil
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

   fun {Mix P2T Music}
      % TODO
      {Project.readFile 'wave/animaux/cow.wav'}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %Music = {Project.load 'joy.dj.oz'}
   %Start

   % Uncomment next line to insert your tests.
   %\insert 'Documents/projet_oz/ozplayer/tests.oz'
   % !!! Remove this before submitting.
in
   % Tests persos
   local P in
      P = [a b#7 c drone(note:g amount:4) transpose(semitones:4 [a a [a b]])]
      {Browse{PartitionToTimedList P}}
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