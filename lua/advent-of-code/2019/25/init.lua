--- @class AOCDay201925: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "25")

require "advent-of-code.2019.intcoder"

function M:solve1()
  local items = {
    "mutex",
    "spool of cat6",
    "hypercube",
    "astronaut ice cream",
    "boulder",
    "antenna",
    "sand",
    "mouse",
  }

  local combinations = {}

  for i = 0, 255 do
    local combination = {}

    for j = 0, 7 do
      if bit.band(bit.rshift(i, j), 1) == 1 then
        table.insert(combination, items[j + 1])
      end
    end

    table.insert(combinations, combination)
  end

  Intcoder(self.input[1]):on_input(function(intcoder)
    if intcoder.data.manual then
      return { io.read "*l" }
    elseif not intcoder.data.at_checkpoint then
      intcoder.data.at_checkpoint = true

      local input = {
        "south",
        "take astronaut ice cream",
        "north",
        "east",
        "take mouse",
        "north",
        "take spool of cat6",
        "north",
        "take hypercube",
        "east",
        "take sand",
        "south",
        "take antenna",
        "north",
        "west",
        "south",
        "south",
        "south",
        "take mutex",
        "west",
        "take boulder",
        "south",
        "south",
        "south",
        "west",
        "south",
        "inv",
      }

      for _, item in ipairs(items) do
        table.insert(input, "drop " .. item)
      end

      return input
    elseif not intcoder.data.brute then
      intcoder.data.brute = true
      local input = {}

      for _, combination in ipairs(combinations) do
        for _, item in ipairs(combination) do
          table.insert(input, "take " .. item)
        end
        table.insert(input, "south")
        for _, item in ipairs(combination) do
          table.insert(input, "drop " .. item)
        end
      end

      return input
    else
      return {}
    end
  end):run {
    ascii = true,
    print = true,
    data = {
      manual = false,
    },
  }
end

--                                                                 Stables                       Engineering ---------------------------- Crew Quarters
--                                                                  (infinite loop)-              (hypercube)                              (sand)
--                                                                  |                              |                                       |
--                                                                  |                              |                                       |
--                                                                  |                              |                                       |
--       Hallway                                                   Observatory     ------         Arcade                                  Navigation
--        (giant electromagnet)-                                                                   (spool of cat6)                         (antenna)
--        |                                                                                         |
--        |                                                                                         |
--        |                                                                                         |
--       Hull Breach   -------------------------------------------------------------------------- Passages
--        |                                                                                        (mouse)
--        |                                                                                         |
--        |                                                                                         |
--        |                                                                                         |
--       Science Lab                      Sick Bay --------------  Gift Wrapping  ------------    Warp Drive
--        (astronaut ice cream)                                     (boulder)                      (mutex)
--                                                                 |                               |
--                                                                 |                               |
--                                                                 |                               |
--                                                                 |                               |
--                                                                Holodeck                       Kitchen
--                                                                 (escape pod)-
--                                                                 |
--                                                                 |
--                                                                 |
--                                                                Hot Chocolate Fountain
--                                                                 (photons)-
--                                                                 |
--                                                                 |
--                                                                 |
--                                      Storage ----------------- Corridor
--                                       |                         (molten lava)-
--                                       |
--                                       |
--                                      Security Checkpoint
--
--
--
-- {
--   Arcade                    = None of the cabinets seem to have power.,
--   Corridor                  = The metal walls and the metal floor are slightly different colors. Or are they?,
--   Crew Quarters             = The beds are all too small for you.,
--   Engineering               = You see a whiteboard with plans for Springdroid v2.,
--   Gift Wrapping Center      = How else do you wrap presents on the go?,
--   Hallway                   = This area has been optimized for something; you're just not quite sure what.,
--   Holodeck                  = Someone seems to have left it on the Giant Grid setting.,
--   Hot Chocolate Fountain    = Somehow, it's still working.,
--   Hull Breach               = You got in through a hole in the floor here. To keep your ship from also freezing, the hole has been sealed.,
--   Kitchen                   = Everything's freeze-dried.,
--   Navigation                = Status: Stranded. Please supply measurements from fifty stars to recalibrate.,
--   Observatory               = There are a few telescopes; they're all bolted down, though.,
--   Passages                  = They're a little twisty and starting to look all alike.,
--   Pressure-Sensitive Floor  = Analyzing...,
--   Science Lab               = You see evidence here of prototype polymer design work.,
--   Security Checkpoint       = In the next room, a pressure-sensitive floor will verify your identity.,
--   Sick Bay                  = Supports both Red-Nosed Reindeer medicine and regular reindeer medicine.,
--   Stables                   = Reindeer-sized. They're all empty.,
--   Storage                   = The boxes just contain more boxes.  Recursively.,
--   Warp Drive Maintenance    = It appears to be working normally.,
-- }

function M:solve2() end

M:run()
