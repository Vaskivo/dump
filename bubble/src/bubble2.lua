
local Bubble = {}
Bubble.__index = Bubble


-- constructor

function Bubble.new(x, y, starting_radius, growth_speed, color, box2d_world)
    local bubble = setmetatable({}, Bubble)
    
    
    
    local deck = MOAIScriptDeck.new()
    deck:setDrawCallback(function()
            local radius = bubble.radius
            MOAIGfxDevice.setPenColor(unpack(color))
            MOAIDraw.fillCircle(0, 0, radius, 32)
            -- I should use setRectCallback (but I don't know how!)
            deck:setRect(-radius, -radius, radius, radius) 
        end
        )
    
    local prop = MOAIProp2D.new()
    prop:setDeck(deck)
    
    local body = box2d_world:addBody(MOAIBox2DBody.DYNAMIC, x, y)
    
    prop:setAttrLink (MOAIProp2D.INHERIT_TRANSFORM, body, MOAIProp2D.TRANSFORM_TRAIT)
    
    local fixture = body:addCircle(0, 0, radius)
    fixture:setCollisionHandler(Bubble._collision_callback, MOAIBox2DArbiter.END)
    
    bubble.start_radius = radius
    bubble.radius = radius
    bubble.growth_speed = growth_speed
    bubble.color = color
    
    bubble.deck = deck
    bubble.prop = prop
    bubble.body = body
    bubble.fixture = fixture
    
    bubble.body.data = bubble
    
    return bubble
end


function Bubble.change_radius_by(self, value)
    self.radius = self.radius + inc
end


function Bubble.update_fixture(self)
    self.fixture:destroy()
    local x, y = self.body:getPosition()
    self.fixture = self.body:addCircle(x, y, self.radius)
    self.fixture:setCollisionHandler(Bubble._collision_callback, MOAIBox2DArbiter.END)
end



return Bubble