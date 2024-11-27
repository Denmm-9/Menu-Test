local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Arceus-X-UI-Library/main/source.lua"))()

-- Crear la ventana del menú
lib:SetTitle("Xerereca")
lib:SetIcon("http://www.roblox.com/asset/?id=9178187770")
lib:SetTheme("Aqua")

-- Variables globales
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local hitboxActive = false
local hitboxTransparency = 0.5 
local activeHeadSize = Vector3.new(3, 3, 3) 
local originalHeadSizes = {}



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
        if player.Team == LocalPlayer.Team then
            return false 
        end
    end
    return true 
end

-- Funciones de Aimbot
local function updateAimbot()
    if AimbotEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        local leftSideTarget = nil
        local rightSideTarget = nil

        -- Obtenemos la posición del mouse (en PC)
        local mousePos = UserInputService:GetMouseLocation()
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        -- Buscar un nuevo objetivo
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
                local targetPart = player.Character:FindFirstChild(TargetPart)

                -- Verificar si el jugador es un objetivo válido
                if isValidTarget(player, player.Character) then  -- Solo si pasa la validación
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

                    if onScreen then
                        local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude

                        -- Verificar si el objetivo está dentro del FOV
                        if distanceFromCenter <= DrawingFOV.Radius then
                            if screenPos.X < Camera.ViewportSize.X / 2 then
                                leftSideTarget = targetPart
                            else
                                rightSideTarget = targetPart
                            end

                            if distance < shortestDistance then
                                closestPlayer = targetPart
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end

        -- Cambiar de objetivo según la posición del mouse
        if mousePos.X < Camera.ViewportSize.X / 2 then
            if leftSideTarget then
                CurrentTarget = leftSideTarget
            end
        else
            if rightSideTarget then
                CurrentTarget = rightSideTarget
            end
        end

        -- Apuntar al objetivo actual
        if CurrentTarget then
            local aimPosition = CurrentTarget.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPosition)
        end
    end
end

-- Ejecutar el aimbot cada frame
RunService.RenderStepped:Connect(updateAimbot)


-- Funciones de ESP Boxes
local function createBox(player)
    local Box = {
        Frame = Drawing.new("Square"),       
        OuterFrame = Drawing.new("Square"),  
        Background = Drawing.new("Square"),
        Shadow = Drawing.new("Square")        
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

local function updateHitboxesForAllCharacters()
    -- Recorre todos los jugadores en el juego
    for _, player in pairs(game.Players:GetPlayers()) do
        -- Asegúrate de no modificar al jugador local
        if player ~= game.Players.LocalPlayer and player.Character then
            local character = player.Character
            local head = character:FindFirstChild("Head")

            if head then
                -- Verifica si la hitbox está activa y si el jugador es un objetivo válido
                if hitboxActive and isValidTarget(player, character) then
                    -- Solo ajusta el tamaño de la cabeza si no se ha hecho antes
                    if not originalHeadSizes[head] then
                        originalHeadSizes[head] = head.Size  -- Guarda el tamaño original de la cabeza
                    end

                    -- Aplica el tamaño y la transparencia configurados
                    head.Size = activeHeadSize
                    head.Transparency = hitboxTransparency
                elseif originalHeadSizes[head] then
                    -- Si la hitbox no está activa, restaura el tamaño y la transparencia originales
                    head.Size = originalHeadSizes[head]
                    head.Transparency = 0  -- Restaurar la transparencia original
                    originalHeadSizes[head] = nil  -- Elimina el tamaño original para evitar reiniciar innecesariamente
                end
            end
        end
    end
end

-- Esta función se puede llamar en un bucle de actualización continuo, por ejemplo, dentro de `Heartbeat`
game:GetService("RunService").Heartbeat:Connect(updateHitboxesForAllCharacters)

local function createToggleButton()
    local ScreenGui = Instance.new("ScreenGui")
    local ToggleButton = Instance.new("TextButton")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Personalización del botón
    ToggleButton.Size = UDim2.new(0, 250, 0, 60)  -- Ajusta el tamaño del botón
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)  -- Ajusta la posición del botón
    ToggleButton.Text = "AIMBOT"  -- Texto del botón
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Verde cuando está activado
    
    -- Cambiar el tamaño del texto
    ToggleButton.TextSize = 30  -- Tamaño del texto
    
    -- Función para manejar el Toggle
    ToggleButton.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        if AimbotEnabled then
            ToggleButton.Text = "OFF"  -- Cambia el texto cuando se activa
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Rojo cuando está activado
        else
            ToggleButton.Text = "ON"  -- Cambia el texto cuando se desactiva
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Verde cuando está desactivado
            CurrentTarget = nil  -- Limpiar objetivo cuando el aimbot se desactiva
        end
    end)
end

-- Asegurarse de que el botón se cree cada vez que el jugador respawnee o inicie una nueva partida
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    createToggleButton()  -- Crear el botón cuando el jugador respawnea
end)

-- Crear el botón al inicio (cuando se une al juego por primera vez)
createToggleButton()

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

lib:AddToggle("Hitbox", function(state)
    hitboxActive = state
end)

-- ComboBox para seleccionar Tamaño de Hitbox
lib:AddComboBox("Hitbox Size", {"1", "2", "3", "4", "5"}, function(selection)
    if selection == "2" then
        activeHeadSize = Vector3.new(2, 2, 2)  
    elseif selection == "3" then
        activeHeadSize = Vector3.new(3, 3, 3)  
    elseif selection == "1" then
        activeHeadSize = Vector3.new(1, 1, 1)  
    elseif selection == "4" then
        activeHeadSize = Vector3.new(4, 4, 4) 
    elseif selection == "5" then
        activeHeadSize = Vector3.new(5, 5, 5)  
    end
end)

-- Dropdown para seleccionar Transparencia
lib:AddComboBox("Hitbox Transparency", {"0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1"}, function(selection)
    hitboxTransparency = tonumber(selection) or 0.5  
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

