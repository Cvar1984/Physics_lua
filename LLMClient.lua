-- Load required modules
local http = require("socket.http")
local ltn12 = require("ltn12")
local socket = require("socket")
local json = require("dkjson")

-- Define a class for handling HTTP requests and JSON parsing
local LLMClient = {
    temp = 0.8,
    stream = false,
    timeout = 30, -- Default timeout in seconds
}
LLMClient.__index = LLMClient

--- Create new model
---@param model string LLM model
---@return self instance
function LLMClient:new(model)
    local instance = setmetatable({}, self)
    self.model = model
    return instance
end

--- Parse json stream response body
--- @param responseBody string raw json data
--- @return string concatenated text response
function LLMClient:parseResponse(responseBody)
    local concatenated = ""
    for json_obj in responseBody:gmatch("{.-}") do
        local parsed_obj, _, err = json.decode(json_obj)
        if err then
            print("Error parsing JSON:", err)
        else
            -- Concatenate the 'response' field
            concatenated = concatenated .. (parsed_obj and parsed_obj.response or "")
        end
    end
    return concatenated
end

--- Make http request to llm API
---@param prompt string your llm prompt
---@return string responseBody raw json data
function LLMClient:makeRequest(prompt)
    -- Prepare the POST data
    -- https://github.com/ollama/ollama/blob/main/docs/api.md
    local data = {
        ["model"] = self.model,
        ["prompt"] = prompt,
        ["stream"] = self.stream,
        ["options"] = {
            ["temperature"] = self.temp,
        },
    }
    data = json.encode(data)

    -- Custom socket factory to set timeout
    local function createCustomSocket()
        local sock = socket.tcp()
        sock:settimeout(self.timeout) -- Set timeout from the LLMClient instance
        return sock
    end

    -- Use custom socket factory for this request
    http.open = function()
        return createCustomSocket()
    end

    -- Make the POST request
    local response = {}
    local result, statusCode, headers = http.request {
        url = "http://cvar1984.my.id:11434/api/generate",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#data)
        },
        source = ltn12.source.string(data),
        sink = ltn12.sink.table(response),
    }

    assert(statusCode == 200, "Error response " .. statusCode)

    local responseBody = table.concat(response)
    return responseBody
end

return LLMClient
