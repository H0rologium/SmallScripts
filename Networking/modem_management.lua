local modem = "left"
local m = peripheral.wrap(modem)
 
while true do
 print("Enter a message: \n")
 local input = read()
 sleep(1)
 m.transmit(2, 1, input)
 sleep(1)
end