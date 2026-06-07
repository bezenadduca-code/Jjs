-- =============================================================================
-- THE ULTIMATE FULL COMPREHENSIVE GRANNY MULTIPLAYER RADAR (FIXED SPIDER CONTAINER)
-- =============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ESP_TRACKING_CACHE = {}

-- Comprehensive Item Registry Mapping
local ITEM_CONFIG = {
    -- Core Keys & Access Cards (Red / Gold)
    ["master key"] = Color3.fromRGB(255, 0, 0),    
    ["padlock key"] = Color3.fromRGB(255, 215, 0),  
    ["playhouse key"] = Color3.fromRGB(255, 215, 0),
    ["car key"] = Color3.fromRGB(255, 215, 0),
    ["weapon key"] = Color3.fromRGB(255, 215, 0),
    ["special key"] = Color3.fromRGB(255, 215, 0),
    ["safe key"] = Color3.fromRGB(255, 215, 0),
    ["spider key"] = Color3.fromRGB(255, 215, 0),
    ["security key"] = Color3.fromRGB(255, 215, 0),
    ["shed key"] = Color3.fromRGB(255, 215, 0),
    ["helicopter key"] = Color3.fromRGB(255, 215, 0),
    ["boat key"] = Color3.fromRGB(255, 215, 0),
    ["train key"] = Color3.fromRGB(255, 215, 0),
    ["ticket"] = Color3.fromRGB(255, 215, 0),

    -- Mechanical Tools & Breakables (Orange)
    ["hammer"] = Color3.fromRGB(255, 127, 80),
    ["cutting pliers"] = Color3.fromRGB(255, 127, 80),
    ["wire cutter"] = Color3.fromRGB(255, 127, 80),
    ["chain cutter"] = Color3.fromRGB(255, 127, 80),
    ["cogwheel"] = Color3.fromRGB(255, 127, 80),
    ["orange cogwheel"] = Color3.fromRGB(255, 127, 80),
    ["red cogwheel"] = Color3.fromRGB(255, 127, 80),
    ["wrench"] = Color3.fromRGB(255, 127, 80),
    ["crowbar"] = Color3.fromRGB(255, 127, 80),
    ["screwdriver"] = Color3.fromRGB(255, 127, 80),
    ["winch handle"] = Color3.fromRGB(255, 127, 80),
    ["wheel crank"] = Color3.fromRGB(255, 127, 80),
    ["bridge crank"] = Color3.fromRGB(255, 127, 80),
    ["hand wheel"] = Color3.fromRGB(255, 127, 80),
    ["remote control"] = Color3.fromRGB(255, 127, 80),
    ["lockpick"] = Color3.fromRGB(255, 127, 80),
    ["code"] = Color3.fromRGB(255, 255, 255),
    ["padlock code"] = Color3.fromRGB(255, 255, 255),
    
    -- Vehicle Fuel, Assemblies & Structural Handles (Bright Pink / Magenta)
    ["car battery"] = Color3.fromRGB(255, 20, 147),
    ["battery"] = Color3.fromRGB(255, 20, 147),
    ["engine part"] = Color3.fromRGB(255, 20, 147),
    ["gas canister"] = Color3.fromRGB(255, 20, 147),
    ["gasoline can"] = Color3.fromRGB(255, 20, 147),
    ["gasoline"] = Color3.fromRGB(255, 20, 147),
    ["spark plug"] = Color3.fromRGB(255, 20, 147),
    ["helicopter manual"] = Color3.fromRGB(255, 20, 147),
    ["generator cable"] = Color3.fromRGB(255, 20, 147),
    ["door handle"] = Color3.fromRGB(255, 20, 147),
    ["door lock"] = Color3.fromRGB(255, 20, 147),
    ["boat steering wheel"] = Color3.fromRGB(255, 20, 147),
    ["duct tape"] = Color3.fromRGB(255, 20, 147),
    ["picture piece"] = Color3.fromRGB(255, 20, 147),
    ["accelerator"] = Color3.fromRGB(255, 20, 147),
    ["electric switch"] = Color3.fromRGB(255, 20, 147),
    ["door activator"] = Color3.fromRGB(255, 20, 147),

    -- Environmental Puzzles & Bait Items (Mint Green)
    ["fuse"] = Color3.fromRGB(0, 250, 154),
    ["glass fuse"] = Color3.fromRGB(0, 250, 154),
    ["plank"] = Color3.fromRGB(0, 250, 154),
    ["teddy bear"] = Color3.fromRGB(0, 250, 154),
    ["teddy"] = Color3.fromRGB(0, 250, 154),
    ["coconut"] = Color3.fromRGB(0, 250, 154),
    ["coin"] = Color3.fromRGB(0, 250, 154),
    ["melon"] = Color3.fromRGB(0, 250, 154),
    ["meat"] = Color3.fromRGB(0, 250, 154),
    ["birdseed"] = Color3.fromRGB(0, 250, 154),
    ["book"] = Color3.fromRGB(0, 250, 154),
    ["firewood"] = Color3.fromRGB(0, 250, 154),
    ["matches"] = Color3.fromRGB(0, 250, 154),

    -- Defensive Weapons, Assemblies & Tactical Items (Cyan)
    ["shotgun"] = Color3.fromRGB(0, 191, 255),
    ["shotgun part"] = Color3.fromRGB(0, 191, 255),
    ["shotgun barrel"] = Color3.fromRGB(0, 191, 255),
    ["shotgun stock"] = Color3.fromRGB(0, 191, 255),
    ["shotgun trigger"] = Color3.fromRGB(0, 191, 255),
    ["crossbow"] = Color3.fromRGB(0, 191, 255),
    ["slingshot"] = Color3.fromRGB(0, 191, 255),
    ["stun gun"] = Color3.fromRGB(0, 191, 255),
    ["pepper spray"] = Color3.fromRGB(0, 191, 255),
    ["freeze trap"] = Color3.fromRGB(0, 191, 255),
    ["hand grenade"] = Color3.fromRGB(0, 191, 255),
    
    -- Escape Vehicles Targets (Purple)
    ["car"] = Color3.fromRGB(138, 43, 226),
    ["helicopter"] = Color3.fromRGB(138, 43, 226),
    ["boat"] = Color3.fromRGB(138, 43, 226),
    ["train"] = Color3.fromRGB(138, 43, 226),
}

