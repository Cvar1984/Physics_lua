local Math = require "Math"

--[[
TODO: kinetic, potential, sound, mechanical, elastic, radiant, chemical, electric, nuclear, heat
]]--
local Energy = {}

function Energy:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--[[ SI unit
energy = joules
mass = kg
acceleration = meter/second^2
force = newton
]]--
-- E = mc^2
function Energy:calculateRelativeEnergy(mass)
    local energy = mass * (Math.SPEED_OF_LIGHT  ^ 2)
    return energy
end
-- m = e/c^2
function Energy:calculateRelativeMass(energy)
    local mass = energy / (Math.SPEED_OF_LIGHT  ^ 2)
    return mass
end
-- c^2 = e/m
function Energy:calculateRelativeSpeed(energy, mass)
    local c2 = energy / mass
    local c = Math:sqrt(c2)
    return c
end
-- KE = 1/2mv^2
function Energy:calculateKineticEnergy(mass, velocity)
    local kineticEnergy = (1/2) * mass * (velocity ^ 2)
    return kineticEnergy
end
-- PE = mgh
function Energy:calculatePotentialEnergy(mass, height)
    local potentialEnergy = mass * Math.GRAVITY * height
    return potentialEnergy
end
-- m = j/(gh)
function Energy:calculatePotentialMass(potentialEnergy, height)
    local potentialMass = potentialEnergy / (Math.GRAVITY * height)
    return potentialMass
end
-- h = j / (mg)
function Energy:calculatePotentialHeight(potentialEnergy, potentialMass)
    local potentialHeight = potentialEnergy / (potentialMass * Math.GRAVITY)
    return potentialHeight
end
-- q = mCΔT
function Energy:calculateHeatEnergy(mass, heatCapacity, tempChanges)
    local heatEnergy = mass * heatCapacity * tempChanges
    return heatEnergy
end
-- C = q/(mΔT)
function Energy:calculateHeatCapacity(heatEnergy, mass, tempChanges)
    local heatCapacity = heatEnergy / (mass * tempChanges)
    return heatCapacity
end
-- ΔT = q/(mC)
function Energy:calculateTempChanges(heatEnergy, mass, heatCapacity)
    local tempChanges = heatEnergy / (mass * heatCapacity)
    return tempChanges
end
-- m = q / (cΔT)
function Energy:calculateHeatMass(heatEnergy, heatCapacity, tempChanges)
    local heatMass = heatEnergy / (heatCapacity * tempChanges)
    return heatMass
end
-- f = ma
function Energy:calculateForce(mass, acceleration)
    local force = mass * acceleration
    return force
end
-- m = f/a
function Energy:calculateMass(force, acceleration)
    local mass = force / acceleration
    return mass
end
-- a = f/m
function Energy:calculateAcceleration(force, mass)
    local acceleration = force / mass
    return acceleration
end
-- v = ir
function Energy:calculateVoltage(current, resitance)
    local voltage = current * resitance
    return voltage
end
-- i = v/r
function Energy:calculateCurrent(voltage, resistance)
    local current = voltage / resistance
    return current
end
-- r = v/i
function Energy:calculateResistance(voltage, current)
    local resistance = voltage / current
    return resistance
end
-- p = vi
function Energy:calculatePower(voltage, current)
    local wattage = voltage * current
    return wattage
end
return Energy