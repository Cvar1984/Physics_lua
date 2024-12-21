local Math = require "Math"

local ElectroMagnetic = {}

setmetatable(ElectroMagnetic, {__index = ElectroMagnetic})


-- Ep = hf
function ElectroMagnetic:energyPerPhotonByFreq(frequency)
    local energy = Math.PLANCK * frequency
    return energy
end

-- P = Np.Ep
function ElectroMagnetic:power(numberOfPhoton, photonEnergy)
    local power = numberOfPhoton * photonEnergy
    return power
end

-- Np = P/Ep
function ElectroMagnetic:photonCollectedByPower(power, photonEnergy)
    local numberOfPhoton = power / photonEnergy
    return numberOfPhoton
end

-- Ep = P/Np
function ElectroMagnetic:energyPerPhotonByPower(power, numberOfPhoton)
    local photonEnergy = power / numberOfPhoton
    return photonEnergy
end

return ElectroMagnetic
