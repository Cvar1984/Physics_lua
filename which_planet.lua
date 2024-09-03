io.write("Initial acceleration of the object in m/s: ");
local initial_velocity = io.read("*n")

io.write("Height in meter: ")
local height = io.read("*n")

io.write("Times the object is dropped from a height in sec: ")
local time = io.read("*n")

local gravity = 2 * (height - initial_velocity * time) / time ^ 2

print(string.format("The acceleration due to gravity is: %s m/s^2", gravity))