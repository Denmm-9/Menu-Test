-- Cargar la biblioteca Tokyo Lib para la interfaz de usuario
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "Aimbot Config",
    gamename = "My Game"
})

library:init()

-- Variables de Aimbot
local FOVRadius = 100
local HitPart = "Head"
local AimbotEnabled = false
local Smoothness = 0.5
local PredictionX = 0.2
local PredictionY = 0.2

-- Variables de Visuals (ESP)
local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 0)  -- Color inicial por defecto en rojo
local ESPSize = 3

-- Función para activar el Aimbot apuntando al objetivo
local function enableAimbot(target)
    local camera = workspace.CurrentCamera
    local predictedPosition = target.Position + target.Velocity * Vector3.new(PredictionX, PredictionY, 0)
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position:Lerp(predictedPosition, Smoothness))
end

-- Función para encontrar el objetivo dentro del radio de FOV
local function findTarget(radius, hitPart)
    local target
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team then
            local character = player.Character
            if character and character:FindFirstChild(hitPart) then
                local part = character[hitPart]
                local distance = (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
                if distance <= radius then
                    target = part
                    break
                end
            end
        end
    end
    return target
end

-- Crear ventana principal de configuración de Aimbot en la UI
local Window1 = library.NewWindow({
    title = "Aimbot & Visuals Settings | My Game",
    size = UDim2.new(0, 510, 0.6, 6)
})

local Tab1 = Window1:AddTab("Aimbot")
local AimbotSection = Tab1:AddSection("Aimbot Configuration", 1)

-- Opciones de Aimbot en la interfaz
AimbotSection:AddToggle({
    text = "Enable Aimbot",
    state = false,
    flag = "AimbotEnabled",
    callback = function(enabled)
        AimbotEnabled = enabled
        if AimbotEnabled then
            -- Ejecuta la lógica del aimbot mientras esté habilitado
            game:GetService("RunService").RenderStepped:Connect(function()
                if AimbotEnabled then
                    local target = findTarget(FOVRadius, HitPart)
                    if target then
                        enableAimbot(target)
                    end
                end
            end)
        end
    end
})

AimbotSection:AddSlider({
    text = "FOV Radius",
    min = 0,
    max = 1000,
    increment = 1,
    flag = "FOVRadius",
    callback = function(value)
        FOVRadius = value
    end
})

AimbotSection:AddList({
    text = "Hit Part",
    values = {"Head", "Body", "Legs"},
    selected = "Head",
    flag = "HitPart",
    callback = function(value)
        HitPart = value
    end
})

AimbotSection:AddSlider({
    text = "Smoothness",
    min = 0,
    max = 1,
    increment = 0.01,
    flag = "Smoothness",
    callback = function(value)
        Smoothness = value
    end
})

AimbotSection:AddSlider({
    text = "Prediction X",
    min = -1,
    max = 1,
    increment = 0.01,
    flag = "PredictionX",
    callback = function(value)
        PredictionX = value
    end
})

AimbotSection:AddSlider({
    text = "Prediction Y",
    min = -1,
    max = 1,
    increment = 0.01,
    flag = "PredictionY",
    callback = function(value)
        PredictionY = value
    end
})

-- Tab para Visuals
local VisualsTab = Window1:AddTab("Visuals")
local VisualsSection = VisualsTab:AddSection("Visuals Configuration", 1)

-- Opciones de Visuals (ESP)
VisualsSection:AddToggle({
    text = "Enable ESP",
    state = false,
    flag = "ESPEnabled",
    callback = function(enabled)
        ESPEnabled = enabled
        if ESPEnabled then
            -- Agregar ESP a los enemigos
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team then
                    createESP(player)
                end
            end
        else
            -- Remover ESP cuando se desactiva
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end
})

VisualsSection:AddSlider({
    text = "ESP Size",
    min = 1,
    max = 5,
    increment = 1,
    flag = "ESPSize",
    callback = function(value)
        ESPSize = value
    end
})

-- Notificación de carga
local Decimals = 4
local Clock = os.clock()
local Time = (string.format("%." .. tostring(Decimals) .. "f", os.clock() - Clock))
library:SendNotification(("Loaded In " .. tostring(Time)), 6)
