Bubble = require 'src/bubble'

MOAISim.openWindow ( "Window", 640, 480 )

viewport = MOAIViewport.new ()
viewport:setSize ( 640, 480 )
viewport:setScale ( 640, 480 )

layer = MOAILayer2D.new()
layer:setViewport(viewport)

--MOAIRenderMgr.setRenderTable( { layer } )
MOAISim.pushRenderPass(layer)

world = MOAIBox2DWorld.new()
world:setUnitsToMeters(1)
world:start()
layer:setBox2DWorld(world)

 
bubble_list = {} 
 
bubble_list[#bubble_list+1] = Bubble.new(-200, 0, 25, 1, {1, 0, 0, 1}, world)
bubble_list[#bubble_list+1] = Bubble.new(-100, -50, 25, 1, {1, 0, 0, 1}, world)
--bubble_list[#bubble_list+1] = Bubble.new(30, 30, 25, 1, {1, 0, 0, 1}, world)
--bubble_list[#bubble_list+1] = Bubble.new(0, -40, 35, 1, {1, 0, 0, 1}, world)
--bubble_list[#bubble_list+1] = Bubble.new(-30, -40, 10, 1, {1, 0, 0, 1}, world)

for _, y in pairs(bubble_list) do
    layer:insertProp(y.prop)
end

timer = MOAITimer.new()
timer:setSpan(0.1)
timer:setMode(MOAITimer.LOOP)
timer:setListener(MOAITimer.EVENT_TIMER_LOOP, 
    function()    
        for _, y in pairs(bubble_list) do
            y:change_radius_by(1)
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
        print('ITER')
        print(bubble1.prop:getLoc())
        print(bubble1.body:getPosition())
        print('#####')
        coroutine.yield()
    end
end

thread = MOAICoroutine.new()
--thread:run(main)
    
    
    