local LLMClient = require "LLMClient"
-- Create a new instance of the LLMClient
local llm = LLMClient:new("qwen2.5:0.5b")

-- Prompt for user input and make the request
print("Enter prompt: ")
local prompt = io.read()
print(llm:parseResponse(llm:makeRequest(prompt)))