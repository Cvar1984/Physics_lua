-- Telescope class definition
local Telescope = {}

function Telescope:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Telescope:calculateFocalLength(diameter, fRatio)
    return diameter * fRatio
end

function Telescope:calculateFocalRatio(focalLength, diameter)
    return focalLength / diameter
end

function Telescope:calculateMagnification(eyepieceFocalLength)
    return self.focalLength / eyepieceFocalLength
end

function Telescope:calculateAperture(focalRatio)
    return self.focalLength / focalRatio
end
-- LGP = π * (Aperture in meter/2)^2 * Luminance Sensitivity of the Human Eye in cd/m^2
function Telescope:calculateLightGatheringPower()
    -- Luminance sensitivity of the human eye in candela per square meter approximately 3.18309 * 10^-6 cd/m^2 according to Lamma-3 AI
    -- and approximately peak at 5.5 x 10^-10 cd/m^2 according to Gemini AI
    local luminanceSensitivity = 3.18309 * 1e-6
    local apertureInMeters = self.aperture / 1000 -- Convert mm to meters

    local lightGatheringPower = math.pi * (apertureInMeters / 2)^2 * luminanceSensitivity

    return lightGatheringPower
end

-- Get user input
print("Enter the diameter of the primary mirror in millimeters:")
local diameter = tonumber(io.read())

print("Enter the focal ratio of the telescope:")
local focalRatio = tonumber(io.read())

print("Enter the focal length of the eyepiece in millimeters:")
local eyepieceFocalLength = tonumber(io.read())

-- Create a new Telescope object
local telescope = Telescope:new{
    diameter = diameter,
    focalRatio = focalRatio,
}

-- Calculate the focal length of the telescope
telescope.focalLength = telescope:calculateFocalLength(telescope.diameter, telescope.focalRatio)

-- Calculate the focal ratio of the telescope
telescope.focalRatio = telescope:calculateFocalRatio(telescope.focalLength, telescope.diameter)

-- Calculate the magnification of the telescope
telescope.magnification = telescope:calculateMagnification(eyepieceFocalLength)

-- Calculate the aperture of the telescope
telescope.aperture = telescope:calculateAperture(telescope.focalRatio)

-- Calculate the light-gathering power of the telescope
telescope.lightGatheringPower = telescope:calculateLightGatheringPower()

-- Print the results
print("Focal Length: ".. telescope.focalLength.. " mm")
print("Focal Ratio: ".. telescope.focalRatio)
print("Magnification: ".. telescope.magnification)
print("Aperture: ".. telescope.aperture.. " mm")
print("Light-Gathering Power: ".. telescope.lightGatheringPower.. " lm/s")