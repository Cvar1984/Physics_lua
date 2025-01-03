---@diagnostic disable: need-check-nil
local Fourier = require "Fourier"

local signal = {}
local time = {}
local harmonic = 30

-- testing sawtooth wave
local frequency = 1
for i = 1, 1000 do
    time[i] = (i - 1) * 0.001  -- time array (0.001 second intervals)
    signal[i] = Fourier:saw(i, frequency, time[i])
end

-- Decompose the signal into Fourier coefficients
local coeffs = Fourier:decompose(signal, harmonic, frequency, time)

local file = io.open("wave.dat", "w")

-- Recompose the signal from the coefficients
local recomposeSignal = {}
for i, ti in ipairs(time) do
    recomposeSignal[i] = Fourier:recompose(coeffs, frequency, ti)
    file:write(string.format("%f\t %f\t %f\n", ti, signal[i], recomposeSignal[i]))
end