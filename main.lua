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
print("v = " .. Energy:calculateDopplerVelocity(434, 482) .. " m/s")
local shift = Energy:calculateDopplerShift(434/(1*10^9), 482/(1*10^9)) -- 1e+9 nm to m conversion
print("z = " .. shift, shift * 100 .. "%") -- redshift
shift = Energy:calculateDopplerShift(482, 434) -- seems not affected if you measure in same scale e.g nm to nm whoever lambda measured in meters
print("z = " .. shift, shift * 100 .. "%") -- blueshift