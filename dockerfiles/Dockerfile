#  docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix openscad openscad
# QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-openscad'
# Use the slim version of Debian Bookworm as the base image
FROM debian:bookworm-20241202-slim

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

# Create a new group and user with the specified gid and uid, and create necessary directories
# Set the ownership of these directories to the newly created user and group
# Make the shell scripts executable
RUN groupadd -g ${gid} ${group} \
    && useradd -d "${OPENSCAD_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}" \
    && mkdir -p "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ "${OPENSCAD_AGENT_HOME}"/projects \
    && chown -R "${uid}":"${gid}" "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    && chmod +x /usr/local/bin/*.sh

# Install necessary packages and libraries, and create symbolic links for python and pip
# Install the GitHub CLI
# Clean up the apt cache to reduce the image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    coreutils \
    curl \
    git \
    gnupg \
    imagemagick \
    openscad \
    python3 \
    python3-pip \
    rsync \
    unzip \
    xauth \
    xvfb \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip install colorama codespell markdown \
    && type -p curl >/dev/null || apt install curl -y \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y  \
    && rm -rf /var/lib/apt/lists/*

# Define volumes for the OpenSCAD agent home directory and other necessary directories
VOLUME "${OPENSCAD_AGENT_HOME}" "/tmp" "/run" "/var/run" "${OPENSCAD_AGENT_HOME}"/projects
WORKDIR "${OPENSCAD_AGENT_HOME}"/projects

# Set environment variables for language and path
ENV LANG='C.UTF-8' LC_ALL='C.UTF-8'
ENV PATH="${OPENSCAD_AGENT_HOME}/.local/share/OpenSCAD/libraries/NopSCADlib/scripts:${PATH}"

# Add the PATH and HOME environment variables to /etc/environment
RUN echo "PATH=${PATH}" >> /etc/environment
RUN echo "HOME=${HOME}" >> /etc/environment

# Install fonts
RUN cd /tmp && curl -O "https://media.fontsgeek.com/download/zip/i/s/isonorm-3098-regular_JreV9.zip" && unzip iso*zip && \
    rm iso*.zip && find . -name Isonorm\ 3098\ Regular.otf -exec cp {} /usr/local/share/fonts \; && \
    rm -fr Isonorm\ 3098\ Regular/Isonorm

# Switch to the openscad user
USER ${user}

# Install various OpenSCAD libraries
RUN cd "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    && git clone https://github.com/revarbat/BOSL2.git \
    && git clone https://github.com/nophead/NopSCADlib.git \
    && curl -L https://github.com/boltsparts/BOLTS_archive/releases/download/v0.4.1/boltsfc_0.4.1.tar.gz | tar xz \
    && git clone https://github.com/rcolyer/threads-scad.git \
    && git clone https://github.com/thehans/funcutils.git \
    && git clone https://github.com/tallakt/bladegen.git && mv bladegen/libraries/bladegen/* bladegen \
    && git clone https://github.com/JustinSDK/dotSCAD.git && cd dotSCAD && for dir in *; do [ "$dir" = "src" ] \
    && continue; rm -rf "$dir"; done; mv src/* . && rm -rf src \
    && cd .. && git clone https://github.com/chrisspen/openscad-extra.git && cd openscad-extra && for dir in *; do [ "$dir" = "src" ] \
    && continue; rm -rf "$dir"; done; mv src/* . && rm -rf src \
    && cd .. && git clone https://github.com/hominoids/SBC_Model_Framework.git

# TODO
# Create a entrypoint script to start the default parsing/rendering process

# And then... \
    # find . -type f -name "*scad" -print0 | xargs -I{} --null xvfb-run -a openscad {} -o {}.png
    # and
    # find . -type f -name "*scad" -print0 | xargs -I{} --null openscad {} -o {}.stl
    # create a new branch (or check if exists) thanks to gh cli, and move only the binary files while keeping the same directory structure
    # rsync -rv --include '*/' --include '*.js' --exclude '*' --prune-empty-dirs Source/ Target/
    # found there: https://unix.stackexchange.com/a/230536/488327
    # to create the branch with gh, get inspiration from MyFirstAndroidAppBuiltWithJenkins
