local function degrees(radians)
    return radians * 180 / math.pi
end

io.write("Height of the pole: ")
local height = io.read("*n")

io.write("Length of the shadow: ")
local wide = io.read("*n")

local tan_alpha = height / wide
local alpha_radian = math.atan(tan_alpha)
local alpha_degree = degrees(alpha_radian)

print("Alpha:", alpha_degree, "deg")