if (SERVER) then
  AddCSLuaFile("gmgram/client/gui.lua")
  AddCSLuaFile("gmgram/client/main.lua")
  AddCSLuaFile("gmgram/config/client_settings.lua")
  include("gmgram/config/client_settings.lua")
  include("gmgram/config/settings.lua")
  include("gmgram/server/main.lua")

  MsgC(Color(255,0,0), "[", Color(255,255,255), "GMGram", Color(255,0,0), "] ", Color(0,255,0), "GMGram has been loaded!\n")
end

if (CLIENT) then
  include("gmgram/config/client_settings.lua")
  include("gmgram/client/gui.lua")
  include("gmgram/client/main.lua")
  MsgC(Color(255,0,0), "[", Color(255,255,255), "GMGram", Color(255,0,0), "] ", Color(0,255,0), "GMGram has been loaded!\n")
end
