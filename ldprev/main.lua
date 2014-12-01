
ResourceManager = require 'resourcemgr'
InputManager = require 'inputmgr'

WIN_DIMENSIONS = { w = 1366, h = 768 }

MOAISim.openWindow('test', WIN_DIMENSIONS.w, WIN_DIMENSIONS.h)

MOAIDebugLines.setStyle(MOAIDebugLines.TEXT_BOX)

viewport = MOAIViewport.new()
viewport:setSize(WIN_DIMENSIONS.w, WIN_DIMENSIONS.h)
viewport:setScale(WIN_DIMENSIONS.w, WIN_DIMENSIONS.h)

layer = MOAILayer2D.new()
layer:setViewport(viewport)
MOAISim.pushRenderPass(layer)

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( ResourceManager.getImage("moai.png") )
gfxQuad:setRect ( -64, -64, 64, 64 )

prop = MOAIProp2D.new ()
prop:setDeck ( gfxQuad )
layer:insertProp ( prop )

MOAIUntzSystem.initialize ()

sound = ResourceManager.getAudio('sweeper.mp3')
--sound:play()

textbox = MOAITextBox.new()
textbox:setString('Hello World!!! so cliché')
textbox:setFont( ResourceManager.getFont('arialbd.ttf', 24) )
textbox:setTextSize(24)
textbox:setRect(-150, -300, 150, -200)
textbox:setYFlip ( true )

layer:insertProp(textbox)



function main()
 
  coroutine.yield()
  
  local timer = timer or MOAITimer.new()
  timer:setSpan(5)
  timer:start()
  MOAICoroutine.blockOnAction(timer)

  ResourceManager.releaseImage('moai.png')
  ResourceManager.releaseSound('sweeper.mp3')
  ResourceManager.releaseFont('arialbd.ttf', 24)

  print('quitting')
  os.exit()
end

thread = MOAICoroutine.new()
--thread:run(main)


action = InputManager.getAction('test_handler')
action:addCallback(function (state)
        local action = InputManager.getAction('new_handler')
        print(action)
        if state then
          action:addKeyboardHandler(string.byte('j'))
        else
          action:removeKeyboardHandler(string.byte('j'))
        end
      end
    )


action:addKeyboardHandler('f')









