local CurrentPostFrames = {}

function LFB_PopulatePosts(self)
    print("Populating posts you bastard...")
end

function CreatePostFrame(self, playerName)
    local newFrame = CreateFrame("Frame", playerName, LFBSummaryScroll, "SecureDialogBorderTemplate")
    local relativeFrame
    if #CurrentPostFrames > 0 then
        print(CurrentPostFrames[1]:GetName(), CurrentPostFrames[#CurrentPostFrames]:GetName())
        relativeFrame = CurrentPostFrames[#CurrentPostFrames]
        
        print("Relative")
    else
        relativeFrame = newFrame:GetParent()
        print("Parent")
    end

    if relativeFrame == newFrame:GetParent() then
        newFrame:SetPoint("TOPLEFT", relativeFrame)
    else
        newFrame:SetPoint("BOTTOMLEFT", relativeFrame)
    end

    newFrame:SetHeight(.1)
    newFrame:SetWidth(1)
    
    print(newFrame:GetHeight(), newFrame:GetWidth())
    CurrentPostFrames[#CurrentPostFrames] = newFrame
    return newFrame
end

function LFB_AddPost(self)
    C_ChatInfo.SendAddonMessage("LFB_POSTING", "POST ADDED BY OBJECTIVEC", "GENERAL", "Objectivec-Area52")
    local newPost = CreatePostFrame(UnitName("player"))
end

function LFB_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")    
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
    -- What happens when the add on initially loads in
    if event == "ADDON_LOADED" and ... == "LookingForBuddy" then
        -- Stop listening for event since we now know our add on loaded
        self:UnregisterEvent("ADDON_LOADED")
        
        -- Register slash command to open/close add-on
        SlashCmdList["MYADDON_SLASHCMD"] = LFB_SlashCommand
        SLASH_MYADDON_SLASHCMD1 = "/lfb";

        -- Regist add-on message prefix
        local successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix("LFB_POSTING")

        -- Set important ui configurations
        LFB.TitleText:SetText("Looking For Buddy")
        LFBSummaryScroll.AddPostButton:SetText("Add Post")
        LFB_PopulatePosts()

        -- Let the user know the add on is ready for use!
        print("Looking for Buddy loaded! Type /lfb to use the add-on.")
    end
end

