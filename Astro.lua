local Math = require "Math"
local Astro = {}

function Astro:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- z = v/c
-- v/c = Δλ / λ∘
-- Δλ = λ - λ∘
-- v = Δλ / λ∘ * c
function Astro:calculateDopplerRadialVelocity(referenceWavelength, observedWavelegth)
    local deltaWavelegth = observedWavelegth - referenceWavelength
    local velocity = Math.SPEED_OF_LIGHT * (deltaWavelegth / referenceWavelength)
    return velocity
end

-- z = Δλ / λ∘
function Astro:calculateDopplerShift(referenceWavelength, observedWavelegth)
    local deltaWavelegth = observedWavelegth - referenceWavelength
    local shift = deltaWavelegth / referenceWavelength
    return shift
end

-- cz = H0d
-- d ≈ cz/H0
function Astro:calculateDopplerDistance(redshift)
    local distance = Math.SPEED_OF_LIGHT * redshift / Math.HUBBLE
    return distance / Math.LIGHT_YEAR -- convert meter to light year
end

return Astro
