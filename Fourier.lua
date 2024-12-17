local Math = require "Math"
local Fourier = {}

setmetatable(Fourier, {__index = Fourier})

-- f_{1}\left(x\right)=\sum_{n=1}^{i}\frac{\left(-1^{n}\right)\sin\left(2\pi nfx\right)}{n}
function Fourier:transformSawtooth(i, f, t)
    local term = 0

    for n = 1, i do
        term = term + (-1 ^ n * math.sin(2 * Math:pi(17) * n * f * t) / n)
    end
    return 2 / Math:pi(17) * term
end
return Fourier
