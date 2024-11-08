local function iterate_function(initial_value, num_iterations)
    local current_value = initial_value

    for i = 1, num_iterations do
      current_value = current_value * math.sin(current_value)
      print(current_value)
    end

    return current_value
  end

  -- Example usage:
  local initial_value = 0.5
  local num_iterations = 10
  local final_value = iterate_function(initial_value, num_iterations)
  print(final_value)