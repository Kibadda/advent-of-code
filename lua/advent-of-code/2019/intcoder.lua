--- @alias IntcoderOpcodes { parameters: integer, func: fun(self: Intcoder, parameters: integer[], modes: 0|1[]): boolean? }

--- @class Intcoder
--- @field pointer integer
--- @field program integer[]
--- @field opcodes table<integer, IntcoderOpcodes>
--- @field output table
--- @field input table
--- @field new fun(program: string): Intcoder
--- @field get fun(self: Intcoder, parameter: integer, mode: 0|1): integer
--- @field active fun(self: Intcoder, opcodes: integer[]): Intcoder
--- @field setup fun(self: Intcoder, func: fun(intcoder: Intcoder)): Intcoder
--- @field run fun(self: Intcoder): Intcoder
local Intcoder = {}

--- @type table<integer, IntcoderOpcodes>
local OPCODES = {
  [1] = {
    parameters = 3,
    func = function(self, parameters, modes)
      self.program[parameters[3] + 1] = self:get(parameters[1], modes[1]) + self:get(parameters[2], modes[2])
    end,
  },
  [2] = {
    parameters = 3,
    func = function(self, parameters, modes)
      self.program[parameters[3] + 1] = self:get(parameters[1], modes[1]) * self:get(parameters[2], modes[2])
    end,
  },
  [3] = {
    parameters = 1,
    func = function(self, parameters)
      local number

      if #self.input > 0 then
        number = table.remove(self.input, 1)
      else
        print "input number: "
        number = io.read "*n"
      end

      if not number or type(number) ~= "number" then
        error "no number provided"
      end

      self.program[parameters[1] + 1] = number
    end,
  },
  [4] = {
    parameters = 1,
    func = function(self, parameters, modes)
      local p = self:get(parameters[1], modes[1])
      table.insert(self.output, p)
    end,
  },
  [5] = {
    parameters = 2,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) ~= 0 then
        self.pointer = self:get(parameters[2], modes[2]) + 1

        return true
      end
    end,
  },
  [6] = {
    parameters = 2,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) == 0 then
        self.pointer = self:get(parameters[2], modes[2]) + 1

        return true
      end
    end,
  },
  [7] = {
    parameters = 3,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) < self:get(parameters[2], modes[2]) then
        self.program[parameters[3] + 1] = 1
      else
        self.program[parameters[3] + 1] = 0
      end
    end,
  },
  [8] = {
    parameters = 3,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) == self:get(parameters[2], modes[2]) then
        self.program[parameters[3] + 1] = 1
      else
        self.program[parameters[3] + 1] = 0
      end
    end,
  },
}

--- @type Intcoder
Intcoder = {
  pointer = 1,
  program = {},
  output = {},
  input = {},
  opcodes = {},
  new = function(program)
    return setmetatable({
      pointer = 1,
      program = program:only_ints "-?%d+",
      opcodes = table.deepcopy(OPCODES),
      output = {},
      input = {},
    }, { __index = Intcoder })
  end,
  get = function(self, parameter, mode)
    return mode == 0 and self.program[parameter + 1] or parameter
  end,
  active = function(self, opcodes)
    for _, opcode in ipairs(table.keys(self.opcodes)) do
      if not table.contains(opcodes, opcode) then
        self.opcodes[opcode] = nil
      end
    end

    return self
  end,
  setup = function(self, func)
    func(self)

    return self
  end,
  run = function(self)
    while true do
      local opcode = self.program[self.pointer]
      local modes = {
        math.floor(opcode / 100) % 10,
        math.floor(opcode / 1000) % 10,
        math.floor(opcode / 10000) % 10,
      }
      opcode = opcode % 100

      if not opcode or opcode == 99 or not self.opcodes[opcode] then
        break
      end

      local opc = self.opcodes[opcode]
      local parameters = {}
      for i = 1, opc.parameters do
        table.insert(parameters, self.program[self.pointer + i])
      end

      if not opc.func(self, parameters, modes) then
        self.pointer = self.pointer + opc.parameters + 1
      end
    end

    return self
  end,
}

--- @param program string
function _G.Intcoder(program)
  return Intcoder.new(program)
end
