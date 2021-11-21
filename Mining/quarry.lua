local tArgs = { ... }
if #tArgs ~= 2 then
	print( "Usage: quarry <diameter> <depth>" )
	return
end

local diameter = tonumber(tArgs[1])
local depth = tonumber(tArgs[2])
--Coordinates array where 1 is x, 2 is y and 3 is z--
--When we count these coordinates, we will use our own custom coordinates system STARTING AT 0,0,0 (where the robot was originally placed)--
local coordinates = {1,0,1}
local dest = {1,0,1}
local curProgress = 0
local curDepth = 0
local rows = 0
local inProgress = false


--Count is how many times the operation should be performed per call--
local function impulse(direction, count)
	os.sleep(0.1)
	local x = 0
	while x < tonumber(count) do
		if direction == "forward" then
			if turtle.detect() then turtle.dig() end
			turtle.forward()
			coordinates[1] = coordinates[1] + 1
			fs.delete(fs.getName("x." .. coordinates[1] - 1))
			local farther = fs.open("x." .. coordinates[1], "w")
			farther.close()
		elseif direction == "backward" then
			turtle.turnRight()
			turtle.turnRight()
			if turtle.detect() then turtle.dig() end
			turtle.turnRight()
			turtle.turnRight()
			turtle.back()
			coordinates[1] = coordinates[1] - 1
			fs.delete(fs.getName("x." .. coordinates[1] + 1))
			local closer = fs.open("x." .. coordinates[1], "w")
			closer.close()
		elseif direction == "left" then
			turtle.turnLeft()
			if turtle.detect() then turtle.dig() end
			impulse("forward", 1)
			turtle.turnLeft()
			coordinates[3] = coordinates[3] - 1
			fs.delete(fs.getName("z." .. coordinates[3] + 1))
			local lefter = fs.open("z." .. coordinates[3], "w")
			lefter.close()
		elseif direction == "right" then
			turtle.turnRight()
			if turtle.detect() then turtle.dig() end
			impulse("forward", 1)
			coordinates[3] = coordinates[3] + 1
			fs.delete(fs.getName("z." .. coordinates[3] - 1))
			local righter = fs.open("z." .. coordinates[3], "w")
			righter.close()
		elseif direction == "up" then
			if turtle.detectUp() then turtle.digUp() end
			turtle.up()
			curDepth = curDepth - 1
			coordinates[2] = coordinates[2] - 1
			fs.delete(fs.getName("y." .. coordinates[2] + 1))
			local higher = fs.open("y." .. coordinates[2], "w")
			higher.close()
		elseif direction == "down" then
			if turtle.detectDown() then turtle.digDown() end
			turtle.down()
			curDepth = curDepth + 1
			coordinates[2] = coordinates[2] + 1
			fs.delete(fs.getName("y." .. coordinates[2] - 1))
			local lower = fs.open("y." .. coordinates[2], "w")
			lower.close()
		end
		x = x + 1
		os.sleep(0.1)
	end
end

--Sends us back to a chest. Will dump all items every time it vists, so make sure the storage can handle all of the blocks.--
local function returnToOrigin()
		print('Returning to origin from ' .. coordinates[1] .. ',' .. coordinates[2] .. ',' .. coordinates[3] .. '!')
		impulse("backward", curProgress)
		os.sleep(0.1)
		impulse("up",  curDepth - dest[2])
		os.sleep(0.1)
		impulse("left", rows)
		os.sleep(0.1)
		print('Returned to origin!')
end



