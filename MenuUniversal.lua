-- Cargar la Biblioteca Poop UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))()
if not Library then
    error("No se pudo cargar la biblioteca PoopLibrary")
end

-- Ventana Principal
local Window = Library:New({Name = "Splix Private Poop UI", Accent = Color3.fromRGB(25, 240, 100)})

-- Página del Aimbot
local AimbotTab = Window:Page({Name = "Aimbot"})
local aimbotEnabled = false
local aimbotKey = Enum.KeyCode.E
local aimbotSmoothness = 1
local hitPart = "Head"

-- Configuración de Keybind para Aimbot
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

-- Configuración de Slider para la suavidad del Aimbot
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

-- Configuración de Dropdown para la parte a apuntar
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

-- Inicializar la Interfaz
Window:Initialize()
print("Script de Aimbot y Visuals cargado correctamente")
