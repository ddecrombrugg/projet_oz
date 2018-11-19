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

   fun {PartitionToTimedList Partition}
      case Partition of nil then nil
      [] H|T then
	 case H of Atom then
	    {NoteToExtended H}|{PartitionToTimedList T}
	 [] note(name:Name octave:Octave sharp:Boolean duration:Duration instrument:Instrument) then
	    note|{PartitionToTimedList T}
	 [] silence(duration:Duration) then
	    silence|{PartitionToTimedList T}
	 [] H2|T2 then
	    case H2 of Atom then
	       {CreateListNotesNE H}|{PartitionToTimedList T}
	    [] note(name:Name octave:Octave sharp:Boolean duration:Duration instrument:Instrument) then
	       H|{PartitionToTimedList T}
	    else nil
	    end
	 [] duration(seconds:Seconds partition) then nil
	 [] stretch(factor:Factor partition) then nil
	 [] drone(note:Note amount:Amount) then nil
	 [] transpose(semitones:Semitones partition) then nil
	 else nil
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

   Music = {Project.load 'joy.dj.oz'}
   Start

   % Uncomment next line to insert your tests.
   \insert 'tests.oz'
   % !!! Remove this before submitting.
in
   %Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}
   {TestNotes PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   %{ForAll [NoteToExtended Music] Wait}
   
   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
   %{Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
   
   % Shows the total time to run your code.
   %{Browse {IntToFloat {Time}-Start} / 1000.0}
end