# Dockerfile for 3DDesign project
# Based on gounthar/openscad:latest (compiled from source with experimental features)
# Adds project-specific tools, libraries, and scripts

FROM gounthar/openscad:latest

# Define arguments for user, group, uid, and gid
ARG user=openscad
ARG group=openscad
ARG uid=1000
ARG gid=1000

# Define the home directory for the OpenSCAD agent
ARG OPENSCAD_AGENT_HOME=/home/${user}
ENV HOME=${OPENSCAD_AGENT_HOME}

# Copy shell scripts from the local scripts directory to /usr/local/bin in the container
COPY scripts/*.sh /usr/local/bin/

# Switch to root for system installations
USER root

# Create a new group and user with the specified gid and uid, and create necessary directories
# Set the ownership of these directories to the newly created user and group
# Make the shell scripts executable
RUN groupadd -g ${gid} ${group} || true \
    && useradd -d "${OPENSCAD_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}" || true \
    && mkdir -p "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ "${OPENSCAD_AGENT_HOME}"/projects \
    && chown -R "${uid}":"${gid}" "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    && chmod +x /usr/local/bin/*.sh

# Install additional packages not in base image
# GitHub CLI, fonts, and Python tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    imagemagick \
    python3-pip \
    python3-venv \
    rsync \
    xauth \
    xvfb \
    # Technical fonts
    fonts-osifont \
    fonts-liberation2 \
    fonts-routed-gothic \
    && fc-cache -f -v \
    # Python virtual environment
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install colorama codespell markdown \
    # GitHub CLI
    && type -p curl >/dev/null || apt install curl -y \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y \
    && rm -rf /var/lib/apt/lists/*

# Define volumes for the OpenSCAD agent home directory and other necessary directories
VOLUME "${OPENSCAD_AGENT_HOME}" "/tmp" "/run" "/var/run" "${OPENSCAD_AGENT_HOME}"/projects
WORKDIR "${OPENSCAD_AGENT_HOME}"/projects

# Set environment variables for language and path
ENV LANG='C.UTF-8' LC_ALL='C.UTF-8'
ENV PATH="${OPENSCAD_AGENT_HOME}/.local/share/OpenSCAD/libraries/NopSCADlib/scripts:/opt/venv/bin:${PATH}"

# Add the PATH and HOME environment variables to /etc/environment
RUN echo "PATH=${PATH}" >> /etc/environment \
    && echo "HOME=${HOME}" >> /etc/environment

# Switch to the openscad user
USER ${user}

# Install various OpenSCAD libraries
# Using --depth 1 --single-branch for minimal clone (only default branch, latest commit)
RUN cd "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    && git clone --depth 1 --single-branch https://github.com/revarbat/BOSL2.git \
    && git clone --depth 1 --single-branch https://github.com/nophead/NopSCADlib.git \
    && curl -L https://github.com/boltsparts/BOLTS_archive/releases/download/v0.4.1/boltsfc_0.4.1.tar.gz | tar xz \
    && git clone --depth 1 --single-branch https://github.com/rcolyer/threads-scad.git \
    && git clone --depth 1 --single-branch https://github.com/thehans/funcutils.git \
    && git clone --depth 1 --single-branch https://github.com/tallakt/bladegen.git && mv bladegen/libraries/bladegen/* bladegen \
    && git clone --depth 1 --single-branch https://github.com/JustinSDK/dotSCAD.git && cd dotSCAD && for dir in *; do [ "$dir" = "src" ] \
    && continue; rm -rf "$dir"; done; mv src/* . && rm -rf src \
    && cd .. && git clone --depth 1 --single-branch https://github.com/chrisspen/openscad-extra.git && cd openscad-extra && for dir in *; do [ "$dir" = "src" ] \
    && continue; rm -rf "$dir"; done; mv src/* . && rm -rf src \
    && cd .. && git clone --depth 1 --single-branch https://github.com/hominoids/SBC_Model_Framework.git

# Verify OpenSCAD version
RUN openscad --version

# Default command
CMD ["/usr/local/bin/openscad"]
