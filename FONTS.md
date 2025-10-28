# Font Usage in OpenSCAD Files

## Background

This project previously used **Isonorm 3098**, a commercial technical font designed for ISO/DIN 3098 standard technical drawings. However, as a commercial font, it cannot be freely distributed in open-source Docker images.

## Current Font Solution: Osifont

The Docker image now uses **Osifont** as the primary font - an open-source ISO 3098 / DIN 3098 compliant alternative:

### Osifont - Primary Font

**Osifont** is specifically designed to conform to the ISO 3098 technical drawing specification:

- **Standard Compliance**: Explicitly conforms to ISO 3098 / DIN 3098
- **License**: GPL v3/v2/LGPL v3 with **font exception**
  - Documents created using Osifont don't inherit GPL restrictions
  - Safe for commercial and open-source projects
- **Package**: `fonts-osifont` in Debian/Ubuntu repositories
- **Format**: TrueType (TTF)
- **Language Support**: 39 languages including English, German, French, Spanish
- **Development**: Actively maintained on GitHub
- **Purpose**: Created specifically to provide free CAD software with standards-compliant fonts

### Additional Fonts Included

**Routed Gothic** - Technical drawing fallback:
- Based on Leroy Lettering templates (mid-20th century technical drawings)
- SIL Open Font License 1.1
- Authentic technical drawing appearance
- Available in multiple widths and styles

**Liberation Sans** - General fallback:
- SIL Open Font License
- Excellent for general technical labels
- Professional, clean appearance

All fonts are:
- Freely licensed and open-source
- Included in Debian repositories (no external downloads needed)
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

**For ISO 3098 compliant technical labels (BEST CHOICE):**
```openscad
font = "osifont:style=Regular";
```

**For vintage technical drawing style:**
```openscad
font = "Routed Gothic:style=Regular";
```

**For general labels:**
```openscad
font = "Liberation Sans:style=Regular";
```

**With automatic fallback chain:**
```openscad
font = "osifont:style=Regular,Routed Gothic:style=Regular,Liberation Sans:style=Regular";
```

## Files Using Font Rendering

The following files currently specify "Isonorm 3098":
- `assets/kluster/generic-bracket.scad`
- `assets/kluster/raspberry-pi-3-b-plus.scad`
- `assets/Server Rack/1U/parts/label.scad`

These files will continue to work without modification due to OpenSCAD's font fallback mechanism. When "Isonorm 3098" is not found, OpenSCAD will automatically use available system fonts. With Osifont installed, labels will now render with ISO 3098 compliant lettering.

## Alternative Technical Fonts

If you need different font characteristics, consider these other free alternatives:

| Font | Characteristics | ISO 3098 Compliance | Installation |
|------|-----------------|---------------------|--------------|
| **Osifont** | ISO 3098 compliant technical drawing | ✅ YES | `apt-get install fonts-osifont` |
| **Routed Gothic** | Leroy Lettering, vintage technical | Authentic style | `apt-get install fonts-routed-gothic` |
| **Relief SingleLine** | Single-line for CNC/engraving | Special purpose | Manual install from GitHub |
| **Liberation Sans** | Clean, professional appearance | No | `apt-get install fonts-liberation2` |
| **Source Code Pro** | Adobe's technical font | No | `apt-get install fonts-source-code-pro` |
| **Hack** | Clear distinction between chars | No | `apt-get install fonts-hack` |
| **DejaVu Sans** | Excellent Unicode coverage | No | `apt-get install fonts-dejavu` |

### Relief SingleLine (For CNC/Engraving)
If your technical drawings need to be machine-engraved or processed by CNC equipment:
- **License**: Open Font License (OFL)
- **Format**: OpenType-SVG for Adobe apps, TTF for CAD software
- **Design**: Based on Adrian Frutiger's Vectora typeface
- **Use Case**: Single-line/open-path font for CNC, laser engraving, pen plotting

## Testing Font Rendering

To verify which fonts are available in your OpenSCAD environment:

```bash
# Check for Osifont (ISO 3098 compliant)
fc-list | grep -i osifont

# Check for Routed Gothic
fc-list | grep -i "routed gothic"

# Check for Liberation Sans
fc-list | grep -i liberation
```

In OpenSCAD, test font rendering:
```openscad
// Test ISO 3098 compliant font
text("Test Label 123", font="osifont:style=Regular");

// Test vintage technical style
text("Test Label 123", font="Routed Gothic:style=Regular");

// Test general fallback
text("Test Label 123", font="Liberation Sans:style=Regular");
```

## Commercial Isonorm 3098

If you have a legitimate license for Isonorm 3098:
1. Install the font manually in your local system
2. The existing `.scad` files will use it automatically
3. For Docker builds, mount the font as a volume or copy during build

**Note**: Do not commit commercial fonts to the repository.
