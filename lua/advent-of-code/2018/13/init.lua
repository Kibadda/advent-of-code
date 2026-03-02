--- @alias AOCDay201813Data { turns: integer, pos: Vector, dir: Vector }

--- @class AOCDay201813: AOCDay
--- @field input { carts: AOCDay201813Data[], paths: string[][] }
local M = require("advent-of-code.AOCDay"):new("2018", "13")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    paths = {},
    carts = {},
  }

  for i, line in ipairs(lines) do
    self.input.paths[i] = {}
    for j, c in ipairs(line:to_list()) do
      if c == ">" or c == "<" or c == "^" or c == "v" then
        table.insert(self.input.carts, {
          turns = 0,
          pos = V(i, j),
          dir = match(c) {
            [">"] = V(0, 1),
            ["<"] = V(0, -1),
            ["^"] = V(-1, 0),
            ["v"] = V(1, 0),
          },
        })

        if c == ">" or c == "<" then
          self.input.paths[i][j] = "-"
        else
          self.input.paths[i][j] = "|"
        end
      else
        self.input.paths[i][j] = c
      end
    end
  end
end

--- @param carts AOCDay201813Data[]
--- @return Vector
function M:solver(carts)
  while true do
    table.sort(carts, function(a, b)
      if a.pos.x == b.pos.x then
        return a.pos.y < b.pos.y
      end

      return a.pos.x < b.pos.x
    end)

    local crashes = {}

    for i, cart in ipairs(carts) do
      cart.pos = cart.pos + cart.dir

      for j, other in ipairs(carts) do
        if i ~= j and cart.pos == other.pos then
          table.insert(crashes, { i, j })
        end
      end

      match(self.input.paths[cart.pos.x][cart.pos.y]) {
        ["/"] = function()
          if cart.dir.x == 0 then
            cart.dir = cart.dir * "L"
          else
            cart.dir = cart.dir * "R"
          end
        end,
        ["\\"] = function()
          if cart.dir.x == 0 then
            cart.dir = cart.dir * "R"
          else
            cart.dir = cart.dir * "L"
          end
        end,
        ["+"] = function()
          cart.dir = cart.dir * ({ "L", 1, "R" })[cart.turns % 3 + 1]
          cart.turns = cart.turns + 1
        end,
      }
    end

    if #crashes > 0 then
      return crashes
    end
  end
end

function M:solve1()
  local carts = table.deepcopy(self.input.carts)
  local crashes = self:solver(carts)
  local cart = carts[crashes[1][1]]
  return ("%s,%s"):format(cart.pos.y - 1, cart.pos.x - 1)
end

function M:solve2()
  while #self.input.carts > 1 do
    local crashes = self:solver(self.input.carts)
    for _, crash in ipairs(crashes) do
      self.input.carts[crash[1]] = nil
      self.input.carts[crash[2]] = nil
    end

    self.input.carts = table.values(self.input.carts)
  end

  return ("%s,%s"):format(self.input.carts[1].pos.y - 1, self.input.carts[1].pos.x - 1)
end

M:run()
