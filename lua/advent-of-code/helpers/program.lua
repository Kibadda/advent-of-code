--- @alias ProgramOperations table<string, fun(self: Program, table)>
--- @alias ProgramHooks { pre?: (fun(self: Program): boolean?), post?: (fun(self: Program): boolean?) }
--- @alias ProgramDebug fun(self: Program): boolean

--- @class Program
--- @field pointer integer
--- @field registers table
--- @field operations ProgramOperations
--- @field hooks ProgramHooks
--- @field debug ProgramDebug
--- @field run fun(self: Program, instructions: table[]): table
--- @field new fun(self: Program, registers: table, operations: ProgramOperations, hooks: ProgramHooks, debug: ProgramDebug): Program
local Program = {}

Program = {
  pointer = 1,
  registers = {},
  operations = {},
  hooks = {},
  debug = function()
    return false
  end,
  --- @param self Program
  --- @param registers table
  --- @param operations ProgramOperations
  --- @param hooks ProgramHooks
  --- @param debug ProgramDebug
  --- @return Program
  new = function(self, registers, operations, hooks, debug)
    return setmetatable({
      pointer = 1,
      registers = registers,
      operations = operations,
      hooks = hooks,
      debug = debug,
    }, { __index = self })
  end,
  --- @param self Program
  --- @param instructions table[]
  --- @return table
  run = function(self, instructions)
    if self.debug and self.debug(self) then
      print(self.pointer, table.concat(self.registers, ", "))
    end

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
        if self.hooks.pre(self) then
          break
        end
      end

      operation(self, instruction)

      if self.hooks.post then
        if self.hooks.post(self) then
          break
        end
      end

      self.pointer = self.pointer + 1

      if self.debug and self.debug(self) then
        print(self.pointer, table.concat(self.registers, ", "))
      end
    end

    return self.registers
  end,
}

--- @param parameters { registers: table, operations: ProgramOperations, hooks: ProgramHooks, debug: ProgramDebug, instructions: table[] }
function _G.Program(parameters)
  return Program:new(parameters.registers, parameters.operations, parameters.hooks, parameters.debug)
    :run(parameters.instructions)
end
