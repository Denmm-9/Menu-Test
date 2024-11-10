-- Cargar la Librería Splix
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))()

-- Crear Ventana Principal
local Window = Library:New({Name = "Splix Private Poop UI", Accent = Color3.fromRGB(25, 240, 100)})

-- Crear Pestañas
local Aimbot = Window:Page({Name = "Aimbot"})
local Visuals = Window:Page({Name = "Visuals"})
local Settings = Window:Page({Name = "Settings"})

-- Secciones de Aimbot
local Aimbot_Main = Aimbot:Section({Name = "Main", Side = "Left"})
local Aimbot_Extra = Aimbot:Section({Name = "Extra", Side = "Right"})

-- Secciones de Visuals
local Visuals_Enemies, Visuals_Teammates, Visuals_Self = Visuals:MultiSection({
    Sections = {"Enemies", "Teammates", "Self"},
    Side = "Left",
    Size = 200
})

-- Sección de Configuración
local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})

-- Configuración del Aimbot
Aimbot_Main:Toggle({
    Name = "Enabled",
    Default = false,
    Pointer = "AimbotMain_Enabled"
}):Keybind({
    Default = Enum.KeyCode.Delete, -- Tecla para activar/desactivar el menú
    KeybindName = "Open Menu",
    Mode = "Toggle",
    Pointer = "AimbotMain_MenuToggle"
})

Aimbot_Main:Slider({
    Name = "Smoothness",
    Minimum = 1,
    Maximum = 30,
    Default = 1.5,
    Decimals = 0.1,
    Pointer = "AimbotMain_Smoothness"
})

Aimbot_Main:Multibox({
    Name = "Hit-Part",
    Minimum = 1,
    Options = {"Head", "Torso", "Arms", "Legs"},
    Default = {"Head", "Torso"},
    Pointer = "AimbotMain_Hitpart"
})

Aimbot_Extra:Keybind({
    Name = "Readjustment",
    Default = Enum.UserInputType.MouseButton2,
    KeybindName = "Readjustment",
    Mode = "Hold",
    Pointer = "AimbotExtra_Readjustment"
})

Aimbot_Extra:Dropdown({
    Name = "Aimbot-Type",
    Options = {"Relative", "Absolute", "Camera", "Camera Relative"},
    Default = "Relative",
    Pointer = "AimbotExtra_Type"
})

Aimbot_Extra:Colorpicker({
    Name = "Locking-Color",
    Info = "Aimbot Locked Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255, 0, 0),
    Pointer = "AimbotExtra_Color"
})

-- Configuración de Visuals para Enemigos
local VisualsEnemies_BoxEsp = Visuals_Enemies:Toggle({
    Name = "Box-Esp",
    Default = false,
    Pointer = "VisualsEnemies_BoxEsp"
})

VisualsEnemies_BoxEsp:Colorpicker({
    Info = "ESP-Box Color",
    Alpha = 0.75,
    Default = Color3.fromRGB(200, 200, 200),
    Pointer = "VisualsEnemies_BoxColor"
})

VisualsEnemies_BoxEsp:Colorpicker({
    Info = "ESP-Box Visible Color",
    Alpha = 0.25,
    Default = Color3.fromRGB(200, 100, 100),
    Pointer = "VisualsEnemies_BoxVisibleColor"
})

-- Opciones Adicionales para Visuals (Team Check, Box, Health Bar, y Name Tag)
local Visuals_TeamCheck = Visuals_Enemies:Toggle({
    Name = "Team Check",
    Default = false,
    Pointer = "VisualsEnemies_TeamCheck"
})

local Visuals_Box = Visuals_Enemies:Toggle({
    Name = "Box",
    Default = false,
    Pointer = "VisualsEnemies_Box"
})

local Visuals_HealthBar = Visuals_Enemies:Toggle({
    Name = "Health Bar",
    Default = true,
    Pointer = "VisualsEnemies_HealthBar"
})

local Visuals_NameTag = Visuals_Enemies:Toggle({
    Name = "Name Tag",
    Default = true,
    Pointer = "VisualsEnemies_NameTag"
})

-- Función para actualizar los Visuals
game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                -- Verificar si debe dibujarse la caja alrededor del jugador (Box ESP)
                if Library.flags.VisualsEnemies_BoxEsp then
                    -- Dibuja una caja alrededor del personaje enemigo
                    -- Aquí puedes usar tus propias funciones para dibujar la caja en pantalla
                end

                -- Team Check (verifica si el jugador es del equipo contrario)
                if Library.flags.VisualsEnemies_TeamCheck and player.Team == game.Players.LocalPlayer.Team then
                    continue -- Ignora si es del mismo equipo
                end

                -- Dibujar Box
                if Library.flags.VisualsEnemies_Box then
                    -- Aquí iría el código para dibujar una caja en el enemigo
                end

                -- Dibujar Health Bar
                if Library.flags.VisualsEnemies_HealthBar then
                    -- Aquí va el código para dibujar la barra de vida en el enemigo
                end

                -- Dibujar Name Tag
                if Library.flags.VisualsEnemies_NameTag then
                    -- Aquí va el código para mostrar el nombre del enemigo
                end
            end
        end
    end
end)

-- Configuración de Visuals para el Jugador
Visuals_Self:Toggle({
    Name = "Enabled",
    Default = true,
    Pointer = "VisualsSelf_Enabled"
})

-- Configuración de Ajustes Generales
Settings_Main:ConfigBox({})

Settings_Main:ButtonHolder({
    Buttons = {
        {"Load", function() end},
        {"Save", function() end}
    }
})

Settings_Main:Label({
    Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.",
    Middle = true
})

Settings_Main:Button({
    Name = "Unload",
    Callback = function()
        Window:Unload()
    end
})

-- Inicialización de la Ventana
Window:Initialize()
