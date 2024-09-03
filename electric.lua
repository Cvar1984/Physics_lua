-- Function to calculate wattage
function calculateWattage(voltage, current)
    return voltage * current
end

-- Function to calculate voltage
function calculateVoltage(wattage, current)
    return wattage / current
end

-- Function to calculate resistance
function calculateResistance(voltage, current)
    return voltage / current
end

-- Function to calculate current
function calculateCurrent(wattage, voltage)
    return wattage / voltage
end

-- Function to calculate power factor
function calculatePowerFactor(powerFactorAngle, powerFactorType)
    if powerFactorType == "cosine" then
        return math.cos(powerFactorAngle * math.pi / 180)
    elseif powerFactorType == "sine" then
        return math.sin(powerFactorAngle * math.pi / 180)
    else
        print("Invalid power factor type. Please use 'cosine' or'sine'.")
        return nil
    end
end

-- Get user input
print("Enter the wattage:")
local wattage = tonumber(io.read())

print("Enter the voltage:")
local voltage = tonumber(io.read())

print("Enter the resistance:")
local resistance = tonumber(io.read())

print("Enter the current:")
local current = tonumber(io.read())

print("Enter the power factor angle (in degrees) and type ('cosine' or'sine'):")
local powerFactorAngle = tonumber(io.read())
local powerFactorType = io.read():sub(1, 1)

-- Calculate power factor
local powerFactor = calculatePowerFactor(powerFactorAngle, powerFactorType)

-- Calculate additional values
local calculatedVoltage = calculateVoltage(wattage, current)
local calculatedResistance = calculateResistance(voltage, current)
local calculatedCurrent = calculateCurrent(wattage, voltage)

-- Print the results
print("Wattage: ".. wattage)
print("Voltage: ".. voltage)
print("Resistance: ".. resistance)
print("Current: ".. current)

if powerFactor then
    print("Power Factor: ".. powerFactor)
end

print("Calculated Voltage: ".. calculatedVoltage)
print("Calculated Resistance: ".. calculatedResistance)
print("Calculated Current: ".. calculatedCurrent)
