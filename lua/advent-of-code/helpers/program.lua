--- @alias ProgramOperations table<string, fun(self: Program, table)>
--- @alias ProgramHooks { pre?: fun(self: Program), post?: fun(self: Program) }

--- @class Program
--- @field pointer integer
--- @field registers table
--- @field operations ProgramOperations
--- @field hooks ProgramHooks
--- @field run fun(self: Program, instructions: table[]): table
--- @field new fun(self: Program, registers: table, operations: ProgramOperations, hooks: ProgramHooks): Program
local Program = {}

Program = {
  pointer = 1,
  registers = {},
  operations = {},
  hooks = {},
  --- @param self Program
  --- @param registers table
  --- @param operations ProgramOperations
  --- @param hooks ProgramHooks
  --- @return Program
  new = function(self, registers, operations, hooks)
    return setmetatable({
      pointer = 1,
      registers = registers,
      operations = operations,
      hooks = hooks,
    }, { __index = self })
  end,
  --- @param self Program
  --- @param instructions table[]
  --- @return table
  run = function(self, instructions)
    print(self.pointer, table.concat(self.registers, ", "))
    while true do
      local instruction = instructions[self.pointer]

      if not instruction then
        break
      end

      local operation = self.operations[instruction[1]]

      if not operation then
        break
      end

      if self.hooks.pre then
        self.hooks.pre(self)
      end

      operation(self, instruction)

      if self.hooks.post then
        self.hooks.post(self)
      end

      self.pointer = self.pointer + 1
      print(self.pointer, table.concat(self.registers, ", "))
    end

    return self.registers
  end,
}

--- @param parameters { registers: table, operations: ProgramOperations, hooks: ProgramHooks, instructions: table[] }
function _G.Program(parameters)
  return Program:new(parameters.registers, parameters.operations, parameters.hooks):run(parameters.instructions)
end
