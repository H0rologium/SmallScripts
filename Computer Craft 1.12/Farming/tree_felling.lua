local fuel, distup
while(true)
do
    distup = 0
    fuel = turtle.getFuelLevel()
    
    if (fuel < 20)
        then
            turtle.select(16)
            turtle.refuel(5)
    end
b, x = turtle.inspect()
if(string.find(x.name,"log"))
    then
        turtle.dig()
        turtle.forward()
        while(turtle.detectUp() == true)
        do
            turtle.digUp()
            turtle.up()
            distup = distup + 1
        end
        while(distup > 0)
        do
            turtle.down()
            distup = distup - 1
        end
            turtle.turnRight()
            turtle.turnRight()
            turtle.forward()
            turtle.select(1)
            turtle.drop()
            turtle.select(2)
            turtle.drop()
            turtle.select(3)
            turtle.drop()
            turtle.turnLeft()
            turtle.turnLeft()
            turtle.select(15)
            turtle.place()
    end
end