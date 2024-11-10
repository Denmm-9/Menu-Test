-- Créditos originales a xz#1111 y gracias a weakhoes por la Octernal Lib
-- Cargar Octernal Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/main/Octernal%20Lib/Octernal%20Lib%20Source.lua"))()
end)

-- Verificamos si se cargó correctamente la librería
if not success or not Library then
    warn("No se pudo cargar la Octernal Library. Verifica la URL o tu conexión.")
    return
end

-- Inicializar UI
local Window = Library:CreateWindow("Mi Script Roblox", Vector2.new(550, 620))
Window:ToggleUI() -- Mostrar el UI al inicio

-- Crear pestañas
local VisualsTab = Window:Tab("Visuals")
local AimbotTab = Window:Tab("Aimbot")

-- Variables globales para Visuals y Aimbot
getgenv().VisualsEnabled = false
getgenv().AimbotEnabled = false
getgenv().AimbotKey = Enum.KeyCode.E -- Tecla por defecto para activar Aimbot

-- == Visuals Tab ==
local VisualsSection = VisualsTab:Section("Visual Settings")

-- Toggle para habilitar/deshabilitar Visuals
VisualsSection:Toggle("Enable ESP", false, function(state)
    getgenv().VisualsEnabled = state
    print("Visuals habilitados:", state)
end)

VisualsSection:Colorpicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    getgenv().ESPColor = color
end)

-- Función ESP
function ESP(player)
    if getgenv().VisualsEnabled then
        pcall(function()
            local espBox = Drawing.new("Square")
            espBox.Thickness = 2
            espBox.Color = getgenv().ESPColor or Color3.fromRGB(255, 0, 0)
            espBox.Transparency = 0.7
            espBox.Visible = true
            
            -- Actualizar ESP en función de la posición del jugador
            game:GetService("RunService").RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPos = player.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPos)
                    if onScreen then
                        espBox.Size = Vector2.new(50, 50)
                        espBox.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 25)
                        espBox.Visible = true
                    else
                        espBox.Visible = false
                    end
                else
                    espBox.Visible = false
                end
            end)
        end)
    end
end

-- Crear ESP para todos los jugadores
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        ESP(player)
    end
end

-- == Aimbot Tab ==
local AimbotSection = AimbotTab:Section("Aimbot Settings")

AimbotSection:Toggle("Enable Aimbot", false, function(state)
    getgenv().AimbotEnabled = state
    print("Aimbot habilitado:", state)
end)

AimbotSection:Keybind("Aimbot Hotkey", Enum.KeyCode.E, function(key)
    getgenv().AimbotKey = key
    print("Aimbot activado con la tecla:", key.Name)
end)

AimbotSection:Slider("Aimbot Sensitivity", 0, 100, 50, function(value)
    getgenv().AimbotSensitivity = value / 100
    print("Sensibilidad del Aimbot:", getgenv().AimbotSensitivity)
end)

-- Función Aimbot
function Aimbot()
    local camera = workspace.CurrentCamera
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == getgenv().AimbotKey and getgenv().AimbotEnabled then
            local closestEnemy = nil
            local shortestDistance = math.huge
            
            for _, enemy in pairs(game.Players:GetPlayers()) do
                if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    local screenPos, onScreen = camera:WorldToViewportPoint(enemy.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestEnemy = enemy
                        end
                    end
                end
            end
            
            -- Ajustar la cámara hacia el enemigo más cercano
            if closestEnemy then
                local targetPos = closestEnemy.Character.HumanoidRootPart.Position
                local targetScreenPos = camera:WorldToViewportPoint(targetPos)
                mousemoveabs(targetScreenPos.X, targetScreenPos.Y)
            end
        end
    end)
end

-- Llamar la función Aimbot
Aimbot()

-- Configuraciones adicionales
Window:SwitchTab(VisualsTab)
