--- @class AOCDay201725: AOCDay
--- @field input { state: string, checksum: number, states: table, tape: number[], index: number }
local M = require("advent-of-code.AOCDay"):new("2017", "25")

--- @param lines string[]
function M:parse(lines)
  local parsing_states = false

  local index, value
  local state = {}
  for _, line in ipairs(lines) do
    --- @cast line string
    if parsing_states then
      if line == "" then
        self.input.states[value] = state
        state = {}
      elseif line:find "In state" then
        value = line:at(#line - 1)
      elseif line:find "If the current value" then
        index = line:only_ints()[1]
        state[index] = {}
      elseif line:find "value" then
        state[index].value = line:only_ints()[1]
      elseif line:find "slot" then
        state[index].slot = line:find "left" and -1 or 1
      elseif line:find "state" then
        state[index].state = assert(line:at(#line - 1))
      end
    else
      if line == "" then
        parsing_states = true
        self.input.states = {}
      elseif not self.input.state then
        self.input.state = assert(line:at(#line - 1))
      else
        self.input.checksum = line:only_ints()[1]
      end
    end
  end

  self.input.states[assert(value)] = state
  self.input.tape = { 0 }
  self.input.index = 1
end

function M:solve1()
  for _ = 1, self.input.checksum do
    local current = self.input.tape[self.input.index] or 0
    local state = self.input.states[self.input.state]

    self.input.tape[self.input.index] = state[current].value
    self.input.index = self.input.index + state[current].slot
    self.input.state = state[current].state
  end

  return table.sum(self.input.tape, pairs)
end

function M:solve2() end

M:run()
