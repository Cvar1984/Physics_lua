local Shape =  {}
function Shape:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

--
function Shape:squareToCircle(squareArea) -- eg: 28m^2
    local circleRadius = math.sqrt(squareArea / math.pi) -- r= √(a^2 / π)
    --local circleDiameter = 2 * circleRadius -- d = 2r
    --local circleCircumference = 2 * math.pi * circleRadius-- c = 2πR
    --local circlePI = circleCircumference / circleDiameter -- π = circumference / diameter
    return circleRadius
end

print(Shape:squareToCircle(28))
-- a 28m^2
-- r 2.9854106607209
-- c 18.757888399339
-- d 5.9708213214418