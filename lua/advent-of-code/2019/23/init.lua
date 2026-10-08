--- @class AOCDay201923: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "23")

require "advent-of-code.2019.intcoder"

--- @type Intcoder[]
local computers = {}
local messages = {}

--- @param handlers { on_nat_message: (fun(packet: integer[]): integer?), on_idle?: (fun(): integer?) }
function M:solver(handlers)
  computers = {}
  messages = {}

  local is_idle = false

  for i = 0, 49 do
    table.insert(messages, { i, i })
    computers[i] = Intcoder(self.input[1]):on_output(function(output, intcoder)
      intcoder.data.buffer = intcoder.data.buffer or {}
      table.insert(intcoder.data.buffer, output)

      if #intcoder.data.buffer == 3 then
        is_idle = false
        table.insert(messages, intcoder.data.buffer)
        intcoder.data.buffer = {}
      end
    end)
  end

  while true do
    while #messages > 0 do
      local message = table.remove(messages, 1)
      local computer_index = table.remove(message, 1)

      if computer_index == 255 then
        local on_nat_message = handlers.on_nat_message(message)

        if on_nat_message then
          return on_nat_message
        end
      else
        for _, v in ipairs(message) do
          table.insert(computers[computer_index].input, v)
        end

        computers[computer_index]:run()
      end
    end

    if is_idle then
      local on_idle = handlers:on_idle()

      if on_idle then
        return on_idle
      end
    else
      is_idle = true

      for i = 0, 49 do
        table.insert(messages, { i, -1 })
      end
    end
  end
end

function M:solve1()
  return self:solver {
    on_nat_message = function(packet)
      return packet[2]
    end,
  }
end

function M:solve2()
  local nat_packet
  local last_sent

  return self:solver {
    on_nat_message = function(packet)
      nat_packet = packet
    end,
    on_idle = function()
      if last_sent == nat_packet[2] then
        return last_sent
      end

      last_sent = nat_packet[2]
      table.insert(messages, { 0, unpack(nat_packet) })
    end,
  }
end

M:run()
