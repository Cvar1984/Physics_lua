local Benchmark = require "Benchmark"
local Math = require "Math"
local f1 = Benchmark:functions(
    function()
        Math:pi(17)
    end, 1e3)

local f2 = Benchmark:functions(
    function()
        Math:pi(17)
    end, 1e3)

local avgT = Benchmark:compare(f1, f2)

print(avgT .. "%") -- small percentage = small diffrences = more stable