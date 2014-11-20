
-- Utility stuff

local utils = {}

-- functional stuff
function utils.map(func, table)
  local new_table = {}
  for i, j in pairs(table) do
    new_table[i] = func(j)
  end
  return new_table
end

function utils.filter(func, table)
  -- DOES NOT GUARANTEE ORDER!!
  -- if func is nil, checks bool value of item
  func = func or function(x) return x end
  local new_table = {}
  for _, j in pairs(table) do
    if func(j) then
      new_table[#new_table+1] = j
    end
  end
  return new_table
end

-- sleep function
function utils.threadSleep(time, timer)
  local timer = timer or MOAITimer.new()
  timer:setSpan(time)
  timer:start()
  MOAICoroutine.blockOnAction(timer)
end


-- Environment data for debug
function utils.print_environment()
  print ("               Display Name : ", MOAIEnvironment.appDisplayName)
  print ("                     App ID : ", MOAIEnvironment.appID)
  print ("                App Version : ", MOAIEnvironment.appVersion)
  print ("            Cache Directory : ", MOAIEnvironment.cacheDirectory)
  print ("   Carrier ISO Country Code : ", MOAIEnvironment.carrierISOCountryCode)
  print ("Carrier Mobile Country Code : ", MOAIEnvironment.carrierMobileCountryCode)
  print ("Carrier Mobile Network Code : ", MOAIEnvironment.carrierMobileNetworkCode)
  print ("               Carrier Name : ", MOAIEnvironment.carrierName)
  print ("            Connection Type : ", MOAIEnvironment.connectionType)
  print ("               Country Code : ", MOAIEnvironment.countryCode)
  print ("                    CPU ABI : ", MOAIEnvironment.cpuabi)
  print ("               Device Brand : ", MOAIEnvironment.devBrand)
  print ("                Device Name : ", MOAIEnvironment.devName)
  print ("        Device Manufacturer : ", MOAIEnvironment.devManufacturer)
  print ("                Device Mode : ", MOAIEnvironment.devModel)
  print ("            Device Platform : ", MOAIEnvironment.devPlatform)
  print ("             Device Product : ", MOAIEnvironment.devProduct)
  print ("         Document Directory : ", MOAIEnvironment.documentDirectory)
  print ("         iOS Retina Display : ", MOAIEnvironment.iosRetinaDisplay)
  print ("              Language Code : ", MOAIEnvironment.languageCode)
  print ("                   OS Brand : ", MOAIEnvironment.osBrand)
  print ("                 OS Version : ", MOAIEnvironment.osVersion)
  print ("         Resource Directory : ", MOAIEnvironment.resourceDirectory)
  print ("                 Screen DPI : ", MOAIEnvironment.screenDpi)
  print ("              Screen Height : ", MOAIEnvironment.screenHeight)
  print ("               Screen Width : ", MOAIEnvironment.screenWidth)
  print ("                       UDID : ", MOAIEnvironment.udid)
end


return utils
