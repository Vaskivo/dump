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

utils = require 'utils'
Dungeon = require 'entities/dungeon'


--MOAISim.openWindow ( "test", 1280, 720 )

dungeon = Dungeon.new('MyDungeon')

--math.randomseed(100)
for i = 1, 400 do
  local x = math.random(25)
  local y = math.random(25)
  local old_cell = dungeon:get_cell_by_position(x, y)
  while old_cell do
    print 'repeat'
    x = math.random(25)
    y = math.random(25)
    old_cell = dungeon:get_cell_by_position(x, y)
  end
  dungeon:add_cell(x, y)
end



map = dungeon:pprint()

print('')

print(map)







 