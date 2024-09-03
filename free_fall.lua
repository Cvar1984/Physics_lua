local initial_velocity, time, gravity, height;

-- The gravitational acceleration of the Earth is 9.80665 m/s².
gravity = 9.80665;

io.write("Initial acceleration of the object in m/s: ");
initial_velocity = io.read("*n");

io.write("Times the object is dropped from a height in sec: ");
time = io.read("*n");

height = initial_velocity * time + 0.5 * gravity * time ^ 2;

print(string.format("Your height: %s Meter", height));