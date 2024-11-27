function ZepwjdcBLsuEQSxtMiuZwwoVxkXBlxDRdexeVjCTgicjIuAJlGUGuEALUDyoZopKmdFpeLtmcSyyGlTXuSLJCUIEoMTrpf(c)
tab={}
for i = 1,#c do
x=string.len(c[i]) 
y=string.char(x)
table.insert(tab,y)
end
x=table.concat(tab)
return x
end 


function bSOIWgCqoWuvMbYesOqKgctsJG(code)res=ZepwjdcBLsuEQSxtMiuZwwoVxkXBlxDRdexeVjCTgicjIuAJlGUGuEALUDyoZopKmdFpeLtmcSyyGlTXuSLJCUIEoMTrpf({})for i in ipairs(code)do res=res..string.char(code[i]/105)end return res end 


local lib = loadstring(game:HttpGet(bSOIWgCqoWuvMbYesOqKgctsJG({10920,12180,12180,11760,12075,6090,4935,4935,11970,10185,12495,4830,10815,11025,12180,10920,12285,10290,12285,12075,10605,11970,10395,11655,11550,12180,10605,11550,12180,4830,10395,11655,11445,4935,6825,9450,9345,12075,7455,11025,12180,10920,12285,10290,4935,6825,11970,10395,10605,12285,12075,4725,9240,4725,8925,7665,4725,7980,11025,10290,11970,10185,11970,12705,4935,11445,10185,11025,11550,4935,12075,11655,12285,11970,10395,10605,4830,11340,12285,10185})))()

-- Crear la ventana del menú
lib:SetTitle(bSOIWgCqoWuvMbYesOqKgctsJG({9240,10605,11970,10605,11970,10605,10395,10185}))
lib:SetIcon(bSOIWgCqoWuvMbYesOqKgctsJG({10920,12180,12180,11760,6090,4935,4935,12495,12495,12495,4830,11970,11655,10290,11340,11655,12600,4830,10395,11655,11445,4935,10185,12075,12075,10605,12180,4935,6615,11025,10500,6405,5985,5145,5775,5880,5145,5880,5775,5775,5775,5040}))
lib:SetTheme(bSOIWgCqoWuvMbYesOqKgctsJG({6825,11865,12285,10185}))

-- Variables globales
local Players = game:GetService(bSOIWgCqoWuvMbYesOqKgctsJG({8400,11340,10185,12705,10605,11970,12075}))
local RunService = game:GetService(bSOIWgCqoWuvMbYesOqKgctsJG({8610,12285,11550,8715,10605,11970,12390,11025,10395,10605}))
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService(bSOIWgCqoWuvMbYesOqKgctsJG({8925,12075,10605,11970,7665,11550,11760,12285,12180,8715,10605,11970,12390,11025,10395,10605}))
local hitboxActive = false
local hitboxTransparency = 0.5 
local activeHeadSize = Vector3.new(3, 3, 3) 
local originalHeadSizes = {}



