local Math = {}
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
return Math