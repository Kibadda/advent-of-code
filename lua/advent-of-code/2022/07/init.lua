local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "07")

local Directory = {
  new = function(self, name, size, parent, is_dir)
    return setmetatable({
      name = name,
      size = size,
      parent = parent,
      is_dir = is_dir,
      children = {},
    }, {
      __index = self,
    })
  end,
  addChild = function(self, name, size, is_dir)
    local child = self:new(name, size, self, is_dir)
    table.insert(self.children, child)
    return child
  end,
  findChild = function(self, name)
    for _, child in ipairs(self.children) do
      if child.name == name then
        return child
      end
    end

    return self:addChild(name, 0, true)
  end,
  calculate_size = function(self)
    for _, child in ipairs(self.children) do
      if child.is_dir then
        self.size = self.size + child:calculate_size()
      else
        self.size = self.size + child.size
      end
    end
    return self.size
  end,
}

function M:parse_input()
  local root = Directory:new("/", 0, nil, true)
  local current_directory = root

  for _, line in ipairs(self.lines) do
    if line ~= "$ cd /" then
      local split = line:split()
      if split[1] == "$" then
        if split[2] == "cd" then
          if split[3] == ".." then
            current_directory = current_directory.parent
          else
            current_directory = current_directory:findChild(split[3])
          end
        end
      else
        if split[1] == "dir" then
        else
          current_directory:addChild(split[2], split[1], false)
        end
      end
    end
  end

  return root
end

function M:solve1()
  local root = self:parse_input()

  root:calculate_size()

  local function traverse(children)
    local size = 0
    for _, child in ipairs(children) do
      if child.is_dir then
        if child.size <= 100000 then
          size = size + child.size
        end
        size = size + traverse(child.children)
      end
    end

    return size
  end

  return traverse(root.children)
end

function M:solve2()
  local root = self:parse_input()

  root:calculate_size()

  local limit = 70000000
  local needed_empty_space = 30000000
  local current_empty_space = limit - root.size

  local deletion = needed_empty_space - current_empty_space

  local minimum = math.huge
  local function traverse(children)
    for _, child in ipairs(children) do
      if child.is_dir then
        if child.size >= deletion then
          minimum = math.min(minimum, child.size)
          traverse(child.children)
        end
      end
    end
  end

  traverse(root.children)

  return minimum
end

return M
