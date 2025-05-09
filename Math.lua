local Math = {
    SPEED_OF_LIGHT = 299792458, -- m/s
    GRAVITY = 9.80665,          -- m/s²
    PLANCK = 6.62607015e-34,    -- J.Hz⁻¹ reduced = h/(2pi) J.s
    sqrtTolerance = 1e-14,
    sqrtMaxIteration = 30,
    lambertTolerance = 1e-2,
    lambertIteration = 3,
}

--setmetatable(Math, { __index = Math }) -- static class

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
        return 0 / 0 -- nan
    elseif (square == 0) then
        return 0
    end

    local iteration, guessFuture = 0, 0
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
    local pmb, qmb, p1a, q1a, r1a, p1b, q1b, r1b, m, rab
    if b == a + 1 then
        -- Base case
        p1a = -(6 * a - 5) * (2 * a - 1) * (6 * a - 1)
        q1a = 10939058860032000 * a ^ 3
        r1a = p1a * (545140134 * a + 13591409)
        return p1a, q1a, r1a
    else
        -- Divide and conquer
        m = math.floor((a + b) / 2)
        p1a, q1a, r1a = self:binarySplit(a, m)
        p1b, q1b, r1b = self:binarySplit(m, b)

        -- Combine results
        pmb = p1a * p1b
        qmb = q1a * q1b
        rab = q1b * r1a + p1a * r1b
        return pmb, qmb, rab
    end
end

function Math:pi(n)
    n = n or 17
    local p1n, q1n, r1n = self:binarySplit(1, n)
    return (426880 * self:sqrt(10005) * q1n) / (13591409 * q1n + r1n)
end

-- Lambert W function implemented using Newton-Raphson iteration
function Math:lambertW(x)
    -- Ensure valid input
    if x < -1 / math.exp(1) then
        return 0 / 0 -- -NaN
    end

    local w
    if x == 0 then
        return 0
    elseif x > 1 then
        -- For large x, initial guess can be log(x)
        w = self:log(x)
    else
        -- For small x, initial guess is x
        w = x
    end

    -- Newton-Raphson iteration
    for i = 1, self.lambertIteration do
        local ew = math.exp(w)
        local wew = w * ew
        local deltaW = (wew - x) / (ew * (w + 1) - ((w + 2) * (wew - x) / (2 * w + 2))) -- Halley's method
        w = w - deltaW

        -- Check convergence
        if math.abs(deltaW) < self.lambertTolerance then
            return w
        end
    end
end

---base^x=n
---@param base number
---@param n any
---@return number x
function Math:log(base, n)
    if n == nil then
        return math.log(base) -- ln(x)
    end
    return math.log(n, base)
end

---@param n integer
---@return integer
function Math:factorial(n)
    if n < 0 then
        return 0 / 0
    end
    local result = 1
    for i = 1, n do
        result = result * i
    end
    return result
end

---Taylor sine, simple but not accurate
---@param x number
---@return number result
function Math:sin(x)
    local sinMaxIteration = 32
    local term, term1, term2
    local result = 0
    for n = 0, sinMaxIteration do
        term1 = 2 * n + 1
        term2 = self:factorial(2 * n + 1)
        term = ((-1) ^ n * x ^ term1) / term2
        result = result + term
    end
    return result
end

---Create integration instance
---@param points table Point x and y
---@return table
function Math:integratorNew(points)
    self.originalPoints = points or {}
    self.processedPoints = {}
    return self
end

--- Draw slope line
---@param heightStart number Starting of height(y)
---@param heightEnd number End of height(y)
---@param lengthStart number Start of length(x)
---@param lengthEnd number End of length(x)
---@return function
function Math:integratorDrawLine(heightStart, heightEnd, lengthStart, lengthEnd)
    local deltaHeight = heightEnd - heightStart
    local deltaLength = lengthEnd - lengthStart
    local slope = deltaHeight / deltaLength
    local intercept = heightStart - slope * lengthStart
    return function(x)
        return slope * x + intercept
    end
end

--- Integrate slope
---@param f function Result from slopeDrawLine
---@param xStart number Starting of length(x)
---@param xEnd number End of length(x)
---@param slices number Precission
---@return number area Area under the curve
function Math:integratorAbsIntegrate(f, xStart, xEnd, slices)
    local totalArea = 0
    local dx = (xEnd - xStart) / slices
    for i = 0, slices - 1 do
        local x1 = xStart + i * dx
        local x2 = x1 + dx
        local y1 = math.abs(f(x1))
        local y2 = math.abs(f(x2))
        totalArea = totalArea + (y1 + y2) * dx / 2
    end
    return totalArea
end

--- Find the x position where the line between two points crosses the x-axis
---@param p1 table {x1, y1}
---@param p2 table {x2, y2}
---@return table {x, 0} the x-coordinate where y = 0
function Math:integratorFindZeroX(p1, p2)
    local x1, y1 = table.unpack(p1)
    local x2, y2 = table.unpack(p2)
    local slope = (y2 - y1) / (x2 - x1)
    local xZero = x1 - y1 / slope
    return {xZero, 0}
end

--- Preprocess points, insert zero-crossings
function Math:integratorInterpolateCrossings()
    for i = 1, #self.originalPoints - 1 do
        local p1 = self.originalPoints[i]
        local p2 = self.originalPoints[i + 1]
        table.insert(self.processedPoints, p1)

        if p1[2] * p2[2] < 0 then
            local zero = self:integratorFindZeroX(p1, p2)
            table.insert(self.processedPoints, zero)
        end
    end
    table.insert(self.processedPoints, self.originalPoints[#self.originalPoints])
end

--- Compute total absolute area under segments
--- @param slices number Precission
--- @return number totalArea
function Math:integratorComputeArea(slices)
    self:integratorInterpolateCrossings()
    local totalArea = 0
    for i = 1, #self.processedPoints - 1 do
        local x1, y1 = table.unpack(self.processedPoints[i])
        local x2, y2 = table.unpack(self.processedPoints[i + 1])
        local f = self:integratorDrawLine(y1, y2, x1, x2)
        totalArea = totalArea + self:integratorAbsIntegrate(f, x1, x2, slices or 10)
    end
    return totalArea
end

return Math
