--- @class AOCDay201913: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "13")

require "advent-of-code.2019.intcoder"

function M:solve1()
  local tile = {}
  local blocks = 0

  Intcoder(self.input[1]):setup(function(intcoder)
    local output_opcode = intcoder.opcodes[4].func
    intcoder.opcodes[4].func = function(...)
      output_opcode(...)

      table.insert(tile, table.remove(intcoder.output, 1))

      if #tile == 3 then
        if tile[3] == 2 then
          blocks = blocks + 1
        end
        tile = {}
      end
    end
  end):run()

  return blocks
end

function M:solve2()
  local game_data = {
    score = 0,
    paddle = 0,
    ball = 0,
    screen = {},
  }

  Intcoder(self.input[1]):setup(function(intcoder)
    intcoder.program[1] = 2

    local output_opcode = intcoder.opcodes[4].func
    intcoder.opcodes[4].func = function(...)
      output_opcode(...)

      if #intcoder.output == 3 then
        if intcoder.output[1] == -1 and intcoder.output[2] == 0 then
          game_data.score = intcoder.output[3]
        else
          game_data.screen[intcoder.output[2] + 1] = game_data.screen[intcoder.output[2] + 1] or {}
          game_data.screen[intcoder.output[2] + 1][intcoder.output[1] + 1] = match(intcoder.output[3]) {
            [0] = " ",
            [1] = "|",
            [2] = "#",
            [3] = function()
              game_data.paddle = intcoder.output[1] + 1
              return "-"
            end,
            [4] = function()
              game_data.ball = intcoder.output[1] + 1
              return "o"
            end,
          }
        end

        intcoder.output = {}
      end
    end

    local input_opcode = intcoder.opcodes[3].func
    intcoder.opcodes[3].func = function(...)
      local blocks = 0
      for _, row in pairs(game_data.screen) do
        for _, pixel in pairs(row) do
          if pixel == "#" then
            blocks = blocks + 1
          end
        end
      end

      if blocks == 0 then
        return IntcoderOpcodesReturnCode.ERROR
      end

      if game_data.paddle < game_data.ball then
        intcoder.input = { 1 }
      elseif game_data.paddle > game_data.ball then
        intcoder.input = { -1 }
      else
        intcoder.input = { 0 }
      end

      input_opcode(...)
    end
  end):run()

  return game_data.score
end

M:run()
