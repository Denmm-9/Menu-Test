-- Créditos a xz#1111 por la fuente
-- Cargando la Abyss Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Abyss%20Lib/Abyss%20Lib%20Source.lua"))()
end)

-- Verificamos si se cargó correctamente la librería
if not success or not Library then
    warn("No se pudo cargar la Abyss Library. Verifica la URL o tu conexión.")
    return
end

-- Inicializando la librería
local LoadTime = tick()

-- Crear el loader principal
local Loader = Library.CreateLoader(
    "Tu Título Aquí", 
    Vector2.new(300, 300) -- Tamaño del Loader
)

-- Crear ventana principal
local Window = Library.Window(
    "Texto Aquí", 
    Vector2.new(500, 620) -- Tamaño de la Ventana
)

-- Notificación inicial
Window.SendNotification(
    "Normal", -- Tipos posibles: Normal, Warning, Error
    "Presiona RightShift para abrir/cerrar el menú.", 
    10 -- Duración en segundos
)

-- Mostrar watermark
Window.Watermark("Texto del Watermark Aquí")

-- Creación de Tab y Sección
local Tab1 = Window:Tab("Tab1")
local Section1 = Tab1:Section("Section1", "Left")

-- Agregar un Toggle con Keybind
Section1:Toggle({
    Title = "Toggle1", 
    Flag = "Toggle_1",
    Type = "Dangerous",
    Callback = function(v)
        print("Toggle 1 activado:", v)
    end
}):Keybind({
    Title = "KeybindToggle1",
    Flag = "Keybind_Toggle_1", 
    Key = Enum.KeyCode.RightShift, -- Puedes cambiar a otra tecla si deseas
    StateType = "Toggle"
})

-- Segundo Toggle con Colorpicker
Section1:Toggle({
    Title = "Toggle2", 
    Flag = "Toggle_2"
}):Colorpicker({
    Color = Library.Theme.Accent[2], 
    Flag = "Toggle2Color"
})

-- Slider en la sección
Section1:Slider({
    Title = "Slider1", 
    Flag = "Slider_1", 
    Symbol = "", 
    Default = 0, 
    Min = 0, 
    Max = 20, 
    Decimals = 1,
    Callback = function(v)
        print("Valor del Slider =", v)
    end
})

-- Dropdown en la sección
Section1:Dropdown({
    Title = "Dropdown1", 
    List = {"1", "2" ,"3"}, 
    Default = "1", 
    Flag = "Dropdown_1",
    Callback = function(v)
        print("Seleccionado del Dropdown =", v)
    end
})

-- Botón en la sección
Section1:Button({
    Title = "Button1",
    Callback = function()
        print("Botón presionado!")
    end
})

-- Añadir pestaña de configuración por defecto y aplicar animación
Window:AddSettingsTab()
Window:SwitchTab(Tab1)
Window.ToggleAnime(false)

-- Medir tiempo de carga
LoadTime = math.floor((tick() - LoadTime) * 1000)
print("Interfaz cargada en", LoadTime, "ms")
