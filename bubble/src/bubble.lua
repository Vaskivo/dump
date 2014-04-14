
local Bubble = {}
Bubble.__index = Bubble


Bubble.states = { INIT = 0,
                  RUNNING = 1,
                  CLEANUP = 2,
                  DEAD = 3
                }


-- constructor

function Bubble.new(x, y, starting_radius, min_radius, growth_speed, tap_shrink, color, box2d_world)
    local bubble = setmetatable({}, Bubble)

    local deck = MOAIScriptDeck.new()
    deck:setDrawCallback(function()
            local radius = bubble.radius
            MOAIGfxDevice.setPenColor(unpack(color))
            MOAIDraw.fillCircle(0, 0, radius, 32)
            MOAIGfxDevice.setPenColor(1,1,1,1)
            MOAIGfxDevice.setPenWidth(3)
            MOAIDraw.drawCircle(0,0,radius,32)
            -- I should use setRectCallback (but I don't know how!)
            deck:setRect(-radius, -radius, radius, radius) 
        end
        )
    deck:setRect(-starting_radius, -starting_radius, starting_radius, starting_radius) 
    
    local prop = MOAIProp2D.new()
    prop:setDeck(deck)
    prop:setLoc(0, 0)
    
    local body = box2d_world:addBody(MOAIBox2DBody.DYNAMIC)
    body:setTransform(x, y)
    
    prop:setAttrLink ( MOAIProp2D.INHERIT_LOC, body, MOAIProp2D.TRANSFORM_TRAIT ) 
    
    local fixture = body:addCircle(0, 0, starting_radius)
    fixture:setCollisionHandler(Bubble._collision_callback, MOAIBox2DArbiter.END)
    
    fixture:setDensity(1)
    fixture:setFriction(0)
    body:resetMassData()
    
    bubble.start_radius = starting_radius
    bubble.radius = starting_radius
    bubble.old_fixture_radius = starting_radius
    
    bubble.max_radius = starting_radius -- points
    
    bubble.min_radius = min_radius
    bubble.growth_speed = growth_speed
    bubble.tap_shrink = tap_shrink
    bubble.color = color
    
    bubble.deck = deck
    bubble.prop = prop
    bubble.body = body
    bubble.fixture = fixture
    
    bubble.body.data = bubble
    bubble.prop.data = bubble
    
    self.state = Bubble.states.INIT
    
    return bubble
end


function Bubble.update(self, delta_time)

    if self.state == Bubble.state.INIT then
        -- do init stuff
        self.state = Bubble.states.RUNNING -- temp
        
    elseif self.state == Bubble.state.RUNNING then
        if self.tapped then
            if self.radius > self.max_radius then
                self.max_radius = self.radius
            end
        
            self.radius = self.radius - self.tap_shrink
            if self.radius <= self.min_radius then
                self.radius = self.min_radius
                self.state = Bubble.state.CLEANUP
            end
            self.tapped = false
        end
        self:increase_radius_with_time(delta_time)
        
    elseif self.state == Bubble.state.CLEANUP then
        -- do cleanup stuff
        self.state = Bubble.state.DEAD -- temp
    end
end

function Bubble.destroy(self)
    -- destroying physics
    self.fixture:destroy()
    self.body:destroy()
    self.fixture = nil
    self.body = nil
    
    -- destroying rendering data
    self.prop = nil
    self.deck = nil
end

function Bubble.change_radius_by(self, value)
    self.radius = self.radius + value
end

function Bubble.increase_radius_with_time(self, delta_time)
    self.radius = self.radius + (self.growth_speed * delta_time)
end

function Bubble.get_points(self) -- may be overriden for SPECIAL BUBBLES!!
    return self.max_radius
end

function Bubble.update_fixture(self)
    if not self.fixture then
        return
    end
    
    local new_radius = math.floor(self.radius)
    if new_radius == self.old_fixture_radius then
        return
    end

    self.fixture:destroy()
    --local x, y = self.body:getPosition()
    self.fixture = self.body:addCircle(0, 0, new_radius)
    self.fixture:setCollisionHandler(Bubble._collision_callback, MOAIBox2DArbiter.END)
    self.fixture:setDensity(1)
    self.fixture:setFriction(0)
    self.body:resetMassData()
    
    self.old_fixture_radius = new_radius
    
    -- default inits
    self.tapped = false
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