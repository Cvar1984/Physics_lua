local Thermodynamics = {}

setmetatable(Thermodynamics, {__index = Thermodynamics})

-- q = mCΔT
--- @param mass number
--- @param heatCapacity number
--- @param tempChanges number
--- @return number heatEnergy J
function Thermodynamics:heatEnergy(mass, heatCapacity, tempChanges)
    local heatEnergy = mass * heatCapacity * tempChanges
    return heatEnergy
end

-- C = q/(mΔT)
---@param heatEnergy number
---@param mass number
---@param tempChanges number
---@return number heatCapacity J/kg.K
function Thermodynamics:heatCapacity(heatEnergy, mass, tempChanges)
    local heatCapacity = heatEnergy / (mass * tempChanges)
    return heatCapacity
end

-- ΔT = q/(mC)
---@param heatEnergy number
---@param mass number
---@param heatCapacity number
---@return number tempChanges K
function Thermodynamics:temperatureChanges(heatEnergy, mass, heatCapacity)
    local tempChanges = heatEnergy / (mass * heatCapacity)
    return tempChanges
end

-- m = q / (cΔT)
---@param heatEnergy number
---@param heatCapacity number
---@param tempChanges number
---@return number heatMass kg
function Thermodynamics:heatMass(heatEnergy, heatCapacity, tempChanges)
    local heatMass = heatEnergy / (heatCapacity * tempChanges)
    return heatMass
end

return Thermodynamics
