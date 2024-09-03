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

function Telescope:calculateLightGatheringPower()
    local area = math.pi * (self.aperture^2) / 4
    local areaOfHumanPupil = 7 * 7 * math.pi / 4
    local ratio = area / areaOfHumanPupil
    return ratio
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