--- @class AOCDay201824: AOCDay
--- @field input AOCDay201824Data[]
local M = require("advent-of-code.AOCDay"):new("2018", "24")

--- @class AOCDay201824Data
--- @field id integer
--- @field hp integer
--- @field units integer
--- @field initiative integer
--- @field type "immune"|"infection"
--- @field damage integer
--- @field damage_type string
--- @field immunities table<string, boolean>
--- @field weaknesses table<string, boolean>

--- @param lines string[]
function M:parse(lines)
  self.input = {}

  local type = "immune"
  for _, line in ipairs(lines) do
    if line == "" then
      type = "infection"
    elseif line:find "^%d" then
      local split = line:split()
      local ints = line:only_ints()

      --- @type string
      local immunities_string = (line:match "immune to ([^;%)]*)") or ""
      --- @type string
      local weaknesses_string = (line:match "weak to ([^;%)]*)") or ""

      table.insert(self.input, {
        id = #self.input + 1,
        hp = ints[2],
        units = ints[1],
        damage = ints[3],
        damage_type = split[#split - 4],
        type = type,
        initiative = ints[4],
        immunities = table.reduce(immunities_string:split ", ", {}, function(immunities, immunity)
          immunities[immunity] = true
          return immunities
        end),
        weaknesses = table.reduce(weaknesses_string:split ", ", {}, function(weaknesses, weakness)
          weaknesses[weakness] = true
          return weaknesses
        end),
      })
    end
  end
end

--- @param attacker AOCDay201824Data
--- @param defender AOCDay201824Data
local function calculate_damage(attacker, defender)
  if defender.immunities[attacker.damage_type] then
    return 0
  end

  local damage = attacker.damage * attacker.units

  if defender.weaknesses[attacker.damage_type] then
    return damage * 2
  end

  return damage
end

function M:solver(boost)
  local groups = table.deepcopy(self.input)

  -- ADD BOOST
  boost = boost or 0

  for _, group in ipairs(groups) do
    if group.type == "immune" then
      group.damage = group.damage + boost
    end
  end
  -------------------------------------------

  local last_fight_result

  while true do
    -- SORT GROUPS FOR SELECTION PHASE
    table.sort(groups, function(a, b)
      local a_effp = a.units * a.damage
      local b_effp = b.units * b.damage

      if a_effp == b_effp then
        return a.initiative > b.initiative
      end

      return a_effp > b_effp
    end)
    -------------------------------------------

    -- CHOOSE ATTACKS
    local defs = {}
    local attacks = {}

    for _, attacker in ipairs(groups) do
      local defenders = table.filter(groups, function(group)
        return group.type ~= attacker.type and not defs[group.id]
      end)

      if #defenders > 0 then
        table.sort(defenders, function(a, b)
          local a_rec = calculate_damage(attacker, a)
          local b_rec = calculate_damage(attacker, b)

          if a_rec == b_rec then
            local a_effp = a.units * a.damage
            local b_effp = b.units * b.damage

            if a_effp == b_effp then
              return a.initiative > b.initiative
            end

            return a_effp > b_effp
          end

          return a_rec > b_rec
        end)

        if calculate_damage(attacker, defenders[1]) > 0 then
          attacks[attacker.id] = defenders[1].id
          defs[defenders[1].id] = true
        end
      end
    end
    -------------------------------------------

    -- SORT GROUPS FOR ATTACKING PHASE
    table.sort(groups, function(a, b)
      return a.initiative > b.initiative
    end)
    -------------------------------------------

    -- DO ATTACKS
    for _, group in ipairs(groups) do
      if group.units > 0 and attacks[group.id] then
        local defender = groups[table.find(groups, { id = attacks[group.id] }, { "id" })]

        if defender then
          local killed = math.floor(calculate_damage(group, defender) / defender.hp)
          defender.units = defender.units - killed
        end
      end
    end
    -------------------------------------------

    -- REMOVE ANY GROUP WITH NO UNITS
    groups = table.filter(groups, function(group)
      return group.units > 0
    end)
    -------------------------------------------

    -- CHECK IF GROUPS OF ONE TYPE REMAIN
    if
      table.reduce(groups, { done = true, type = nil }, function(carry, group)
        if not carry.type then
          carry.type = group.type
          return carry
        end

        if carry.type ~= group.type then
          carry.done = false
          return carry
        end

        return carry
      end).done
    then
      break
    end
    -------------------------------------------

    -- CHECK IF ANYTHING CHANGED THIS ROUND
    table.sort(groups, function(a, b)
      return a.id < b.id
    end)

    local hash = table.concat(
      table.reduce(groups, {}, function(carry, group)
        table.insert(carry, ("%s-%s"):format(group.id, group.units))
        return carry
      end),
      "|"
    )

    if hash == last_fight_result then
      break
    end

    last_fight_result = hash
    -------------------------------------------
  end

  return groups
end

function M:solve1()
  return table.reduce(self:solver(), 0, function(units, group)
    return units + group.units
  end)
end

function M:solve2()
  for i = 1, math.huge do
    local result = table.reduce(self:solver(i), { units = 0, win = true }, function(carry, group)
      if group.type == "infection" then
        return { units = 0, win = false }
      end

      if not carry.win then
        return carry
      end

      return { units = carry.units + group.units, win = true }
    end)

    if result.win then
      return result.units
    end
  end
end

M:run()
