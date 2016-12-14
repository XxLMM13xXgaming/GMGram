SENDING_DATA = false

function net.SendGMGramChunk(id, data, max, rate) -- Thanks to Author. (STEAM_0:0:58068155) for these chunk functions :D
	max = max or 16384
	rate = rate or 1/4

	assert(not SENDING_DATA)
	SENDING_DATA = true

	local chunk_count = math.ceil(string.len(data) / max)

	for i = 1, chunk_count do
		local delay = rate * ( i - 1 )

		timer.Simple(delay, function()
			local chunk = string.sub(data, ( i - 1 ) * max + 1, i * max)
			local chunk_len = string.len(chunk)

			net.Start(id)
			net.WriteData(chunk, chunk_len)
			net.WriteBit(i == chunk_count)

			if ply and SERVER then
				net.Send(ply)
			elseif SERVER then
				net.Broadcast()
			elseif CLIENT then
				net.SendToServer()
			end

			if i == chunk_count then
				SENDING_DATA = false
			end
		end)
	end
end

function net.ReceiveGMGramChunk(id, func) -- Thanks to Author. (STEAM_0:0:58068155) for these chunk functions :D
	local chunks = chunks or {}

	net.Receive(id, function(len, server)
		local chunk = net.ReadData(( len - 1 ) / 8)
		local last_chunk = net.ReadBit() == 1

		table.insert(chunks, chunk)

		if last_chunk then
			local data = table.concat(chunks)
			func(data, server)

			chunks = nil
		end
	end)
end

concommand.Add("gmgram_takepicture",function(ply)
  local gmgrampicconfig = {
    format="jpeg",
    w=ScrW(),
    h=ScrH(),
    quality=75,
    x=0,
    y=0
  }
  gmgrampic = render.Capture(gmgrampicconfig)
  gmgrampic = util.Base64Encode(gmgrampic)

  chat.AddText(Color(0,0,0), "[", Color(255,255,255), "GMGram", Color(0,0,0), "] ", Color(0,0,0), "Sending Photo... This may take a few moments...")

  net.SendGMGramChunk("GMGramClientTookPicture", gmgrampic)
end)
