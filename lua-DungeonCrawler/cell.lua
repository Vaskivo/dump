
local Cell = {}
Cell.__index = Cell


-- Constructors

function Cell.new(x, y)
    local cell = setemtatable({}, Cell)
    -- init stuff
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