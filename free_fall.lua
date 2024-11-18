--[[
h = 1/2 gt^2
]]--
local gravity_tables = {
    ["moon"] = 1.625,
    ["earth"] = 9.80665,
    ["mars"] = 3.72076,
    ["sun"] = 274,
    ["betelgeus"] = 0.003162,
}

io.write("Select gravity sources [earth,moon,mars,sun,betelgeus]: ")
local choice = io.read("*l")
choice = string.lower(choice)
local gravity = gravity_tables[choice]

io.write("Times the object is dropped from a height in sec: ")
local time = io.read("*n");

local height = 1/2 * gravity * (time ^ 2)
--local t = math.sqrt(height / (1/2 * gravity))
--local g = height/(1/2 * (time ^ 2))

print(string.format("Your height: %s m", height))
print(string.format("Your gravity: %s m/s^2", gravity))
print(string.format("Your time: %s S", time))
