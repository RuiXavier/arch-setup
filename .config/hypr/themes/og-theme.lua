hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = {
                colors = {"rgba(cba6f7ff)", "rgba(f2cdcdff)"},
                angle = 45,
            },
            inactive_border = "rgba(313244aa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle"
    },
    decoration = {
        rounding = 16,
        active_opacity = 0.95,
        shadow = {
            enabled = true,
            range = 25,
            render_power = 3,
            color = "rgba(11111baa)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true,
            ignore_opacity = true,
            vibrancy = 0.1696
        }
    },
    dwindle = {
        preserve_split = true
    },
    master = {
        new_status = "master"
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false
    },
    input = {
        kb_layout = "pt",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true
        }
    },
    cursor = {
        no_hardware_cursors = true
    }
})