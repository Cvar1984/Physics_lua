local WavParse = {}
WavParse.__index = WavParse

--- Create a new WavParse object
---@param filename string Path to the WAV file
---@return table WavParse object
function WavParse:new(filename)
    local self = setmetatable({}, WavParse)
    self.filename = filename
    self.file = io.open(filename, "rb")
    assert(self.file, "Failed to open file: " .. filename)
    self:parseHeader()

    local mt = getmetatable(self)
    mt.__gc = function(obj)
        obj:close()
    end
    return self
end

--- Parse the WAV header and extract metadata
function WavParse:parseHeader()
    local file = self.file

    assert(file:read(4) == "RIFF", "Not a valid WAV file")
    self.fileSize = string.unpack("<I4", file:read(4)) + 8 -- Include RIFF header size
    assert(file:read(4) == "WAVE", "Not a valid WAV file")

    self.chunkInfo = {}
    local dataFound = false

    while true do
        local chunkId = file:read(4)
        if not chunkId then break end

        local chunkSize = string.unpack("<I4", file:read(4))
        if chunkId == "fmt " then
            self.audioFormat = string.unpack("<I2", file:read(2))
            self.channels = string.unpack("<I2", file:read(2))
            self.sampleRate = string.unpack("<I4", file:read(4))
            self.byteRate = string.unpack("<I4", file:read(4))
            self.blockAlign = string.unpack("<I2", file:read(2))
            self.bitDepth = string.unpack("<I2", file:read(2))
            file:seek("cur", chunkSize - 16) -- Move to the end of this chunk
        elseif chunkId == "data" then
            self.dataChunkSize = chunkSize
            self.dataStart = file:seek("cur")
            file:seek("cur", chunkSize) -- Skip to the end of the data chunk
            dataFound = true
        else
            file:seek("cur", chunkSize) -- Skip unknown chunk
        end
    end

    assert(dataFound, "Data chunk not found in the WAV file")
end

--- Get the number of channels
---@return number Channels
function WavParse:getChannel()
    return self.channels
end

--- Get the bit depth
---@return number Bit depth
function WavParse:getBitDepth()
    return self.bitDepth
end

--- Get the sample rate
---@return number Sample rate
function WavParse:getSampleRate()
    return self.sampleRate
end

--- Get the file size in bytes
---@return number File bytes
function WavParse:getFileSize()
    return self.fileSize
end

--- Read samples from the WAV file
---@return table Sample
function WavParse:readSample()
    if not self.dataChunkSize then
        error("Data chunk not found in the WAV file")
    end

    local file = self.file
    file:seek("set", self.dataStart)

    local bytesPerSample = self.bitDepth / 8
    local numSamples = math.floor(self.dataChunkSize / bytesPerSample)
    local samples = {}

    for i = 1, numSamples do
        if self.bitDepth == 8 then
            samples[i] = string.unpack("B", file:read(1)) - 128 -- 8-bit is unsigned
        elseif self.bitDepth == 16 then
            samples[i] = string.unpack("<i2", file:read(2)) -- 16-bit is signed
        else
            error("Unsupported bit depth: " .. self.bitDepth)
        end
    end

    return samples
end

---Get total audio duration in seconds
---@return number Duration second
function WavParse:getDuration()
    if not self.sampleRate or not self.channels or not self.bitDepth or not self.dataChunkSize then
        error("Required data not parsed. Ensure the header is parsed first.")
    end

    local bytesPerSample = self.bitDepth / 8
    local duration = self.dataChunkSize / (self.sampleRate * self.channels * bytesPerSample)
    return duration
end

function WavParse:getTimesSamples(samples, duration)
    local timeStep = duration / #samples
    local x,y = {}, {}

    for i, sample in ipairs(samples) do
        local time = (i - 1) * timeStep
        x[i] = time
        y[i] = sample
    end
    return x, y
end

---Automatically close the file when the object is garbage collected
function WavParse:close()
    if self.file then
        self.file:close()
        self.file = nil
    end
end

return WavParse
