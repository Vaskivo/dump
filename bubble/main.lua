Bubble = require 'src/bubble'

MOAISim.openWindow ( "Window", 640, 480 )

viewport = MOAIViewport.new ()
viewport:setSize ( 640, 480 )
viewport:setScale ( 640, 480 )

layer = MOAILayer2D.new()
layer:setViewport(viewport)

partition = MOAIPartition.new()
layer:setPartition(partition)

--MOAIRenderMgr.setRenderTable( { layer } )
MOAISim.pushRenderPass(layer)

world = MOAIBox2DWorld.new()
world:setUnitsToMeters(1/32)
world:setIterations(1,8) 
world:start()
layer:setBox2DWorld(world)

 
bubble_list = {} 
 
--bubble_list[#bubble_list+1] = Bubble.new(-200, 0, 5, 10, {1, 0, 0, 1}, world)
bubble_list[#bubble_list+1] = Bubble.new(-100, -50, 5, 10, {1, 0, 0, 1}, world)
--bubble_list[#bubble_list+1] = Bubble.new(30, 30, 25, 1, {1, 0, 0, 1}, world)
--bubble_list[#bubble_list+1] = Bubble.new(0, -40, 35, 1, {1, 0, 0, 1}, world)
--bubble_list[#bubble_list+1] = Bubble.new(-30, -40, 10, 1, {1, 0, 0, 1}, world)

for _, y in pairs(bubble_list) do
    partition:insertProp(y.prop)
end

timer = MOAITimer.new()
timer:setSpan(0.1)
timer:setMode(MOAITimer.LOOP)
timer:setListener(MOAITimer.EVENT_TIMER_LOOP, 
    function()    
        for _, y in pairs(bubble_list) do
            --y:change_radius_by(1)
            y:update_fixture()
        end
    end
    )
timer:start()


--- walls
left = world:addBody(MOAIBox2DBody.STATIC)
left_fix = left:addRect(-320, -240, -300, 240)
left_fix:setFriction(0)
    
top = world:addBody(MOAIBox2DBody.STATIC)
top_fix = top:addRect(-320, 220, 320, 240)
top_fix:setFriction(0)    
    
right = world:addBody(MOAIBox2DBody.STATIC)
right_fix = right:addRect(300, -240, 320, 240)
right_fix:setFriction(0)

bottom = world:addBody(MOAIBox2DBody.STATIC)
bottom_fix = bottom:addRect(-320, -240, 320, -220)
bottom_fix:setFriction(0)
    
    
bubble1 = bubble_list[1]

function main()
    while true do
        local now = MOAISim.getElapsedTime()
        local delta_time = now - run_time
        
        for _, bubble in ipairs(bubble_list) do
            bubble:increase_radius_with_time(delta_time)
        end
        
        coroutine.yield()
    end
end

thread = MOAICoroutine.new()

run_time = MOAISim.getElapsedTime() -- I'm hoping this is a float
thread:run(main)
    
    
--[[

    Touch callback arguments:
    
    eventType   - TOUCH_UP, TOUCH_DOWN or TOUCH_MOVE
    idx         - id of the touch registered
    x           - x of the touch (in screen coordinates)
    y           - y of the touch (in screen coordinates)
    tapCount    - Total number of taps (registered since last iteration or current total??)

]]--


touch_list = {}

if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback(
        function(isMouseDown)
            if(isMouseDown) then
                local x, y = layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc())
                local prop = partition:propForPoint(x, y)
                -- if prop is a bubble...
                touch_list.MOUSE = prop
            else
                local x, y = layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc())
                local prop = partition:propForPoint(x, y)
                if touch_list.MOUSE and (touch_list.MOUSE == prop) then
                    prop.tapped = true
                end
            end
        end
        )
    MOAIInputMgr.device.mouseRight:setCallback(
        function(isMouseDown)
            if(isMouseDown) then
                -- MOUSE RIGHT DOWN
            else 
                -- MOUSE LEFT RIGHT
            else
        end
        )
else
-- If it isn't a mouse, its a touch screen... or some really weird device.
    MOAIInputMgr.device.touch:setCallback (

        function ( eventType, idx, x, y, tapCount )
            -- RANDOM SHIT AROUND HERE
        end
    )
end
    
    
    
    
    
    
    
    
    
    
    
    