-- Ownership Filter Validation Loop
local function isHeldByPlayer(object)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and object:IsDescendantOf(player.Character) then
            return true
        end
        local backpack = player:FindFirstChildWhichIsA("Backpack")
        if backpack and object:IsDescendantOf(backpack) then
            return true
        end
    end
    return false
end

-- ============================================================
-- VISIBILITY UPGRADE: Pulsing outline + brighter fill
-- ============================================================
local function createUniversalESP(object, displayName, espColor, isAI)
    if ESP_TRACKING_CACHE[object] then return end
    if not object or not object.Parent then return end
    if object:FindFirstChild("UniversalItemESP") then return end
    ESP_TRACKING_CACHE[object] = true

    -- Wait longer for AI models to fully load in
    local targetPart
    if isAI then
        targetPart = object:WaitForChild("HumanoidRootPart", 5) or object:FindFirstChildWhichIsA("BasePart")
    else
        -- For items, try a couple of times to find a BasePart
        for i = 1, 5 do
            targetPart = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart")
            if targetPart then break end
            task.wait(0.2)
        end
    end

    if not targetPart then
        ESP_TRACKING_CACHE[object] = nil
        return
    end

    local espFolder = Instance.new("Folder")
    espFolder.Name = "UniversalItemESP"
    espFolder.Parent = object

    -- ---- Highlight (more visible: low fill transparency, bright outline) ----
    local highlight = Instance.new("Highlight")
    highlight.Adornee = object
    highlight.FillColor = espColor
    highlight.FillTransparency = isAI and 0.3 or 0.15   -- Much more opaque fill
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Always white outline for max contrast
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = espFolder

    -- ---- Billboard label ----
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemLabel"
    billboard.Size = UDim2.new(0, 180, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, isAI and 4 or 2, 0)
    billboard.MaxDistance = 10000
    billboard.Adornee = targetPart
    billboard.Parent = espFolder

    -- Background frame for readability
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 0
    bg.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = bg

    -- Colored border strip on left edge
    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(0, 4, 1, 0)
    strip.BackgroundColor3 = espColor
    strip.BackgroundTransparency = 0
    strip.BorderSizePixel = 0
    strip.Parent = bg

    local stripCorner = Instance.new("UICorner")
    stripCorner.CornerRadius = UDim.new(0, 4)
    stripCorner.Parent = strip

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text always
    label.TextStrokeColor3 = espColor               -- Colored stroke for identity
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bg

    -- ---- Pulse loop: alternates outline between white and espColor ----
    local pulseToggle = false
    task.spawn(function()
        local camera = workspace.CurrentCamera
        while object and object.Parent and espFolder.Parent do
            -- Remove ESP if item is picked up
            if not isAI and isHeldByPlayer(object) then
                espFolder:Destroy()
                break
            end

            -- Pulse the outline color for visibility
            pulseToggle = not pulseToggle
            if highlight and highlight.Parent then
                highlight.OutlineColor = pulseToggle and Color3.fromRGB(255, 255, 255) or espColor
            end

            if camera and targetPart and targetPart.Parent then
                local pos = targetPart.Position
                local distance = (camera.CFrame.Position - pos).Magnitude

                if isAI then
                    label.Text = string.format("⚠ %s\n%d studs", string.upper(displayName), math.floor(distance))
                    label.TextColor3 = Color3.fromRGB(255, pulseToggle and 255 or 80, pulseToggle and 80 or 255)
                else
                    label.Text = string.format("%s\n%d studs", string.upper(displayName), math.floor(distance))
                end
            else
                label.Text = ""
            end

            task.wait(isAI and 0.35 or 0.5) -- slower pulse = less CPU
        end
        ESP_TRACKING_CACHE[object] = nil
    end)
