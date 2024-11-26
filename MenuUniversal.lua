-- Cargar la biblioteca Arceus X
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Arceus-X-UI-Library/main/source.lua"))()

-- Crear la ventana del menú
lib:SetTitle("Non")
lib:SetIcon("http://www.roblox.com/asset/?id=9178187770")

-- Variables globales
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Aimbot Variables
local AimbotEnabled = false
local TargetPart = "Head"
local CurrentTarget = nil
local FOVSize = 50
local FOVVisible = false
local FOVColor = Color3.new(1, 1, 1) -- Blanco
local DrawingFOV = Drawing.new("Circle")

-- Chams Variables
local Chams = {}
local ChamsActive = false
local chamsColor = Color3.fromRGB(255, 105, 180)
local chamsTransparency = 0.5

-- ESP Boxes Variables
local ESPBoxes = {}
local ESPEnabled = false

-- TeamCheck Variables
local TeamCheckEnabled = false

-- Funciones auxiliares
local function isValidTarget(player, character)
    if TeamCheckEnabled then
        -- Validar si el jugador pertenece al mismo equipo
        local localPlayer = game.Players.LocalPlayer
        if player.Team == localPlayer.Team then
            return false  -- No es un objetivo válido si pertenece al mismo equipo
        end
    end
    return true  -- El objetivo es válido si pasa la validación del equipo
end

-- Funciones de Aimbot
local previousCameraCFrame = workspace.CurrentCamera.CFrame

local function updateAimbot()
    if AimbotEnabled then
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local mouse = player:GetMouse()

        -- Verificar si la cámara se ha movido
        local cameraMoved = camera.CFrame ~= previousCameraCFrame
        previousCameraCFrame = camera.CFrame

        -- Solo actualizar el objetivo si la cámara se movió
        if cameraMoved then
            -- Verificar si el objetivo actual sigue siendo válido
            if CurrentTarget and (not CurrentTarget.Parent or not CurrentTarget.Parent:FindFirstChild("Humanoid") or CurrentTarget.Parent.Humanoid.Health <= 0) then
                -- El objetivo actual murió o desapareció, buscar un nuevo objetivo
                CurrentTarget = nil
            end

            -- Si no hay objetivo, buscar uno nuevo
            if not CurrentTarget then
                local closestPlayer = nil
                local shortestDistance = math.huge
                local leftSideTarget = nil
                local rightSideTarget = nil

                -- Buscar un nuevo objetivo (sin incluir al LocalPlayer)
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild(TargetPart) then
                        local targetPart = v.Character:FindFirstChild(TargetPart)
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)

                        if onScreen then
                            local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                            local distance = (camera.CFrame.Position - targetPart.Position).Magnitude

                            -- Verificar si el objetivo está dentro del FOV
                            if distanceFromCenter <= DrawingFOV.Radius then
                                -- Dividir la pantalla en dos áreas: izquierda y derecha
                                if screenPos.X < camera.ViewportSize.X / 2 then
                                    -- Objetivo en el lado izquierdo
                                    if not leftSideTarget or distance < shortestDistance then
                                        leftSideTarget = targetPart
                                    end
                                else
                                    -- Objetivo en el lado derecho
                                    if not rightSideTarget or distance < shortestDistance then
                                        rightSideTarget = targetPart
                                    end
                                end

                                -- Actualizar al objetivo más cercano (sin importar el lado)
                                if distance < shortestDistance then
                                    closestPlayer = targetPart
                                    shortestDistance = distance
                                end
                            end
                        end
                    end
                end

                -- Si el jugador está apuntando hacia la izquierda o la derecha, cambiar el objetivo
                if mouse.X < camera.ViewportSize.X / 2 then
                    -- Apuntar al objetivo en el lado izquierdo
                    if leftSideTarget then
                        CurrentTarget = leftSideTarget
                    end
                else
                    -- Apuntar al objetivo en el lado derecho
                    if rightSideTarget then
                        CurrentTarget = rightSideTarget
                    end
                end
            end

            -- Apuntar al objetivo actual si lo encontramos
            if CurrentTarget then
                local aimPosition = CurrentTarget.Position
                -- Sin suavizado (no Lerp)
                camera.CFrame = CFrame.new(camera.CFrame.Position, aimPosition)
            end
        end
    end
