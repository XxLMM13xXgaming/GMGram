if (SERVER) then
  include("gmgram/main.lua")
  AddCSLuaFile("gmgram/main.lua")
end

if (CLIENT) then
  include("gmgram/main.lua")
end
