if (SERVER) then
  include("gmgram/main.lua")
  AddCSLuaFile("gmgram/main.lua")
  --test
end

if (CLIENT) then
  include("gmgram/main.lua")
end
