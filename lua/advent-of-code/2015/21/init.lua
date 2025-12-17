--- @class AOCDay201521: AOCDay
--- @field input { shop: table, player: table, boss: table }
local M = require("advent-of-code.AOCDay"):new("2015", "21")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    shop = {
      weapon = {
        [8] = 4,
        [10] = 5,
        [25] = 6,
        [40] = 7,
        [74] = 8,
      },
      armor = {
        [13] = 1,
        [31] = 2,
        [53] = 3,
        [75] = 4,
        [102] = 5,
      },
      rings = {
        [25] = { damage = 1, armor = 0 },
        [50] = { damage = 2, armor = 0 },
        [100] = { damage = 3, armor = 0 },
        [20] = { damage = 0, armor = 1 },
        [40] = { damage = 0, armor = 2 },
        [80] = { damage = 0, armor = 3 },
      },
    },
    boss = {
      hp = 0,
      damage = 0,
      armor = 0,
    },
  }

  self.input.boss.hp = lines[1]:only_ints()[1]
  self.input.boss.damage = lines[2]:only_ints()[1]
  self.input.boss.armor = lines[3]:only_ints()[1]
end

function M:solver(player_should_win)
  return treesearch {
    start = {
      hp = 100,
      cost = 0,
    },
    bound = player_should_win and math.huge or -math.huge,
    depth = true,
    exit = function(current)
      return current.damage and current.armor and current.rings
    end,
    step = function(current)
      local steps = {}

      if current.damage == nil then
        for cost, damage in spairs(self.input.shop.weapon) do
          local n = table.deepcopy(current)
          n.damage = damage
          n.cost = cost
          table.insert(steps, n)
        end
      elseif current.armor == nil then
        local n = table.deepcopy(current)
        n.armor = 0
        table.insert(steps, n)

        for cost, armor in spairs(self.input.shop.armor) do
          n = table.deepcopy(current)
          n.armor = armor
          n.cost = n.cost + cost
          table.insert(steps, n)
        end
      elseif current.rings == nil then
        local n = table.deepcopy(current)
        n.rings = {}
        table.insert(steps, n)

        for cost, ring in spairs(self.input.shop.rings) do
          local k = table.deepcopy(current)
          k.rings = 1
          k.damage = k.damage + ring.damage
          k.armor = k.armor + ring.armor
          k.cost = k.cost + cost
          table.insert(steps, k)

          for cost2, ring2 in spairs(self.input.shop.rings) do
            if cost < cost2 then
              local l = table.deepcopy(current)
              l.rings = 2
              l.damage = l.damage + ring.damage + ring2.damage
              l.armor = l.armor + ring.armor + ring2.armor
              l.cost = l.cost + cost + cost2
              table.insert(steps, l)
            end
          end
        end
      end

      return steps
    end,
    compare = function(solution, current)
      local a, b = current, table.deepcopy(self.input.boss)
      local i = 0

      while a.hp > 0 do
        b.hp = b.hp - math.max(1, a.damage - b.armor)
        a, b = b, a
        i = i + 1
      end

      if i % 2 == (player_should_win and 1 or 0) then
        return (player_should_win and math.min or math.max)(solution, current.cost)
      else
        return solution
      end
    end,
  }
end

function M:solve1()
  return self:solver(true)
end

function M:solve2()
  return self:solver(false)
end

M:run()
