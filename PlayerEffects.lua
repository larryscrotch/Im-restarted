-- PlayerEffects.lua
local Players = game.Players
local Config = require(script.Parent.Config)

local PlayerEffects = {}

-- Function to check if a player is in the whitelist
function PlayerEffects.isWhitelisted(playerName)
    for _, name in ipairs(Config.whitelist) do
        if name == playerName then
            return true
        end
    end
    return false
end

-- Function to create or update Dot ESP for the main "Head" part
function PlayerEffects.createOrUpdateDot(headPart)
    if headPart and not headPart:FindFirstChild("ESP") then
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(0, Config.dotSize, 0, Config.dotSize)
        billboardGui.Adornee = headPart
        billboardGui.AlwaysOnTop = true
        billboardGui.StudsOffset = Config.offsetAboveHead

        local dotFrame = Instance.new("Frame")
        dotFrame.Size = UDim2.new(1, 0, 1, 0)
        dotFrame.BackgroundColor3 = Config.dotColor
        dotFrame.BackgroundTransparency = 1 - Config.dotOpacity
        dotFrame.BorderSizePixel = 0
        dotFrame.Parent = billboardGui

        local espMarker = Instance.new("BoolValue")
        espMarker.Name = "ESP"
        espMarker.Parent = headPart

        billboardGui.Parent = headPart
        
        return true -- Indicate that ESP was created successfully
    end
    
    return false -- Indicate that ESP already exists or could not be created
end

-- Function to remove Dot ESP for a given head part
function PlayerEffects.removeDot(headPart)
    if headPart and headPart:FindFirstChild("ESP") then
        headPart:FindFirstChild("ESP"):Destroy()
        if headPart:FindFirstChildWhichIsA("BillboardGui") then
            headPart:FindFirstChildWhichIsA("BillboardGui"):Destroy()
        end
    end
end

-- Function to apply effects only if they are not already applied
function PlayerEffects.applyEffects(player)
    local character = player.Character

    if not character then return end

    local resized = false

    for _, partName in ipairs({"HeadBack", "HeadEars", "HeadEyes", "HeadJaws", "HeadNape", "HeadNeck", "HeadTop", "Head"}) do
        local headPart = character:FindFirstChild(partName)
        
        if headPart then 
            local hasESP = headPart:FindFirstChild("ESP") ~= nil
            
            if not hasESP and partName == "Head" then 
                PlayerEffects.createOrUpdateDot(headPart) 
            end
            
            if headPart.Size ~= Vector3.new(Config.targetSize, Config.targetSize, Config.targetSize) then 
                headPart.Size = Vector3.new(Config.targetSize, Config.targetSize, Config.targetSize)
                resized = true 
            end
            
            if partName ~= "Head" then 
                PlayerEffects.removeDot(headPart) 
            end 
        end 
    end 

    return resized 
end

return PlayerEffects
