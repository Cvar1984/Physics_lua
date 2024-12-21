local Electric = {}

setmetatable(Electric, {__index = Electric})

-- v = ir
function Electric:calculateElectricVoltage(current, resistance)
    local voltage = current * resistance
    return voltage
end

-- i = v/r
function Electric:calculateElectricCurrent(voltage, resistance)
    local current = voltage / resistance
    return current
end

-- r = v/i
function Electric:calculateElectricResistance(voltage, current)
    local resistance = voltage / current
    return resistance
end

-- p = vi
function Electric:calculateElectricPower(voltage, current)
    local wattage = voltage * current
    return wattage
end

return Electric
