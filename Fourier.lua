local Math = require "Math"
local Fourier = {}

function Fourier:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- f_{1}\left(x\right)=\sum_{n=1}^{i}\frac{\left(-1^{n}\right)\sin\left(2\pi nfx\right)}{n}
function Fourier:transformSawtooth(i, f, t)
    local term = 0

    for n = 1, i do
        term = term + (-1 ^ n * math.sin(2 * Math.PI * n * f * t) / n)
    end
    return 2 / Math.PI * term
end
return Fourier
