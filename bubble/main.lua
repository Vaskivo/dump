Bubble = require 'src/bubble'

MOAISim.openWindow ( "Cenas", 640, 480 )

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
 
bubble_list[#bubble_list+1] = Bubble.new(0, 0, 25, world)
bubble_list[#bubble_list+1] = Bubble.new(-50, 0, 25, world)
--bubble_list[#bubble_list+1] = Bubble.new(30, 30, 25, world)
--bubble_list[#bubble_list+1] = Bubble.new(0, -40, 35, world)
--bubble_list[#bubble_list+1] = Bubble.new(-30, -40, 10, world)

for _, y in pairs(bubble_list) do
    layer:insertProp(y.prop)
end

timer = MOAITimer.new()
timer:setSpan(0.1)
timer:setMode(MOAITimer.LOOP)
timer:setListener(MOAITimer.EVENT_TIMER_LOOP, 
    function()    
        for _, y in pairs(bubble_list) do
            y:increase_radius_by(1)
        end
    end
    )
timer:start()


--- walls
left = world:addBody(MOAIBox2DBody.STATIC)
left_fix = left:addRect(-320, -240, -300, 240)
    
top = world:addBody(MOAIBox2DBody.STATIC)
top_fix = top:addRect(-320, 220, 320, 240)
    
right = world:addBody(MOAIBox2DBody.STATIC)
right_fix = right:addRect(300, -240, 320, 240)

bottom = world:addBody(MOAIBox2DBody.STATIC)
bottom_fix = bottom:addRect(-320, -240, 320, -220)
    
    
    
    
    
    