
local Manager = {}

-- constants
local RES_PATH = './resources/'
local IMAGES_PATH = RES_PATH .. 'images/'
local AUDIO_PATH = RES_PATH .. 'audio/'
local FONTS_PATH = RES_PATH .. 'fonts/'

local CHARCODES = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&amp;/-"'

-- caches
local image_cache = {}
local audio_cache = {}
local font_cache = {}

---------   IMAGES   ----------------------------------------------------------

function Manager.getImage(filename)
  if image_cache[filename] then
    return image_cache[filename]
  end
  
  local image = MOAIImage.new()
  image:load(IMAGES_PATH .. filename)
  image_cache[filename] = image
  
  return image
end

function Manager.releaseImage(filename)
  if image_cache[filename] then
    image_cache[filename] = nil
  end
end



---------  AUDIO CLIPS --------------------------------------------------------

-- if needed, create a whole Sound or AudioClip class with added functionality

function Manager.getAudio(filename)
  if audio_cache[filename] then
    return audio_cache[filename]
  end
  
  if MOAIUntzSystem then
    local sound = MOAIUntzSound.new()
    sound:load(AUDIO_PATH .. filename)
    audio_cache[filename] = sound
    return sound
  end
end

function Manager.releaseSound(filename)
  if audio_cache[filename] then
    audio_cache[filename] = nil
  end
end


---------   FONTS   -----------------------------------------------------------

function Manager.getFont(filename, size)
  local fonts = font_cache[filename]
  
  if fonts then
    if fonts[size] then
      return fonts[size]
    end
  else
    fonts = {}
  end
  
  local font = MOAIFont.new()
  font:loadFromTTF(FONTS_PATH .. filename, CHARCODES, size)
  
  fonts[size] = font
  font_cache[filename] = fonts
  return font
end

function Manager.releaseFont(filename, size)
  if size and font_cache[filename] then
    font_cache[filename][size] = nil
  else
    font_cache[filename] = nil
  end
end
    

return Manager
  
    
