# OpenSCAD Docker Wrapper

A convenient wrapper script to run OpenSCAD from Docker with persistent configuration.

## Features

- **Persistent configuration**: Recent files, preferences, and settings are saved between sessions
- **WSL2/WSLg compatible**: Full GUI support with X11 and Wayland
- **File access**: Mount your working directories automatically
- **Libraries preserved**: BOSL2, NopSCADlib, and other libraries stay in the container

## Installation

### Quick Setup

```bash
# Make the script executable
chmod +x /mnt/c/support/users/MerryKombo/3DDesign/dockerfiles/scripts/openscad-docker.sh

# Create a symlink for easy access (optional)
sudo ln -s /mnt/c/support/users/MerryKombo/3DDesign/dockerfiles/scripts/openscad-docker.sh /usr/local/bin/openscad-docker

# Or add to your PATH in ~/.bashrc
echo 'export PATH="/mnt/c/support/users/MerryKombo/3DDesign/dockerfiles/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### First Run

On first run, the script creates a configuration directory:

```
~/.openscad-docker/
└── config/          # OpenSCAD preferences and recent files
```

## Usage

### Launch GUI

```bash
# Open OpenSCAD GUI
openscad-docker.sh

# Open a specific file
openscad-docker.sh /mnt/c/support/users/MerryKombo/3DDesign/assets/bike/Alves/plot-cadre-velo-1990.scad
```

### Command Line Rendering

```bash
# Render to STL
openscad-docker.sh -o output.stl input.scad

# Render to PNG
openscad-docker.sh --imgsize=1920,1080 -o preview.png model.scad

# Show version
openscad-docker.sh --version

# Show help
openscad-docker.sh --help
```

### Batch Processing

```bash
# Render all SCAD files in current directory
for f in *.scad; do
    openscad-docker.sh -o "${f%.scad}.stl" "$f"
done
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `OPENSCAD_DOCKER_IMAGE` | `gounthar/openscad:test` | Docker image to use |
| `OPENSCAD_CONFIG_DIR` | `~/.openscad-docker` | Where to store persistent config |

### Examples

```bash
# Use a different Docker image
OPENSCAD_DOCKER_IMAGE=gounthar/openscad:master openscad-docker.sh

# Use a different config directory
OPENSCAD_CONFIG_DIR=/tmp/openscad-config openscad-docker.sh
```

## How It Works

### Volume Mounts

The script mounts several volumes:

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `/tmp/.X11-unix` | `/tmp/.X11-unix` | X11 display socket |
| `/mnt/wslg` | `/mnt/wslg` | WSLg Wayland support |
| `/mnt` | `/mnt` | Windows filesystem access |
| `~/.openscad-docker/config` | `/home/openscad/.config/OpenSCAD` | Persistent settings |

### What Gets Persisted

**Saved between sessions:**
- Recent files list
- Window size and position
- Editor preferences
- Rendering settings
- Custom color schemes
- View options

**Stays in container (not persisted):**
- OpenSCAD binary
- Libraries (BOSL2, NopSCADlib, etc.)
- System fonts

This design ensures libraries are always from the Docker image (consistent versions) while user preferences persist.

## Troubleshooting

### Display Issues

**Error: "Cannot open display"**

```bash
# Ensure DISPLAY is set
echo $DISPLAY

# For WSL2, should be something like :0 or localhost:0
export DISPLAY=:0
```

**Black window or no GUI**

```bash
# Check if X server is running
xeye  # Should show animated eyes

# For WSLg, ensure it's enabled
wsl --version  # Requires Windows 11 or Windows 10 with updates
```

### Permission Issues

**Error: "Permission denied" on config directory**

```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.openscad-docker
```

**Error: "Cannot write to file"**

The container runs as user `openscad` (UID 1000). If your files have different ownership:

```bash
# Check your UID
id -u

# If not 1000, you may need to adjust file permissions
chmod 666 yourfile.scad
```

### Docker Issues

**Error: "Docker daemon not running"**

```bash
# Start Docker (WSL2)
sudo service docker start

# Or if using Docker Desktop, launch it from Windows
```

**Error: "Image not found"**

```bash
# Build the image first
cd /mnt/c/support/users/MerryKombo/3DDesign/dockerfiles
docker build -f Dockerfile.new -t gounthar/openscad:test .
```

### Library Issues

**Error: "Cannot find library BOSL2"**

Libraries are in the container at `/home/openscad/.local/share/OpenSCAD/libraries/`. If they're missing:

```bash
# Verify libraries in container
docker run --rm gounthar/openscad:test ls /home/openscad/.local/share/OpenSCAD/libraries/
```

Should show: BOSL2, NopSCADlib, threads-scad, etc.

## Advanced Usage

### Custom Docker Image

Build your own variant:

```bash
# Use production image
OPENSCAD_DOCKER_IMAGE=gounthar/openscad:master openscad-docker.sh

# Use local development image
OPENSCAD_DOCKER_IMAGE=my-openscad:dev openscad-docker.sh
```

### Headless Rendering (CI/CD)

For headless rendering without X11:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  gounthar/openscad:test \
  xvfb-run -a openscad -o /workspace/output.stl /workspace/input.scad
```

### Multiple Configurations

Run different OpenSCAD profiles:

```bash
# Work profile
OPENSCAD_CONFIG_DIR=~/.openscad-work openscad-docker.sh

# Personal profile
OPENSCAD_CONFIG_DIR=~/.openscad-personal openscad-docker.sh
```

## Included Libraries

The Docker image includes these OpenSCAD libraries:

| Library | Description | Usage |
|---------|-------------|-------|
| **BOSL2** | Belfry OpenSCAD Library v2 | `include <BOSL2/std.scad>` |
| **NopSCADlib** | Vitamins (screws, nuts, etc.) | `include <NopSCADlib/vitamins/screws.scad>` |
| **threads-scad** | Thread generation | `use <threads-scad/threads.scad>` |
| **BOLTS** | Standard parts library | `include <BOLTS/BOLTS.scad>` |
| **dotSCAD** | Additional utilities | `use <dotSCAD/...>` |
| **SBC_Model_Framework** | Single-board computer models | `include <SBC_Model_Framework/...>` |
| **funcutils** | Functional utilities | `use <funcutils/...>` |
| **bladegen** | Blade generation | `use <bladegen/...>` |
| **openscad-extra** | Extra utilities | `use <openscad-extra/...>` |

## Comparison with Native OpenSCAD

| Feature | Native | Docker Wrapper |
|---------|--------|----------------|
| Installation | Package manager | Docker image |
| Version | System version (often old) | Latest compiled from source |
| Libraries | Manual install | Pre-installed |
| Config persistence | Automatic | Via mounted volume |
| Experimental features | Usually no | Yes (built with `-DEXPERIMENTAL=1`) |
| Cross-platform | Per-OS install | Same container everywhere |

## Updating

To get the latest OpenSCAD and libraries:

```bash
# Rebuild the Docker image
cd /mnt/c/support/users/MerryKombo/3DDesign/dockerfiles
docker build -f Dockerfile.new -t gounthar/openscad:test --no-cache .
```

Your configuration in `~/.openscad-docker/` is preserved during updates.

## Uninstalling

```bash
# Remove configuration
rm -rf ~/.openscad-docker

# Remove Docker image
docker rmi gounthar/openscad:test

# Remove symlink (if created)
sudo rm /usr/local/bin/openscad-docker
```

## License

Part of the 3DDesign project: https://github.com/MerryKombo/3DDesign
