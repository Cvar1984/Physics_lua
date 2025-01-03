local Math = require "Math"
local Fourier = {}

setmetatable(Fourier, { __index = Fourier })

---CoefficientsWave
---@param i number index
---@param f number frequency
---@param t number time
---@return number result coefficients wave
function Fourier:cosine(i, f, t)
    -- i is the index, f is the frequency, t is the time
    return math.cos(2 * Math:pi() * f * i * t)
end

---Sinwave
---@param i number index
---@param f number frequency
---@param t number time
---@return number result sinwave
function Fourier:sine(i, f, t)
    return math.sin(2 * Math:pi() * f * i * t)
end

---Recompose signals
---@param coeffs table sin & cosin coefficients signals
---@param f number frequency
---@param t number time
---@return number result composed signals
function Fourier:recompose(coeffs, f, t)
    local result = 0
    for n, coeff in ipairs(coeffs) do
        -- Rebuild signal using both sine and cosine terms
        result = result + coeff.cos * self:cosine(n, f, t) + coeff.sin * self:sine(n, f, t)
    end
    return result
end

---Decompose signals
---@param signal table table of discrete signal
---@param maxHarmonic number
---@param f number frequency
---@param t table time table
---@return table coefficients
function Fourier:decompose(signal, maxHarmonic, f, t)
    local coeffs = {}

    for n = 1, maxHarmonic do
        local cosC, sinC = 0, 0

        for i, ti in ipairs(t) do
            cosC = cosC + signal[i] * self:cosine(n, f, ti)
            sinC = sinC + signal[i] * self:sine(n, f, ti)
        end
        -- Average them over the time length
        cosC = (2 / #t) * cosC
        sinC = (2 / #t) * sinC

        -- Store the coefficients
        coeffs[n] = { cos = cosC, sin = sinC }
    end

    return coeffs
end

-- f_{1}\left(x\right)=\sum_{n=1}^{i}\frac{\left(-1^{n}\right)\sin\left(2\pi nfx\right)}{n}
function Fourier:transformSawtooth(i, f, t)
    local term = 0

    for n = 1, i do
        term = term + ((-1) ^ n * math.sin(2 * Math:pi() * n * f * t) / n)
    end
    return 2 / Math:pi() * term
end

return Fourier
