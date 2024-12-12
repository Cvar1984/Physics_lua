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

-- γ = 1/sqrt(1-v²/c²)
function Energy:lorentzFactor(velocity)
    if velocity / Math.SPEED_OF_LIGHT < 0.01 then
        return 1 -- Approximation when v << c
    else
        local lorentz = 1 / math.sqrt(1 - (velocity / Math.SPEED_OF_LIGHT) ^ 2)
        return lorentz
    end
end

--p = γm0v
-- approximated as p ≈ m0v if v << c
function Energy:calculateMomentum(restMass, velocity)
    if velocity / Math.SPEED_OF_LIGHT < 0.01 then
        return restMass * velocity -- Approximation for low velocities
    else
        local lorentzFactor = Energy:lorentzFactor(velocity)
        local momentum = lorentzFactor * restMass * velocity
        return momentum
    end
end

-- e² = (m0c²)²+(pc)²
-- Approximated as E ≈ m0c² + KE if v << c
function Energy:calculateRelativeEnergy(restMass, velocity)
    local restEnergy = restMass * Math.SPEED_OF_LIGHT ^ 2
    if velocity / Math.SPEED_OF_LIGHT < 0.01 then
        -- Add the classical kinetic energy for low velocities
        local kineticEnergy = Energy:calculateKineticEnergy(restMass, velocity)
        return restEnergy + kineticEnergy
    else
        -- Full relativistic energy calculation
        local momentum = Energy:calculateMomentum(restMass, velocity)
        local relativisticEnergy = math.sqrt((restEnergy ^ 2) + (momentum * Math.SPEED_OF_LIGHT) ^ 2)
        return relativisticEnergy
    end
end

-- e² - (pc)² = (m0c²)²
-- m² = (e² - (pc)²)/c⁴
function Energy:calculateRelativeMass(energy, momentum)
    local restMass = Math:sqrt((energy ^ 2 - (momentum * Math.SPEED_OF_LIGHT) ^ 2) / Math.SPEED_OF_LIGHT ^ 4)
    return restMass
end

-- e² - (m0c²)² = (pc)²
-- p² = (e² - (m0c²)²) / c²
function Energy:calculateRelativeMomentum(energy, restMass)
    local momentum = Math:sqrt((energy ^ 2 - (restMass * Math.SPEED_OF_LIGHT ^ 2) ^ 2) / Math.SPEED_OF_LIGHT ^ 2)
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

-- E = hf
function Energy:calculatePhotonEnergy(frequency)
    local energy = Math.PLANCK * frequency
    return energy
end

-- Np = P/hf
function Energy:calculatePhotonCollected(totalEnergyCollected, photonEnergy)
    local numberOfPhoton = totalEnergyCollected / photonEnergy
    return numberOfPhoton
end

return Energy
