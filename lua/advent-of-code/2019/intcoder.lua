--- @alias IntcoderOpcodes { parameters: integer, func: fun(self: Intcoder, parameters: integer[], modes: 0|1|2[]): IntcoderOpcodesReturnCode? }
--- @alias IntcoderInputHook (fun(self: Intcoder): string[]|integer[])
--- @alias IntcoderOutputHook fun(output: integer, self: Intcoder)
--- @alias IntcoderRunConfig { ascii?: boolean, program?: table<integer, integer>, data?: table, print?: boolean }

--- @enum IntcoderExitStatus
local exit_statuses = {
  OK = 0,
  OPCODE_NOT_FOUND = 1,
  BREAK = 2,
  ERROR = 4,
}

--- @enum IntcoderOpcodesReturnCode
local return_codes = {
  OK = 0,
  JUMP = 1,
  BREAK = 2,
  ERROR = 4,
}

--- @class Intcoder
--- @field pointer integer
--- @field program integer[]
--- @field opcodes table<integer, IntcoderOpcodes>
--- @field output table
--- @field input table
--- @field base integer
--- @field data table
--- @field hooks { input: IntcoderInputHook, output: IntcoderOutputHook }
--- @field ascii boolean
--- @field print boolean
--- @field exit IntcoderExitStatus
--- @field new fun(program: string): Intcoder
--- @field get fun(self: Intcoder, parameter: integer, mode: 0|1|2): integer
--- @field on_output fun(self: Intcoder, func: IntcoderOutputHook): Intcoder
--- @field on_input fun(self: Intcoder, func: IntcoderInputHook): Intcoder
--- @field run fun(self: Intcoder, config?: IntcoderRunConfig): Intcoder
local Intcoder = {}

local output_buffer = ""

--- @type table<integer, IntcoderOpcodes>
local OPCODES = {
  [1] = {
    parameters = 3,
    func = function(self, parameters, modes)
      self.program[parameters[3] + 1 + (modes[3] == 2 and self.base or 0)] = self:get(parameters[1], modes[1])
        + self:get(parameters[2], modes[2])
    end,
  },
  [2] = {
    parameters = 3,
    func = function(self, parameters, modes)
      self.program[parameters[3] + 1 + (modes[3] == 2 and self.base or 0)] = self:get(parameters[1], modes[1])
        * self:get(parameters[2], modes[2])
    end,
  },
  [3] = {
    parameters = 1,
    func = function(self, parameters, modes)
      if #self.input == 0 then
        if self.hooks.input then
          local input = self.hooks.input(self)

          if self.ascii then
            for _, str in ipairs(input) do
              --- @cast str string
              for _, char in ipairs(str:to_list()) do
                table.insert(self.input, string.byte(char))
              end
              table.insert(self.input, 10)
            end
          else
            for _, num in ipairs(input) do
              table.insert(self.input, num)
            end
          end
        end
      end

      local number = table.remove(self.input, 1)

      if not number or type(number) ~= "number" then
        return return_codes.ERROR
      end

      self.program[parameters[1] + 1 + (modes[1] == 2 and self.base or 0)] = number
    end,
  },
  [4] = {
    parameters = 1,
    func = function(self, parameters, modes)
      local p = self:get(parameters[1], modes[1])
      table.insert(self.output, p)

      if self.hooks.output then
        self.hooks.output(p, self)
      end

      if self.print and p <= 127 then
        if p == 10 then
          print(output_buffer)
          output_buffer = ""
        else
          output_buffer = output_buffer .. string.char(p)
        end
      end
    end,
  },
  [5] = {
    parameters = 2,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) ~= 0 then
        self.pointer = self:get(parameters[2], modes[2]) + 1

        return return_codes.JUMP
      end
    end,
  },
  [6] = {
    parameters = 2,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) == 0 then
        self.pointer = self:get(parameters[2], modes[2]) + 1

        return return_codes.JUMP
      end
    end,
  },
  [7] = {
    parameters = 3,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) < self:get(parameters[2], modes[2]) then
        self.program[parameters[3] + 1 + (modes[3] == 2 and self.base or 0)] = 1
      else
        self.program[parameters[3] + 1 + (modes[3] == 2 and self.base or 0)] = 0
      end
    end,
  },
  [8] = {
    parameters = 3,
    func = function(self, parameters, modes)
      if self:get(parameters[1], modes[1]) == self:get(parameters[2], modes[2]) then
        self.program[parameters[3] + 1 + (modes[3] == 2 and self.base or 0)] = 1
      else
        self.program[parameters[3] + 1 + (modes[3] == 2 and self.base or 0)] = 0
      end
    end,
  },
  [9] = {
    parameters = 1,
    func = function(self, parameters, modes)
      self.base = self.base + self:get(parameters[1], modes[1])
    end,
  },
}

--- @type Intcoder
Intcoder = {
  pointer = 1,
  program = {},
  opcodes = {},
  output = {},
  input = {},
  base = 0,
  data = {},
  hooks = {},
  ascii = false,
  print = false,
  exit = exit_statuses.OK,
  new = function(program)
    return setmetatable({
      pointer = 1,
      program = program:only_ints "-?%d+",
      opcodes = table.deepcopy(OPCODES),
      output = {},
      input = {},
      base = 0,
      data = {},
      hooks = {},
      ascii = false,
      print = false,
      exit = exit_statuses.OK,
    }, { __index = Intcoder })
  end,
  get = function(self, parameter, mode)
    if mode == 0 then
      return (self.program[parameter + 1] or 0)
    elseif mode == 1 then
      return parameter
    else
      return (self.program[parameter + 1 + self.base] or 0)
    end
  end,
  on_output = function(self, func)
    self.hooks.output = func

    return self
  end,
  on_input = function(self, func)
    self.hooks.input = func

    return self
  end,
  run = function(self, config)
    config = config or {}
    self.ascii = config.ascii
    self.print = config.print

    if config.data then
      for k, v in pairs(config.data) do
        self.data[k] = v
      end
    end

    if config.program then
      for k, v in pairs(config.program) do
        self.program[k] = v
      end
    end

    while true do
      local opcode = self.program[self.pointer]
      local modes = {
        math.floor(opcode / 100) % 10,
        math.floor(opcode / 1000) % 10,
        math.floor(opcode / 10000) % 10,
      }
      opcode = opcode % 100

      if opcode == 99 then
        self.exit = exit_statuses.OK
        break
      end

      if not opcode or not self.opcodes[opcode] then
        self.exit = exit_statuses.OPCODE_NOT_FOUND
        break
      end

      local opc = self.opcodes[opcode]
      local parameters = {}
      for i = 1, opc.parameters do
        table.insert(parameters, self.program[self.pointer + i])
      end

      local result = opc.func(self, parameters, modes)

      if not result or result == return_codes.OK then
        self.pointer = self.pointer + opc.parameters + 1
      elseif result == return_codes.BREAK then
        self.exit = exit_statuses.BREAK
        break
      elseif result == return_codes.ERROR then
        self.exit = exit_statuses.ERROR
        break
      end
    end

    return self
  end,
}

_G.IntcoderOpcodesReturnCode = return_codes
_G.IntcoderExitStatus = exit_statuses

--- @param program string
function _G.Intcoder(program)
  return Intcoder.new(program)
end
