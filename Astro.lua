local Math = require "Math"
local Astro = {
    hubble = {       -- Plack + ACTPol + SPTpol 2021 https://lambda.gsfc.nasa.gov/education/graphic_history/hubb_const.html
        value = 67.8 * 1000, -- m/s/Mpc
        uncertainty = 0.35 * 1000
    },
}

setmetatable(Astro, {__index = Astro})

-- v = λf
---@param length number
---@param frequency number
---@return number velocity m/s
function Astro:waveVelocity(length, frequency)
    local velocity = length * frequency
    return velocity
end

-- λ = v/f
---@param velocity number
---@param frequency number
---@return number length m
function Astro:waveLength(velocity, frequency)
    local length = velocity / frequency
    return length
end

-- f = v/λ
---@param velocity number
---@param length number
---@return number frequency Hz
function Astro:waveFrequency(velocity, length)
    local frequency = velocity / length
    return frequency
end

-- z = v/c
-- v/c = Δλ / λ∘
-- Δλ = λ - λ∘
-- v = Δλ / λ∘ * c
---@param referenceWavelength number
---@param observedWavelegth number
---@return number velocity m/s
function Astro:dopplerRadialVelocity(referenceWavelength, observedWavelegth)
    local deltaWavelegth = observedWavelegth - referenceWavelength
    local velocity = Math.SPEED_OF_LIGHT * (deltaWavelegth / referenceWavelength)
    return velocity
end

-- z = Δλ / λ∘
---@param referenceWavelength number
---@param observedWavelegth number
---@return number shift z
function Astro:dopplerShift(referenceWavelength, observedWavelegth)
    local deltaWavelegth = observedWavelegth - referenceWavelength
    local shift = deltaWavelegth / referenceWavelength
    return shift
end

-- Vr = cz
-- cz = H0d
-- d = cz/H0
---@param redshift number
---@return number distance mpc
---@return number uncertain mpc
function Astro:dopplerDistance(redshift)
    local relativeUncertain = self.hubble.uncertainty / self.hubble.value
    local recessionVelocity = Math.SPEED_OF_LIGHT * redshift
    local distance = recessionVelocity / self.hubble.value
    local uncertain = distance * relativeUncertain
    return distance, uncertain
end

return Astro
