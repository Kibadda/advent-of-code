--- @class AOCDay201522: AOCDay
--- @field input { player: table, boss: table, effects: table, spent_mana: number, turn: number }
local M = require("advent-of-code.AOCDay"):new("2015", "22")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    player = {
      hp = 50,
      mp = 500,
      armor = 0,
    },
    boss = {
      hp = 0,
      damage = 0,
    },
    effects = {},
    spent_mana = 0,
    turn = 0,
  }

  self.input.boss.hp = lines[1]:only_ints()[1]
  self.input.boss.damage = lines[2]:only_ints()[1]
end

function M:solver(hard_mode)
  if hard_mode then
    self.input.effects.hard = math.huge
  end

  return treesearch {
    start = table.deepcopy(self.input),
    bound = math.huge,
    depth = true,
    exit = function(current)
      return current.boss.hp <= 0
        or current.player.hp <= 0
        or (current.effects.poison and current.boss.hp <= 3)
        or (current.effects.hard and current.turn % 2 == 0 and current.player.hp == 1)
    end,
    step = function(current, solution)
      local steps = {}

      current.player.armor = 0

      for effect, turns in spairs(current.effects) do
        match(effect) {
          shield = function()
            current.player.armor = 7
          end,
          poison = function()
            current.boss.hp = current.boss.hp - 3
          end,
          recharge = function()
            current.player.mp = current.player.mp + 101
          end,
          hard = function()
            if current.turn % 2 == 0 then
              current.player.hp = current.player.hp - 1
            end
          end,
        }

        if turns > 1 then
          current.effects[effect] = turns - 1
        else
          current.effects[effect] = nil
        end
      end

      if current.turn % 2 == 0 then
        local spells = {
          [53] = "missile",
          [73] = "drain",
          [113] = "shield",
          [173] = "poison",
          [229] = "recharge",
        }

        for cost, spell in spairs(spells) do
          if cost <= current.player.mp and not current.effects[spell] then
            local n = table.deepcopy(current)
            n.player.mp = n.player.mp - cost
            n.spent_mana = n.spent_mana + cost
            n.turn = n.turn + 1

            match(spell) {
              missile = function()
                n.boss.hp = n.boss.hp - 4
              end,
              drain = function()
                n.boss.hp = n.boss.hp - 2
                n.player.hp = n.player.hp + 2
              end,
              shield = function()
                n.effects.shield = 6
              end,
              poison = function()
                n.effects.poison = 6
              end,
              recharge = function()
                n.effects.recharge = 5
              end,
            }

            if n.spent_mana < solution then
              table.insert(steps, n)
            end
          end
        end
      else
        local n = table.deepcopy(current)
        n.player.hp = n.player.hp - math.max(1, n.boss.damage - n.player.armor)
        n.turn = n.turn + 1
        table.insert(steps, n)
      end

      return steps
    end,
    compare = function(solution, current)
      if current.effects.hard and current.turn % 2 == 0 then
        current.player.hp = current.player.hp - 1
      end
      if current.player.hp > 0 then
        return math.min(solution, current.spent_mana)
      else
        return solution
      end
    end,
  }
end

function M:solve1()
  return self:solver(false)
end

function M:solve2()
  return self:solver(true)
end

M:run()
