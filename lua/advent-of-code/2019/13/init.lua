--- @class AOCDay201913: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "13")

require "advent-of-code.2019.intcoder"

function M:solve1()
  local tile = {}
  local blocks = 0

  Intcoder(self.input[1]):on_output(function(output)
    table.insert(tile, output)

    if #tile == 3 then
      if tile[3] == 2 then
        blocks = blocks + 1
      end
      tile = {}
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
  local buffer = {}

  Intcoder(self.input[1])
    :on_input(function()
      local blocks = 0
      for _, row in pairs(game_data.screen) do
        for _, pixel in pairs(row) do
          if pixel == "#" then
            blocks = blocks + 1
          end
        end
      end

      if game_data.paddle < game_data.ball then
        return { 1 }
      elseif game_data.paddle > game_data.ball then
        return { -1 }
      else
        return { 0 }
      end
    end)
    :on_output(function(output)
      table.insert(buffer, output)
      if #buffer == 3 then
        if buffer[1] == -1 and buffer[2] == 0 then
          game_data.score = buffer[3]
        else
          game_data.screen[buffer[2] + 1] = game_data.screen[buffer[2] + 1] or {}
          game_data.screen[buffer[2] + 1][buffer[1] + 1] = match(buffer[3]) {
            [0] = " ",
            [1] = "|",
            [2] = "#",
            [3] = function()
              game_data.paddle = buffer[1] + 1
              return "-"
            end,
            [4] = function()
              game_data.ball = buffer[1] + 1
              return "o"
            end,
          }
        end

        buffer = {}
      end
    end)
    :run {
      program = {
        [1] = 2,
      },
    }

  return game_data.score
end

M:run()
