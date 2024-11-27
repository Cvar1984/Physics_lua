local Telescope = {
    EYE_DIAMETER = 0.007, -- 7mm
}

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

function Telescope:calculateMagnification(focalLength, eyepieceFocalLength)
    return focalLength / eyepieceFocalLength
end

function Telescope:calculateAperture(focalLength, focalRatio)
    return focalLength / focalRatio
end

-- universally accepted LGP according to GPT 4
function Telescope:calculateRelativeLightGatheringPower(telescopeDiameter, referenceDiameter)
    return (telescopeDiameter / referenceDiameter) ^ 2
end

--return Telescope
print("Main mirror diameter in mm: ")
local mainMirrorDiameter = tonumber(io.read()) / 1000

print("Main mirror focal length in mm: ")
local mainMirrorFocalLength = tonumber(io.read()) / 1000

local mainMirrorFocalRatio = Telescope:calculateFocalRatio(mainMirrorFocalLength, mainMirrorDiameter)

print("Eyepiece 1 focal length in mm: ")
local eyepieceFocalLength1 = tonumber(io.read()) / 1000

print("Eyepiece 2 focal length in mm: ")
local eyepieceFocalLength2 = tonumber(io.read()) / 1000

local focalRatio = Telescope:calculateFocalRatio(mainMirrorFocalLength, mainMirrorDiameter)
local magnification1 = Telescope:calculateMagnification(mainMirrorFocalLength, eyepieceFocalLength1)
local magnification2 = Telescope:calculateMagnification(mainMirrorFocalLength, eyepieceFocalLength2)
local aperture = Telescope:calculateAperture(mainMirrorFocalLength, mainMirrorFocalRatio)
local apertureInches = aperture / 0.0254 -- m to inch
local relativeLightGatheringPower = Telescope:calculateRelativeLightGatheringPower(mainMirrorDiameter, Telescope.EYE_DIAMETER)

print("Focal length: " .. mainMirrorFocalLength * 1000 .. " mm")
print("Focal ratio: f/" .. focalRatio)
print("Magnification 1: " .. magnification1 .. "x")
print("Magnification 2: " .. magnification2 .. "x")
print("Aperture: " .. aperture * 1000 .. " mm (" .. apertureInches .. "\")")
print("Relative Light Gathering power ≈ " .. relativeLightGatheringPower .. "x compared to the human eye")
