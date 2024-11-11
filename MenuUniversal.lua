-- // Cargar la Biblioteca Poop UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))()
if not Library then
    error("No se pudo cargar la biblioteca PoopLibrary")
end

-- // Ventana Principal
local Window = Library:New({Name = "Splix Private Poop UI", Accent = Color3.fromRGB(25, 240, 100)})

-- // Página del Aimbot
local AimbotTab = Window:Page({Name = "Aimbot"})
local aimbotEnabled = false
local aimbotKey = Enum.KeyCode.E
local aimbotSmoothness = 1
local hitPart = "Head"

-- Toggle para Aimbot sin Callback
AimbotTab:AddToggle({
    Name = "Enabled",
    Default = false,
    Pointer = "AimbotMain_Enabled"
})

-- Control manual del Aimbot
game:GetService("RunService").RenderStepped:Connect(function()
    aimbotEnabled = Library.Flags["AimbotMain_Enabled"]
    if aimbotEnabled then
        -- Ejecutar la función del Aimbot si está habilitado
        AimAtTarget()
    end
end)



AimbotTab:AddKeybind({
    Default = aimbotKey,
    KeybindName = "Aimbot Key",
    Mode = "Hold",
    Pointer = "AimbotMain_Bind",
    Callback = function()
        if aimbotEnabled then
            AimAtTarget()
        end
    end
})

AimbotTab:AddSlider({
    Name = "Smoothness",
    Minimum = 1,
    Maximum = 30,
    Default = aimbotSmoothness,
    Decimals = 0.1,
    Pointer = "AimbotMain_Smoothness",
    Callback = function(value)
        aimbotSmoothness = value
    end
})

AimbotTab:AddDropdown({
    Name = "Hit-Part",
    Options = {"Head", "Torso", "Arms", "Legs"},
    Default = "Head",
    Pointer = "AimbotMain_Hitpart",
    Callback = function(value)
        hitPart = value
    end
})

-- Función de Aimbot
function AimAtTarget()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera

    local function getClosestTarget()
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character then
                local targetPart = player.Character:FindFirstChild(hitPart)
                if targetPart then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
        return closestPlayer
    end

    local target = getClosestTarget()
    if target then
        local targetPart = target.Character:FindFirstChild(hitPart)
        if targetPart then
            local aimPos = targetPart.Position
            local direction = (aimPos - camera.CFrame.Position).unit
            local newCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)

            -- Suavidad del aimbot
            camera.CFrame = camera.CFrame:Lerp(newCFrame, aimbotSmoothness / 30)
        end
    end
end

-- // Página de Visuals
local VisualsTab = Window:Page({Name = "Visuals"})
local visualsEnabled = false
local teamCheck = true

VisualsTab:AddToggle({
    Name = "Box ESP",
    Default = false,
    Pointer = "VisualsEnemies_BoxEsp",
    Callback = function(value)
        visualsEnabled = value
        print("Box ESP habilitado:", visualsEnabled)
    end
})

VisualsTab:AddToggle({
    Name = "Team Check",
    Default = teamCheck,
    Pointer = "VisualsEnemies_TeamCheck",
    Callback = function(value)
        teamCheck = value
    end
})

-- Función para dibujar cajas alrededor de los enemigos
function DrawESP()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and (not teamCheck or player.Team ~= localPlayer.Team) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local head = player.Character:FindFirstChild("Head")
                local torso = player.Character:FindFirstChild("Torso")

                local rootPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                local headPos = camera:WorldToViewportPoint(head.Position)
                local torsoPos = camera:WorldToViewportPoint(torso.Position)

                if onScreen and visualsEnabled then
                    local boxHeight = (headPos.Y - torsoPos.Y) * 2
                    local boxWidth = boxHeight / 2.5

                    -- Dibujar el rectángulo en la pantalla
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Color = Color3.fromRGB(255, 0, 0)
                    box.Thickness = 1
                    box.Size = Vector2.new(boxWidth, boxHeight)
                    box.Position = Vector2.new(rootPos.X - boxWidth / 2, rootPos.Y - boxHeight / 2)
                end
            end
        end
    end
end

-- Conexión para actualizar el ESP en cada frame
game:GetService("RunService").RenderStepped:Connect(DrawESP)

-- // Página de Settings
local SettingsTab = Window:Page({Name = "Settings"})
local Settings_Main = SettingsTab:Section({Name = "Main", Side = "Left"})

Settings_Main:Button({
    Name = "Unload",
    Callback = function()
        Window:Unload()
        print("Interfaz descargada")
    end
})

-- Inicializar la Interfaz
Window:Initialize()
print("Script de Aimbot y Visuals cargado correctamente")
