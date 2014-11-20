-------------------------------------------------------------------------------                    
-- Ensure undefined global access is an error.                                                     
-------------------------------------------------------------------------------                    

local global_meta = {}      
setmetatable(_G, global_meta)

function global_meta:__index(k)
  error("Undefined global variable '" .. k .. "'!")                                              
end



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

Utils = require 'utils/Utils'
Dungeon = require 'entities/dungeon'


--MOAISim.openWindow ( "test", 1280, 720 )

dungeon = Dungeon.new('MyDungeon')

--[[
--math.randomseed(100)
for i = 1, 40 do
  local x = math.random(10)
  local y = math.random(10)
  local old_cell = dungeon:get_cell_by_position(x, y)
  while old_cell do
    print 'repeat'
    x = math.random(10)
    y = math.random(10)
    old_cell = dungeon:get_cell_by_position(x, y)
  end
  dungeon:add_cell(x, y)
end
--]]

dungeon:add_cell(-1, -2)
dungeon:add_cell(-1, -3)
dungeon:add_cell(-1, -4)
dungeon:add_cell(-2, -3)
dungeon:add_cell(-3, -3)
dungeon:add_cell(-4, -1)
dungeon:add_cell(-4, -2)
dungeon:add_cell(-4, -3)
dungeon:add_cell(-5, -3)
dungeon:add_cell(-6, -3)
dungeon:add_cell(-7, -2)
dungeon:add_cell(-7, -3)
dungeon:add_cell(-7, -4)


map = dungeon:pprint()

print('')

print(map)









 