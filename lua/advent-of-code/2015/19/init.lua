--- @class AOCDay201519: AOCDay
--- @field input { replacements: string[], molecule: string }
local M = require("advent-of-code.AOCDay"):new("2015", "19")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    replacements = {},
    molecule = "",
  }

  local parsing_replacements = true
  for _, line in ipairs(lines) do
    if line == "" then
      parsing_replacements = false
    else
      if parsing_replacements then
        table.insert(self.input.replacements, line:split " => ")
      else
        self.input.molecule = line
      end
    end
  end
end

function M:solve1()
  local molecules = {}

  for _, replacement in ipairs(self.input.replacements) do
    local init = 1
    while true do
      local start, ending = self.input.molecule:find(replacement[1], init)
      if start == nil then
        break
      end
      local prev = self.input.molecule:sub(1, start - 1)
      local next = self.input.molecule:sub(ending + 1)
      local new = prev .. replacement[2] .. next
      molecules[new] = true
      init = start + 1
    end
  end

  return table.count(molecules)
end

function M:solve2()
  return self.input.molecule:count "%u"
    - self.input.molecule:count "Rn"
    - self.input.molecule:count "Ar"
    - 2 * self.input.molecule:count "Y"
    - 1
end

M:run()