end
RunService.RenderStepped:Connect(updateAimbot)




-- Funciones de ESP Boxes
local function createBox(player)
    -- Crear elementos de la caja
    local Box = {
        Frame = Drawing.new("Square"),        -- Borde blanco interior
        OuterFrame = Drawing.new("Square"),   -- Borde negro exterior
        Background = Drawing.new("Square"),
        Shadow = Drawing.new("Square")        -- Sombra negra
    }

    -- Configuración de la caja (fondo oscuro)
    Box.Background.Transparency = 0.2 -- Fondo semitransparente
    Box.Background.Color = Color3.fromRGB(0, 0, 0) -- Fondo oscuro
    Box.Background.Filled = true -- Fondo lleno
    Box.Background.Thickness = 0 -- Sin borde en el fondo

    -- Configuración del borde negro exterior (más grande)
    Box.OuterFrame.Thickness = 1.1 -- Grosor del borde negro exterior
    Box.OuterFrame.Color = Color3.fromRGB(0, 0, 0) -- Color negro
    Box.OuterFrame.Filled = false -- Solo borde sin fondo

    -- Configuración del borde blanco interior
    Box.Frame.Thickness = 0.8 -- Grosor del borde blanco
    Box.Frame.Color = Color3.fromRGB(255, 255, 255) -- Color blanco
    Box.Frame.Filled = false -- Solo borde sin fondo

    -- Configuración de la sombra
    Box.Shadow.Transparency = 1
    Box.Shadow.Color = Color3.fromRGB(0, 0, 0) -- Sombra negra
    Box.Shadow.Filled = true
    Box.Shadow.Thickness = 0

    -- Guardar en la tabla
    ESPBoxes[player] = Box
end

local function updateBox(player)
    -- Validar si el jugador es válido y no es el jugador local
    if not player or player == LocalPlayer or not player.Character then
        return
    end

    local Box = ESPBoxes[player]
    if not Box then return end

    -- Verificar si el jugador tiene un personaje y está visible
    local character = player.Character
    if character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        local localRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if not localRootPart then return end

        -- Verificamos si el objetivo es válido según los modos
        if not isValidTarget(player, character) then
            Box.Background.Visible = false
            Box.Frame.Visible = false
            Box.OuterFrame.Visible = false
            return
        end

        local Vector, OnScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude -- Distancia basada en la cámara

        if OnScreen then
            -- Ajustar el tamaño según la distancia
            local baseSizeX, baseSizeY = 100, 130 -- Tamaño base de la caja
            local scaleFactor = math.clamp(1 / (distance / 30), 0.1, 2.8) -- Escalar de forma proporcional a la distancia

            local sizeX, sizeY = baseSizeX * scaleFactor, baseSizeY * scaleFactor
            local posX, posY = Vector.X - sizeX / 2, Vector.Y - sizeY / 2.3

            -- Actualizar la posición y tamaño del fondo
            Box.Background.Size = Vector2.new(sizeX, sizeY)
            Box.Background.Position = Vector2.new(posX, posY)
            Box.Background.Visible = true

            -- Actualizar el borde negro exterior (ligeramente más grande)
            Box.OuterFrame.Size = Vector2.new(sizeX + 2, sizeY + 2)
            Box.OuterFrame.Position = Vector2.new(posX - 1, posY - 1)
            Box.OuterFrame.Visible = true

            -- Actualizar el borde blanco interior
            Box.Frame.Size = Vector2.new(sizeX, sizeY)
            Box.Frame.Position = Vector2.new(posX, posY)
            Box.Frame.Visible = true
        else
            -- Si el jugador no está visible, ocultar las cajas
            Box.Background.Visible = false
            Box.Frame.Visible = false
            Box.OuterFrame.Visible = false
        end
    else
        -- Si el personaje no existe, ocultar las cajas
        Box.Background.Visible = false
        Box.Frame.Visible = false
        Box.OuterFrame.Visible = false
    end
