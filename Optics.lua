local Optics = {
    eyeDiameter = 0.007, -- 7mm
}

setmetatable(Optics, {__index = Optics})

--- Lf = d.Rf
---@param diameter number
---@param ratioFocal number
---@return number focalLength m
function Optics:focalLength(diameter, ratioFocal)
    return diameter * ratioFocal
end

--- Rf = Lf/D
---@param lengthFocal number
---@param diameter number
---@return number ratioFocal m
function Optics:focalRatio(lengthFocal, diameter)
    return lengthFocal / diameter
end

--- Z = Lf/Rf
---@param lengthFocal number
---@param eyepieceFocalLength number
---@return number magnification
function Optics:magnification(lengthFocal, eyepieceFocalLength)
    return lengthFocal / eyepieceFocalLength
end

--- N = f/D
---@param focalLength number
---@param focalRatio number
---@return number aperture m
function Optics:aperture(focalLength, focalRatio)
    return focalLength / focalRatio
end

--- LGP (Db/Dr)²
---@param baseDiameter number
---@param referenceDiameter number
---@return number lgp
function Optics:lightGatheringPower(baseDiameter, referenceDiameter)
     referenceDiameter = referenceDiameter or self.eyeDiameter
    return (baseDiameter / referenceDiameter) ^ 2
end

return Optics
