local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "04")

function M:parse_input(file)
  for line in file:lines() do
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

function M:solve1()
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

    if table.count(turned) == table.count(section_pair[mergee]) then
      score = score + 1
    end
  end

  self.solution:add("1", score)
end

function M:solve2()
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

    if table.count(turned) < table.count(section_pair[mergee]) + table.count(section_pair[merger]) then
      score = score + 1
    end
  end

  self.solution:add("2", score)
end

M:run(false)

return M
