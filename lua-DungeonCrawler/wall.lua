
local Wall = {}
Wall.__index = Wall

-- Constructors

function Wall.new()
    local wall = setmetatable({}, Wall)
    -- init stuff
    wall.passable = false
    
    return wall
end


return Wall