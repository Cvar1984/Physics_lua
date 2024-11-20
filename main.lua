local Math = require "Math"
local Energy = require "Energy"
local Shape = require "ShapeConversion"

-- 1 gram of weights
local mass = Energy:calculateMass(1/1000, Math.GRAVITY)
local momentum = Energy:calculateMomentum(mass, Math.GRAVITY)

print("E = " .. Energy:calculateRelativeEnergy(mass, momentum) .. " J")
print("F = " .. Energy:calculateForce(mass, Math.SPEED_OF_LIGHT) .. " N")
print("KE = " .. Energy:calculateKineticEnergy(3, 100 * 3.6) .. " J") -- ms to kmh
print("PE = " .. Energy:calculatePotentialEnergy(3, 10) .. " J")
print("q = " .. Energy:calculateHeatEnergy(3, 4.2, 10) .. " J")
print("C = " .. Energy:calculateHeatCapacity(126, 3, 10) .. " J/(kg°C)")
print("I = " .. Energy:calculateCurrent(5, 0.1) .. " A")
print("R = " .. Energy:calculateResistance(5, 50) .. " Ohm")
print("P = " .. Energy:calculatePower(5,50) .. " W")
print("V = " .. Energy:calculateVoltage(50, 0.1) .. " V")
print(Shape:squareToCircle(28)) -- 28m^2 aprox to circle with 15.797308339337 r