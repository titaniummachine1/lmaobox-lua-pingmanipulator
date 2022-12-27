--[[
    Ping Reducer for Lmaobox
    Author: LNX (github.com/lnx00)
    editor: terminator ()
]]

local menuLoaded, MenuLib = pcall(require, "Menu")
assert(menuLoaded, "MenuLib not found, please install it!")
assert(MenuLib.Version >= 1.43, "MenuLib version is too old, please update it!")

--[[ Menu ]]
local Menu = MenuLib.Create("Ping utils", MenuFlags.AutoSize)
Menu.Style.TitleBg = { 10, 200, 100, 255 }
Menu.Style.Outline = true

local Options = {
    Enabled = Menu:AddComponent(MenuLib.Checkbox("Enable", true)),
    TargetPing = Menu:AddComponent(MenuLib.Slider("Target Ping", 0, 100, 77)),
    mRandPing = Menu:AddComponent(MenuLib.Checkbox("Random Ping", true)),
    mRandPingValue = Menu:AddComponent(MenuLib.Slider("Ping Randomness", 1, 15, 7)),
}

local function OnCreateMove()
    if not Options.Enabled:GetValue() then return end

    local localIndex = entities.GetLocalPlayer():GetIndex()
    local ping = entities.GetPlayerResources():GetPropDataTableInt("m_iPing")[localIndex + 1]
    if ping <= Options.TargetPing:GetValue() then
        gui.SetValue("ping reducer", 0)
    else
        gui.SetValue("ping reducer", 1)
    end
    local prTimer = 0 
    if mRandPing:GetValue() == true then                     -- If Random Ping is enabled
        prTimer = prTimer +1                                 -- Increment the ping timer
        if (prTimer >= mRandPingValue:GetValue() * 66) then  -- Check if the ping timer is greater than "mRandPingValue" (set in the menu).
            prTimer = 0                                      -- Reset the ping timer
            local prActive = gui.GetValue("ping reducer")    -- Set "prActive" to the current value of ping reducer
            -- if (gui.GetValue("ping reducer") == 0) then   -- Untested. This might work better.
            if (prActive == 0) then                          -- Check if ping reducer is currently disabled
                gui.SetValue("ping reducer", 1)              -- If it is disabled, enable it
            elseif (prActive == 1) then                      -- Check if ping reducer is currently enabled
                gui.SetValue("ping reducer", 0)              -- If it is enabled, disable it
            end
        end
    end
end

local function OnUnload()
    MenuLib.RemoveMenu(Menu)

    client.Command('play "ui/buttonclickrelease"', true)
end

callbacks.Unregister("CreateMove", "PR_CreateMove")
callbacks.Unregister("Unload", "PR_Unload")

callbacks.Register("CreateMove", "PR_CreateMove", OnCreateMove)
callbacks.Register("Unload", "PR_Unload", OnUnload)

client.Command('play "ui/buttonclick"', true)