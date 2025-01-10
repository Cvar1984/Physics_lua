local LLMClient = require "LLMClient"

local qwen = LLMClient:new("qwen2.5:0.5b")
qwen.temp = 1

local mathstral = LLMClient:new("mathstral:latest")
mathstral.temp = 0.3
mathstral.timeout = 120

io.write("Enter prompt: ")
local prompt = io.read()

local rawRensponse = qwen:makeRequest(prompt)
print(qwen:parseResponse(rawRensponse))

local rawRensponse = mathstral:makeRequest(prompt)
print(mathstral:parseResponse(rawRensponse))