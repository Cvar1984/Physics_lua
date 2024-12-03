local Math = require "Math"
local Energy = require "Energy"
local Astro = require "Astro"

-- 1 gram of weights
local mass = Energy:calculateMass(1/1000, Math.GRAVITY)
local momentum = Energy:calculateMomentum(mass, Math.GRAVITY)
local acceleration = 9.8 -- m/s²
local velocity = 0.5 -- m/s

print("E = " .. Math:formatNumber(Energy:calculateRelativeEnergy(mass, momentum)) .. " J")
print("F = " .. Energy:calculateForce(mass, acceleration) .. " kg⋅m/s²")
print("KE = " .. Energy:calculateKineticEnergy(mass, velocity) .. " kg⋅m²⋅s⁻²")
print("v = " .. Energy:calculateVelocity(5, 10) .. " m/s")
print("a = " .. Energy:calculateAcceleration(0.5, 0, 10) .. " m/s²") -- stopping
print("p = " .. Energy:calculateMomentum(mass, velocity) .. " kg⋅m/s)") -- stopping
print("PE = " .. Energy:calculatePotentialEnergy(mass, 10) .. " kg⋅m²⋅s⁻²")
print("q = " .. Energy:calculateHeatEnergy(mass, 4.2, 10) .. " kg⋅m²⋅s⁻²")
print("C = " .. Energy:calculateHeatCapacity(126, mass, 10) .. " kg⋅m²⋅s⁻²/(kg°C)")
print("I = " .. Energy:calculateCurrent(5, 0.1) .. " A")
print("R = " .. Energy:calculateResistance(5, 50) .. " Ohm")
print("P = " .. Energy:calculatePower(5,50) .. " W")
print("V = " .. Energy:calculateVoltage(50, 0.1) .. " V")
local shift = Astro:calculateDopplerShift(1e9, 1000000001) -- 1nm shift
print("z = " .. shift, shift * 100 .. "%") -- redshift
local distance, uncertain = Astro:calculateDopplerDistance(shift)
local distanceLightYears = distance * Math.LIGHT_YEAR -- parsec -> ly
local uncertainLightYears = uncertain * Math.LIGHT_YEAR -- parsec -> ly
print("d ≈ " .. Math:formatNumber(distance) .. " ± " .. Math:formatNumber(uncertain) .. " Pc")
print("d ≈ " .. Math:formatNumber(distanceLightYears) .. " ± " .. Math:formatNumber(uncertainLightYears) .. " Ly")