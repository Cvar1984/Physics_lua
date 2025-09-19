-- Deep Sky Imaging Optimizer for Mono Camera (LRGB/Narrowband)

-- More exposure more signal captured
-- More calibration frames more noise reduction
-- Better calibration frames less noise overall but longer integration times

-- Bias	Remove read noise from the camera
-- + Cover your camera (cap on, total darkness)
-- + Set shortest exposure time possible (e.g. 0.1ms or 0.0001s)
-- + Use same gain/ISO as your light frames
-- Dark	Remove thermal noise & hot pixels
-- + Cover telescope or lens (completely dark)
-- + Use same exposure, same gain, and ideally same temperature as your light frames
-- Flat	Remove dust, vignetting, artifacts
-- + Use a flat, evenly illuminated white source
-- + Set exposure so histogram peaks around 50% (no clipping!)
-- + Use same focus and optical setup
-- Deep Sky Imaging Optimizer for Mono Camera (LRGB/Narrowband)
-- OOP Refactor, single-file

------------------------------------------------------------
-- Class Definition
------------------------------------------------------------
local DeepSkyOptimizer = {}
DeepSkyOptimizer.__index = DeepSkyOptimizer

function DeepSkyOptimizer:new(config)
    local self = setmetatable({}, DeepSkyOptimizer)

    -- User configuration
    self.brotleClass   = config.brotleClass   or 5
    self.guiding        = config.guiding        or false
    self.totalMinutes  = config.totalMinutes  or nil
    self.targetSnr     = config.targetSnr     or 100

    self.biasRatio     = config.biasRatio     or 0.2 -- 20% of light frames
    self.darkRatio     = config.darkRatio     or 0.2 -- 20% of light frames
    self.flatRatio     = config.flatRatio     or 0.15 -- 15% of light frames

    self.channels       = {
        {name = "Luminance", weight = 0.5},
        {name = "Red",       weight = 0.166, altername = "S-II"},
        {name = "Green",     weight = 0.166, altername = "H-alpha"},
        {name = "Blue",      weight = 0.166, altername = "O-III"},
    }

    self.useDarks      = config.useDarks ~= false
    self.useFlats      = config.useFlats ~= false
    self.useBias       = config.useBias  ~= false

    -- Derived values
    self.exposureTime  = self:getExposureTime(self.brotleClass, self.guiding)
    self.gain           = self:getGain(self.brotleClass)
    self.totalSeconds  = self.totalMinutes and (self.totalMinutes * 60) or nil
    self.maxSnr        = 1000  -- arbitrary scaling

    return self
end

------------------------------------------------------------
-- Core Methods
------------------------------------------------------------

function DeepSkyOptimizer:getExposureTime(bortle, guiding)
    if guiding then
        if bortle <= 3 then return 240
        elseif bortle <= 5 then return 180
        elseif bortle <= 7 then return 90
        else return 45 end
    else
        if bortle <= 3 then return 120
        elseif bortle <= 5 then return 90
        elseif bortle <= 7 then return 60
        else return 30 end
    end
end

function DeepSkyOptimizer:getGain(bortle)
    if bortle <= 3 then return 10
    elseif bortle <= 5 then return 20
    else return 30 end
end

function DeepSkyOptimizer:estimateSnr(frames, exposure)
    return math.sqrt(frames * exposure)
end

function DeepSkyOptimizer:normalizeSnr(rawSnr)
    return math.min(100, (rawSnr / self.maxSnr) * 100)
end

function DeepSkyOptimizer:timeForSnr(targetPercent, exposure)
    local targetRaw = (targetPercent / 100) * self.maxSnr
    return targetRaw ^ 2 / exposure
end

