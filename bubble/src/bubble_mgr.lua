Bubble = require 'src/bubble'

local BubbleManager = {}
BubbleManager.__index = BubbleManager


function BubbleManager.new(partition, box2dWorld, fixture_step)
    manager = setmetatable({}, BubbleManager)
    
    manager.bubble_set = {}          
    manager.partition = partition
    manager.fixture_step = fixture_step
    manager.box2dWorld = box2dWorld
    
    return manager
end


function BubbleManager.start(self)
    if self.timer then
        self.timer:stop()
    end
    
    print('CENAS')
    
    self.timer = MOAITimer.new()
    self.timer:setSpan(self.fixture_step)
    self.timer:setMode(MOAITimer.LOOP)
    self.timer:setListener(MOAITimer.EVENT_TIMER_LOOP,
        function()
            for bubble, _ in pairs(self.bubble_set) do
                bubble:update_fixture()
            end
        end
    )
    self.timer:start()
end

function BubbleManager.stop(self)
    if self.timer then
        self.timer:stop()
    end
end


function BubbleManager.create_bubble(self, x, y, radius, min_radius, growth_speed, tap_shrink, color)
    local bubble = Bubble.new(x, y, radius, min_radius, growth_speed, tap_shrink, color, self.box2dWorld)
    self.bubble_set[bubble] = true
    
    self.partition:insertProp(bubble.prop)    
    
    return bubble
end


function BubbleManager.destroy_bubble(self, bubble)
    if self.bubble_set[bubble] then
        self.partition:removeProp(bubble.prop)
        -- clean up bubble
        self.bubble_set[bubble] = nil
    end
end


function BubbleManager.update_bubbles(self, delta_time)
    for bubble, _ in pairs(self.bubble_set) do
        bubble:increase_radius_with_time(delta_time)
        if bubble.tapped then
            bubble.radius = bubble.radius - bubble.tap_shrink
            if bubble.radius < bubble.min_radius then
                bubble.radius = bubble.min_radius 
            end
        end
    end
end



--[[ TEMP

function BubbleManager.spawn_bubble(self, min_x, min_y, max_x, max_y, radius, min_radius, growth_speed, tap_shrink, color)
    local max_dist = 0
    local overlaps = true
    local x_pos = 0
    local y_pos = 0

    for i = 1, 5 do
        local x = math.random(min_x, max_x)
        local y = math.random(min_y, max_y)
        
        local tmp_dist = 0
        local tmp_overlap = false
        for bub, _ in pairs(self.bubble_set) do
            local bx, by = bub.prop:getLoc()
            
            local dist = math.sqrt( (bx-x)^2 + (by-y)^2 )
            
            if dist < radius + bub.radius then
                tmp_overlap = tmp_overlap or true
            end
            tmp_dist = tmp_dist + dist
        end
        
        if (tmp_overlap == 
        
    end
end 
]]--

return BubbleManager
