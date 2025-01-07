---@diagnostic disable: need-check-nil

local WavParse = require "WavParse"
local Math = require "Math"
local wav = WavParse:new("suntuk.wav")

print("Channels:", wav:getChannel())
print("Bit Depth:", wav:getBitDepth() .. " bits")
print("Sample Rate:", wav:getSampleRate() .. " Hz")
print("File Size:", wav:getFileSize() / 1e6 .. " MB")
local duration = wav:getDuration()
print("Duration:", Math:round(duration) .. "s")
local time, sample = wav:getTimesSamples(wav:readSample(), duration)
print("Samples:", #time)

local file = io.open("wave.dat", "wb")
-- Plot data
for i = 1, #time do
    file:write(string.format("%f %f\n", time[i], sample[i]))
end
file:close()