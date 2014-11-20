 
local utils = require 'utils' 

-- for the cell matrix
local function insert_in_matrix(matrix, x, y, data)
  matrix[x] = matrix[x] or {}
  matrix[x][y] = data
end
 
local function get_from_matrix(matrix, x, y)
  if matrix[x] then
    return matrix[x][y]
  end
end

local function get_max_index(table)
  if not table then
    return 0
  end
  local max_index = 0
  for i, _ in pairs(table) do
    if type(i) == 'number' then
      max_index = math.max(max_index, i)
    end
  end
  return max_index
end

 
local Dungeon = {}
Dungeon.__index = Dungeon
 
 
function Dungeon.new(name)
  local dungeon = setmetatable({}, Dungeon)
    
  dungeon.name = name
  dungeon.cells = {}
    
  return dungeon
end
 
function Dungeon.add_cell(self, x, y, cell)
  local cell = cell or Dungeon.Cell.new()
  local old_cell = self:get_cell_by_position(x, y)
  if old_cell then
    return old_cell
  end
  insert_in_matrix(self.cells, x, y, cell)
  return cell
end
 
function Dungeon.get_cell_by_position(self, x, y)
  return get_from_matrix(self.cells, x, y)
end
 
function Dungeon.get_cells_by_tag(self, tag)
  local cells = {}
  for _, t in pairs(self.cells) do
    for _, cell in pairs(t) do
      if cell.tags then
        for _, cell_tag in pairs(sell.tags) do
          cells[#cells+1] = cell
        end
      end
    end
  end
  return cells
end
                
function Dungeon.pprint(self)
  local max_x = get_max_index(self.cells)
  local t = utils.map(get_max_index, self.cells) 
  t = utils.filter(nil, t)
  local max_y = math.max(unpack(t))
  str = ''
  for y = max_y, 1, -1 do 
    row = ''
    for x = 1, max_x do
      if self:get_cell_by_position(x, y) then
        row = row .. '0'
      else
        row = row .. '#'
      end
    end
    str = str .. row .. '\n'
  end
  return str    
end
    
 
 
 
-- Cell
local Cell = {}
Cell.__index = Cell
 
function Cell.new()
  local cell = setmetatable({}, Cell)
  
  return cell
end
 
Dungeon.Cell = Cell
 
 
 
-- static "sub entitiy" creators
function Dungeon.new_cell()
  return Dungeon.Cell.new()
end
 
 
return Dungeon
 