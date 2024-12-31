local Math = require "Math"
local Fourier = {}

setmetatable(Fourier, {__index = Fourier})

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
    -- i is the index, f is the frequency, t is the time
    return math.sin(2 * Math:pi() * f * i * t)
end

---Recompose signals
---@param coeffs table coefficients signals
---@param f number frequency
---@param t number time
---@return number result composed signals
function Fourier:recompose(coeffs, f, t)
    -- coeffs is a table of the Fourier series coefficients (A_n, B_n)
    local result = 0
    for n, coeff in ipairs(coeffs) do
        -- Rebuild signal using both sine and cosine terms
        result = result + coeff.A * self:cosine(n, f, t) + coeff.B * self:sine(n, f, t)
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
        -- Calculate A_n (cosine coefficient) and B_n (sine coefficient)
        local A_n, B_n = 0, 0
        for i, ti in ipairs(t) do
            A_n = A_n + signal[i] * self:cosine(n, f, ti)
            B_n = B_n + signal[i] * self:sine(n, f, ti)
        end
        -- Average them over the time length
        A_n = (2 / #t) * A_n
        B_n = (2 / #t) * B_n

        -- Store the coefficients
        coeffs[n] = { A = A_n, B = B_n }
    end

    return coeffs
end

-- f_{1}\left(x\right)=\sum_{n=1}^{i}\frac{\left(-1^{n}\right)\sin\left(2\pi nfx\right)}{n}
function Fourier:transformSawtooth(i, f, t)
    local term = 0

    for n = 1, i do
        term = term + (-1 ^ n * math.sin(2 * Math:pi(17) * n * f * t) / n)
    end
    return 2 / Math:pi() * term
end
return Fourier
