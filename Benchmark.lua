---@diagnostic disable: need-check-nil
local Math = require "Math"
local Benchmark = {}

setmetatable(Benchmark, { __index = Benchmark })

function Benchmark:calculatePercentage(fasterTime, slowerTime)
    local delta = slowerTime - fasterTime
    return delta / slowerTime * 100
end

function Benchmark:functions(callback, iteration)
    iteration = iteration or 1
    local totalTime = 0

    for i = 0, iteration do
        local initialTime = os.clock()
        callback()
        local finalTime = os.clock()
        local deltaTime = finalTime - initialTime
        totalTime = totalTime + deltaTime
    end

    local averageTime = totalTime / iteration
    return averageTime
end

--return Benchmark
local f1 = Benchmark:functions(
    function()
        Math:pi(17)
    end, 1e3)

local f2 = Benchmark:functions(
    function()
        Math:pi(17)
    end, 1e3)

local fasterTime = math.min(f1, f2)
local slowerTime = math.max(f1, f2)

local avgT = Benchmark:calculatePercentage(fasterTime, slowerTime)
print(avgT .. "%") -- small percentage = small diffrences = more stable