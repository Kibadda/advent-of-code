--- @class AOCDay201815: AOCDay
--- @field input { units: { hp: integer, pos: Vector, type: "G"|"E" }[], cave: string[][] }
local M = require("advent-of-code.AOCDay"):new("2018", "15")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    units = {},
    cave = {},
  }

  for i, line in ipairs(lines) do
    self.input.cave[i] = {}

    for j, c in ipairs(line:to_list()) do
      if c == "E" or c == "G" then
        table.insert(self.input.units, {
          hp = 200,
          pos = V(i, j),
          type = c,
        })
      end

      self.input.cave[i][j] = c
    end
  end
end

function M:solver(attack_power, stop_on_elf_death)
  local rounds = 0

  local input = table.deepcopy(self.input)

  for _ = 1, math.huge do
    table.sort(input.units, function(a, b)
      if a.pos.x == b.pos.x then
        return a.pos.y < b.pos.y
      end

      return a.pos.x < b.pos.x
    end)

    local j = 1
    while j <= #input.units do
      local unit = input.units[j]

      local targets = table.filter(input.units, function(u)
        return u.type ~= unit.type
      end)

      if #targets == 0 then
        return rounds * table.reduce(input.units, 0, function(sum, u)
          return sum + u.hp
        end)
      end

      --- @type { hp: integer, pos: Vector, type: "G"|"E" }?
      local can_attack = table.reduce(targets, nil, function(enemy, target)
        if target.pos:distance(unit.pos) ~= 1 then
          return enemy
        end

        if not enemy then
          return target
        end

        if target.hp < enemy.hp then
          return target
        end

        if target.hp == enemy.hp then
          if
            (target.pos.x ~= enemy.pos.x and target.pos.x < enemy.pos.x)
            or (target.pos.x == enemy.pos.x and target.pos.y < enemy.pos.y)
          then
            enemy = target
          end
        end

        return enemy
      end)

      if not can_attack then
        --- @type Vector[]
        local possible_positions = table.reduce(targets, {}, function(positions, target)
          return table.extend(
            positions,
            table.filter(target.pos:adjacent(4), function(position)
              return input.cave[position.x][position.y] == "."
            end)
          )
        end)

        --- @type { steps: integer, pos: Vector }[]
        local reachable_positions = table.values(table.map(possible_positions, function(position)
          return treesearch {
            start = { pos = unit.pos, steps = 0 },
            depth = false,
            exit = function(current)
              return current.pos == position
            end,
            step = function(current)
              return table.map(
                table.filter(current.pos:adjacent(4), function(pos)
                  return input.cave[pos.x][pos.y] == "."
                end),
                function(pos)
                  return { steps = current.steps + 1, pos = pos }
                end
              )
            end,
            memoize = function(current)
              return current.pos:string()
            end,
          }
        end))

        --- @type { pos: Vector, steps: integer }?
        local nearest_position = table.reduce(
          reachable_positions,
          { steps = math.huge, pos = nil },
          function(n, position)
            if position.steps < n.steps then
              return position
            end

            if position.steps == n.steps then
              if
                (position.pos.x ~= n.pos.x and position.pos.x < n.pos.x)
                or (position.pos.x == n.pos.x and position.pos.y < n.pos.y)
              then
                n = position
              end
            end

            return n
          end
        )

        if nearest_position and nearest_position.pos then
          local start_hash = {}
          local starts = {}
          local distance_hash = {}

          treesearch {
            start = { pos = unit.pos, steps = 0, path = {}, start = nil },
            depth = true,
            compare = function() end,
            exit = function(current)
              if current.pos == nearest_position.pos then
                start_hash[current.start:string()] = true
                table.insert(starts, current.start)

                return true
              end

              return false
            end,
            step = function(current)
              if
                (current.start and start_hash[current.start:string()])
                or (distance_hash[current.pos:string()] and distance_hash[current.pos:string()] < current.steps)
                or current.steps >= nearest_position.steps
                or current.pos:distance(nearest_position.pos) + current.steps > nearest_position.steps
              then
                return {}
              end

              distance_hash[current.pos:string()] = current.steps

              return table.map(
                table.filter(current.pos:adjacent(4), function(pos)
                  return input.cave[pos.x][pos.y] == "."
                end),
                function(pos)
                  return {
                    steps = current.steps + 1,
                    pos = pos,
                    path = table.extend(current.path, { pos }),
                    start = current.start or pos,
                  }
                end
              )
            end,
          }

          local next_step = table.reduce(starts, nil, function(ns, start)
            if not ns then
              return start
            end

            if (start.x ~= ns.x and start.x < ns.x) or (start.x == ns.x and start.y < ns.y) then
              return start
            end

            return ns
          end)

          if next_step then
            input.cave[unit.pos.x][unit.pos.y] = "."
            unit.pos = next_step
            input.cave[unit.pos.x][unit.pos.y] = unit.type
          end
        end
      end

      --- @type { hp: integer, pos: Vector, type: "G"|"E" }?
      can_attack = table.reduce(targets, nil, function(enemy, target)
        if target.pos:distance(unit.pos) ~= 1 then
          return enemy
        end

        if not enemy then
          return target
        end

        if target.hp < enemy.hp then
          return target
        end

        if target.hp == enemy.hp then
          if
            (target.pos.x ~= enemy.pos.x and target.pos.x < enemy.pos.x)
            or (target.pos.x == enemy.pos.x and target.pos.y < enemy.pos.y)
          then
            enemy = target
          end
        end

        return enemy
      end)

      if can_attack then
        for k, enemy in ipairs(input.units) do
          if enemy.pos == can_attack.pos then
            enemy.hp = enemy.hp - (enemy.type == "E" and 3 or attack_power)
            if enemy.hp <= 0 then
              if enemy.type == "E" and stop_on_elf_death then
                return false
              end

              table.remove(input.units, k)
              input.cave[enemy.pos.x][enemy.pos.y] = "."
              if k <= j then
                j = j - 1
              end
            end
            break
          end
        end
      end

      j = j + 1
    end

    rounds = rounds + 1
  end
end

function M:solve1()
  return self:solver(3)
end

function M:solve2()
  for i = 4, math.huge do
    local result = self:solver(i, true)

    if result then
      return result
    end
  end
end

M:run()
