
local Manager = {}


-- input handlers
local key_event_handlers = {}   -- matrix -> [key] = {list of handlers}
local mouse_pointer_handlers = {}
local mouse_button_handler = {} -- matrix [button] = {list of handlers}


---------   ACTION CLASS   ----------------------------------------------------

local Action = {}
Action.__index = Action

function Action.new(name)
  action = setmetatable({}, Action)
  
  action.name = name
  action.state = nil    -- just for completion sake
  action.key_handlers = {}
  
  return action
end  

function Action.addKeyboardHandler(self, key)
  if type(key) == 'string' then
    key = string.byte(key)
  end
  function button_callback(down)
    if self.state ~= down then
      self.state = down
      if self.callback then
        self.callback(self.state)
      end
      print('changed state of action ' .. self.name .. ' to ' .. tostring(down))
    end
  end
  
  f = button_callback
  self.key_handlers[key] = f
  
  if not key_event_handlers[key] then
    key_event_handlers[key] = {}
  end
  
  key_event_handlers[key][#key_event_handlers[key]+1] = f
end

function Action.removeKeyboardHandler(self, key)
  f = self.key_handlers[key]
  self.key_handlers[key] = nil
  
  if key_event_handlers[key] then
    local index = nil
    for i, v in pairs(key_event_handlers[key]) do
      if v == f then
        index = i
        -- goto exit loop
      end
    end
    table.remove(key_event_handlers[key], index)
  end
end

function Action.addCallback(self, func)
  self.callback = func
end

function Action.removeCallbak(self)
  self.callback = nil
end



-- actions
local actions = {}

function Manager.getAction(name)
  if actions[name] then
    return actions[name]
  end

  action = Action.new(name)
  -- init stuff if needed
  
  actions[name] = action
  return action
end



-- global handlers
local key_events = {}   -- matrix [key] -> state

function Manager.keyboardHandler(key, down)
  key_events[key] = down
end
MOAIInputMgr.device.keyboard:setCallback(Manager.keyboardHandler)




local function inputManagerMain()
  while true do
    for key, state in pairs(key_events) do
      if key_event_handlers[key] then
        for _, handler in pairs(key_event_handlers[key]) do
          handler(state)
        end
      end
    end 
    
    -- do same for other events
    coroutine.yield()
  end
end

local inputManagerThread = MOAICoroutine.new()
inputManagerThread:run(inputManagerMain)


return Manager




  
  
  

