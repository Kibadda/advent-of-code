local AOC = require "advent-of-code.AOC"
AOC.reload()

---@alias instruction { cmd: string, lhs: string|integer, rhs?: string|integer }

---@class AOCDay201718: AOCDay
---@field input instruction[]
local M = AOC.create("2017", "18")

---@param file file*
function M:parse(file)
  for line in file:lines() do
    local split = line:split()
    self.input[#self.input + 1] = match(split[1]) {
      [{ "set", "add", "mul", "mod", "jgz" }] = {
        cmd = split[1],
        lhs = tonumber(split[2]) or split[2],
        rhs = tonumber(split[3]) or split[3],
      },
      [{ "snd", "rcv" }] = {
        cmd = split[1],
        lhs = tonumber(split[2]) or split[2],
      },
    }
  end
end

---@class Program
---@field identifier integer
---@field registers table<string, integer>
---@field pointer integer
---@field queue integer[]
---@field waiting boolean
---@field snd fun(self: Program, instruction: instruction)
---@field rcv fun(self: Program, instruction: instruction)
local Program = {
  ---@param self Program
  ---@param initial Program
  ---@return Program
  new = function(self, initial)
    return setmetatable(initial, {
      __index = self,
    })
  end,
  ---@param self Program
  ---@param value string|integer
  ---@return integer
  evaluate = function(self, value)
    if type(value) == "number" then
      return value
    end

    if not self.registers[value] then
      self.registers[value] = 0
    end

    return self.registers[value]
  end,
  ---@param self Program
  ---@param instructions instruction[]
  advance = function(self, instructions)
    local instruction = instructions[self.pointer]

    if instruction == nil then
      return false
    end

    self[instruction.cmd](self, instruction)

    return true
  end,
  ---@param self Program
  ---@return boolean
  running = function(self)
    return not self.waiting or #self.queue > 0
  end,
  ---@param self Program
  ---@param instruction instruction
  set = function(self, instruction)
    self.registers[instruction.lhs] = self:evaluate(instruction.rhs)
    self.pointer = self.pointer + 1
  end,
  ---@param self Program
  ---@param instruction instruction
  add = function(self, instruction)
    self.registers[instruction.lhs] = self:evaluate(instruction.lhs) + self:evaluate(instruction.rhs)
    self.pointer = self.pointer + 1
  end,
  ---@param self Program
  ---@param instruction instruction
  mul = function(self, instruction)
    self.registers[instruction.lhs] = self:evaluate(instruction.lhs) * self:evaluate(instruction.rhs)
    self.pointer = self.pointer + 1
  end,
  ---@param self Program
  ---@param instruction instruction
  mod = function(self, instruction)
    self.registers[instruction.lhs] = self:evaluate(instruction.lhs) % self:evaluate(instruction.rhs)
    self.pointer = self.pointer + 1
  end,
  ---@param self Program
  ---@param instruction instruction
  jgz = function(self, instruction)
    if self:evaluate(instruction.lhs) > 0 then
      self.pointer = self.pointer + self:evaluate(instruction.rhs)
    else
      self.pointer = self.pointer + 1
    end
  end,
}

function M:solve1()
  local sound
  local stop = false

  local program = Program:new {
    registers = {},
    pointer = 1,
    ---@param pro Program
    ---@param instruction instruction
    snd = function(pro, instruction)
      sound = pro:evaluate(instruction.lhs)
      pro.pointer = pro.pointer + 1
    end,
    ---@param pro Program
    ---@param instruction instruction
    rcv = function(pro, instruction)
      if pro:evaluate(instruction.lhs) ~= 0 then
        stop = true
      end
      pro.pointer = pro.pointer + 1
    end,
    identifier = 1,
    queue = {},
    waiting = false,
  }

  while not stop do
    if not program:advance(self.input) then
      return
    end
  end

  return sound
end

function M:solve2()
  ---@type Program, Program
  local p0, p1

  ---@param pro Program
  ---@param instruction instruction
  local function rcv(pro, instruction)
    if #pro.queue == 0 then
      pro.waiting = true
    else
      pro.registers[instruction.lhs] = table.remove(pro.queue, 1)
      pro.waiting = false
      pro.pointer = pro.pointer + 1
    end
  end

  local sent = 0

  p0 = Program:new {
    identifier = 0,
    pointer = 1,
    registers = { p = 0 },
    waiting = false,
    queue = {},
    ---@param pro Program
    ---@param instruction instruction
    snd = function(pro, instruction)
      table.insert(p1.queue, pro:evaluate(instruction.lhs))
      pro.pointer = pro.pointer + 1
    end,
    rcv = rcv,
  }

  p1 = Program:new {
    identifier = 1,
    pointer = 1,
    registers = { p = 1 },
    waiting = false,
    queue = {},
    ---@param pro Program
    ---@param instruction instruction
    snd = function(pro, instruction)
      sent = sent + 1

      table.insert(p0.queue, pro:evaluate(instruction.lhs))
      pro.pointer = pro.pointer + 1
    end,
    rcv = rcv,
  }

  while p0:running() or p1:running() do
    if not p0:advance(self.input) then
      return
    end
    if not p1:advance(self.input) then
      return
    end
  end

  return sent
end

M:run()

return M
