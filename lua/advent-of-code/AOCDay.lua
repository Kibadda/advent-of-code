---@class AOCDay
---@field solve1 (fun(): string|integer) solves first problem
---@field solve2 (fun(): string|integer) solves second problem
---@field read_input (fun(): function) reads input and returns interator

---@param year string
---@param day string
---@param input_file string
---@return AOCDay
local function create_object(year, day, input_file)
  local obj = {}
  year = year or os.date "%Y"

  function obj.read_input()
    local path = ("./lua/advent-of-code/%s/%s/%s"):format(year, day, input_file)
    local file, err = io.open(path, "r")

    if err then
      error(err)
    end

    if file then
      return file:lines()
    else
      return ipairs {}
    end
  end

  function obj.solve1()
    error "solve1 was not overwritten"
  end

  function obj.solve2()
    error "solve2 was not overwritten"
  end

  return obj
end

return create_object
