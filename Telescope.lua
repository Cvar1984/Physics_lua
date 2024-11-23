local Math = require "Math"
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

function Telescope:calculateMagnification(focalLength,eyepieceFocalLength)
    return focalLength / eyepieceFocalLength
end

function Telescope:calculateAperture(focalLength, focalRatio)
    return focalLength / focalRatio
end
-- LGP = π * (Aperture in meter/2)^2 * Luminance Sensitivity of the Human Eye in cd/m^2
function Telescope:calculateLightGatheringPower(aperture) -- according to llama-3
    -- Luminance sensitivity of the human eye in candela per square meter approximately 3.18309 * 10^-6 cd/m^2 according to Lamma-3 AI
    -- and approximately peak at 5.5 x 10^-10 cd/m^2 according to Gemini AI
    local luminanceSensitivity = 3.18309 * 1e-6
    local apertureInMeters = aperture / 1000 -- Convert mm to meters

    local lightGatheringPower = Math.PI * (apertureInMeters / 2)^2 * luminanceSensitivity

    return lightGatheringPower
end
--return Telescope
print("Main mirror diameter in mm: ")
local mainMirrorDiameter = tonumber(io.read())

print("Main mirror focal length in mm: ")
local mainMirrorFocalLength = tonumber(io.read())

local mainMirrorFocalRatio = Telescope:calculateFocalRatio(mainMirrorFocalLength, mainMirrorDiameter)

print("Eyepiece 1 focal length in mm: ")
local eyepieceFocalLength1 = tonumber(io.read())

print("Eyepiece 2 focal length in mm: ")
local eyepieceFocalLength2 = tonumber(io.read())

local focalRatio = Telescope:calculateFocalRatio(mainMirrorFocalLength, mainMirrorDiameter)
local magnification1 = Telescope:calculateMagnification(mainMirrorFocalLength, eyepieceFocalLength1)
local magnification2 = Telescope:calculateMagnification(mainMirrorFocalLength, eyepieceFocalLength2)
local aperture = Telescope:calculateAperture(mainMirrorFocalLength, mainMirrorFocalRatio)
local apertureInches = aperture / 25.4
local lightGatheringPower = Telescope:calculateLightGatheringPower(aperture)

print("Focal length: ".. mainMirrorFocalLength.. " mm")
print("Focal ratio: f/".. focalRatio)
print("Magnification 1: ".. magnification1.."X")
print("Magnification 2: ".. magnification2.."X")
print("Aperture: ".. aperture.. " mm (\""..apertureInches..")")
print("Light Gathering power: ".. lightGatheringPower.. " lm/s")