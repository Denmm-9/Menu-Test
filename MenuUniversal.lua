-- Carga la Jan Library
loadstring(game:HttpGet('https://garfieldscripts.xyz/ui-libs/janlib.lua'))()

-- Inicializar la biblioteca
local library = JanLib:Create({
    Name = "My Custom Script",
    SizeX = 600,
    SizeY = 400,
    Theme = "Dark"
})

-- [Legit Tab]
local LegitTab = library:AddTab("Legit")

-- Aim Assist Section
local LegitMain = LegitTab:AddSection("Aim Assist")
LegitMain:AddToggle("AimbotEnabled", {Text = "Enabled"})
LegitMain:AddSlider("AimbotFov", {Text = "Aimbot FOV", Min = 0, Max = 750, Default = 105})
LegitMain:AddSlider("Smoothing", {Text = "Smoothing Factor", Min = 0, Max = 30, Default = 3})
LegitMain:AddDropdown("AimbotHitbox", {Text = "Hit Box", Options = {"Head", "Torso"}})
LegitMain:AddDropdown("AimbotKey", {Text = "Aimbot Key", Options = {"On Aim", "On Shoot"}})
LegitMain:AddToggle("CircleEnabled", {Text = "Draw Fov", Default = false})
LegitMain:AddColorPicker("CircleColor", {Text = "Fov Color", Default = Color3.new(1, 1, 1)})
LegitMain:AddSlider("CircleNumSides", {Text = "Num Sides", Min = 3, Max = 48, Default = 48})

-- Extend Hitbox Section
local LegitSecond = LegitTab:AddSection("Extend Hitbox")
LegitSecond:AddToggle("HitboxEnabled", {Text = "Enabled"})
LegitSecond:AddDropdown("ExtendHitbox", {Text = "Hit Box", Options = {"Head", "Torso"}})
LegitSecond:AddSlider("ExtendRate", {Text = "Extend Rate", Min = 0, Max = 10, Default = 10})

-- Trigger Bot Section
local LegitThird = LegitTab:AddSection("Trigger Bot")
LegitThird:AddToggle("TriggerEnabled", {Text = "Enabled"})
LegitThird:AddKeybind("TriggerBind", {Text = "Trigger Key", Default = Enum.KeyCode.One})
LegitThird:AddSlider("TriggerSpeed", {Text = "Trigger Speed", Min = 0, Max = 1000, Default = 10})

-- Bullet Redirection Section
local LegitForth = LegitTab:AddSection("Bullet Redirection")
LegitForth:AddToggle("SilentAimEnabled", {Text = "Enabled"})
LegitForth:AddSlider("SilentAimFOV", {Text = "Silent Aim FOV", Min = 0, Max = 750, Default = 105})
LegitForth:AddSlider("HitChances", {Text = "Hit Chances", Min = 0, Max = 100, Default = 100})
LegitForth:AddDropdown("RedirectionMode", {Text = "Redirection Mode", Options = {"P Mode", "Normal Mode"}})
LegitForth:AddDropdown("SilentAimHitbox", {Text = "Hit Box", Options = {"Head", "Torso"}})
LegitForth:AddToggle("Circle2Enabled", {Text = "Draw Fov"})
LegitForth:AddColorPicker("Circle2Color", {Text = "Fov Color", Default = Color3.new(1, 1, 1)})
LegitForth:AddSlider("Circle2NumSides", {Text = "Num Sides", Min = 3, Max = 48, Default = 48})
LegitForth:AddToggle("VisibleCheck", {Text = "Visible Check"})

-- Recoil Control Section
local LegitFifth = LegitTab:AddSection("Recoil Control")
LegitFifth:AddToggle("RecoilControlEnabled", {Text = "Enabled"})
LegitFifth:AddSlider("ModelKick", {Text = "Model Kick", Min = 5, Max = 100, Default = 100})
LegitFifth:AddSlider("CameraKick", {Text = "Camera Kick", Min = 5, Max = 100, Default = 100})

-- [Visuals Tab]
local VisualsTab = library:AddTab("Visuals")

-- Local Visuals Section
local VisualsMain = VisualsTab:AddSection("Local Visuals")
VisualsMain:AddToggle("LocalVisualsEnabled", {Text = "Enabled"})
VisualsMain:AddColorPicker("ArmColor", {Text = "Custom Arm Color", Default = Color3.new(0.6, 0.45, 0.97)})
VisualsMain:AddSlider("ArmTransparency", {Text = "Transparency", Min = 0.10, Max = 0.95, Default = 0.85})
VisualsMain:AddDropdown("ArmMaterial", {Text = "Material", Options = {"ForceField", "Neon", "SmoothPlastic"}})

-- Camera Visuals Section
local VisualsSecond = VisualsTab:AddSection("Camera Visuals")
VisualsSecond:AddToggle("CameraVisualsEnabled", {Text = "Enabled"})
VisualsSecond:AddSlider("CameraFOV", {Text = "Camera FOV", Min = 10, Max = 120, Default = 120})
VisualsSecond:AddToggle("NoCameraBob", {Text = "No Camera Bob"})
VisualsSecond:AddToggle("NoGunBob", {Text = "No Gun Bob"})

-- [Settings Tab]
local SettingsTab = library:AddTab("Settings")
local SettingsSection = SettingsTab:AddSection("Menu")
SettingsSection:AddKeybind("UIToggle", {Text = "Toggle UI", Default = Enum.KeyCode.End, Callback = function()
    library:ToggleUI()
end})

SettingsSection:AddColorPicker("MenuColor", {Text = "Accent Color", Default = Color3.new(0.6, 0.45, 0.97)})

-- Initialize Library
library:Initialize()
