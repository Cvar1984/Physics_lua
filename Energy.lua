local Math = require "Math"
local Motion = require "Motion"

local Energy = {}

setmetatable(Energy, {__index = Energy})

-- p = mv
function Energy:calculateMomentum(restMass, velocity)
    local momentum = restMass * velocity
    return momentum
end

--p = γm0v
-- approximated as p ≈ m0v if v << c
function Energy:calculateRelativeMomentum(restMass, velocity)
    local lorentzFactor = Motion:lorentzFactor(velocity)
    local momentum = lorentzFactor * restMass * velocity
    return momentum
end

-- E = m0c²
function Energy:calculateRestEnergy(restMass)
    local restEnergy = restMass * Math.SPEED_OF_LIGHT ^ 2
    return restEnergy
end

-- e² = (m0c²)²+(pc)²
-- Approximated as E ≈ m0c² + KE if v << c
-- e² = (m0​c²)²+(γm0​vc)²
function Energy:calculateRelativeEnergy(restMass, velocity)
    local restEnergy = Energy:calculateRestEnergy(restMass)
    local momentum = Energy:calculateRelativeMomentum(restMass, velocity)
    local kineticEnergy = momentum * Math.SPEED_OF_LIGHT
    local totalEnergy = Math:sqrt((restEnergy ^ 2) + (kineticEnergy ^ 2))
    return totalEnergy
end

-- e² - (pc)² = (m0c²)²
-- m² = (e² - (pc)²)/c⁴
function Energy:calculateRelativeMassFromEnergy(energy, momentum)
    local restMass = Math:sqrt((energy ^ 2 - (momentum * Math.SPEED_OF_LIGHT) ^ 2) / Math.SPEED_OF_LIGHT ^ 4)
    return restMass
end

-- e² - (m0c²)² = (pc)²
-- p² = (e² - (m0c²)²) / c²
function Energy:calculateRelativeMomentumFromEnergy(energy, restMass)
    local momentum = Math:sqrt((energy ^ 2 - (restMass * Math.SPEED_OF_LIGHT ^ 2) ^ 2) / Math.SPEED_OF_LIGHT ^ 2)
    return momentum
end

-- KE = m0c²(γ-1)
function Energy:calculateRelativeKineticEnergy(restMass, velocity)
    local lorentz = Motion:lorentzFactor(velocity)
    local kineticEnergy = restMass * Math.SPEED_OF_LIGHT ^ 2 * (lorentz - 1)
    return kineticEnergy
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
