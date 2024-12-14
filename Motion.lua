local Math = require "Math"
local Motion = {
    lorentzThreshold = 1e-4, -- error 0.005%
}

function Motion:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- γ = 1/sqrt(1-v²/c²)
function Motion:lorentzFactor(velocity)
    -- A lower threshold: Increases accuracy but might lead to unnecessary calculations for very low velocities.
    -- A higher threshold: Reduces computational cost but might introduce more error for higher velocities.
    local beta = velocity / Math.SPEED_OF_LIGHT
    if (beta ^ 2) < Motion.lorentzThreshold then
        -- Use binomial approximation for low velocities (v << c)
        return 1 + 0.5 * beta ^ 2
    else
        -- Exact Lorentz factor for relativistic velocities
        return 1 / Math:sqrt(1 - beta ^ 2)
    end
end

-- a = Δv/Δt
function Motion:calculateAcceleration(pastVelocity, presentVelocity, timeInterval)
    local deltaVelocity = presentVelocity - pastVelocity
    local acceleration = deltaVelocity / timeInterval
    return acceleration
end

-- v = Δx/Δt
function Motion:calculateVelocity(distance, time)
    local velocity = distance / time
    return velocity
  end

-- h = 1/2 gt²
function Motion:calculateHeightFalloff(time, gravity)
    gravity = gravity or Math.GRAVITY
    local height = 1/2 * gravity * time^2
    return height
end
-- d = Vit+1/2at²
function Motion:calculateKinematicDistance(time, initialVelocity, acceleration)
    initialVelocity = initialVelocity or 0
    acceleration = acceleration or Math.GRAVITY
    local distance = initialVelocity * time + 1/2 * acceleration * time ^ 2
    return distance
end

-- d-Vit = 1/2at²
-- 2(d−Vi​t) = at²
-- a = 2(d-Vit)/t²
function Motion:calculateKinematicAcceleration(distance, time, initialVelocity)
    initialVelocity = initialVelocity or 0
     local acceleration = 2 * (distance - initialVelocity * time) / time ^ 2
     return acceleration
end

return Motion
