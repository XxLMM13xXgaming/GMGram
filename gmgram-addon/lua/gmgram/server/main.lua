--GMGram
util.AddNetworkString("GMGramClientTookPicture")
util.AddNetworkString("GMGramOpenClientMenu")
util.AddNetworkString("GMGramKillNotification")
util.AddNetworkString("GMGramClientNotify")

gmgramaddonused = false

GMGramErrorTable = {
	{"ID WRONG/NOT FOUND SERVER", "Server not found/The ID is wrong. (please report this message to a server administrator)", false},
	{"BANNED.", "You are banned from posting.", false},
	{"Found Server", "This isnt an error.", false},
	{"ALREADY EXISTING BABE", "Cannot send a photo due to an exisiting photo is already pending.", false},
	{"FAQ", "DB Failed. (please report this message to a server administrator)", false},
	{"PASS WRONG", "Password is wrong (please report this message to a server administrator)", false},
	{"Works lol", "Success! Your photo has been posted please verify your photo now!", true}
}

hook.Add("PlayerInitialSpawn", "GMGramPlayerInitialSpawn", function()
	if !gmgramaddonused then
		http.Post("http://xxlmm13xxgaming.com/addons/data/serveradd.php",{sid = "gmgram", sip = game.GetIPAddress(), sdate=tostring(os.time()), soid = 76561198141863800},function(body)
			print(body)
			gmgramaddonused = true
		end,function(error)
			print(error)
		end)
	end
end)


function net.ReceiveGMGramChunk(id, func) -- Thanks to Author. (STEAM_0:0:58068155) for these chunk functions :D
	local chunks = chunks or {}

	net.Receive(id, function(len, server)
		local chunk = net.ReadData(( len - 1 ) / 8)
		local last_chunk = net.ReadBit() == 1
        if chunks == nil then
            chunks = {}
        end
		table.insert(chunks, chunk)

		if last_chunk then
			local data = table.concat(chunks)
			func(data, server)

			chunks = nil
		end
	end)
end

function GMGramNotify(ply, type, message)
  if ply == "*" then
    net.Start("GMGramClientNotify")
      net.WriteFloat(type)
      net.WriteString(message)
    net.Broadcast()
  else
    net.Start("GMGramClientNotify")
      net.WriteFloat(type)
      net.WriteString(message)
    net.Send(ply)
  end
end

-- When a person says !gmgram
hook.Add("PlayerSay", "GMGramAddonCommands", function(ply, text)
  local text = string.lower(text)
  if text:lower():match('[!/:.]gmgram') then
    net.Start("GMGramOpenClientMenu")
      net.WriteBool(GMGramConfig.TakeCodeFromInternet)
    net.Send(ply)
    return ''
  end
end)

-- When the person takes a picture
net.ReceiveGMGramChunk("GMGramClientTookPicture",function(data, ply)
  local gmgrampic = data

  if ply.GMGramPlayerOnCooldown then
    GMGramNotify(ply, 3, "You are on cool down please wait "..GMGramConfig.CooldownTime.." minute(s)!")
    return
  end

  http.Post ("http://gmgram.com/auth/auth32.php", {picture=gmgrampic, pass=GMGramConfig.Password, steamid64=ply:SteamID64(), IDs=GMGramConfig.ServerID},function( body, len, headers, code)
    ply.GMGramPlayerOnCooldown = true
    timer.Simple(GMGramConfig.CooldownTime, function()
      ply.GMGramPlayerOnCooldown = false
    end)

		msgfound = false
		for k, v in pairs(GMGramErrorTable) do
			if body == v[1] then
				msgfound = true
				if v[3] then
					GMGramNotify(ply, 2, v[2])
		      ply:SendLua( "gui.OpenURL( 'http://gmgram.com/confirm' )" )
				else
					GMGramNotify(ply, 3, v[2])
					if GMGramConfig.DevMode then
		          MsgC(GMGramClientConfig.ErrorColor, "GMGram Error body printing...\n\n")
		            print(body)
		          Msg("\n")
		          MsgC(GMGramClientConfig.ErrorColor, "GMGram Error body printed...\n\n")
		      end
				end
			end
		end

		if !msgfound then
			GMGramNotify(ply, 3, "An unknown error has occured. Please report this message to an administrator... (nomsgfound)")
      if GMGramConfig.DevMode then
        MsgC(GMGramClientConfig.ErrorColor, "GMGram Error body printing...\n\n")
          print(body)
        MsgC("\n", GMGramClientConfig.ErrorColor, "GMGram Error body printed...\n\n")
      end
		end
  end, function()
		GMGramNotify(ply, 3, "An unknown error has occured. Please report this message to an administrator... (webfunctionerror)")
		MsgC(GMGramClientConfig.ErrorColor, "GMGram Error body printing...\n\n")
			print(error)
		MsgC("\n", GMGramClientConfig.ErrorColor, "GMGram Error body printed...\n\n")
  end)
end)

-- Timer to advert the addon and get people to upload pictures!
timer.Create("GMGramRunningOnServer",1800,0,function()
  GMGramNotify("*", 2, "This server is running GMGram")
end)
