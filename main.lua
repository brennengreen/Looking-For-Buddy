function LFB_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    LFB.TitleText:SetText("Looking For Buddy")
    LFB.portrait:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
    print("Looking for Buddy loaded! Type /lfb to use the add-on.")
end

-- Open the add on by chatting /lfb
local isHidden = true
function LFB_SlashCommand(msg)
    if isHidden then
        isHidden = false 
        LFB:Show()
    else
        LFB:Hide()
        isHidden = true
    end
end
function LFB_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "LookingForBuddy" then
        -- Stop listening for event since we now know our add on loaded
        self:UnregisterEvent("ADDON_LOADED")
        
        -- Register slash command to open add-on
        SlashCmdList["MYADDON_SLASHCMD"] = LFB_SlashCommand
        SLASH_MYADDON_SLASHCMD1 = "/lfb";
    end
end