local Math = require "Math"
local Motion = require "Motion"

local Relativistic = {}

setmetatable(Relativistic, {__index = Relativistic})

-- γ = 1/sqrt(1-v²/c²)
---@param velocity number
---@return number y
function Relativistic:lorentzFactor(velocity)
    -- A lower threshold: Increases accuracy but might lead to unnecessary calculations for very low velocities.
    -- A higher threshold: Reduces computational cost but might introduce more error for higher velocities.
    local beta = velocity / Math.SPEED_OF_LIGHT
    local y
    if (beta ^ 2) < Motion.lorentzThreshold then
        -- Use binomial approximation for low velocities (v << c)
        y = 1 + 0.5 * beta ^ 2
    else
        -- Exact Lorentz factor for relativistic velocities
        y = 1 / Math:sqrt(1 - beta ^ 2)
    end
    return y
end

-- p = γm0v
---@param restMass number
---@param velocity number
---@return number momentum kg.m/s
function Relativistic:momentum(restMass, velocity)
    local lorentzFactor = Motion:lorentzFactor(velocity)
    local momentum = lorentzFactor * restMass * velocity
    return momentum
end

-- E = m0c²
---@param restMass number
---@return number restEnergy J
function Relativistic:restEnergy(restMass)
    local restEnergy = restMass * Math.SPEED_OF_LIGHT ^ 2
    return restEnergy
end

-- e² = (m0c²)²+(pc)²
-- Approximated as E ≈ m0c² + KE if v << c
-- e² = (m0​c²)²+(γm0​vc)²
---@param restMass number
---@param velocity number
---@return number totalEnergy J
function Relativistic:totalEnergy(restMass, velocity)
    local restEnergy = self:restEnergy(restMass)
    local momentum = self:momentum(restMass, velocity)
    local kineticEnergy = momentum * Math.SPEED_OF_LIGHT
    local totalEnergy = Math:sqrt((restEnergy ^ 2) + (kineticEnergy ^ 2))
    return totalEnergy
end

-- e² - (pc)² = (m0c²)²
-- m² = (e² - (pc)²)/c⁴
--- @param energy number
--- @param momentum number
--- @return number restMass kg
function Relativistic:massFromTotalEnergy(energy, momentum)
    local restMass = Math:sqrt((energy ^ 2 - (momentum * Math.SPEED_OF_LIGHT) ^ 2) / Math.SPEED_OF_LIGHT ^ 4)
    return restMass
end

-- e² - (m0c²)² = (pc)²
-- p² = (e² - (m0c²)²) / c²
---@param energy number
---@param restMass number
---@return number momentum kg.m/s
function Relativistic:momentumFromTotalEnergy(energy, restMass)
    local momentum = Math:sqrt((energy ^ 2 - (restMass * Math.SPEED_OF_LIGHT ^ 2) ^ 2) / Math.SPEED_OF_LIGHT ^ 2)
    return momentum
end

-- KE = m0c²(γ-1)
---@param restMass number
---@param velocity number
---@return number kineticEnergy J
function Relativistic:kineticEnergy(restMass, velocity)
    local lorentz = Motion:lorentzFactor(velocity)
    local kineticEnergy = restMass * Math.SPEED_OF_LIGHT ^ 2 * (lorentz - 1)
    return kineticEnergy
end

return Relativistic