end

local function removeBox(player)
    local Box = ESPBoxes[player]
    if Box then
        for _, element in pairs(Box) do
            element:Remove()
        end
        ESPBoxes[player] = nil
    end
end

-- Funciones de Chams
local function createChams(player)
    local character = player and player.Character or nil
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return -- Salir si el personaje no es válido
    end

    if not isValidTarget(player, character) then
        return -- Salir si no cumple las condiciones de los modos
    end

    -- Crear un Highlight si no existe
    if not Chams[player or character] then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character -- Asociar el Highlight al personaje
        highlight.Parent = game.CoreGui -- Evitar problemas con Parenting
        highlight.FillColor = chamsColor -- Color del glow
        highlight.FillTransparency = chamsTransparency -- Transparencia del relleno
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0) -- Contorno negro
        highlight.OutlineTransparency = 0 -- Sin transparencia en el contorno

        -- Guardar el Highlight en la tabla
        Chams[player or character] = highlight
    else
        -- Actualizar Adornee si el Highlight ya existe
        Chams[player or character].Adornee = character
        Chams[player or character].Enabled = true -- Reactivar si estaba desactivado
    end
end


local function updateChams(player)
    local highlight = Chams[player]
    local character = player.Character

    if character and character:FindFirstChild("HumanoidRootPart") and isValidTarget(player, character) then
        if not highlight then
            createChams(player)
        else
            highlight.Adornee = character -- Aseguramos que sigue apuntando al personaje
        end
    else
        if highlight then
            highlight:Destroy()
            Chams[player] = nil
        end
    end
end

local function removeChams(player)
    local highlight = Chams[player or (player and player.Character)]
    if highlight then
        highlight:Destroy() -- Destruir el Highlight
        Chams[player or (player and player.Character)] = nil -- Eliminar referencia en la tabla
    end
end

-- Funciones del FOV
RunService.RenderStepped:Connect(function()
    if FOVVisible then
        -- Asegurarse de que el círculo solo tenga el borde y no el relleno
        DrawingFOV.Visible = true
        DrawingFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        DrawingFOV.Radius = FOVSize
        DrawingFOV.Color = FOVColor
        DrawingFOV.Filled = false  -- No tiene relleno, solo el borde
        DrawingFOV.Thickness = 0.9   -- Grosor del borde (puedes ajustarlo si lo deseas)
    else
        DrawingFOV.Visible = false
    end
end)


-- Inicialización del Menú
lib:AddToggle("Activar Aimbot", function(state)
    AimbotEnabled = state
    if not state then
        CurrentTarget = nil -- Limpiar objetivo al desactivar
    end
end)

lib:AddToggle("Activar FOV", function(state)
    FOVVisible = state
end)

lib:AddComboBox("Tamaño FOV", {"50", "100", "150", "200", "250"}, function(selection)
    FOVSize = tonumber(selection)
end)

lib:AddToggle("Boxes", function(state)
    ESPEnabled = state
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeBox(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createBox(player)
            end
        end
    end
end)

lib:AddToggle("Chams", function(state)
    ChamsActive = state
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeChams(player)
            end
        end
    end
end)

lib:AddToggle("TeamCheck", function(state)
    TeamCheckEnabled = state
end)

-- Listeners para nuevos jugadores
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then createBox(player) end
    if ChamsActive then createChams(player) end
end)

Players.PlayerRemoving:Connect(function(player)
    removeBox(player)
    removeChams(player)
end)

-- Render Stepped para ESP Boxes y Chams
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                updateBox(player)
            end
        end
    end

    if ChamsActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                updateChams(player)
            end
        end
    end
end)
