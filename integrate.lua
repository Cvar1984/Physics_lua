local Math = require "Math"

local points = { -- x,y
    {0.0, 0.0},
    {0.5, 0.119856},
    {1.6, 0.799659},
    {2.028758, 0.909853},
    {2.4, 0.810556},
    {2.8, 0.468983},
    {3.4, -0.43442},
    {4.0, -1.513605},
}

local precision = 10
local integrator = Math:integratorNew(points)
local totalArea = Math:integratorComputeArea(precision)

print("Total area under |y| from x = 0 to x = 4 is:", totalArea)