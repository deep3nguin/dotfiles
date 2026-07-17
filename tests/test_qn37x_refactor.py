from pathlib import Path
import os
import re
import stat


ROOT = Path(__file__).resolve().parents[1]

DOMAIN_SCOPES = {
    "Agent-Hypr": {
        "hypr/hyprland.lua",
        "hypr/keybinds.lua",
        "hypr/monitors.lua",
        "hypr/autostart.lua",
        "hypr/rules.lua",
        "hypr/animations.lua",
    },
    "Agent-Waybar": {"waybar/config.jsonc", "waybar/style.css"},
    "Agent-Fuzzel": {"fuzzel/fuzzel.ini"},
    "Agent-Hyprpaper": {"hypr/hyprpaper.conf", "scripts/wallpaper.sh"},
    "Agent-Yazi": {"yazi/yazi.toml", "yazi/theme.toml", "yazi/keymap.toml"},
}

REFACTORED_FILES = sorted(set().union(*DOMAIN_SCOPES.values()) | {"install.sh", "README.md"})
VISUAL_FILES = [
    "hypr/hyprland.lua",
    "waybar/style.css",
    "fuzzel/fuzzel.ini",
    "yazi/theme.toml",
]

STALE_NAMES = ("Purple", "Mint", "Peach", "growth-green", "action-cyan", "surface-dark", "surface-medium", "surface-bright")
STALE_COLORS = (
    "#0B0B0C",
    "#F0F5F5",
    "#0053D6",
    "#A261FF",
    "#D4FFED",
    "#FFEACC",
    "#FFDB13",
    "0B0B0C",
    "F0F5F5",
    "0053D6",
    "A261FF",
    "D4FFED",
    "FFEACC",
    "FFDB13",
    "#00FF8A",
    "#00BFD6",
    "#121F1C",
    "#0C1614",
    "#121414",
    "00FF8A",
    "00BFD6",
    "121F1C",
    "0C1614",
    "121414",
)


def read(path: str) -> str:
    content = (ROOT / path).read_text()
    if path == "fuzzel/fuzzel.ini" and "include=" in content:
        # Resolve path relative to home or just read fuzzel/colors.ini in repo
        colors_file = ROOT / "fuzzel/colors.ini"
        if colors_file.exists():
            content = re.sub(r"include=.*colors\.ini", colors_file.read_text(), content)
    elif path == "waybar/style.css" and '@import "colors.css"' in content:
        colors_file = ROOT / "waybar/colors.css"
        if colors_file.exists():
            content = content.replace('@import "colors.css";', colors_file.read_text())
    elif path == "hypr/hyprland.lua":
        colors_file = ROOT / "hypr/colors.lua"
        if colors_file.exists():
            colors_text = colors_file.read_text()
            for m in re.finditer(r'(\w+)\s*=\s*"([^"]+)"', colors_text):
                var_name, val = m.groups()
                # Resolve active_border colors
                pattern = re.compile(r'"rgba\("\s*\.\.\s*colors\.' + var_name + r'\s*\.\.\s*"([fF]{2})"\)')
                content = pattern.sub(lambda match: f'"rgba({val}{match.group(1)})"', content)
                # Resolve inactive_border
                pattern_single = re.compile(r'"rgba\("\s*\.\.\s*colors\.' + var_name + r'\s*\.\.\s*"([fF]{2})"\)')
                content = pattern_single.sub(lambda match: f'"rgba({val}{match.group(1)})"', content)
    return content


def design_tokens() -> dict[str, str]:
    tokens: dict[str, str] = {}
    section = None
    for raw in read("DESIGN.md").splitlines():
        line = raw.rstrip()
        if line in {"colors:", "typography:", "rounded:", "spacing:"}:
            section = line[:-1]
            continue
        if line and not line.startswith(" ") and not line.startswith("-"):
            section = None
        if section and raw.startswith("  ") and ":" in line:
            key, value = line.strip().split(":", 1)
            value = value.strip().strip("'\"")
            if value:
                tokens[f"{section}.{key}"] = value
    return tokens


def hex_no_hash(value: str) -> str:
    return value.strip("#").upper()


def test_design_md_is_the_only_design_source_for_refactored_visual_tokens():
    tokens = design_tokens()
    assert (ROOT / "DESIGN.md").exists()
    assert (ROOT / "AGENTS.md").exists()
    assert tokens["colors.primary"] == "#41a1cf"
    assert tokens["colors.primary-dark"] == "#0081c0"

    visual_text = "\n".join(read(path) for path in VISUAL_FILES)
    required = [
        tokens["colors.bg"],
        tokens["colors.ink"],
        tokens["colors.primary"],
        tokens["colors.primary-dark"],
        tokens["colors.border"],
        tokens["colors.bg-alt"],
        tokens["colors.danger"],
    ]
    for token in required:
        assert token in visual_text or hex_no_hash(token) in visual_text.upper()

    assert "af" in visual_text


def test_domain_agents_stay_within_exclusive_write_scope():
    assert "DESIGN.md" not in set().union(*DOMAIN_SCOPES.values())
    assert "AGENTS.md" not in set().union(*DOMAIN_SCOPES.values())
    for agent, allowed in DOMAIN_SCOPES.items():
        for path in allowed:
            assert (ROOT / path).exists(), f"{agent} allowed file missing: {path}"
        if agent == "Agent-Hypr":
            assert "hypr/hyprpaper.conf" not in allowed
        if agent != "Agent-Waybar":
            assert not any(path.startswith("waybar/") for path in allowed)
        if agent != "Agent-Fuzzel":
            assert not any(path.startswith("fuzzel/") for path in allowed)
        if agent != "Agent-Yazi":
            assert not any(path.startswith("yazi/") for path in allowed)


