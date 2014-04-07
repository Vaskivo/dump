
local Bubble = {}
Bubble.__index = Bubble


-- Constructor

function Bubble.new(x, y, radius, box2dWorld)
    local bubble = setmetatable({}, Bubble)
    
    bubble.radius = radius
    
    local deck = MOAIScriptDeck.new()
    deck:setDrawCallback(function()
            local x, y = bubble.body:getPosition()
            MOAIGfxDevice.setPenColor(1, 0, 0, 1)
            --MOAIDraw.fillCircle(x, y, bubble.radius, 64)
        end
        )
    deck:setRect(-25, -25, 25, 25)
            
    local prop = MOAIProp2D.new()
    prop:setDeck(deck)
    
    local body = box2dWorld:addBody(MOAIBox2DBody.DYNAMIC, x, y)
    --body:setTransform(x, y)
    body:setMassData(50)
    
    prop:setAttrLink(MOAIProp2D.INHERIT_TRANSFORM, body, MOAIProp2D.TRANSFORM_TRAIT)
    
    local fixture = body:addCircle(x, y, bubble.radius)
    --[[
    fixture:setCollisionHandler(
        function (phase, fixtureA, fixtureB, arbiter)
            print('CENAS')
            local radius1 = fixtureA:getBody().data.radius
            local radius2 = fixtureB:getBody().data.radius
            
            local x1, y1 = fixtureA:getBody():getPosition()
            local x2, y2 = fixtureB:getBody():getPosition()
            local v1 = x2-x1
            local v2 = y2-y1
            
            local dist = math.sqrt(v1^2 + v2^2)
            
            if dist < (radius1 + radius2) then
                print('GAME OVER!!')
            end
        end)
    ]]--
    
    --fixture:setSensor(true)
    fixture:setCollisionHandler(Bubble._collision_callback, MOAIBox2DArbiter.END)
    
    
    bubble.deck = deck
    bubble.prop = prop
    bubble.body = body
    bubble.fixture = fixture
    
    bubble.body.data = bubble -- must be changed!!
    return bubble
end

function Bubble.update_fixture(self)
    self.fixture:destroy()
    local x, y = self.body:getPosition()
    self.fixture = self.body:addCircle(x, y, self.radius)
    --self.fixture:setSensor(true)
    self.fixture:setCollisionHandler(Bubble._collision_callback, MOAIBox2DArbiter.END)
end


function Bubble.increase_radius_by(self, inc)
    self.radius = self.radius + inc
    self:update_fixture()
end

function Bubble._collision_callback(phase, fixtureA, fixtureB, arbiter)
    if not fixtureB:getBody().data then -- colliding with outer wall
        return
    end
    
    local radius1 = fixtureA:getBody().data.radius
    local radius2 = fixtureB:getBody().data.radius
    
    local x1, y1 = fixtureA:getBody():getPosition()
    local x2, y2 = fixtureB:getBody():getPosition()
    local v1 = x2-x1
    local v2 = y2-y1
    
    local dist = math.sqrt(v1^2 + v2^2)
    
    if dist < (radius1 + radius2 - 10) then
        print('GAME OVER!!')
    end
end






return Bubble