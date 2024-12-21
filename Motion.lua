local Math = require "Math"
local Motion = {
    lorentzThreshold = 1e-4, -- error 0.005%
}

setmetatable(Motion, {__index = Motion})

-- f = ma
---@param mass number
---@param acceleration number
---@return number force J
function Motion:force(mass, acceleration)
    local force = mass * acceleration
    return force
end

-- m = f/a
---@param force number
---@param acceleration number
---@return number mass kg
function Motion:mass(force, acceleration)
    local mass = force / acceleration
    return mass
end

-- p = mv
---@param restMass number
---@param velocity number
---@return number momentum kg.m/s
function Motion:momentum(restMass, velocity)
    local momentum = restMass * velocity
    return momentum
end

-- KE = 1/2mv²
---@param mass number
---@param velocity number
---@return number kineticEnergy J
function Motion:kineticEnergy(mass, velocity)
    local kineticEnergy = (1 / 2) * mass * (velocity ^ 2)
    return kineticEnergy
end

-- a = Δv/Δt
---@param pastVelocity number
---@param presentVelocity number
---@param timeInterval number
---@return number acceleration m/s²
function Motion:acceleration(pastVelocity, presentVelocity, timeInterval)
    local deltaVelocity = presentVelocity - pastVelocity
    local acceleration = deltaVelocity / timeInterval
    return acceleration
end

-- v = Δx/Δt
---@param distance number
---@param time number
---@return number velocity m/s
function Motion:velocity(distance, time)
    local velocity = distance / time
    return velocity
  end

-- h = 1/2 gt²
---@param time number
---@param gravity number
---@return number height m
function Motion:heightFalloff(time, gravity)
    gravity = gravity or Math.GRAVITY
    local height = 1/2 * gravity * time^2
    return height
end

-- d = Vit+1/2at²
---@param acceleration number
---@param time number
---@param initialVelocity number
---@return number distance m
function Motion:kinematicDistance(acceleration, time, initialVelocity)
    initialVelocity = initialVelocity or 0
    acceleration = acceleration or Math.GRAVITY
    local distance = initialVelocity * time + 1/2 * acceleration * time ^ 2
    return distance
end

-- d-Vit = 1/2at²
-- 2(d−Vi​t) = at²
-- a = 2(d-Vit)/t²
---@param distance number
---@param time number
---@param initialVelocity number
---@return number acceleration m/s²
function Motion:kinematicAcceleration(distance, time, initialVelocity)
    initialVelocity = initialVelocity or 0
     local acceleration = 2 * (distance - initialVelocity) / time ^ 2
     return acceleration
end

-- d-Vit = 1/2at²
-- 2(d-Vit) = at²
-- t² = 2(d-Vit)/a
---@param distance number
---@param acceleration number
---@param initialVelocity number
---@return number time s
function Motion:kinematicTime(distance, acceleration, initialVelocity)
    initialVelocity = initialVelocity or 0
    local time = Math:sqrt(2 * (distance - initialVelocity) / acceleration)
    return time
end

return Motion
