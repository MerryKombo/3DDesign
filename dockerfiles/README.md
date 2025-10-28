# OpenSCAD Docker Image

Multi-architecture Docker image for OpenSCAD with comprehensive 3D modeling libraries, designed for automated rendering of 3D models in CI/CD pipelines.

## Quick Start

```bash
# Pull the latest master branch image
docker pull gounthar/openscad:master

# Render an STL file from a SCAD file
docker run -v $(pwd):/workspace gounthar/openscad:master \
  openscad -o /workspace/output.stl /workspace/input.scad

# Render a PNG preview image
docker run -v $(pwd):/workspace gounthar/openscad:master \
  xvfb-run -a openscad --imgsize=1920,1080 \
  -o /workspace/output.png /workspace/input.scad
```

## Features

- **Multi-architecture**: Supports `linux/amd64` and `linux/arm64`
- **Headless rendering**: Includes Xvfb for PNG generation without display
- **Comprehensive libraries**: Pre-installed with popular OpenSCAD libraries
- **CI/CD optimized**: Designed for GitHub Actions workflows
- **Branch-based tags**: Each branch gets its own image tag

## Included Libraries

- **BOSL2**: Advanced constructive solid geometry operations
- **NopSCADlib**: Hardware component library (screws, nuts, PCBs, etc.)
- **threads-scad**: Thread generation for screws and bolts
- **BOLTS**: Standard parts library
- **dotSCAD**: Additional utilities
- **SBC_Model_Framework**: Single-board computer models

## Available Tags

Images are automatically built for each branch:

- `gounthar/openscad:master` - Latest stable version from master branch
- `gounthar/openscad:fosdem-2025` - FOSDEM 2025 event-specific builds
- `gounthar/openscad:<branch-name>` - Any active development branch

## Usage Examples

### Basic STL Rendering

```bash
docker run --rm \
  -v $(pwd):/workspace \
  gounthar/openscad:master \
  openscad -o /workspace/model.stl /workspace/model.scad
```

### High-Quality PNG Preview

```bash
docker run --rm \
  -v $(pwd):/workspace \
  gounthar/openscad:master \
  xvfb-run -a openscad --imgsize=3840,2160 \
  -o /workspace/preview.png /workspace/model.scad
```

### Batch Processing with Timeout

```bash
docker run --rm \
  -v $(pwd):/workspace \
  gounthar/openscad:master \
  bash -c 'for f in /workspace/*.scad; do \
    timeout 300 openscad -o "${f}.stl" "$f"; \
  done'
```

## CI/CD Integration

This image is used in GitHub Actions workflows for automated binary generation:

```yaml
jobs:
  render:
    runs-on: ubuntu-latest
    container:
      image: gounthar/openscad:master
      options: --user root  # Required for git operations and file permissions in Actions
    steps:
      - uses: actions/checkout@v5
      - name: Render models
        run: |
          find . -name "*.scad" -exec openscad -o {}.stl {} \;
```

**Note on `--user root`**: This is required in GitHub Actions when using `actions/checkout` because the action needs write permissions to the workspace. For standalone Docker usage without git operations, you can omit this option and run as the default `openscad` user for better security.

## Build Information

- **Base Image**: Debian Bookworm Slim
- **Platforms**: linux/amd64, linux/arm64
- **Build Frequency**:
  - On every push to any branch
  - Scheduled daily at 4:30 and 16:30 UTC
  - On pull requests
- **Source Repository**: [MerryKombo/3DDesign](https://github.com/MerryKombo/3DDesign)
- **Dockerfile Location**: `dockerfiles/Dockerfile`

## Performance Considerations

### Resolution vs Speed

PNG rendering time scales exponentially with resolution:

- **1920x1080**: ~30 seconds per file (recommended for CI/CD)
- **3840x2160** (4K): ~10 minutes per file
- **7680x4320** (8K): 20+ minutes per file

### Timeout Recommendations

- **STL files**: 300 seconds (5 minutes)
- **PNG files** (1920x1080): 180 seconds (3 minutes)
- **PNG files** (4K): 600 seconds (10 minutes)

### Optimization Tips

1. Use `--imgsize=1920,1080` for reasonable render times
2. Add `timeout` command to prevent infinite hangs
3. Set appropriate `$fn` values in SCAD files (50-100 for production)
4. Consider parallel processing with GNU Parallel or xargs -P

## Environment Variables

- `DISPLAY`: Set by Xvfb for headless rendering
- `HOME`: `/home/openscad`
- `WORKSPACE`: `/workspace` (recommended mount point)

## Support & Issues

- **Project Issues**: [GitHub Issues](https://github.com/MerryKombo/3DDesign/issues)
- **Docker Hub**: [gounthar/openscad](https://hub.docker.com/r/gounthar/openscad)
- **Source Code**: [GitHub Repository](https://github.com/MerryKombo/3DDesign)

## License

See the [source repository](https://github.com/MerryKombo/3DDesign) for license information.

## Maintenance

This image is actively maintained and automatically rebuilt on:
- Dockerfile changes
- Dependency updates
- Scheduled builds (daily)

Last updated: 2025-10-28
