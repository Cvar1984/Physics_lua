local Math = {
    SPEED_OF_LIGHT = 299792458, -- m/s^2
    GRAVITY = 9.80665,          -- m/s^2
    PI = 3.14159265358979,      -- 15 digit seems to be accurate enough
    HUBBLE = 2.3817e-18,        -- m/s/m
    LIGHT_YEAR = 9.461e15,      -- m
}
function Math:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- binary tree square root
function Math:sqrt(x)
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
function Math:Sqrt(x)
    local epsilon = 1e-14
    local guess = x / 2

    while math.abs(guess * guess - x) > epsilon do
        guess = (guess + x / guess) / 2
    end

    return guess
end

-- decimal grouping separator
function Math:formatNumber(amount)
    local formatted, k = amount, nil
    while k ~= 0 do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    end
    return formatted
end

return Math
