local Math = {
    SPEED_OF_LIGHT = 299792458, -- m/s
    GRAVITY = 9.80665,          -- m/s²
    --PI = 3.14159265358979,      -- 15 digit seems to be accurate enough
    PLANCK = 6.62607015e-34,    -- J.Hz⁻¹ reduced = h/(2pi) J.s
    sqrtTolerance = 1e-14,
    sqrtMaxIteration = 30,
    lambertTolerance = 1e-2,
    lambertIteration = 3,
    pmb = 0,
    qmb = 0,
    p1a = 0,
    q1a = 0,
    r1a = 0,
    p1b = 0,
    q1b = 0,
    r1b = 0,
    m = 0,
    rab = 0,
}

setmetatable(Math, { __index = Math }) -- static class

-- binary tree square root
function Math:sqrtTree(x)
    local low, mid, high = 0, 0, x
    local eps = 1e-14 -- Adjust epsilon for desired precision, 1*(10^-14) seems the best

    while high - low > eps do
        mid = (low + high) / 2
        if mid * mid <= x then
            low = mid
        else
            high = mid
        end
    end

    return low
end

-- newton square root
function Math:sqrt(square)
    if (square < 0) then
        return 0/0 -- nan
    elseif (square == 0) then
        return 0
    end

    local iteration, guessFuture = 0,0
    --local guess = square / 2 -- Initial guess
    local guess = square -- Start with a more robust initial guess

    while iteration < self.sqrtMaxIteration do
        guessFuture = 0.5 * (guess + (square / guess))
        if math.abs(guessFuture - guess) < self.sqrtTolerance then
            return guessFuture
        end
        guess = guessFuture
        iteration = iteration + 1
    end
    return guess
end

-- decimal grouping separator
function Math:separate(amount)
    local formatted, k = amount, nil
    while k ~= 0 do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    end
    return formatted
end

-- round numbers
function Math:round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

-- round and format
function Math:humanize(x)
    return Math:separate(Math:round(x))
end

function Math:binarySplit(a, b)
    if b == a + 1 then
        -- Base case
        self.p1a = -(6 * a - 5) * (2 * a - 1) * (6 * a - 1)
        self.q1a = 10939058860032000 * a ^ 3
        self.r1a = self.p1a * (545140134 * a + 13591409)
        return self.p1a, self.q1a, self.r1a
    else
        -- Divide and conquer
        self.m = math.floor((a + b) / 2)
        self.p1a, self.q1a, self.r1a = self:binarySplit(a, self.m)
        self.p1b, self.q1b, self.r1b = self:binarySplit(self.m, b)

        -- Combine results
        self.pmb = self.p1a * self.p1b
        self.qmb = self.q1a * self.q1b
        self.rab = self.q1b * self.r1a + self.p1a * self.r1b
        return self.pmb, self.qmb, self.rab
    end
end

function Math:pi(n)
    local p1n, q1n, r1n = self:binarySplit(1, n)
    return (426880 * self:sqrt(10005) * q1n) / (13591409 * q1n + r1n)
end

-- Lambert W function implemented using Newton-Raphson iteration
function Math:lambertW(x)
    -- Ensure valid input
    if x < -1 / math.exp(1) then
        return 0/0 -- -NaN
    end

    local w
    if x == 0 then
        return 0
    elseif x > 1 then
        -- For large x, initial guess can be log(x)
        w = math.log(x)
    else
        -- For small x, initial guess is x
        w = x
    end

    -- Newton-Raphson iteration
    for i = 1, self.lambertIteration do
        local ew = math.exp(w)
        local wew = w * ew
        local deltaW = (wew - x) / (ew * (w + 1) - ((w + 2) * (wew - x) / (2 * w + 2)))  -- Halley's method
        w = w - deltaW

        -- Check convergence
        if math.abs(deltaW) < self.lambertTolerance then
            return w
        end
    end
end

return Math
