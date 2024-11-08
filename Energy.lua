-- TODO: kinetic, potential, sound, mechanical, elastic, radiant, chemical, electric, nuclear, heat
local Energy = { -- energy constant
    SPEED_OF_LIGHT = 299792458, -- meter/seconds
    GRAVITY = 9.80665 -- meter/seconds
}

-- E = mc^2
-- mass in kilograms
function Energy:calculateEnergy(mass)
    local energy = mass * (self.SPEED_OF_LIGHT  ^ 2)
    return energy
end

-- KE = 1/2mv^2
-- mas in kilograms, velocity in meter/second
function Energy:calculateKineticEnergy(mass, velocity)
    local kineticEnergy = 1/2 * mass * (velocity ^ 2)
    return kineticEnergy
end

-- PE = mgh
-- mas in kilograms, height in meter
function Energy:calculatePotentialEnergy(mass, height)
    local potentialEnergy = mass * self.GRAVITY * height
    return potentialEnergy
end

-- q = mCΔT
-- mass in kilograms, heatcap j/kg celcius, tempchange in celcius
function Energy:calculateHeatEnergy(mass, heatCapacity, tempChanges)
    local heatEnergy = mass * heatCapacity * tempChanges
    return heatEnergy
end

-- C = q/(mΔT)
-- heat energy in joules, mass in kg, tempchange in celcius
function Energy:calculateHeatCapacity(heatEnergy, mass, tempChanges)
    local heatCapacity = heatEnergy / (mass * tempChanges)
    return heatCapacity
end
-- f = ma
-- mass in kilograms, acceleration in meter/second^2
function Energy:calculateForce(mass, acceleration)
    local force = mass * acceleration
    return force
end

-- annihilation of 1 gram of matter and 1 gram of antimatter is aproximately 21.5 kilotons of TNT explosive about the same as the fat man
print("E = " .. Energy:calculateEnergy(1/1000) .. " J")
print("F = " .. Energy:calculateForce(1/1000, Energy.SPEED_OF_LIGHT) .. " N")
print("KE = " .. Energy:calculateKineticEnergy(3, 100 * 3.6) .. " J") -- ms to kmh
print("PE = " .. Energy:calculatePotentialEnergy(3, 10) .. " J")
print("q = " .. Energy:calculateHeatEnergy(3, 4.2, 10) .. " J")
print("C = " .. Energy:calculateHeatCapacity(126, 3, 10) .. " J/(kg°C)")