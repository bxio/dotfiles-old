(*
This script will get the Song Name of the single selected track
and display it in a text field so that portions of its text can
be used for the selected track's Movement Name.
*)
tell application "iTunes"

	set sel to selection of front browser window
	if sel is {} then
			try
					display dialog "Try selecting a non-zero number of items." buttons {"Quit"} with icon 0
			end try
			return
	end if

	set sizeOfSelection to (count of sel)--how many pieces are we working with
	--define the work name
	set workName to display dialog "Composer: **Work Name**: Number. Movement Name\n\nEdit for Work name and then click OK." default answer (get name of item 1 of sel) --prompt for work name

	--loop through the selection and change details
	repeat with i from 1 to sizeOfSelection --set the movement numbers
		set thisTrack to item i of sel
		set songName to (get name of thisTrack)
    set originalSongName to songName
		set shortSongName to songName
    --shorten and display the songname

    set newSongName to display dialog "Composer: Work Name: Number. **Movement Name**\n\nEdit for Movement Name and then click OK." default answer songName




		try
			set movement of thisTrack to text returned of newSongName
			set work of thisTrack to text returned of workName
			set movement number of thisTrack to i
			set movement count of thisTrack to sizeOfSelection
	end try

	end repeat

end tell
