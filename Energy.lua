-- TODO: kinetic, potential, sound, mechanical, elastic, radiant, chemical, electric, nuclear, heat
local Energy = {
    speedOfLight = 299792458, -- m/s^2
    gravity = 9.80665 -- m/s^2
}

-- mas in gram, velocity in meter/second
function Energy:calculateKineticEnergy(mass, velocity)
    mass = mass / 1000 -- Convert mass from grams to kilograms
    local kineticEnergy = 1/2 * mass * velocity ^ 2
    return kineticEnergy
end

-- mas in grams, velocity in meter/second, height in meter
function Energy:calculatePotentialEnergy(mass, height)
    mass = mass / 1000 -- Convert mass from grams to kilograms
    local potentialEnergy = mass * self.gravity * height
    return potentialEnergy
end
-- mass in grams
function Energy:calculateEnergy(mass)
    mass = mass / 1000 -- grams to kilograms
    local energy = mass * self.speedOfLight ^ 2
    return energy
end

-- test
print("E = " .. Energy:calculateEnergy(1) .. " J")
print("KE = " .. Energy:calculateKineticEnergy(3000, 100 * 3.6) .. " J") -- ms to kmh
print("PE = " .. Energy:calculatePotentialEnergy(3000, 100) .. " J")