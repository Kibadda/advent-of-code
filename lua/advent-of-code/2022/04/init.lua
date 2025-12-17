--- @class AOCDay202204: AOCDay
--- @field input number[][][]
local M = require("advent-of-code.AOCDay"):new("2022", "04")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local parsed_section = {}
    for _, elf_sections in ipairs(line:split ",") do
      local boundaries = elf_sections:split "-"
      local min = boundaries[1]
      local max = boundaries[2]

      local sections = {}
      for i = min, max do
        table.insert(sections, i)
      end
      table.insert(parsed_section, sections)
    end
    table.insert(self.input, parsed_section)
  end
end

function M:solver(fun)
  local score = 0

  for _, section_pair in ipairs(self.input) do
    local section1_length = #section_pair[1]
    local section2_length = #section_pair[2]

    local mergee = section1_length > section2_length and 1 or 2
    local merger = section1_length > section2_length and 2 or 1

    local turned = {}
    for _, v in ipairs(section_pair[mergee]) do
      turned[v] = true
    end

    for _, v in ipairs(section_pair[merger]) do
      turned[v] = true
    end

    if fun(table.count(turned), table.count(section_pair[mergee]), table.count(section_pair[merger])) then
      score = score + 1
    end
  end

  return score
end

function M:solve1()
  return self:solver(function(turned, mergee)
    return turned == mergee
  end)
end

function M:solve2()
  return self:solver(function(turned, mergee, merger)
    return turned < mergee + merger
  end)
end

M:run()
