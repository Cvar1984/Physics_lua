local Math = require "Math"
local Astro = {}

function Astro:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- v = λf
function Astro:calculateWaveVelocity(length, frequency)
    local velocity = length * frequency
    return velocity
end

-- λ = v/f
function Astro:calculateWaveLength(velocity, frequency)
    local length = velocity / frequency
    return length
end

-- f = v/λ
function Astro:calculateWaveFrequency(velocity, length)
    local frequency = velocity / length
    return frequency
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

-- Vr = cz
-- cz = H0d
-- d = cz/H0
function Astro:calculateDopplerDistance(redshift)
    local hubble = Math.HUBBLE.VALUE * 1000 -- km/s/mpc -> m/s/mpc
    local hubbleUncertain = Math.HUBBLE.UNCERTAIN * 1000 -- km/s/mpc -> m/s/mpc
    local relativeUncertain = hubbleUncertain / hubble
    local recessionVelocity = Math.SPEED_OF_LIGHT * redshift
    local distance = recessionVelocity / hubble
    local uncertain = distance * relativeUncertain
    distance = distance * 1e6 -- mpc -> pc
    uncertain = uncertain * 1e6 -- mpc -> pc
    return distance, uncertain
end

return Astro