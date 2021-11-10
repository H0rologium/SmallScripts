function mf()
    if (turtle.detect())
        then
            turtle.dig()
    end
    turtle.forward()
end
function mu()
    if(turtle.detectUp())
        then
            turtle.digUp()
    end
    turtle.up()
end
 
length = 9
height = 6
i = 0
f = 1
h = 0
z = 0
q = 0
function row()
    while (i < length)
    do
        mf()
        i = i + 1
    end
    i = 0
end
 
 
function rott()
    if (f == 1)
        then
            turtle.turnRight()
            mf()
            turtle.turnRight()
            f = 0
    return
    end
    if (f == 0)
        then
            turtle.turnLeft()
            mf()
            turtle.turnLeft()
            f = 1
    return
    end
 
end
 
function goUp()
    if (h < height)
        then
            mu()
    h = h + 1
    end
 
end
 
print(turtle.getFuelLevel())
function maan()
while(z < length)
do
    row()
    rott()
    z = z + 1 
end
row()
turtle.turnRight()
while (z > 0)
do
    z = z - 1
    mf() 
end
turtle.turnRight()
z = 0
end
 
while (q < height)
do
    f = 1
    maan()
    mu()
end