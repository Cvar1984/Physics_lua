---@diagnostic disable: need-check-nil
local Fourier = require "Fourier"

local i = 12 -- Number of terms
local f = 1  -- Frequency

local file = io.open("wave.dat", "w")

for t = 0, 10, 0.001 do
    file:write(string.format("%f %f\n", t, Fourier:transformSawtooth(i, f, t)))
end
os.execute("gnuplot -p -e \"plot 'wave.dat' using 1:2 with lines title 'Sawtooth Wave'\"")