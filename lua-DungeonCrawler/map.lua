
local Map = {}
Map.__index = Map

-- Constructors

function Map.new_map()
    local map = setmetatable({}, Map)
    -- init stuff
    
    return map
end

-- Adds a cell to the map
--      cell        -> Cell
--      x           -> int, x coordinate for the cell
--      y           -> int, y coordinate for the cell
function Map.add_cell(self, cell, x, y)
    local key = x .. '-' .. y
    self[key] = cell
end

-- Returns the cell in the given coordinates
--      x           -> int, x coordinate
--      y           -> int, y coordinate
function Map.get_cell(self, x, y)
    local key = x .. '-' .. y
    return self[key]
end

-- Checks if movement can be made from a cell to an adjacent one.
--      from_x      -> int
--      from_y      -> int
--      direction   -> string, possible values: {'n', 'e', 's', 'w'}
function Map.can_move_in_direction(self, from_x, from_y, direction)
    local current_cell = self[from_x .. '-' .. from_y]
    if current_cell == nil then
        print("ERROR! - Origin cell does not exist")
        return false
    end
    return current_cell:can_move_in_direction(direction)
end


return Map


