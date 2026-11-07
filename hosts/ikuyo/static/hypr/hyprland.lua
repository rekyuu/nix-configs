local monitorL = "HDMI-A-1"
local monitorC = "DP-1"
local monitorR = "DP-2"

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/configuring/core/monitors/
hl.monitor({
    output   = monitorL,
    mode     = "2560x2880@60",
    position = "0x0",
    scale    = "1.0",
})

hl.monitor({
    output   = monitorC,
    mode     = "3440x1440@144",
    position = "2560x1440",
    scale    = "1.0",
})

hl.monitor({
    output   = monitorR,
    mode     = "2560x2880@60",
    position = "6000x0",
    scale    = "1.0",
})

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/configuring/core/autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
hl.on("hyprland.start", function ()
    -- hl.exec_cmd("xrandr --output \"${monitorC}\" --primary --preferred")
    -- hl.exec_cmd("xdg-portal-init.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("waypaper --restore")
    hl.exec_cmd("gammastep -O 4500")
    hl.exec_cmd("fcitx5 -d -r")
    hl.exec_cmd("Telegram")
    hl.exec_cmd("discord.sh")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("firefox")
    hl.exec_cmd("steam")
    hl.exec_cmd("kitty --class=btop btop")
    hl.exec_cmd("wl-paste --type text --watch clipboard.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("NIXOS_OZONE_WL", "1")

hl.env("XCURSOR_SIZE", "24")
-- hl.env("GTK_THEME", "Adwaita-dark")
hl.env("QT_QPA_PLATFORMTHEME", "adwaita-dark")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 3,

        col = {
            active_border   = { colors = {"rgb(FFFFFF)", "rgb(4587C3)"}, angle = 45 },
            inactive_border = "rgb(4E5160)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        rounding_power = 3,

        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 25,
            render_power = 3,
            color = 0xCC1A1A1A,
            color_inactive = 0x771A1A1A
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 4.79, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/configuring/core/rules/workspace-rules/
hl.workspace_rule({
    workspace = "1",
    persistent = true,
    monitor = monitorL
})

hl.workspace_rule({
    workspace = "4",
    persistent = true,
    monitor = monitorL
})

hl.workspace_rule({
    workspace = "7",
    persistent = true,
    monitor = monitorL
})

hl.workspace_rule({
    workspace = "2",
    persistent = true,
    monitor = monitorC,
    layout = "scrolling"
})

hl.workspace_rule({
    workspace = "5",
    persistent = true,
    monitor = monitorC,
    layout = "scrolling"
})

hl.workspace_rule({
    workspace = "8",
    persistent = true,
    monitor = monitorC,
    layout = "scrolling"
})

hl.workspace_rule({
    workspace = "3",
    persistent = true,
    monitor = monitorR
})

hl.workspace_rule({
    workspace = "6",
    persistent = true,
    monitor = monitorR
})

hl.workspace_rule({
    workspace = "9",
    persistent = true,
    monitor = monitorR
})

hl.config({
    -- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
    dwindle = {
        preserve_split = true, -- You probably want this
        force_split = 2
    },

    -- See https://wiki.hypr.land/configuring/layouts/scrolling-layout/ for more
    scrolling = {
        fullscreen_on_one_column = true,
        column_width = 0.5,
        focus_fit_method = 1,
        explicit_column_widths = "0.25, 0.333, 0.5, 0.667, 0.75, 1.0",
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        numlock_by_default = true,

        follow_mouse = 2,
        float_switch_override_focus = 0,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Example binds, see https://wiki.hypr.land/configuring/core/binds/ for more
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("ALT + SHIFT + F4", hl.dsp.window.close())
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -modi drun,run -show run -m " .. monitorC))
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("rofi-power-menu.sh"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("rofi-screenshot-menu.sh"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))

hl.bind("PRINT", hl.dsp.exec_cmd("screenshot-hyprland.sh desktop"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("screenshot-hyprland.sh selection"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("screenshot-hyprland.sh active-window"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("screenshot-hyprland.sh selection-video"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("media-control-with-cooldown.sh next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("media-control-with-cooldown.sh toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("media-control-with-cooldown.sh toggle"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("media-control-with-cooldown.sh cdprev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("mpc-toggle-random.sh"), { locked = true })

local numpadKeys = {
    [1] = "KP_End",
    [2] = "KP_Down",
    [3] = "KP_Next",
    [4] = "KP_Left",
    [5] = "KP_Begin",
    [6] = "KP_Right",
    [7] = "KP_Home",
    [8] = "KP_Up",
    [9] = "KP_Prior",
}

-- Since the workspace order is reversed, the top/bottom rows of the numpad are swapped
local workspaceMap = {
    [1] = "7",
    [2] = "8",
    [3] = "9",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "1",
    [8] = "2",
    [9] = "3",
}

for i, numpadKey in pairs(numpadKeys) do
    hl.bind("SUPER + " .. numpadKey, hl.dsp.focus({ workspace = workspaceMap[i] }))
    hl.bind("SUPER + SHIFT + " .. numpadKey, hl.dsp.window.move({ workspace = workspaceMap[i], follow = false }))
end

-- Scrolling layout keybinds
hl.bind("SUPER + LEFT", hl.dsp.layout("focus l"))
hl.bind("SUPER + RIGHT", hl.dsp.layout("focus r"))
-- hl.bind("SUPER + LEFT", hl.dsp.layout("move -col"))
-- hl.bind("SUPER + RIGHT", hl.dsp.layout("move +col"))
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.layout("swapcol r"))

hl.bind("SUPER + UP", hl.dsp.layout("colresize +conf"))
hl.bind("SUPER + DOWN", hl.dsp.layout("colresize -conf"))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.layer_rule {
    name = "no-anim-for-selection",
    match = { namespace = "selection" },
    no_anim = true,
}

-- See https://wiki.hypr.land/configuring/core/rules/
local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "center-floating-windows",
    match = { float = true },
    center = true,
})

hl.window_rule({
    name = "blender",

    match = {
        class = "^blender$",
    },

    monitor = monitorC,
    scrolling_width = 1.0,
})

hl.window_rule({
    name = "blender",

    match = {
        class = "^blender$",
        title = "^File Browser$",
    },

    size = { 1280, 720 },
    center = true,
})

hl.window_rule({
    name = "blender-render",

    match = {
        class = "^blender$",
        title = "^Blender Render$"
    },

    float = true,
    size = { 1920, 1080 },
    center = true,
})

hl.on("window.title", function(w)
    if w ~= nil and w.title == "Blender Render" then
        hl.dispatch(hl.dsp.window.float({ window = w, action = "set" }))
        hl.dispatch(hl.dsp.window.resize({ window = w, x = 1920, y = 1080, relative = false }))
        hl.dispatch(hl.dsp.window.center({ window = w }))
    end
end)

hl.window_rule({
    name = "btop",

    match = {
        class = "^btop$",
    },

    workspace = workspaceMap[1],
})

hl.window_rule({
    name = "discord",

    match = {
        class = "^(discord)|(vesktop)$",
    },

    workspace = workspaceMap[1],
})

hl.window_rule({
    name = "gamescope",

    match = {
        class = "^gamescope$",
    },

    monitor = monitorC,
    fullscreen = true,
})

hl.window_rule({
    name = "gnome-calculator",

    match = {
        class = "^org.gnome.Calculator$",
    },

    float = true,
})

hl.window_rule({
    name = "gnome-nautilus",

    match = {
        class = "^org.gnome.Nautilus$",
    },

    float = true,
    center = true,
    size = { 970, 590 },
})

hl.window_rule({
    name = "firefox",

    match = {
        class = "^firefox$",
    },

    workspace = workspaceMap[3],
})

hl.window_rule({
    name = "retroarch",

    match = {
        class = "^org.libretro.RetroArch$",
    },

    monitor = monitorC,
    fullscreen = true,
})

hl.window_rule({
    name = "steam",

    match = {
        class = "^steam$",
        title = "^Steam$"
    },

    workspace = workspaceMap[5],
    scrolling_width = 0.85,
})

hl.window_rule({
    name = "steam",

    match = {
        class = "^steam$",
        title = "^Friends List$"
    },

    workspace = workspaceMap[5],
    scrolling_width = 0.15,
})

hl.window_rule({
    name = "telegram",

    match = {
        class = "^org.telegram.desktop$",
    },

    workspace = workspaceMap[1],
})

hl.window_rule({
    name = "telegram",

    match = {
        class = "^org.telegram.desktop$",
        title = "^Media viewer$"
    },

    workspace = workspaceMap[1],
    float = true,
})

hl.on("window.active", function(w)
    if w ~= nil and w.class == "org.telegram.desktop" then
        local desiredWidth = 600
        local desiredHeight = 1425

        if w.size.x > desiredWidth then
            hl.dispatch(hl.dsp.window.resize({ x = desiredWidth, y = desiredHeight, relative = false }))
        end
    end
end)