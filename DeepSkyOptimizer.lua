-- Deep Sky Imaging Optimizer with adjustable integration time or fixed time

-- User Input
local bortle_class = 5            -- 1 = darkest skies, 9 = bright city
local guiding = false             -- true = using autoguider, false = unguided
local total_minutes = nil         -- Desired total integration time in minutes, or nil for auto-calc
local target_snr = 50             -- Desired SNR (10 = basic, 20 = good, 30+ = excellent)

-- Function: Suggest exposure time based on sky brightness and guiding
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

-- Function: Suggest gain (range 1–30)
local function get_gain(bortle)
    if bortle <= 3 then return 10
    elseif bortle <= 5 then return 20
    else return 30
    end
end

-- Function: Calculate optimal calibration frames
local function calculate_frame_counts(light_frames)
    local darks = math.max(20, math.floor(light_frames * 0.3))
    local flats = math.max(15, math.floor(light_frames * 0.2))
    local bias  = math.max(30, math.floor(light_frames * 0.5))
    return darks, flats, bias
end

-- Function: Estimate SNR given frames and exposure
local function estimate_snr(frames, exposure)
    return math.sqrt(frames * exposure)
end

-- Function: Calculate required total time for target SNR
local function time_for_snr(target_snr)
    return target_snr ^ 2 -- seconds needed
end

-- Function: Adjust for SNR depending on fixed vs variable total time
local function adjust_for_snr(exposure, total_time, target_snr)
    if total_time then
        -- Fixed total integration time
        local frames = math.floor(total_time / exposure)
        local snr = estimate_snr(frames, exposure)
        return frames, snr, total_time
    else
        -- Calculate required time for target SNR
        local required_seconds = time_for_snr(target_snr)
        local frames = math.ceil(required_seconds / exposure)
        local snr = estimate_snr(frames, exposure)
        return frames, snr, frames * exposure
    end
end

-- Main calculation
local exposure_time = get_exposure_time(bortle_class, guiding)
local gain = get_gain(bortle_class)
local total_seconds = total_minutes and (total_minutes * 60) or nil

local light_frames, achieved_snr, integration = adjust_for_snr(exposure_time, total_seconds, target_snr)
local darks, flats, bias = calculate_frame_counts(light_frames)

-- Output
print("➡ Sky Quality (Bortle): " .. bortle_class)
print("➡ Guiding: " .. tostring(guiding))
print("➡ Target SNR: " .. target_snr)
print("➡ Estimated SNR: " .. string.format("%.1f", achieved_snr))
print("➡ Exposure time / frames: " .. exposure_time .. " seconds")
print("➡ Gain: " .. gain)
print("➡ Lights: " .. light_frames)
print("➡ Darks: " .. darks)
print("➡ Flats: " .. flats)
print("➡ Bias: " .. bias)
print("➡ Total Integration: " .. string.format("%.1f", integration / 60) .. " minutes")
