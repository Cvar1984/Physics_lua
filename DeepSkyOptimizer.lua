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

-- ===================== USER INPUT =====================
local bortle_class   = 5            -- 1 = darkest skies, 9 = bright city
local guiding        = true        -- true = using autoguider, false = unguided
local total_minutes  = nil          -- total session time in minutes; nil for auto-SNR
local target_snr     = 100           -- desired SNR % (0–100)

-- channel weights (fraction of total integration)
local channels = {
    {name = "Luminance", weight = 0.5},
    {name = "Red",       weight = 0.166, altername = "S-II"},
    {name = "Green",     weight = 0.166, altername = "H-alpha"},
    {name = "Blue",      weight = 0.166, altername = "O-III"},
}

-- reuse flags
local reuse_darks = false
local reuse_flats = false
local reuse_bias  = false
-- =======================================================

-- Suggest exposure time based on sky brightness and guiding
local function get_exposure_time(bortle, guiding)
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

-- Suggest gain (range 1–30)
local function get_gain(bortle)
    if bortle <= 3 then return 10
    elseif bortle <= 5 then return 20
    else return 30
    end
end

-- Estimate raw SNR
local function estimate_snr(frames, exposure)
    return math.sqrt(frames * exposure)
end

-- Normalize SNR into 0–100%
local function normalize_snr(raw_snr, max_snr)
    return math.min(100, (raw_snr / max_snr) * 100)
end

-- Time needed to reach target SNR %
local function time_for_snr(target_percent, exposure, max_snr)
    local target_raw = (target_percent / 100) * max_snr
    return target_raw ^ 2 / exposure
end

-- Adjust for fixed or variable total integration
local function adjust_for_snr(exposure, total_time, target_percent, max_snr)
    if total_time then
        local frames = math.floor(total_time / exposure)
        local raw_snr = estimate_snr(frames, exposure)
        return frames, normalize_snr(raw_snr, max_snr), total_time
    else
        local required_seconds = time_for_snr(target_percent, exposure, max_snr)
        local frames = math.ceil(required_seconds / exposure)
        local raw_snr = estimate_snr(frames, exposure)
        return frames, normalize_snr(raw_snr, max_snr), frames * exposure
    end
end

-- Balanced calibration frame counts based on lights (scaled)
local function calculate_frame_counts(light_frames)
    local bias_min, bias_max   = 10, 50
    local dark_min, dark_max   = 5, 30
    local flat_min, flat_max   = 5, 20

    local bias  = math.floor(light_frames * 0.2)
    local darks = math.floor(light_frames * 0.2)
    local flats = math.floor(light_frames * 0.15)

    bias  = math.max(bias_min, math.min(bias, bias_max))
    darks = math.max(dark_min, math.min(darks, dark_max))
    flats = math.max(flat_min, math.min(flats, flat_max))

    return darks, flats, bias
end

-- Estimate calibration time in seconds
local function calculate_calibration_time(darks, flats, bias, exposure)
    local bias_time = bias * 0.005                      -- 5 ms per bias
    local flat_time = flats * math.max(0.1, exposure * 0.1) -- flats ~10% of light exposure, min 0.1s
    local dark_time = darks * exposure                 -- darks same as exposure
    return bias_time + flat_time + dark_time
end

-- ===================== MAIN =====================
local exposure_time  = get_exposure_time(bortle_class, guiding)
local gain           = get_gain(bortle_class)
local total_seconds  = total_minutes and (total_minutes * 60) or nil
local max_snr        = 1000  -- arbitrary perfect SNR for scaling

print("➡ Sky Quality (Bortle): " .. bortle_class)
print("➡ Guiding: " .. tostring(guiding))
print("➡ Target SNR: " .. target_snr .. "%")
print("➡ Exposure Time / Frame: " .. exposure_time .. " seconds")
print("➡ Gain: " .. gain)
print("--------------------------------------------------")

local grand_total = 0

for _, ch in ipairs(channels) do
    local channel_time = total_seconds and (total_seconds * ch.weight) or nil
    local frames, snr_percent, integration = adjust_for_snr(exposure_time, channel_time, target_snr, max_snr)

    -- Calculate calibration frames
    local darks, flats, bias = calculate_frame_counts(frames)

    -- Apply reuse flags
    if reuse_bias then bias = 0 end
    if reuse_darks then darks = 0 end
    if reuse_flats then flats = 0 end

    -- Total calibration time
    local calib_time = calculate_calibration_time(darks, flats, bias, exposure_time)
    local channel_total = integration + calib_time
    grand_total = grand_total + channel_total

    print("Channel: " .. ch.name .. (ch.altername and (" (" .. ch.altername .. ")") or ""))
    print("  Achieved SNR: " .. string.format("%.1f%%", snr_percent))
    print("  Lights: " .. frames .. " | Darks: " .. darks .. " | Flats: " .. flats .. " | Bias: " .. bias)
    print("  Light Time: " .. string.format("%.1f", integration / 60) .. " minutes")
    print("  Calibration Time: " .. string.format("%.2f", calib_time / 60) .. " minutes")
    print("  Channel Total: " .. string.format("%.1f", channel_total / 60) .. " minutes")
    print("--------------------------------------------------")
end

print("➡ Grand Total (Lights + Calibrations Across Channels): " .. string.format("%.1f", grand_total / 3600) .. " hours")
