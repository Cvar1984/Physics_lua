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

io.write("Initial acceleration of the object in m/s: ")
local initial_velocity = io.read("*n")

io.write("Times the object is dropped from a height in sec: ")
local time = io.read("*n");

local height = initial_velocity * time + 0.5 * gravity * time ^ 2

print(string.format("Your height: %s Meter", height))
