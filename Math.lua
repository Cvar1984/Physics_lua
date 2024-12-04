local Math = {
    SPEED_OF_LIGHT = 299792458, -- m/s
    GRAVITY = 9.80665,          -- m/s²
    PI = 3.14159265358979,      -- 15 digit seems to be accurate enough
    HUBBLE = {                  -- Plack + ACTPol + SPTpol 2021 https://lambda.gsfc.nasa.gov/education/graphic_history/hubb_const.html
        VALUE = 68.7,           -- Km/s/Mpc
        UNCERTAIN = 1.3,
    },
    LIGHT_YEAR = 3.2615637769, -- ly/pc
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

return Math
