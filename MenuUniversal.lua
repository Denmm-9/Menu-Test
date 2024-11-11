-- // Cargar la Biblioteca Splix
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua"))()
if not Library then
    error("No se pudo cargar la biblioteca PoopLibrary")
end

-- // Variables y Ventana Principal
local Window = Library:New({Name = "Splix Private Poop UI", Accent = Color3.fromRGB(25, 240, 100)})
local menuVisible = true  -- Control de visibilidad del menú

-- // Función para mostrar/ocultar el menú
local function toggleMenu()
    menuVisible = not menuVisible
    Window:SetVisible(menuVisible)
end

-- // Pestañas Principales
local AimbotTab = Window:Page({Name = "Aimbot"})
local VisualsTab = Window:Page({Name = "Visuals"})
local SettingsTab = Window:Page({Name = "Settings"})

-- // Secciones de Aimbot
local Aimbot_Main = AimbotTab:Section({Name = "Main", Side = "Left"})
local Aimbot_Extra = AimbotTab:Section({Name = "Extra", Side = "Right"})

-- // Configuración del Aimbot
local aimbotEnabled = false
Aimbot_Main:Toggle({
    Name = "Enabled",
    Default = false,
    Pointer = "AimbotMain_Enabled",
    Callback = function(value)
        aimbotEnabled = value
        print("Aimbot habilitado:", aimbotEnabled)
    end
})

Aimbot_Main:Keybind({
    Default = Enum.KeyCode.E,
    KeybindName = "Aimbot Key",
    Mode = "Hold",
    Pointer = "AimbotMain_Bind",
    Callback = function()
        if aimbotEnabled then
            -- Aquí se ejecuta el código del Aimbot
            print("Aimbot activado")
            -- Agrega aquí el código de apuntado (targeting) según tus necesidades
        end
    end
})

Aimbot_Main:Slider({
    Name = "Smoothness",
    Minimum = 1,
    Maximum = 30,
    Default = 1,
    Decimals = 0.1,
    Pointer = "AimbotMain_Smoothness",
    Callback = function(value)
        print("Smoothness:", value)
        -- Aquí ajusta la suavidad del apuntado (aimbot smoothness)
    end
})

Aimbot_Main:Multibox({
    Name = "Hit-Part",
    Minimum = 1,
    Options = {"Head", "Torso", "Arms", "Legs"},
    Default = {"Head"},
    Pointer = "AimbotMain_Hitpart",
    Callback = function(selected)
        print("Partes objetivo:", table.concat(selected, ", "))
        -- Aquí selecciona las partes del cuerpo a apuntar
    end
})

Aimbot_Extra:Keybind({
    Name = "Readjustment",
    Default = Enum.UserInputType.MouseButton2,
    KeybindName = "Readjustment",
    Mode = "Hold",
    Pointer = "AimbotExtra_Readjustment",
    Callback = function()
        if aimbotEnabled then
            print("Reajuste del Aimbot activado")
            -- Agrega el código para reajustar el aimbot
        end
    end
})

Aimbot_Extra:Dropdown({
    Name = "Aimbot-Type",
    Options = {"Relative", "Absolute", "Camera", "Camera Relative"},
    Default = "Relative",
    Pointer = "AimbotExtra_Type",
    Callback = function(value)
        print("Tipo de Aimbot:", value)
        -- Aquí puedes ajustar el tipo de aimbot
    end
})

Aimbot_Extra:Colorpicker({
    Name = "Locking-Color",
    Info = "Aimbot Locked Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255, 0, 0),
    Pointer = "AimbotExtra_Color",
    Callback = function(color)
        print("Color de bloqueo del Aimbot:", color)
        -- Ajusta el color de bloqueo del aimbot
    end
})

-- // Configuración de Visuals
local Visuals_Enemies, Visuals_Teammates, Visuals_Self = VisualsTab:MultiSection({
    Sections = {"Enemies", "Teammates", "Self"},
    Side = "Left",
    Size = 200
})

-- Configuración de Visuals para Enemigos
Visuals_Enemies:Toggle({
    Name = "Box-Esp",
    Default = false,
    Pointer = "VisualsEnemies_BoxEsp",
    Callback = function(value)
        print("Box ESP para enemigos:", value)
        -- Aquí agrega el código para el ESP de cajas
    end
})

Visuals_Enemies:Toggle({
    Name = "Team Check",
    Default = false,
    Pointer = "VisualsEnemies_TeamCheck",
    Callback = function(value)
        print("Chequeo de equipo:", value)
    end
})

-- // Configuración de Hotkey en Settings
Settings_Main = SettingsTab:Section({Name = "Main", Side = "Left"})
Settings_Main:Keybind({
    Name = "Toggle Menu",
    Default = Enum.KeyCode.Delete,
    KeybindName = "Menu Toggle",
    Callback = toggleMenu  -- Llamar la función para mostrar/ocultar el menú
})

-- // Unload con Funcionalidad Completa
Settings_Main:Button({
    Name = "Unload",
    Callback = function()
        Window:Unload()
        print("Interfaz descargada")
        -- Limpiar recursos
        Library = nil
        Window = nil
        AimbotTab, VisualsTab, SettingsTab = nil, nil, nil
    end
})

-- // Inicializar la Interfaz
Window:Initialize()
print("Interfaz inicializada")
