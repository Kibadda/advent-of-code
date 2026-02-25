--- @class AOCDay202408: AOCDay
--- @field input { height: integer, width: integer, antennas: table<string, Vector[]> }
local M = require("advent-of-code.AOCDay"):new("2024", "08")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    height = #lines,
    width = #lines[1],
    antennas = {},
  }

  for i, line in ipairs(lines) do
    for j, c in ipairs(line:to_list()) do
      if c ~= "." then
        self.input.antennas[c] = self.input.antennas[c] or {}
        table.insert(self.input.antennas[c], V(i, j))
      end
    end
  end
end

--- @param stop_on_first boolean
function M:solver(stop_on_first)
  local antinodes = {}

  for _, a in pairs(self.input.antennas) do
    for i = 1, #a do
      if not stop_on_first then
        antinodes[a[i]:string()] = true
      end

      for j = 1, #a do
        if i ~= j then
          local diff = a[i] - a[j]
          local pos = a[i]

          while true do
            pos = pos + diff

            if pos.x >= 1 and pos.x <= self.input.height and pos.y >= 1 and pos.y <= self.input.width then
              antinodes[pos:string()] = true
            else
              break
            end

            if stop_on_first then
              break
            end
          end
        end
      end
    end
  end

  return table.count(antinodes)
end

function M:solve1()
  return self:solver(true)
end

function M:solve2()
  return self:solver(false)
end

M:run()