-- Aimbot Variables
local AimbotEnabled = false
local TargetPart = bSOIWgCqoWuvMbYesOqKgctsJG({7560,10605,10185,10500})
local CurrentTarget = nil
local FOVSize = 50
local FOVVisible = false
local FOVColor = Color3.new(1, 1, 1) -- Blanco
local DrawingFOV = Drawing.new(bSOIWgCqoWuvMbYesOqKgctsJG({7035,11025,11970,10395,11340,10605}))

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
        Frame = Drawing.new(bSOIWgCqoWuvMbYesOqKgctsJG({8715,11865,12285,10185,11970,10605})),       
        OuterFrame = Drawing.new(bSOIWgCqoWuvMbYesOqKgctsJG({8715,11865,12285,10185,11970,10605})),  
        Background = Drawing.new(bSOIWgCqoWuvMbYesOqKgctsJG({8715,11865,12285,10185,11970,10605})),
        Shadow = Drawing.new(bSOIWgCqoWuvMbYesOqKgctsJG({8715,11865,12285,10185,11970,10605}))        
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
    if character:FindFirstChild(bSOIWgCqoWuvMbYesOqKgctsJG({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
        local rootPart = character.HumanoidRootPart
        local localRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(bSOIWgCqoWuvMbYesOqKgctsJG({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180}))
        
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
    if not character or not character:FindFirstChild(bSOIWgCqoWuvMbYesOqKgctsJG({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) then
        return -- Salir si el personaje no es válido
    end

    if not isValidTarget(player, character) then
        return -- Salir si no cumple las condiciones de los modos
    end

    -- Crear un Highlight si no existe
    if not Chams[player or character] then
        local highlight = Instance.new(bSOIWgCqoWuvMbYesOqKgctsJG({7560,11025,10815,10920,11340,11025,10815,10920,12180}))
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

    if character and character:FindFirstChild(bSOIWgCqoWuvMbYesOqKgctsJG({7560,12285,11445,10185,11550,11655,11025,10500,8610,11655,11655,12180,8400,10185,11970,12180})) and isValidTarget(player, character) then
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
            local head = character:FindFirstChild(bSOIWgCqoWuvMbYesOqKgctsJG({7560,10605,10185,10500}))

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
game:GetService(bSOIWgCqoWuvMbYesOqKgctsJG({8610,12285,11550,8715,10605,11970,12390,11025,10395,10605})).Heartbeat:Connect(updateHitboxesForAllCharacters)

local ScreenGui = Instance.new(bSOIWgCqoWuvMbYesOqKgctsJG({8715,10395,11970,10605,10605,11550,7455,12285,11025}))
local ToggleButton = Instance.new(bSOIWgCqoWuvMbYesOqKgctsJG({8820,10605,12600,12180,6930,12285,12180,12180,11655,11550}))
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild(bSOIWgCqoWuvMbYesOqKgctsJG({8400,11340,10185,12705,10605,11970,7455,12285,11025}))

-- Personalización de la posición y tamaño del botón (puedes ajustar estos valores)
ToggleButton.Size = UDim2.new(0, 250, 0, 60)  -- Ajusta el tamaño del botón (ancho, alto)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)  -- Ajusta la posición del botón (X, Y) desde la esquina superior izquierda
ToggleButton.Text = bSOIWgCqoWuvMbYesOqKgctsJG({6825,7665,8085,6930,8295,8820})  -- Texto del botón
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Verde cuando está activado

-- Cambiar el tamaño del texto
ToggleButton.TextSize = 30  -- Ajusta este valor para cambiar el tamaño del texto (puedes poner un valor mayor o menor)

-- Función para manejar el Toggle
ToggleButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        ToggleButton.Text = bSOIWgCqoWuvMbYesOqKgctsJG({8295,7350,7350})  -- Cambia el texto cuando se activa
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Rojo cuando está desactivado
    else
        ToggleButton.Text = bSOIWgCqoWuvMbYesOqKgctsJG({8295,8190})  -- Cambia el texto cuando se desactiva
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Verde cuando está activado
        CurrentTarget = nil  -- Limpiar objetivo cuando el aimbot se desactiva
    end
end)




-- Inicialización del Menú
lib:AddToggle(bSOIWgCqoWuvMbYesOqKgctsJG({6825,10395,12180,11025,12390,10185,11970,3360,6825,11025,11445,10290,11655,12180}), function(state)
    AimbotEnabled = state
    if not state then
        CurrentTarget = nil -- Limpiar objetivo al desactivar
    end
end)

lib:AddToggle(bSOIWgCqoWuvMbYesOqKgctsJG({6825,10395,12180,11025,12390,10185,11970,3360,7350,8295,9030}), function(state)
    FOVVisible = state
end)

lib:AddComboBox(bSOIWgCqoWuvMbYesOqKgctsJG({8820,10185,11445,10185,20475,18585,11655,3360,7350,8295,9030}), {bSOIWgCqoWuvMbYesOqKgctsJG({5565,5040}), bSOIWgCqoWuvMbYesOqKgctsJG({5145,5040,5040}), bSOIWgCqoWuvMbYesOqKgctsJG({5145,5565,5040}), bSOIWgCqoWuvMbYesOqKgctsJG({5250,5040,5040}), bSOIWgCqoWuvMbYesOqKgctsJG({5250,5565,5040})}, function(selection)
    FOVSize = tonumber(selection)
end)

lib:AddToggle(bSOIWgCqoWuvMbYesOqKgctsJG({7560,11025,12180,10290,11655,12600}), function(state)
    hitboxActive = state
end)

-- ComboBox para seleccionar Tamaño de Hitbox
lib:AddComboBox(bSOIWgCqoWuvMbYesOqKgctsJG({7560,11025,12180,10290,11655,12600,3360,8715,11025,12810,10605}), {bSOIWgCqoWuvMbYesOqKgctsJG({5145}), bSOIWgCqoWuvMbYesOqKgctsJG({5250}), bSOIWgCqoWuvMbYesOqKgctsJG({5355}), bSOIWgCqoWuvMbYesOqKgctsJG({5460}), bSOIWgCqoWuvMbYesOqKgctsJG({5565})}, function(selection)
    if selection == bSOIWgCqoWuvMbYesOqKgctsJG({5250}) then
        activeHeadSize = Vector3.new(2, 2, 2)  
    elseif selection == bSOIWgCqoWuvMbYesOqKgctsJG({5355}) then
        activeHeadSize = Vector3.new(3, 3, 3)  
    elseif selection == bSOIWgCqoWuvMbYesOqKgctsJG({5145}) then
        activeHeadSize = Vector3.new(1, 1, 1)  
    elseif selection == bSOIWgCqoWuvMbYesOqKgctsJG({5460}) then
        activeHeadSize = Vector3.new(4, 4, 4) 
    elseif selection == bSOIWgCqoWuvMbYesOqKgctsJG({5565}) then
        activeHeadSize = Vector3.new(5, 5, 5)  
    end
end)

-- Dropdown para seleccionar Transparencia
lib:AddComboBox(bSOIWgCqoWuvMbYesOqKgctsJG({7560,11025,12180,10290,11655,12600,3360,8820,11970,10185,11550,12075,11760,10185,11970,10605,11550,10395,12705}), {bSOIWgCqoWuvMbYesOqKgctsJG({5040}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5145}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5250}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5355}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5460}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5565}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5670}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5775}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5880}), bSOIWgCqoWuvMbYesOqKgctsJG({5040,4830,5985}), bSOIWgCqoWuvMbYesOqKgctsJG({5145})}, function(selection)
    hitboxTransparency = tonumber(selection) or 0.5  
end)

lib:AddToggle(bSOIWgCqoWuvMbYesOqKgctsJG({6930,11655,12600,10605,12075}), function(state)
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

lib:AddToggle(bSOIWgCqoWuvMbYesOqKgctsJG({7035,10920,10185,11445,12075}), function(state)
    ChamsActive = state
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeChams(player)
            end
        end
    end
end)

lib:AddToggle(bSOIWgCqoWuvMbYesOqKgctsJG({8820,10605,10185,11445,7035,10920,10605,10395,11235}), function(state)
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

        
