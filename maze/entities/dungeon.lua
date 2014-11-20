 
local Utils = require 'utils/Utils' 

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

local function get_max_index(tbl)
  local max_index = -999
  
  if tbl then
    for i, _ in pairs(tbl) do
      if type(i) == 'number' then
        max_index = math.max(max_index, i)
      end
    end
  end
  
  return max_index
end

local function get_min_index(tbl)
  local min_index = 999
  
  if tbl then
    for i, _ in pairs(tbl) do
      if type(i) == 'number' then
        min_index = math.min(min_index, i)
      end
    end
  end
  
  return min_index
end
  
local function get_min_max_indexes(tbl)
  local min_index = 999
  local max_index = -999
  if not tbl then
    return min_index, max_index
  end
  for i, _ in pairs(tbl) do
    if type(i) == 'number' then
      min_index = math.min(min_index, i)
      max_index = math.max(max_index, i)
    end
  end
  return min_index, max_index
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
  local x_min, x_max = get_min_max_indexes(self.cells)
  local y_min_t = Utils.map(get_min_index, self.cells) 
  local y_max_t = Utils.map(get_max_index, self.cells) 
  y_min_t = Utils.filter(nil, y_min_t)
  y_max_t = Utils.filter(nil, y_max_t)
  local y_min = math.min(unpack(y_min_t))
  local y_max = math.max(unpack(y_max_t))
  str = ''
  for y = y_max, y_min, -1 do 
    row = ''
    for x = x_min, x_max do
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
 