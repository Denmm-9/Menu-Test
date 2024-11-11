-- // Cargar la Biblioteca Splix
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))()

-- // Variables y Ventana Principal
local Window = Library:New({Name = "Splix Private Poop UI", Accent = Color3.fromRGB(25, 240, 100)})
local menuVisible = true  -- Control de visibilidad del menú

-- // Pestañas Principales
local AimbotTab = Window:Page({Name = "Aimbot"})
local VisualsTab = Window:Page({Name = "Visuals"})
local SettingsTab = Window:Page({Name = "Settings"})

-- // Secciones de Aimbot
local Aimbot_Main = AimbotTab:Section({Name = "Main", Side = "Left"})
local Aimbot_Extra = AimbotTab:Section({Name = "Extra", Side = "Right"})

-- // Configuración de Visuals
local Visuals_Enemies, Visuals_Teammates, Visuals_Self = VisualsTab:MultiSection({
    Sections = {"Enemies", "Teammates", "Self"},
    Side = "Left",
    Size = 200
})

-- // Sección de Configuración en Settings
local Settings_Main = SettingsTab:Section({Name = "Main", Side = "Left"})

-- // Aimbot Configuraciones Iniciales (Asegurarse de que están desactivadas)
Aimbot_Main:Toggle({Name = "Enabled", Default = false, Pointer = "AimbotMain_Enabled"})
:Keybind({Default = Enum.KeyCode.E, KeybindName = "Aimbot", Mode = "Hold", Pointer = "AimbotMain_Bind"})

Aimbot_Main:Slider({Name = "Smoothness", Minimum = 1, Maximum = 30, Default = 1, Decimals = 0.1, Pointer = "AimbotMain_Smoothness"})
Aimbot_Main:Multibox({Name = "Hit-Part", Minimum = 1, Options = {"Head", "Torso", "Arms", "Legs"}, Default = {"Head"}, Pointer = "AimbotMain_Hitpart"})

Aimbot_Extra:Keybind({Name = "Readjustment", Default = Enum.UserInputType.MouseButton2, KeybindName = "Readjustment", Mode = "Hold", Pointer = "AimbotExtra_Readjustment"})
Aimbot_Extra:Dropdown({Name = "Aimbot-Type", Options = {"Relative", "Absolute", "Camera", "Camera Relative"}, Default = "Relative", Pointer = "AimbotExtra_Type"})
Aimbot_Extra:Colorpicker({Name = "Locking-Color", Info = "Aimbot Locked Color", Alpha = 0.5, Default = Color3.fromRGB(255, 0, 0), Pointer = "AimbotExtra_Color"})

-- // Visuals Configuración (Iniciar en `false`)
local VisualsEnemies_BoxEsp = Visuals_Enemies:Toggle({Name = "Box-Esp", Default = false, Pointer = "VisualsEnemies_BoxEsp"})
VisualsEnemies_BoxEsp:Colorpicker({Info = "ESP-Box Color", Alpha = 0.75, Default = Color3.fromRGB(200, 200, 200), Pointer = "VisualsEnemies_BoxColor"})
VisualsEnemies_BoxEsp:Colorpicker({Info = "ESP-Box Visible Color", Alpha = 0.25, Default = Color3.fromRGB(200, 100, 100), Pointer = "VisualsEnemies_BoxVisibleColor"})

Visuals_Enemies:Toggle({Name = "Team Check", Default = false, Pointer = "VisualsEnemies_TeamCheck"})
Visuals_Enemies:Toggle({Name = "Box", Default = false, Pointer = "VisualsEnemies_Box"})
Visuals_Enemies:Toggle({Name = "Health Bar", Default = false, Pointer = "VisualsEnemies_HealthBar"})
Visuals_Enemies:Toggle({Name = "Name Tag", Default = false, Pointer = "VisualsEnemies_NameTag"})

Visuals_Self:Toggle({Name = "Enabled", Default = false, Pointer = "VisualsSelf_Enabled"})

-- // Configuración de Hotkey en Settings
Settings_Main:Keybind({
    Name = "Toggle Menu",
    Default = Enum.KeyCode.Delete,
    KeybindName = "Menu Toggle",
    Callback = function()
        menuVisible = not menuVisible
        Window:SetVisible(menuVisible)
    end
})

-- // Configuración para guardar y cargar configuración
Settings_Main:ConfigBox({})
Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
Settings_Main:Label({Name = "Unloading cerrará completamente la interfaz.\nGuardar configuración antes de descargar.", Middle = true})

-- // Unload con Funcionalidad Completa
Settings_Main:Button({
    Name = "Unload",
    Callback = function()
        Window:Unload()
        -- Aquí eliminamos el menú y limpiamos recursos si es necesario
        Library = nil
        Window = nil
        AimbotTab, VisualsTab, SettingsTab = nil, nil, nil
    end
})

-- // Inicializar la Interfaz
Window:Initialize()
