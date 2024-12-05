local Optics = require "Optics"
local Math = require "Math"

print("Main mirror diameter in mm: ")
local mainMirrorDiameter = tonumber(io.read()) / 1000

print("Main mirror focal length in mm: ")
local mainMirrorFocalLength = tonumber(io.read()) / 1000

local mainMirrorFocalRatio = Optics:calculateFocalRatio(mainMirrorFocalLength, mainMirrorDiameter)

print("Eyepiece 1 focal length in mm: ")
local eyepieceFocalLength1 = tonumber(io.read()) / 1000

print("Eyepiece 2 focal length in mm: ")
local eyepieceFocalLength2 = tonumber(io.read()) / 1000

local focalRatio = Optics:calculateFocalRatio(mainMirrorFocalLength, mainMirrorDiameter)
local magnification1 = Optics:calculateMagnification(mainMirrorFocalLength, eyepieceFocalLength1)
local magnification2 = Optics:calculateMagnification(mainMirrorFocalLength, eyepieceFocalLength2)
local aperture = Optics:calculateAperture(mainMirrorFocalLength, mainMirrorFocalRatio)
local apertureInches = aperture / 0.0254 -- m to inch
local relativeLightGatheringPower = Optics:calculateRelativeLightGatheringPower(mainMirrorDiameter, Optics.EYE_DIAMETER)

print("Focal length: " .. mainMirrorFocalLength * 1000 .. " mm")
print("Focal ratio: f/" .. focalRatio)
print("Magnification 1: " .. magnification1 .. "x")
print("Magnification 2: " .. magnification2 .. "x")
print("Aperture: " .. aperture * 1000 .. " mm (" .. apertureInches .. "\")")
print("Relative Light Gathering power ≈ " .. Math:humanize(relativeLightGatheringPower) .. "x compared to the human eye")