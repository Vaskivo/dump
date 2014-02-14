
--[[
    Module for the map. the map will have the following structure:
    
    Map = { 'c1_x-c1_y' = Cell,
            'c2_x-c2_y' = Cell,
            'c3_x-c3_y' = Cell,
            ...
          }
    -- Where the key is a concatenation of the cell's coordinates
    
    -- represents a single cell
    Cell = { x = x position,
             y = y position,
             n_wall = Wall,
             e_wall = Wall,
             s_wall = Wall,
             w_wall = Wall,
             items_on_ground = { item1, item2, ... },
             on_enter = function (...),
             on_leave = function (...),
             interact = function (...)
           }
           
    Wall = { interact = function (...)
             passable = Boolean
           }
           
    -- interaction will mainly work like this:
        
        - party in cell in map, chose 'interact' action.
        - if cell has interact, cell.interact()
        - else, see which wall the party is turned to and call 
          wall.interact()
        ( the simplest idea is to have a dummy function in the cell that 
          manages the dispatch:
          
          function (...) 
            if party.turned_to_N() then
                self.n_wall.interact(...)
            if party.turned_to_E() then
                self.e_wall.interact(...)
          end
          
          If the cell has specific functionality, just replace the 
          dummy function
        )
]]

local Map = {}
Map.__index = Map

-- Constructors

function Map.new_map()
    local map = setmetatable({}, Map)
    -- init stuff
    
    return map
end

-- Returns the cell in the given coordinates
--      self        -> Map
--      x           -> int, x coordinate
--      y           -> int, y coordinate
local function Map.get_cell(self, x, y)
    local key = x .. '-' .. y
    return self[key]
end

-- Checks if movement can be made from a cell to an adjacent one.
--      self        -> Map
--      from_x      -> int
--      from_y      -> int
--      direction   -> string, possible values: {'n', 'e', 's', 'w'}
local function Map.can_move_in_direction(self, from_x, from_y, direction)
    local current_cell = self[from_x .. '-' .. from_y]
    if current_cell == nil then
        print("ERROR! - Origin cell does not exist")
        return false
    end
    return current_cell:can_move_in_direction(direction)
end


return Map


-- Cell Stuff

local Cell = {}
Cell.__index = Cell


-- Constructors

function Cell.new(x, y)
    local cell = setemtatable({}, Cell)
    -- init stuff
    cell.x = x
    cell.y = y
    items_on_ground = {}
    
    return cell
end

function Cell.can_move_in_direction(self, direction)
    local wall = self[direction .. '_wall']
    if wall then
        return wall.passable
    end
    return true
end

-- default interact. Replace at will
function Cell.interact(self, party --[[or something]])
    local wall = self[party.direction .. '_wall']
    if wall and wall.interact then
        return wall.interact()
    end
    return nil
end


return Cell



-- Wall Stuff

local Wall = {}
Wall.__index = Wall

-- Constructors

function Wall.new()
    local wall = setmetatable({}, Wall)
    -- init stuff
    wall.passable = false
    
    return wall
end