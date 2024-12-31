---@diagnostic disable: need-check-nil
local Fourier = require "Fourier"

-- Example usage
local signal = {}
local t = {}
local harmonic = 3


-- Generate a simple sine wave for the example
local f = 1
for i = 1, 50 do
    t[i] = (i - 1) * 0.01  -- time array (0.01 second intervals)
    signal[i] = math.sin(2 * math.pi * f * t[i])
end

-- Decompose the signal into Fourier coefficients
local coeffs = Fourier:decompose(signal, harmonic, f, t)

local file = io.open("wave.dat", "w")

-- Recompose the signal from the coefficients
local recomposeSignal = {}
for i, ti in ipairs(t) do
    recomposeSignal[i] = Fourier:recompose(coeffs, f, ti)
    file:write(string.format("%f\t %f\t %f\n", ti, signal[i], recomposeSignal[i]))
end