os.pullEvent = os.pullEventRaw
local side = "back"
local password = "12345"
local opentime = 6
while true do
 term.clear()
 term.setCursorPos(1,1)
 textutils.slowPrint("Please enter password: ")
 local input = read("X")
 if input == password then
  term.clear()
  term.setCursorPos(1,1)
  textutils.slowPrint("Password Correct")
  rs.setOutput(side, true)
  sleep(opentime)
  rs.setOutput(side, false)
  sleep(4)
 else
  term.clear()
  term.setCursorPos(1,1)
  textutils.slowPrint("Password Incorrect")
  sleep(1)
  end
end