local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Translate a note to the extended notation.
   fun {NoteToExtended Note}
      case Note
      of Name#Octave then
         note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
         case {AtomToString Atom}
         of [_] then
            note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
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

   % Multiply every partition-item in a partition (L) by a factor (Factor)
   fun {Stretch Factor L}
      case L of nil then nil
      [] H|T then
	 case H of note then
	    note(name:H.name
		 octave:H.octave
		 sharp:H.sharp
		 duration:Factor*H.duration
		 instrument:H.instrument)|{Stretch Factor T}
	 [] H2|T2 then
	    {Stretch Factor H2}|{Stretch Factor T2}|{Stretch Factor T}
	 else nil
	 end
      else nil
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
	       {FindTotDuration T2 Acc+H2.duration+{FindTotDuration T 0}}
	    else 0
	    end
	 end
      else 0
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
	    {Stretch (H.seconds div {FindTotDuration {PartitionToTimedList H.1} 0}) {PartitionToTimedList H.1}}|{PartitionToTimedList T}
	 [] 'stretch' then
	    {Stretch H.factor {PartitionToTimedList H.1}}|{PartitionToTimedList T}
	 [] 'drone' then nil
	 [] 'transpose' then nil
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
   
   /*
   fun {PartitionToTimedList Partition}
      case Partition of nil then nil
      [] H|T then
	 case H of Atom then
	    {NoteToExtended H}|{PartitionToTimedList T}
	 [] note then 
	    H|{PartitionToTimedList T}
	 [] silence then
	    H|{PartitionToTimedList T}
	 [] H2|T2 then
	    case H2 of Atom then
	       {CreateListNotesNE H}|{PartitionToTimedList T}
	    [] note then %%%
	       H|{PartitionToTimedList T}
	    else nil
	    end
	 [] duration then
	    {Stretch (H.duration div {FindTotDuration {PartitionToTimedList H.1} 0}) {PartitionToTimedList H.1}}|{PartitionToTimedList T} 
	 [] stretch then
	    {Stretch H.factor {PartitionToTimedList H.1}}|{PartitionToTimedList T}
	 [] drone then
	    nil
	 [] transpose then
	    nil
	 end
      end  
   end
   */

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %fun {Mix P2T Music}
      % TODO
   %   {Project.readFile 'wave/animaux/cow.wav'}
   %end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %Music = {Project.load 'joy.dj.oz'}
   %Start

   % Uncomment next line to insert your tests.
   %\insert 'Documents/projet_oz/ozplayer/tests.oz'
   % !!! Remove this before submitting.
in
   % Tests persos
   {Browse {PartitionToTimedList [[a b] stretch(factor:3 [a c#5 b]) c c [c c c] c#7]}}

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