end

-- ============================================================
-- RELIABILITY UPGRADE: pcall wrapping + re-scan loop
-- ============================================================
local function checkAndApply(desc)
    local ok, err = pcall(function()
        if not desc or not desc.Parent then return end
        local lowerName = string.lower(desc.Name)
        if string.find(lowerName, "prop") then return end

        -- 1. Main Enemy AI Profiles
        if lowerName == "granny" or lowerName == "grandpa" or lowerName == "slendrina" then
            if desc:IsA("Model") and (desc:FindFirstChild("Humanoid") or desc:FindFirstChild("HumanoidRootPart")) then
                local enemyColor = Color3.fromRGB(0, 255, 0)
                if lowerName == "grandpa" then enemyColor = Color3.fromRGB(148, 0, 211) end
                if lowerName == "slendrina" then enemyColor = Color3.fromRGB(255, 105, 180) end
                createUniversalESP(desc, desc.Name, enemyColor, true)
                return
            end
        end

        -- 2. Big Spider container targeting
        local spidersContainer = workspace:FindFirstChild("Spiders")
        local isSpiderDescendant = (spidersContainer and desc:IsDescendantOf(spidersContainer))
            or string.find(lowerName, "spider")
        if isSpiderDescendant then
            if desc:IsA("Model") and not string.find(lowerName, "key") and not string.find(lowerName, "room") then
                if desc ~= spidersContainer and desc:FindFirstChildWhichIsA("BasePart") then
                    local cf, size = desc:GetBoundingBox()
                    if size and (size.X * size.Y * size.Z) > 50 then
                        createUniversalESP(desc, "BIG SPIDER", Color3.fromRGB(255, 69, 0), true)
                        return
                    end
                end
            end
        end

        -- 3. Item loot matching
        local itemColor = ITEM_CONFIG[lowerName]
        if itemColor then
            if desc.Parent and string.lower(desc.Parent.Name) == lowerName then return end
            createUniversalESP(desc, desc.Name, itemColor, false)
        end
    end)

    if not ok then
        -- Silently ignore errors from destroyed/nil instances
    end
end

-- Initial scan
for _, desc in ipairs(workspace:GetDescendants()) do
    task.spawn(checkAndApply, desc)
end

-- Live scan for newly added objects
workspace.DescendantAdded:Connect(function(desc)
    task.wait(0.5) -- give the object time to fully load
    checkAndApply(desc)
end)

-- ============================================================
-- RELIABILITY: Re-scan every 15s to catch anything missed
-- ============================================================
task.spawn(function()
    while true do
        task.wait(15)
        for _, desc in ipairs(workspace:GetDescendants()) do
            -- Only process untracked objects
            if not ESP_TRACKING_CACHE[desc] and not desc:FindFirstChild("UniversalItemESP") then
                task.spawn(checkAndApply, desc)
            end
        end
    end
end)

print("Master Radar Active: High-visibility ESP + auto-rescan enabled.")
