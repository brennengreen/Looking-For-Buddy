local CurrentPostFrames = {}
local lastOffset = 0
local currentTopScrollIndex = 1

function LFBSummaryScroll_Update(self)
    FauxScrollFrame_Update(LFBSummaryScroll,50,4,50);
    if FauxScrollFrame_GetOffset(LFBSummaryScroll) > lastOffset and FauxScrollFrame_GetOffset(LFBSummaryScroll) % 4 == 0 then
        CurrentPostFrames[currentTopScrollIndex]:Hide()
        currentTopScrollIndex = currentTopScrollIndex + 1
        CurrentPostFrames[currentTopScrollIndex]:Show()
        lastOffset = FauxScrollFrame_GetOffset(LFBSummaryScroll)
    elseif FauxScrollFrame_GetOffset(LFBSummaryScroll) < lastOffset and FauxScrollFrame_GetOffset(LFBSummaryScroll) % 4 == 0 then
        CurrentPostFrames[currentTopScrollIndex]:Hide()
        currentTopScrollIndex = currentTopScrollIndex - 1
        CurrentPostFrames[currentTopScrollIndex]:Show()
        lastOffset = FauxScrollFrame_GetOffset(LFBSummaryScroll)
    end
end

function LFB_PopulatePosts(self)
    print("Populating posts you bastard...")
end

function CreatePostFrame(self, playerName)
    local newFrame = CreateFrame("Frame", playerName, LFBSummaryScroll)
    newFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
         edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
         tile=true, tileSize=16, edgeSize=16,
         insets={left=4,right=4,top=4,bottom=4}});
    newFrame:SetBackdropColor(0,0,0,1);
    newFrame:SetHeight(127.5)

    local relativeFrame

    if #CurrentPostFrames > 0 th en
        relativeFrame = CurrentPostFrames[#CurrentPostFrames]        
    else
        relativeFrame = LFBSummaryScroll.AddPostButton
    end

    if relativeFrame == newFrame:GetParent() then
        newFrame:SetPoint("TOPLEFT", relativeFrame, "TOPLEFT")
        newFrame:SetPoint("TOPRIGHT", relativeFrame, "TOPRIGHT")
    else
        newFrame:SetPoint("TOPLEFT", relativeFrame, "BOTTOMLEFT")
        newFrame:SetPoint("TOPRIGHT", relativeFrame, "BOTTOMRIGHT")
    end
    
    table.insert(CurrentPostFrames, newFrame)
    return newFrame
end

function LFB_AddPost(self)
    C_ChatInfo.SendAddonMessage("LFB_POSTING", "POST ADDED BY OBJECTIVEC", "GENERAL", "Objectivec-Area52")
    local newPost = CreatePostFrame(UnitName("player"))
    if #CurrentPostFrames > 4 then
        newPost:Hide()
    end
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

