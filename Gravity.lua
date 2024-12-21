local Math = require "Math"

local Gravity = {}

-- PE = mgh
---@param mass number
---@param height number
---@return number potentialEnergy J
function Gravity:potentialEnergy(mass, height)
    local potentialEnergy = mass * Math.GRAVITY * height
    return potentialEnergy
end

-- m = j/(gh)
---@param potentialEnergy number
---@param height number
---@return number potentialMass kg
function Gravity:PotentialMass(potentialEnergy, height)
    local potentialMass = potentialEnergy / (Math.GRAVITY * height)
    return potentialMass
end

-- h = j / (mg)
---@param potentialEnergy number
---@param potentialMass number
---@return number potentialHeight m
function Gravity:potentialHeight(potentialEnergy, potentialMass)
    local potentialHeight = potentialEnergy / (potentialMass * Math.GRAVITY)
    return potentialHeight
end

return Gravity
