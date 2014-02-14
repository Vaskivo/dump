--[[
    The map will have the following structure:
    
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

local MapFactory = {}

-- create map from txt

-- create map from randomGenerator

-- output map as [[something]] (for saving)

return MapFactory
