# Font Usage in OpenSCAD Files

## Background

This project previously used **Isonorm 3098**, a commercial technical font designed for ISO/DIN 3098 standard technical drawings. However, as a commercial font, it cannot be freely distributed in open-source Docker images.

## Current Font Solution

The Docker image now uses **Liberation Sans** and **Inconsolata** as free, open-source alternatives:

- **Liberation Sans**: Excellent for general technical labels, clean appearance
- **Inconsolata**: Monospaced font, ideal for technical text and codes

Both fonts are:
- Freely licensed (SIL Open Font License)
- Included in Debian repositories (no external downloads needed)
- Professionally designed with excellent readability
- Well-supported in OpenSCAD

## Font Fallback in OpenSCAD

OpenSCAD's font resolution works as follows:
1. If "Isonorm 3098" is specified but not found, OpenSCAD falls back to system fonts
2. The fallback typically uses Liberation Sans or DejaVu Sans
3. Labels will render correctly even if the exact font is unavailable

## Updating OpenSCAD Files (Optional)

If you want to explicitly use the new fonts, update your `.scad` files:

### Current usage:
```openscad
font = "Isonorm 3098";
```

### Recommended replacements:

**For general labels:**
```openscad
font = "Liberation Sans:style=Regular";
```

**For monospaced/technical labels:**
```openscad
font = "Inconsolata:style=Regular";
```

**With automatic fallback:**
```openscad
font = "Liberation Sans:style=Regular,Inconsolata:style=Regular";
```

## Files Using Font Rendering

The following files currently specify "Isonorm 3098":
- `assets/kluster/generic-bracket.scad`
- `assets/kluster/raspberry-pi-3-b-plus.scad`
- `assets/Server Rack/1U/parts/label.scad`

These files will continue to work without modification due to OpenSCAD's font fallback mechanism. The rendered labels will use Liberation Sans automatically.

## Alternative Technical Fonts

If you need different font characteristics, consider these other free alternatives:

| Font | Characteristics | Installation |
|------|-----------------|--------------|
| **Source Code Pro** | Adobe's technical font, professional | `apt-get install fonts-source-code-pro` |
| **Hack** | Clear distinction between similar chars | `apt-get install fonts-hack` |
| **DejaVu Sans** | Excellent Unicode coverage | `apt-get install fonts-dejavu` |
| **Roboto Mono** | Modern, clean technical appearance | `apt-get install fonts-roboto` |

## Testing Font Rendering

To verify which fonts are available in your OpenSCAD environment:

```bash
fc-list | grep -i liberation
fc-list | grep -i inconsolata
```

In OpenSCAD, test font rendering:
```openscad
text("Test Label", font="Liberation Sans:style=Regular");
```

## Commercial Isonorm 3098

If you have a legitimate license for Isonorm 3098:
1. Install the font manually in your local system
2. The existing `.scad` files will use it automatically
3. For Docker builds, mount the font as a volume or copy during build

**Note**: Do not commit commercial fonts to the repository.
