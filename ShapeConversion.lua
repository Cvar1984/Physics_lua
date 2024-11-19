local Math = require "Math"

local ShapeConversion =  {}
function ShapeConversion:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--[[
pi = c/d
c = pi*d
d = c/pi
]]--
function ShapeConversion:squareToCircle(squareArea) -- eg: 28m^2
    local circleRadius = Math:sqrt(squareArea ^ 2 / Math.PI) -- r= √(a^2 / π)
    --local circleDiameter = 2 * circleRadius -- d = 2r
    --local circleCircumference = 2 * math.pi * circleRadius-- c = 2πR
    --local circlePI = circleCircumference / circleDiameter -- π = circumference / diameter
    return circleRadius
end
return ShapeConversion