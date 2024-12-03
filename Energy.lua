local Math = require "Math"

--[[
TODO: kinetic, potential, sound, mechanical, elastic, radiant, chemical, electric, nuclear, heat
]] --
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
acceleration = m/s²
velocity = m/s
force = newton
]] --
--p = mv
function Energy:calculateMomentum(mass, velocity)
    local momentum = mass * velocity
    return momentum
end

-- e2 = (mc²)²+(pc)²
function Energy:calculateRelativeEnergy(mass, momentum)
    local energy = math.sqrt((mass * Math.SPEED_OF_LIGHT ^ 2) ^ 2 + (momentum * Math.SPEED_OF_LIGHT) ^ 2)
    return energy
end

-- e2 - (pc)² = (mc²)²
-- m2 = (e² - (pc)²)/c⁴
function Energy:calculateRelativeMass(energy, momentum)
    local mass = math.sqrt((energy ^ 2 - (momentum * Math.SPEED_OF_LIGHT) ^ 2) / Math.SPEED_OF_LIGHT ^ 4)
    return mass
end

-- e2 - (mc²)² = (pc)²
-- p2 = (e² - (mc²)²) / c²
function Energy:calculateRelativeMomentum(energy, mass)
    local momentum = math.sqrt((energy ^ 2 - (mass * Math.SPEED_OF_LIGHT ^ 2) ^ 2) / Math.SPEED_OF_LIGHT ^ 2)
    return momentum
end

-- KE = 1/2mv²
function Energy:calculateKineticEnergy(mass, velocity)
    local kineticEnergy = (1 / 2) * mass * (velocity ^ 2)
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

-- a = Δv/Δt
function Energy:calculateAcceleration(pastVelocity, presentVelocity, timeInterval)
    local deltaVelocity = presentVelocity - pastVelocity
    local acceleration = deltaVelocity / timeInterval
    return acceleration
end

-- v = Δx/Δt
function Energy:calculateVelocity(distance, time)
    local velocity = distance / time
    return velocity
  end

-- v = ir
function Energy:calculateVoltage(current, resistance)
    local voltage = current * resistance
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
