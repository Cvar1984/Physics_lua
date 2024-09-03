local function calculateAltitudeAngle(height, shadowLength)
    local angleInRadians = math.atan(height / shadowLength)
    local angleInDegrees = math.deg(angleInRadians)
    return angleInDegrees
end

-- Get user input
print("Enter the height of the pole in meters:")
local height = tonumber(io.read())

print("Enter the length of the shadow in meters:")
local shadowLength = tonumber(io.read())

-- Calculate the altitude angle
local altitudeAngle = calculateAltitudeAngle(height, shadowLength)

-- Print the result
print("Altitude Angle: ".. altitudeAngle.. " deg")