--Mines out one layer--
local function mineLayer()
	while curProgress < diameter do
		impulse("forward", 1)
		fs.delete(fs.getName("curProgress." .. tostring(curProgress)))
		curProgress = curProgress + 1
		local q = fs.open("curProgress." .. tostring(curProgress), "w")
		q.close()
	end
	if curProgress == diameter and rows < diameter then --Pray we dont somehow go over--
		fs.delete(fs.getName("curProgress." .. tostring(curProgress)))
		if rows % 2 == 0 then
			--Even row--
			turtle.turnRight()
			impulse("forward", 1)
			turtle.turnRight()
			curProgress = 0
		else
			--Odd row--
			turtle.turnLeft()
			impulse("forward", 1)
			turtle.turnLeft()
			curProgress = 0
		end
		local q = fs.open("curProgress." .. tostring(curProgress), "w")
		q.close()
		rows = rows + 1
	elseif curProgress >= diameter and curDepth < depth then --We've mined out an entire row--
		if rows % 2 == 0 then
			turtle.turnLeft()
			impulse("forward", diameter)
			turtle.turnLeft()
			impulse("forward", diameter)
			turtle.turnLeft()
			os.sleep(0.1)
			turtle.turnLeft()
		else 
			turtle.turnRight()
			impulse("forward", diameter)
			turtle.turnRight()
			impulse("forward", diameter)
			turtle.turnRight()
			os.sleep(0.1)
			turtle.turnRight()
		end
		impulse("down", 1)
		rows = 0
		fs.delete(fs.getName("curProgress." .. tostring(curProgress)))
		curProgress = 0
		local qe = fs.open("curProgress." .. tostring(curProgress), "w")
		qe.close()
		curDepth = coordinates[2]
	else 
		return
	end
end
--Refuel function, run at startup. Different from checkfuel as this function will only continue when the robot has fuel to travel the ENTIRE quarry--
local function fuel()
	--Check fuel level, 20 is added on as a safeguard--
	if turtle.getFuelLevel() < (diameter * diameter) * depth + 20  then
		turtle.refuel()
	end
	if turtle.getFuelLevel() < (diameter * diameter) * depth + 20 then
		print("Needing more fuel... have " .. turtle.getFuelLevel() .. " need " .. tostring((diameter * diameter) * depth + 20 ))
		os.sleep(5)
		fuel()
	end
	print("Fueled up with " .. tostring(turtle.getFuelLevel()) .. " fuel.")
end


local function main()
	fuel()
	if inProgress then
		--We are in progress, our marked coordinates must be where we left off from.--
		--We have started in progress so we need to match this and continue--
		coordinates = dest
		curProgress = coordinates[1]
		curDepth = coordinates[2]
		rows = coordinates[3]
	end
	--The robot mines from a left to right angle--
	while curDepth < depth do
		mineLayer()
	end
	--Cleanup since done--
	mineLayer()
	returnToOrigin()
end
--Sets up the robot, determines if we were in progress--
local function preInit()
	if fs.exists("x.*") then--We were cut off in-progress--
		print("attempting to resume program")
		dest[1] = tonumber(string.sub(fs.getName("x.*"), 2, string.len(fs.getName("x.*")-2)))
		dest[2] = tonumber(string.sub(fs.getName("y.*"), 2, string.len(fs.getName("y.*")-2)))
		dest[3] = tonumber(string.sub(fs.getName("z.*"), 2, string.len(fs.getName("z.*")-2)))
		diameter = tonumber(string.sub(fs.getName("diameter.*"), 9, string.len(fs.getName("diameter.*")-9)))
		depth = tonumber(string.sub(fs.getName("depth.*"), 6, string.len(fs.getName("depth.*")-6)))
		inProgress = true
	else 
		inProgress = false
		local f = fs.open([[diameter.]] .. tostring(diameter), "w")
		f.close()
		f = fs.open([[depth.]] .. tostring(depth), "w")
		f.close()
		f = fs.open([[x.]] .. tostring(coordinates[1]), "w")
		f.close()
		f = fs.open([[y.]] .. tostring(coordinates[2]), "w")
		f.close()
		f = fs.open([[z.]] .. tostring(coordinates[3]), "w")
		f.close()
		f = fs.open([[curProgress.]] .. tostring(curProgress), "w")
		f.close()
	end
	
end




preInit()
main()


