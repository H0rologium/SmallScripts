local tArgs = { ... }
if #tArgs ~= 2 then
	print( "Usage: quarry <diameter> <depth>" )
	return
end

local diameter = tArgs[1]
local depth = tArgs[2]
--Coordinates array where 0 is x, 1 is y and 2 is z
local coordinates = [0,0,0]

preInit()

local function preInit()
	if fs.exists("coords.txt") then
	
	else 
		local f = fs.open("coords.txt", "w")
	
		f.close()
	end
	
end

local function move(direction)
	print('bluh')

end





