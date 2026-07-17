#!/usr/bin/env python3
import os
import re
import sys
from pathlib import Path

# Get root directory of the project
SCRIPT_DIR = Path(__file__).resolve().parent
ROOT_DIR = SCRIPT_DIR.parent

DESIGN_PATH = ROOT_DIR / "DESIGN.md"
ACTIVE_SYMLINK_PATH = ROOT_DIR / "themes/active"

def load_design():
    content = DESIGN_PATH.read_text()
    
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

def main():
    design_content, current_theme, light_colors, dark_colors = load_design()
    
    if current_theme == "light":
        new_theme = "dark"
        new_palette = dark_colors
    else:
        new_theme = "light"
        new_palette = light_colors
        
    print(f"Switching theme from {current_theme} to {new_theme}...")
    
    # 1. Update DESIGN.md theme and colors block
    new_design_content = re.sub(
        rf"^theme:\s*{current_theme}",
        f"theme: {new_theme}",
        design_content,
        flags=re.MULTILINE
    )
    
    new_colors_block_lines = ["colors:"]
    for k, v in new_palette.items():
        new_colors_block_lines.append(f'  {k}: "{v}"')
    new_colors_block = "\n".join(new_colors_block_lines)
    
    pattern = r"^colors:\s*\n(?:\s+[\w\-]+:\s*\"?[^\n\"]+\"?\n?)+"
    new_design_content = re.sub(pattern, new_colors_block + "\n", new_design_content, flags=re.MULTILINE)
    
    DESIGN_PATH.write_text(new_design_content)
    print("Updated DESIGN.md active colors.")
    
    # 2. Update symlink themes/active to point to new_theme (relative symlink)
    if ACTIVE_SYMLINK_PATH.exists() or ACTIVE_SYMLINK_PATH.is_symlink():
        ACTIVE_SYMLINK_PATH.unlink()
    ACTIVE_SYMLINK_PATH.symlink_to(new_theme)
    print(f"Updated active theme symlink to point to themes/{new_theme}.")

if __name__ == "__main__":
    main()
