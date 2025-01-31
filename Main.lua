-- MainScript.lua
local Players = game.Players
local PlayerEffects = require(script.Parent.PlayerEffects)

local executingPlayerName = Players.LocalPlayer.Name -- Automatically gets the name of the local player

-- Function to handle new players joining or existing players respawning
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        task.wait() -- Wait for character model to fully load before applying effects.
        
        if not PlayerEffects.isWhitelisted(player.Name) and player.Name ~= executingPlayerName then 
            PlayerEffects.applyEffects(player) 
        end 
    end)

    if not PlayerEffects.isWhitelisted(player.Name) and player.Name ~= executingPlayerName and player.Character then 
        PlayerEffects.applyEffects(player) 
    end 
end

-- Monitor function that checks all players periodically for missing effects.
local function monitorPlayers()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do 
            if not PlayerEffects.isWhitelisted(player.Name) and player.Name ~= executingPlayerName and player.Character then 
                PlayerEffects.applyEffects(player)
            end 
        end
        
        task.wait(1) -- Check every second (adjust as needed)
    end
end

-- Connect existing players when script runs.
for _, player in ipairs(Players:GetPlayers()) do 
    onPlayerAdded(player) 
end 

-- Connect new players joining after script execution.
Players.PlayerAdded:Connect(onPlayerAdded)

-- Start monitoring players for missing effects.
task.spawn(monitorPlayers)

print("Script loaded and optimized.")
