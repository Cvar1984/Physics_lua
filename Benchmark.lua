local Benchmark = {}

setmetatable(Benchmark, { __index = Benchmark })

---@param fasterTime number
---@param slowerTime number
---@return number
function Benchmark:calculatePercentage(fasterTime, slowerTime)
    local delta = slowerTime - fasterTime
    return delta / slowerTime * 100
end

---@param callback function
---@param iteration number
---@return number
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

---@param averageTime1 (number)
---@param averageTime2 (number)
---@return number
function Benchmark:compare(averageTime1, averageTime2)
    local fasterTime = math.min(averageTime1, averageTime2)
    local slowerTime = math.max(averageTime1, averageTime2)
    local percentage = self:calculatePercentage(fasterTime, slowerTime)
    return percentage
end

return Benchmark
