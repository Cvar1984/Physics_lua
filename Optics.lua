local Optics = {
    EYE_DIAMETER = 0.007, -- 7mm
}

setmetatable(Optics, {__index = Optics})

function Optics:calculateFocalLength(diameter, fRatio)
    return diameter * fRatio
end

function Optics:calculateFocalRatio(focalLength, diameter)
    return focalLength / diameter
end

function Optics:calculateMagnification(focalLength, eyepieceFocalLength)
    return focalLength / eyepieceFocalLength
end

function Optics:calculateAperture(focalLength, focalRatio)
    return focalLength / focalRatio
end

-- universally accepted LGP according to GPT 4
function Optics:calculateRelativeLightGatheringPower(baseDiameter, referenceDiameter)
     referenceDiameter = referenceDiameter or self.EYE_DIAMETER
    return (baseDiameter / referenceDiameter) ^ 2
end

return Optics