function DeepSkyOptimizer:adjustForSnr(exposure, totalTime, targetPercent)
    if totalTime then
        local frames = math.floor(totalTime / exposure)
        local rawSnr = self:estimateSnr(frames, exposure)
        return frames, self:normalizeSnr(rawSnr), totalTime
    else
        local requiredSeconds = self:timeForSnr(targetPercent, exposure)
        local frames = math.ceil(requiredSeconds / exposure)
        local rawSnr = self:estimateSnr(frames, exposure)
        return frames, self:normalizeSnr(rawSnr), frames * exposure
    end
end

function DeepSkyOptimizer:calculateFrameCounts(lightFrames)
    local biasMin, biasMax   = 10, 50
    local darkMin, darkMax   = 5, 30
    local flatMin, flatMax   = 5, 20

    local bias  = math.floor(lightFrames * self.biasRatio)
    local darks = math.floor(lightFrames * self.darkRatio)
    local flats = math.floor(lightFrames * self.flatRatio)

    bias  = math.max(biasMin, math.min(bias, biasMax))
    darks = math.max(darkMin, math.min(darks, darkMax))
    flats = math.max(flatMin, math.min(flats, flatMax))

    if not self.useBias  then bias  = 0 end
    if not self.useDarks then darks = 0 end
    if not self.useFlats then flats = 0 end

    return darks, flats, bias
end

function DeepSkyOptimizer:calculateCalibrationTime(darks, flats, bias, exposure)
    local biasTime = bias * 0.005                         -- 5 ms per bias
    local flatTime = flats * math.max(0.1, exposure * 0.1) -- flats ~10% of light exposure
    local darkTime = darks * exposure                     -- darks same as exposure
    return biasTime + flatTime + darkTime
end

function DeepSkyOptimizer:run()
    print("➡ Sky Quality (Bortle): " .. self.brotleClass)
    print("➡ Guiding: " .. tostring(self.guiding))
    print("➡ Target SNR: " .. self.targetSnr .. "%")
    print("➡ Exposure Time / Frame: " .. self.exposureTime .. " seconds")
    print("➡ Gain: " .. self.gain)
    print("--------------------------------------------------")

    local grandTotal = 0

    for _, ch in ipairs(self.channels) do
        local channelTime = self.totalSeconds and (self.totalSeconds * ch.weight) or nil
        local frames, snrPercent, integration = self:adjustForSnr(self.exposureTime, channelTime, self.targetSnr)

        local darks, flats, bias = self:calculateFrameCounts(frames)
        local calibTime = self:calculateCalibrationTime(darks, flats, bias, self.exposureTime)

        local channelTotal = integration + calibTime
        grandTotal = grandTotal + channelTotal

        print("Channel: " .. ch.name .. (ch.altername and (" (" .. ch.altername .. ")") or ""))
        print("  Achieved SNR: " .. string.format("%.1f%%", snrPercent))
        print("  Lights: " .. frames .. " | Darks: " .. darks .. " | Flats: " .. flats .. " | Bias: " .. bias)
        print("  Light Time: " .. string.format("%.1f", integration / 60) .. " minutes")
        print("  Calibration Time: " .. string.format("%.2f", calibTime / 60) .. " minutes")
        print("  Channel Total: " .. string.format("%.1f", channelTotal / 60) .. " minutes")
        print("--------------------------------------------------")
    end

    print("➡ Grand Total (Lights + Calibrations Across Channels): " ..
          string.format("%.1f", grandTotal / 3600) .. " hours")
end

------------------------------------------------------------
-- Example usage
------------------------------------------------------------
local config = {
    brotleClass  = 5, -- 1 = darkest skies, 9 = bright city
    guiding       = true,
    totalMinutes = nil, -- total session time in minutes; nil for auto-SNR
    targetSnr    = 100, -- desired SNR % (0–100)
    useDarks     = true,
    useFlats     = true,
    useBias      = true,
    darkRatio    = 0.2,  -- 20% of light frames
    flatRatio    = 0.15, -- 15% of light frames
    biasRatio    = 0.2,  -- 20% of light frames
}
local optimizer = DeepSkyOptimizer:new(config)
optimizer:run()