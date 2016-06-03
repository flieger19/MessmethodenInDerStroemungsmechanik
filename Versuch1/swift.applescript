set res to {}
set angle to {}
set p_s1 to {}
set xPos to {}
set p_s2 to {}
set p_g2 to {}
set yPos to {}
set p_s3 to {}
set p_g3 to {}
tell application "Numbers"
	tell document 1
		activate
		set a1 to {}
		set in0 to {}
		tell sheet 1
			tell table 1
				repeat with k from 2 to 15
					copy value of cell k of row 38 to end of angle
					copy value of cell k of row 39 to end of p_s1
				end repeat
				repeat with k from 2 to 14
					copy value of cell k of row 41 to end of xPos
					copy value of cell k of row 42 to end of p_s2
					copy value of cell k of row 43 to end of p_g2
				end repeat
				repeat with k from 2 to 7
					copy value of cell k of row 45 to end of yPos
					copy value of cell k of row 46 to end of p_s3
					copy value of cell k of row 47 to end of p_g3
				end repeat
			end tell
		end tell
	end tell
end tell

set res to {angle, p_s1, xPos, p_s2, p_g2, yPos, p_s3, p_g3}

return res
