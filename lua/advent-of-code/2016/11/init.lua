--- @class AOCDay201611: AOCDay
--- @field input { floor: number, elements: string[], floors: { g: table<string, number>, m: table<string, number> }[], steps: number, count: number }
local M = require("advent-of-code.AOCDay"):new("2016", "11")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    floor = 1,
    floors = {},
    elements = {},
    steps = 0,
  }

  for _, line in ipairs(lines) do
    local floor = { g = {}, m = {} }
    local _, e = line:find "The.*floor contains "
    line = line
      :sub(e + 1)
      :gsub("and", ",")
      :gsub("a ", "")
      :gsub("nothing relevant", "")
      :gsub("%.", "")
      :gsub("%-compatible", "")
    for _, s in ipairs(line:split ",") do
      if s:find "generator" then
        local g = s:trim():split(" ")[1]
        floor.g[g] = 1
      elseif s:find "microchip" then
        local m = s:trim():split(" ")[1]
        floor.m[m] = 1
      end
    end
    table.insert(self.input.floors, floor)
  end
end

function M:solver(input)
  local elements = {}
  for _, floor in ipairs(input.floors) do
    for g in spairs(floor.g) do
      elements[g] = true
    end
  end

  input.elements = table.keys(elements)

  local function key(config)
    local k = {}

    for i, floor in ipairs(config.floors) do
      local f = {}

      for _, e in ipairs(input.elements) do
        if floor.m[e] and floor.g[e] then
          table.insert(f, "M")
          table.insert(f, "G")
        elseif floor.m[e] then
          table.insert(f, e .. "M")
        elseif floor.g[e] then
          table.insert(f, e .. "G")
        end
      end

      table.insert(k, i .. "-" .. table.concat(f, ":"))
    end

    return config.floor .. "+" .. table.concat(k, "|")
  end

  local function check(floors)
    for _, floor in ipairs(floors) do
      for m in pairs(floor.m) do
        if table.count(floor.g) > 0 and not floor.g[m] then
          return false
        end
      end
    end

    return true
  end

  local hash = {}

  return treesearch({
    start = input,
    depth = false,
    exit = function(current)
      return table.count(current.floors[4].g) + table.count(current.floors[4].m) == #input.elements * 2
    end,
    compare = function()
      return true
    end,
    step = function(current)
      local steps = {}

      local k = key(current)

      if hash[k] and hash[k] <= current.steps then
        return {}
      end

      hash[k] = current.steps

      local function new(opts)
        local n = table.deepcopy(current)

        for _, m in ipairs(opts.ms or {}) do
          n.floors[n.floor].m[m] = nil
        end
        for _, g in ipairs(opts.gs or {}) do
          n.floors[n.floor].g[g] = nil
        end
        n.floor = n.floor + opts.level
        for _, m in ipairs(opts.ms or {}) do
          n.floors[n.floor].m[m] = 1
        end
        for _, g in ipairs(opts.gs or {}) do
          n.floors[n.floor].g[g] = 1
        end
        n.steps = n.steps + 1

        return n
      end

      if current.floor > 1 then
        local one_down = false

        for _, e in ipairs(input.elements) do
          if current.floors[current.floor].m[e] then
            local n = new { level = -1, ms = { e } }
            if check(n.floors) then
              table.insert(steps, n)
              one_down = true
            end
          end
          if current.floors[current.floor].g[e] then
            local n = new { level = -1, gs = { e } }
            if check(n.floors) then
              table.insert(steps, n)
              one_down = true
            end
          end
        end

        if not one_down then
          for j = 1, #input.elements do
            for l = j, #input.elements do
              local e1 = input.elements[j]
              local e2 = input.elements[l]

              if e1 == e2 then
                if current.floors[current.floor].m[e1] and current.floors[current.floor].g[e2] then
                  local n = new { level = -1, ms = { e1 }, gs = { e2 } }
                  if check(n.floors) then
                    table.insert(steps, n)
                  end
                end
              else
                if current.floors[current.floor].m[e1] and current.floors[current.floor].m[e2] then
                  local n = new { level = -1, ms = { e1, e2 } }
                  if check(n.floors) then
                    table.insert(steps, n)
                  end
                elseif current.floors[current.floor].g[e1] and current.floors[current.floor].g[e2] then
                  local n = new { level = -1, gs = { e1, e2 } }
                  if check(n.floors) then
                    table.insert(steps, n)
                  end
                end
              end
            end
          end
        end
      end

      if current.floor < 4 then
        local two_up = false

        for j = 1, #input.elements do
          for l = j, #input.elements do
            local e1 = input.elements[j]
            local e2 = input.elements[l]

            if e1 == e2 then
              if current.floors[current.floor].m[e1] and current.floors[current.floor].g[e2] then
                local n = new { level = 1, ms = { e1 }, gs = { e2 } }
                if check(n.floors) then
                  table.insert(steps, n)
                  two_up = true
                end
              end
            else
              if current.floors[current.floor].m[e1] and current.floors[current.floor].m[e2] then
                local n = new { level = 1, ms = { e1, e2 } }
                if check(n.floors) then
                  table.insert(steps, n)
                  two_up = true
                end
              elseif current.floors[current.floor].g[e1] and current.floors[current.floor].g[e2] then
                local n = new { level = 1, gs = { e1, e2 } }
                if check(n.floors) then
                  table.insert(steps, n)
                  two_up = true
                end
              end
            end
          end
        end

        if not two_up then
          for _, e in ipairs(input.elements) do
            if current.floors[current.floor].m[e] then
              local n = new { level = 1, ms = { e } }
              if check(n.floors) then
                table.insert(steps, n)
              end
            end
            if current.floors[current.floor].g[e] then
              local n = new { level = 1, gs = { e } }
              if check(n.floors) then
                table.insert(steps, n)
              end
            end
          end
        end
      end

      return steps
    end,
  }).steps
end

function M:solve1()
  return self:solver(self.input)
end

function M:solve2()
  self.input.floors[1].g.elerium = 1
  self.input.floors[1].m.elerium = 1
  self.input.floors[1].g.dilithium = 1
  self.input.floors[1].m.dilithium = 1

  return self:solver(self.input)
end

M:run()
