local Math = require "Math"
local Energy = require "Energy"
local Astro = require "Astro"

-- 1 gram of weights
local mass = Energy:calculateMass(1/1000, Math.GRAVITY)
local momentum = Energy:calculateMomentum(mass, Math.GRAVITY)

print("E = " .. Math:formatNumber(Energy:calculateRelativeEnergy(mass, momentum)) .. " J")
print("F = " .. Energy:calculateForce(mass, Math.SPEED_OF_LIGHT) .. " N")
print("KE = " .. Energy:calculateKineticEnergy(3, 100 * 3.6) .. " J") -- ms to kmh
print("PE = " .. Energy:calculatePotentialEnergy(3, 10) .. " J")
print("q = " .. Energy:calculateHeatEnergy(3, 4.2, 10) .. " J")
print("C = " .. Energy:calculateHeatCapacity(126, 3, 10) .. " J/(kg°C)")
print("I = " .. Energy:calculateCurrent(5, 0.1) .. " A")
print("R = " .. Energy:calculateResistance(5, 50) .. " Ohm")
print("P = " .. Energy:calculatePower(5,50) .. " W")
print("V = " .. Energy:calculateVoltage(50, 0.1) .. " V")
print("v = " .. Astro:calculateDopplerRadialVelocity(434, 435) .. " m/s")
local shift = Astro:calculateDopplerShift(434, 435)
print("z = " .. shift, shift * 100 .. "%") -- redshift
print("d = " .. Math:formatNumber(Astro:calculateDopplerDistance(shift)), "Light Years")