-- Cargar la Biblioteca Poop UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))()
if not Library then
    error("No se pudo cargar la biblioteca PoopLibrary")
end

-- Ventana Principal
local Window = Library:New({Name = "Splix Private Poop UI", Accent = Color3.fromRGB(25, 240, 100)})

-- Página del Aimbot (sin elementos)
local AimbotTab = Window:Page({Name = "Aimbot"})
-- Configuraciones predeterminadas para el Aimbot
local aimbotEnabled = true  -- Aimbot habilitado por defecto
local aimbotSmoothness = 5  -- Suavidad predeterminada
local hitPart = "Head"      -- Parte objetivo predeterminada

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

            -- Aplicar la suavidad del aimbot
            camera.CFrame = camera.CFrame:Lerp(newCFrame, aimbotSmoothness / 30)
        end
    end
end

-- Página de Visuals (sin elementos)
local VisualsTab = Window:Page({Name = "Visuals"})
-- Configuraciones predeterminadas para Visuals
local visualsEnabled = true  -- Visuals habilitados por defecto
local teamCheck = true       -- Verificación de equipo habilitada

-- Función para Dibujar ESP
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

-- Conexión para Actualizar el Aimbot y ESP en Cada Frame
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        AimAtTarget()
    end
    if visualsEnabled then
        DrawESP()
    end
end)

-- Inicializar la Interfaz sin controles
Window:Initialize()
print("Script de Aimbot y Visuals cargado correctamente")
