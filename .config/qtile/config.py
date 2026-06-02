import os
import subprocess

import libqtile.resources
from libqtile import bar, hook, layout, widget
from libqtile.config import (
    Click,
    Drag,
    DropDown,
    Group,
    Key,
    Match,
    ScratchPad,
    Screen,
)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
alt = "mod1"
terminal = guess_terminal()

keys = [
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch Terminal"),
    Key([mod, "shift"], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "e", lazy.spawn("nautilus"), desc="Launch File Manager"),
    Key([mod], "b", lazy.spawn("firefox -P 'default'"), desc="Launch Browser"),
    Key([], "print", lazy.spawn("flameshot gui"), desc="Launch Flameshot"),
    Key(
        [mod, "shift"],
        "b",
        lazy.spawn("firefox -P 'work'"),
        desc="Launch Browser",
    ),
    Key(
        [mod],
        "space",
        lazy.spawn("rofi -show combi -modes combi -combi-modes 'window,drun,run'"),
        desc="Launch Rofi",
    ),
    Key(
        [mod, "shift"],
        "space",
        lazy.spawn("rofi -show run"),
        desc="Launch Rofi",
    ),
    Key(
        [mod],
        "v",
        lazy.spawn("rofi-copyq"),
        desc="CopyQ clipboard history",
    ),
    Key([mod], "j", lazy.screen.prev_group(skip_empty=True)),
    Key([mod], "k", lazy.screen.next_group(skip_empty=True)),
    Key([alt], "j", lazy.layout.down(), desc="Move focus down"),
    Key([alt], "k", lazy.layout.up(), desc="Move focus up"),
    Key([alt], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([alt], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([alt], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([alt, "control"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([alt, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([alt, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([alt, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([alt, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([alt, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([alt], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "t",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([alt, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([alt, "control"], "s", lazy.spawn("shutdown now"), desc="Shutdown computer"),
    Key([alt, "control"], "r", lazy.spawn("shutdown -r now"), desc="Reboot computer"),
    # Volume
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"),
        desc="Volume up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"),
        desc="Volume down",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        desc="Mute/unmute",
    ),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        desc="Mute/unmute mic",
    ),
    # Media control
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play/pause"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Next track"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Previous track"),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop"), desc="Stop"),
    # Screen brightness
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn(
            "sh -c 'brightnessctl set +10% >/dev/null; level=$(brightnessctl -m | cut -d, -f4 | tr -d %); notify-send \"Brightness: $level%\"'"
        ),
        desc="Increase brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn(
            "sh -c 'brightnessctl set 10%- >/dev/null; level=$(brightnessctl -m | cut -d, -f4 | tr -d %); notify-send \"Brightness: $level%\"'"
        ),
        desc="Decrease brightness",
    ),
    # Keyboard backlight
    Key(
        [],
        "XF86KbdBrightnessUp",
        lazy.spawn(
            'sh -c \'brightnessctl -d "*::kbd_backlight" set +33% >/dev/null; cur=$(brightnessctl -d "*::kbd_backlight" get); max=$(brightnessctl -d "*::kbd_backlight" max); pct=$((100 * cur / max)); notify-send "Kbd: $pct%"\''
        ),
        desc="Keyboard backlight up",
    ),
    Key(
        [],
        "XF86KbdBrightnessDown",
        lazy.spawn(
            'sh -c \'brightnessctl -d "*::kbd_backlight" set 33%- >/dev/null; cur=$(brightnessctl -d "*::kbd_backlight" get); max=$(brightnessctl -d "*::kbd_backlight" max); pct=$((100 * cur / max)); notify-send "Kbd: $pct%"\''
        ),
        desc="Keyboard backlight down",
    ),
]

regular_groups = [
    Group("1"),
    Group("2"),
    Group("3"),
    Group(
        "4",
        matches=[
            Match(wm_class="jetbrains-toolbox"),
            Match(wm_class="net.lutris.Lutris"),
        ],
    ),
    Group(
        "5",
        matches=[
            Match(wm_class="cs2"),
            Match(wm_class="steam_app_default"),
        ],
    ),
    Group(
        "6",
        matches=[
            Match(wm_class="vlc"),
        ],
    ),
    Group("7"),
    Group(
        "8",
        matches=[
            Match(wm_class="steam"),
            Match(wm_class="libreoffice-startcenter"),
        ],
    ),
    Group("9"),
    Group("0", label="10"),
]
scratchpad_groups = ScratchPad(
    "scratchpad",
    [
        DropDown(
            "term",
            ["kitty"],
            height=0.8,
            width=1.0,
            x=0.0,
            y=0.0,
            opacity=0.85,
            on_focus_lost_hide=False,
            warp_pointer=False,
        ),
        DropDown(
            "volumecontrol",
            ["pavucontrol"],
            height=0.8,
            width=1.0,
            x=0.0,
            y=0.0,
            opacity=0.85,
            on_focus_lost_hide=False,
            warp_pointer=False,
        ),
    ],
)

groups = regular_groups + [scratchpad_groups]

for i in regular_groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(toggle=True),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

keys.extend(
    [
        Key(
            [mod],
            "p",
            lazy.group["scratchpad"].dropdown_toggle("term"),
            desc="Toggle dropdown terminal",
        ),
        Key(
            [mod, "shift"],
            "v",
            lazy.group["scratchpad"].dropdown_toggle("volumecontrol"),
            desc="Toggle dropdown volume control",
        ),
    ]
)

layout_theme = {
    "border_width": 2,
    "margin": [4, 4, 2, 4],  # top, right, bottom, left
    "border_focus": "#ffffff",
    "border_normal": "#000000",
}

layouts = [
    layout.Columns(**layout_theme),
    # layout.Max(**layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.Zoomy(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Stack(**layout_theme, num_stacks=2),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=18,
    padding=3,
)
extension_defaults = widget_defaults.copy()

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screens = [
    Screen(
        bottom=bar.Bar(
            [
                # ==================== LEFT SECTION ====================
                widget.CurrentLayout(padding_x=20),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.GroupBox(),
                widget.Prompt(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.WindowName(max_chars=20),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.TextBox(text="🎵"),
                widget.Mpris2(width=100),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.CPU(format="🧠{load_percent}%"),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.Memory(
                    format="🔥{MemUsed:.1f}/{MemTotal:.1f}GB",
                    measure_mem="G",
                ),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.PulseVolume(
                    fmt="🔊{}",
                ),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.Backlight(
                    format="🔆{percent:2.0%}",
                    backlight_name="intel_backlight",
                    step=5,
                ),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.Battery(format="🔋{char} {percent:2.0%}"),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.Clock(format="📆%d %B %Y %a"),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.Clock(format="🕐%H:%M:%S"),
                widget.Sep(
                    linewidth=2,
                    padding=10,
                ),
                widget.Systray(padding_x=20),
            ],
            margin=[2, 4, 4, 4],
            size=20,
        ),
        background="#000000",
        wallpaper=logo,
        wallpaper_mode="center",
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules: list = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_width=0,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(wm_class="Xdg-desktop-portal-gtk"),
        Match(wm_class=".blueman-manager-wrapped"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
auto_minimize = False
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart")
    subprocess.Popen([script])
