Bubble = require 'src/bubble'

local BubbleManager = {}
BubbleManager.__index = BubbleManager


function BubbleManager.new(partition, box2dWorld, fixture_step)
    manager = setmetatable({}, BubbleManager)
    
    manager.bubble_set = {}          
    manager.partition = partition
    manager.fixture_step = fixture_step
    manager.box2dWorld = box2dWorld
end


function BubbleManager.start(self)
    if self.timer then
        self.timer:stop()
    end
    
    self.timer = MOAITimer.new()
    self.timer:setTime(self.fixture_step)
    self.timer:setListener(MOAITimer.EVENT_TIMER_LOOP,
        function()
            for bubble, _ in pairs(self.bubble_set) do
                bubble:update_fixture()
            end
        end
        )
end

function BubbleManager.stop(self)
    if self.timer then
        self.timer:stop()
    end
end


function BubbleManager.create_bubble(self, x, y, radius, min_radius, growth_speed, tap_shrink, color)
    local bubble = Bubble.new(x, y, radius, min_radius, growth_speed, color, self.box2dWorld)
    self.bubble_set[bubble] = true
    
    self.partition:insertProp(bubble.prop)    
end


function BubbleManager.destroy_bubble(self, bubble)
    if self.bubble_set[bubble] then
        self.partition:removeProp(bubble.prop)
        -- clean up bubble
        self.bubble_set[bubble] = nil
    end
end





