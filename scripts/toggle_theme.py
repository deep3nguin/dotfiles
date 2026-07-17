#!/usr/bin/env python3
import os
import re
import sys
from pathlib import Path

# Get root directory of the project
SCRIPT_DIR = Path(__file__).resolve().parent
ROOT_DIR = SCRIPT_DIR.parent

DESIGN_PATH = ROOT_DIR / "DESIGN.md"

VISUAL_FILES = [
    ROOT_DIR / "hypr/hyprland.lua",
    ROOT_DIR / "waybar/style.css",
    ROOT_DIR / "fuzzel/fuzzel.ini",
    ROOT_DIR / "yazi/theme.toml",
]

def load_design():
    content = DESIGN_PATH.read_text()
    
    # Simple YAML frontmatter parser
    parts = content.split("---")
    if len(parts) < 3:
        raise ValueError("Could not parse YAML frontmatter in DESIGN.md")
        
    frontmatter = parts[1]
    
    theme_match = re.search(r"^theme:\s*(\w+)", frontmatter, re.MULTILINE)
    if not theme_match:
        raise ValueError("Could not find theme in DESIGN.md")
    theme = theme_match.group(1).strip()
    
    def parse_colors(section_name):
        colors = {}
        # Match from section_name at start of line until the next unindented line or section start
        pattern = rf"^{section_name}:\s*\n((?:\s+[\w\-]+:\s*\"?[^\n\"]+\"?\n)+)"
        match = re.search(pattern, frontmatter, re.MULTILINE)
        if not match:
            raise ValueError(f"Could not parse section {section_name} in DESIGN.md")
        for line in match.group(1).splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                k = k.strip()
                v = v.strip().strip('"\'')
                colors[k] = v
        return colors

    light_colors = parse_colors("light-colors")
    dark_colors = parse_colors("dark-colors")
    
    return content, theme, light_colors, dark_colors

def replace_colors_in_content(content, old_palette, new_palette, force_uppercase=False):
    # Step 1: Replace original colors with unique placeholders that encode uppercase and hash status
    for key, old_hex in old_palette.items():
        old_raw = old_hex.strip('#')
        
        def repl_to_placeholder(match):
            val = match.group(0)
            has_hash = '1' if val.startswith('#') else '0'
            is_upper = '1' if (val.strip('#').isupper() or force_uppercase) else '0'
            placeholder = f"__COLOR_TOKEN_{key}_{is_upper}_{has_hash}__"
            return placeholder
            
        pattern = re.compile(r'#?' + re.escape(old_raw), re.IGNORECASE)
        content = pattern.sub(repl_to_placeholder, content)
        
    # Step 2: Replace placeholders with new colors
    for key, new_hex in new_palette.items():
        new_raw = new_hex.strip('#')
        
        pattern = re.compile(rf"__COLOR_TOKEN_{key}_([01])_([01])__")
        
        def repl_from_placeholder(match):
            is_upper = match.group(1) == '1'
            has_hash = match.group(2) == '1'
            res = new_raw.upper() if (is_upper or force_uppercase) else new_raw.lower()
            return '#' + res if has_hash else res
            
        content = pattern.sub(repl_from_placeholder, content)
        
    return content

def main():
    design_content, current_theme, light_colors, dark_colors = load_design()
    
    if current_theme == "light":
        new_theme = "dark"
        old_palette = light_colors
        new_palette = dark_colors
    else:
        new_theme = "light"
        old_palette = dark_colors
        new_palette = light_colors
        
    print(f"Switching theme from {current_theme} to {new_theme}...")
    
    # 1. Update DESIGN.md theme and colors block
    # Replace theme line
    new_design_content = re.sub(
        rf"^theme:\s*{current_theme}",
        f"theme: {new_theme}",
        design_content,
        flags=re.MULTILINE
    )
    
    # Replace colors section under colors:
    new_colors_block_lines = ["colors:"]
    for k, v in new_palette.items():
        new_colors_block_lines.append(f'  {k}: "{v}"')
    new_colors_block = "\n".join(new_colors_block_lines)
    
    pattern = r"^colors:\s*\n(?:\s+[\w\-]+:\s*\"?[^\n\"]+\"?\n?)+"
    new_design_content = re.sub(pattern, new_colors_block + "\n", new_design_content, flags=re.MULTILINE)
    
    DESIGN_PATH.write_text(new_design_content)
    print("Updated DESIGN.md active colors.")
    
    # 2. Update all visual/config files
    for file_path in VISUAL_FILES:
        if not file_path.exists():
            print(f"Warning: file {file_path} does not exist.")
            continue
            
        content = file_path.read_text()
        force_uppercase = file_path.name in ["fuzzel.ini", "hyprland.lua"]
        new_content = replace_colors_in_content(content, old_palette, new_palette, force_uppercase=force_uppercase)
        
        # Special case for waybar style.css rgba background color
        if file_path.name == "style.css":
            if new_theme == "dark":
                new_content = new_content.replace("rgba(23, 23, 23, 0.86)", "rgba(254, 255, 252, 0.86)")
            else:
                new_content = new_content.replace("rgba(254, 255, 252, 0.86)", "rgba(23, 23, 23, 0.86)")
                
        file_path.write_text(new_content)
        print(f"Updated colors in {file_path.relative_to(ROOT_DIR)}")

if __name__ == "__main__":
    main()