def test_workspace_cap_is_preserved_in_hyprland_and_waybar():
    combined = read("hypr/keybinds.lua") + "\n" + read("waybar/config.jsonc")
    for workspace in range(1, 6):
        assert re.search(rf"workspace\s*=\s*{workspace}\b", combined) or str(workspace) in read("waybar/config.jsonc")
    assert not re.search(r"workspace\s*=\s*([6-9]|\d{2,})\b", combined)
    assert '"*": [1, 2, 3, 4, 5]' in read("waybar/config.jsonc")
    assert not re.search(r'"persistent-workspaces".*\b([6-9]|\d{2,})\b', read("waybar/config.jsonc"), re.S)


def test_waybar_uses_qn37x_visual_language():
    css = read("waybar/style.css")
    config = read("waybar/config.jsonc")
    tokens = design_tokens()
    assert "rgba(23, 23, 23, 0.86)" in css or "rgba(254, 255, 252, 0.86)" in css
    assert 'font-family: af, "Helvetica Neue", Arial, sans-serif;' in css or 'font-family: "af"' in css or 'font-family: af' in css
    assert tokens["colors.primary"] in css
    assert tokens["colors.ink"] in css
    assert tokens["colors.border"] in css
    assert tokens["colors.primary-dark"] in css
    assert tokens["colors.danger"] in css
    assert tokens["colors.primary-tint"] in css
    for value in ("4px", "8px", "12px", "16px", "24px", "50px"):
        assert value in css or value in config
    assert "backdrop-filter: blur" in css


def test_fuzzel_uses_qn37x_launcher_styling():
    ini = read("fuzzel/fuzzel.ini")
    tokens = design_tokens()
    assert f"background={hex_no_hash(tokens['colors.bg-alt'])}DD" in ini
    assert f"text={hex_no_hash(tokens['colors.ink'])}FF" in ini
    assert f"match={hex_no_hash(tokens['colors.primary-dark'])}FF" in ini
    assert f"selection={hex_no_hash(tokens['colors.primary'])}FF" in ini
    assert "horizontal-pad=24" in ini
    assert "vertical-pad=16" in ini
    assert "radius=16" in ini


def test_hyprland_window_styling_matches_design_system():
    hypr = read("hypr/hyprland.lua")
    tokens = design_tokens()
    assert f"rgba({hex_no_hash(tokens['colors.primary'])}ff)" in hypr
    assert f"rgba({hex_no_hash(tokens['colors.primary-dark'])}ff)" in hypr
    assert f"rgba({hex_no_hash(tokens['colors.border'])}ff)" in hypr
    assert "gaps_in = 8" in hypr
    assert "gaps_out = 16" in hypr
    assert "rounding = 16" in hypr
    assert "blur = {" in hypr and "size = 12" in hypr
    assert "inactive_opacity = 0.92" in hypr


def test_yazi_theme_matches_qn37x_states():
    theme = read("yazi/theme.toml")
    for section in ("[manager]", "[status]", "[input]", "[pick]", "[completion]", "[tasks]", "[help]", "[filetype]"):
        assert section in theme
    tokens = design_tokens()
    assert tokens["colors.primary"] in theme
    assert tokens["colors.primary-dark"] in theme
    assert tokens["colors.danger"] in theme
    assert tokens["colors.primary-tint"] in theme
    assert tokens["colors.bg"] in theme
    assert "af" in read("yazi/yazi.toml")


def test_wallpaper_is_applied_through_delivered_system_path():
    conf = read("hypr/hyprpaper.conf")
    script = ROOT / "scripts/wallpaper.sh"
    wallpaper = str(ROOT / "assets/wallpaper.jpg")
    assert f"preload = {wallpaper}" in conf
    assert f"wallpaper = ,{wallpaper}" in conf
    assert script.stat().st_mode & stat.S_IXUSR
    text = script.read_text()
    assert 'hyprctl hyprpaper preload "$WALLPAPER_PATH"' in text
    assert 'hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"' in text


def test_installer_applies_refactor_to_local_system():
    install = read("install.sh")
    for package in (
        "hyprland",
        "hyprpaper",
        "waybar",
        "fuzzel",
        "yazi",
        "kitty",
        "wl-clipboard",
        "grim",
        "slurp",
        "pavucontrol",
        "papirus-icon-theme",
        "noto-fonts",
    ):
        assert package in install
    for path in ("hypr", "waybar", "fuzzel", "yazi"):
        assert f'safe_symlink "{path}" "$XDG_CONFIG_HOME/{path}"' in install
    assert ".bak_${TIMESTAMP}" in install
    assert "DOTFILES_INSTALL_DRY_RUN" in install


def test_delivered_configs_contain_no_unfinished_placeholders():
    forbidden = re.compile(r"\b(TODO|FIXME|PLACEHOLDER|TEMPORARY)\b")
    for path in REFACTORED_FILES:
        assert not forbidden.search(read(path)), path


def test_stale_palette_names_and_old_literal_colors_are_removed():
    text = "\n".join(read(path) for path in REFACTORED_FILES)
    for name in STALE_NAMES:
        assert name not in text
    for color in STALE_COLORS:
        assert color not in text
    assert "DeepMind" not in text
