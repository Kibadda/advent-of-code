--- @class AOCDay202004: AOCDay
--- @field input { [string]: string }[]
local M = require("advent-of-code.AOCDay"):new("2020", "04")

--- @param lines string[]
function M:parse(lines)
  local passport = {}

  for _, line in ipairs(lines) do
    if line == "" then
      table.insert(self.input, passport)
      passport = {}
    else
      for _, feat in ipairs(line:split()) do
        local s = feat:split ":"
        passport[s[1]] = s[2]
      end
    end
  end

  table.insert(self.input, passport)
end

--- @param checker fun(passport: table): boolean
function M:solver(checker)
  return table.reduce(self.input, 0, function(valid, passport)
    if checker(passport) then
      return valid + 1
    end

    return valid
  end)
end

function M:solve1()
  return self:solver(function(passport)
    return table.count(passport) == 8 or (table.count(passport) == 7 and passport.cid == nil)
  end)
end

function M:solve2()
  return self:solver(function(passport)
    if not passport.byr or tonumber(passport.byr) < 1920 or tonumber(passport.byr) > 2002 then
      return false
    end

    if not passport.iyr or tonumber(passport.iyr) < 2010 or tonumber(passport.iyr) > 2020 then
      return false
    end

    if not passport.eyr or tonumber(passport.eyr) < 2020 or tonumber(passport.eyr) > 2030 then
      return false
    end

    if not passport.hgt then
      return false
    else
      local height, unit = passport.hgt:match "^([%d]+)(.*)$"
      height = tonumber(height)

      if
        (unit ~= "cm" and unit ~= "in")
        or (unit == "cm" and (height < 150 or height > 193))
        or (unit == "in" and (height < 59 or height > 76))
      then
        return false
      end
    end

    if not passport.hcl then
      return false
    else
      local m = passport.hcl:match "^#([0-9a-f]*)$"

      if not m or #m ~= 6 then
        return false
      end
    end

    if not passport.ecl or not table.contains({ "amb", "brn", "blu", "gry", "grn", "hzl", "oth" }, passport.ecl) then
      return false
    end

    if not passport.pid then
      return false
    else
      local m = passport.pid:match "^([0-9]*)$"

      if not m or #m ~= 9 then
        return false
      end
    end

    return true
  end)
end

M:run()
