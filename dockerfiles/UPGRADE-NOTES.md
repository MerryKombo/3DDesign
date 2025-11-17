# Docker Image Upgrade Notes

## Migration to Latest OpenSCAD from Source

### Changes

The new Dockerfile (`Dockerfile.new`) uses a **multi-stage build** approach to leverage the latest OpenSCAD compiled from source instead of the older packaged version from Debian repositories.

### Architecture

```
┌─────────────────────────────────────────┐
│ Stage 1: gounthar/openscad:latest       │
│ - OpenSCAD compiled from source         │
│ - Built with EXPERIMENTAL=1             │
│ - Latest features and bug fixes         │
└────────────┬────────────────────────────┘
             │ Copy /usr/local/bin/openscad
             ▼
┌─────────────────────────────────────────┐
│ Stage 2: debian:trixie-20251103-slim    │
│ + OpenSCAD binary from Stage 1          │
│ + User management (openscad:1000)       │
│ + OpenSCAD libraries (BOSL2, etc.)      │
│ + GitHub CLI                            │
│ + Technical fonts (Osifont)             │
│ + Build scripts                         │
└─────────────────────────────────────────┘
```

### Benefits

1. **Latest OpenSCAD version** - Compiled from source with experimental features enabled
2. **Better threading support** - Latest BOSL2 threading improvements
3. **Faster rendering** - Performance optimizations from latest codebase
4. **Same project tools** - All libraries and scripts preserved
5. **Smaller layers** - Multi-stage build reduces final image size

### Key Differences

| Aspect | Old Dockerfile | New Dockerfile |
|--------|---------------|----------------|
| OpenSCAD source | Debian package (old) | Compiled from source (latest) |
| Base image | `debian:trixie-20250908-slim` | Multi-stage from `gounthar/openscad:latest` |
| Experimental features | No | Yes (`-DEXPERIMENTAL=1`) |
| Python venv | Global pip install | Isolated venv in `/opt/venv` |
| Build approach | Single stage | Multi-stage |

### Testing the New Image

#### 1. Build the new image locally

```bash
cd dockerfiles
docker build -f Dockerfile.new -t gounthar/openscad:test .
```

#### 2. Test interactive GUI (WSL2)

```bash
docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /mnt/wslg:/mnt/wslg \
  -v /mnt:/mnt \
  -e DISPLAY \
  -e WAYLAND_DISPLAY \
  -e XDG_RUNTIME_DIR \
  -e PULSE_SERVER \
  gounthar/openscad:test
```

Should open OpenSCAD GUI successfully.

#### 3. Test headless rendering

```bash
cd /mnt/c/support/users/MerryKombo/3DDesign

# Test PNG rendering
docker run --rm \
  -v $(pwd):/home/openscad/projects \
  gounthar/openscad:test \
  xvfb-run -a openscad \
    --imgsize=1920,1080 \
    -o /home/openscad/projects/test.png \
    /home/openscad/projects/assets/bike/Alves/plot-cadre-velo-1990.scad

# Test STL export
docker run --rm \
  -v $(pwd):/home/openscad/projects \
  gounthar/openscad:test \
  openscad \
    -o /home/openscad/projects/test.stl \
    /home/openscad/projects/assets/bike/Alves/plot-cadre-velo-1990.scad
```

#### 4. Test BOSL2 threading

```bash
docker run --rm \
  -v $(pwd):/home/openscad/projects \
  gounthar/openscad:test \
  openscad \
    --info \
    /home/openscad/projects/assets/bike/Alves/plot-cadre-velo-1990.scad
```

Should not show any library import errors.

#### 5. Verify OpenSCAD version

```bash
docker run --rm gounthar/openscad:test openscad --version
```

Should show a recent version (likely 2024.11 or newer).

### Migration Checklist

- [ ] Build new image locally: `docker build -f Dockerfile.new -t gounthar/openscad:test .`
- [ ] Test GUI mode with WSL2 X11 forwarding
- [ ] Test headless PNG rendering (xvfb)
- [ ] Test STL export
- [ ] Verify BOSL2 libraries are accessible
- [ ] Test threading module (plot-cadre-velo-1990.scad)
- [ ] Check OpenSCAD version is recent
- [ ] Test binary generation workflow: `bash dockerfiles/scripts/generate-binaries.sh`
- [ ] Verify CI/CD pipeline compatibility
- [ ] Update GitHub Actions workflow to use new image tag

### Rollout Strategy

1. **Phase 1: Local testing** (current)
   - Build as `gounthar/openscad:test`
   - Test all use cases locally
   - Verify binary generation works

2. **Phase 2: Branch-specific deployment**
   - Update `Dockerfile.new` → `Dockerfile`
   - Push to feature branch
   - GitHub Actions builds `gounthar/openscad:feature-branch-name`
   - Test automated binary generation

3. **Phase 3: Production rollout**
   - Merge to `master`
   - GitHub Actions builds `gounthar/openscad:master`
   - Binaries generated with new OpenSCAD version
   - Monitor for rendering differences

### Potential Issues & Solutions

#### Issue: Python scripts fail

**Cause:** Venv not in PATH

**Solution:** Already handled in Dockerfile with symlinks:
```dockerfile
ln -s /opt/venv/bin/colorama /usr/local/bin/
ln -s /opt/venv/bin/codespell /usr/local/bin/
```

#### Issue: Libraries not found

**Cause:** User permissions or PATH

**Solution:** Verify with:
```bash
docker run --rm gounthar/openscad:test \
  ls -la /home/openscad/.local/share/OpenSCAD/libraries/
```

#### Issue: Threading renders differently

**Cause:** BOSL2 version differences

**Solution:** This is expected - newer BOSL2 may have improved threading. Review and update models if needed.

#### Issue: Slower build times

**Cause:** Multi-stage build downloads gounthar/openscad:latest

**Solution:** This is expected. Build cache helps on subsequent builds.

### Reverting

If issues occur, revert by:

```bash
git checkout HEAD -- dockerfiles/Dockerfile
docker build -t gounthar/openscad:master dockerfiles/
```

### Questions?

- Check OpenSCAD compilation flags: Lines 31-34 in `/mnt/c/support/users/MerryKombo/openscad/Dockerfile`
- Review multi-stage build docs: https://docs.docker.com/build/building/multi-stage/
- Test rendering differences between versions
