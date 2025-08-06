-- Deep Sky Imaging Optimizer for SV305M Pro (or similar)
-- Author: ChatGPT

-- More frame more clear SNR
-- More exposure more signal captured
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


-- User Input
local target_name = "Orion Nebula"
local bortle_class = 6           -- 1 = darkest skies, 9 = bright city
local guiding = false            -- true = using autoguider, false = unguided
local total_minutes = 30        -- Desired total integration time in minutes

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

-- Function: Suggest gain for SV305M Pro
local function get_gain(bortle)
    if bortle <= 3 then return 250
    elseif bortle <= 5 then return 300
    else return 350
    end
end

-- Function: Calculate optimal calibration frames
local function calculate_frame_counts(light_frames)
    local darks = math.max(20, math.floor(light_frames * 0.3))
    local flats = math.max(15, math.floor(light_frames * 0.2))
    local bias  = math.max(30, math.floor(light_frames * 0.5))
    return darks, flats, bias
end

-- Main calculation
local exposure_time = get_exposure_time(bortle_class, guiding)
local gain = get_gain(bortle_class)
local total_seconds = total_minutes * 60
local light_frames = math.floor(total_seconds / exposure_time)
local integration = light_frames * exposure_time

local darks, flats, bias = calculate_frame_counts(light_frames)

-- Output
print("🎯 Deep Sky Imaging Plan for: " .. target_name)
print("Sky Quality (Bortle): " .. bortle_class)
print("Guiding: " .. tostring(guiding))
print("➡ Suggested Exposure Time: " .. exposure_time .. " seconds")
print("➡ Suggested Gain: " .. gain)
print("➡ Light Frames: " .. light_frames)
print("➡ Total Integration: " .. (integration / 60) .. " minutes")
print("➡ Darks: " .. darks)
print("➡ Flats: " .. flats)
print("➡ Bias: " .. bias)
