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

local totalArea = 0

for i = 1, #points - 1 do
    local x1, y1 = table.unpack(points[i])
    local x2, y2 = table.unpack(points[i + 1])
    local segmentFunc = Math:slopeDrawLine(y1, y2, x1, x2)
    local area = Math:slopeIntegrate(segmentFunc, x1, x2, 1000)
    print(string.format("Segment %d: from %.2f to %.2f = Area %.6f", i, x1, x2, area))
    totalArea = totalArea + area
end
print("Total Approximate Area:", totalArea)