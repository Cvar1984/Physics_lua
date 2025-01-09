-- Load required modules
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson")

-- Define a class for handling HTTP requests and JSON parsing
local LLMClient = {}
LLMClient.__index = LLMClient

---comment
---@param model string LLM model
---@return self instance
function LLMClient:new(model)
    local instance = setmetatable({}, self)
    self.model = model
    return instance
end

--- comment
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
    local data = string.format('{"model": "%s", "prompt": "%s"}', self.model, prompt)

    -- Make the POST request
    local response = {}
    local result, statusCode, headers = http.request{
        url = "http://cvar1984.my.id:11434/api/generate",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#data)
        },
        source = ltn12.source.string(data),
        sink = ltn12.sink.table(response)
    }

    -- Check the status code
    assert(statusCode == 200, "Error response " .. statusCode)

    -- Join the response table into a single string
    local responseBody = table.concat(response)

    -- Concatenate all responses
    return responseBody
end

return LLMClient