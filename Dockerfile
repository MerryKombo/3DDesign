FROM debian:sid-20221205-slim

ARG user=openscad
ARG group=openscad
ARG uid=1000
ARG gid=1000

ARG OPENSCAD_AGENT_HOME=/home/${user}

# Create a volume to link to the current project

COPY scripts/*.sh /usr/local/bin/

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${OPENSCAD_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}" \
    # Prepare subdirectories
    && mkdir -p "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    # Make sure that user 'openscad' own these directories and their content
    && chown -R "${uid}":"${gid}" "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    # Change scripts permissions
    && chmod +x /usr/local/bin/*.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    imagemagick \
    openscad \
    python3 \
    python3-pip \
    rsync \
    xauth \
    xvfb \
    # Some openSCAD libraries need python
    && ln -s /usr/bin/python3 /usr/bin/python \
    # Some openSCAD libraries need pip
    && pip install colorama codespell markdown \
    # Install gh CLI
    && type -p curl >/dev/null || apt install curl -y \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y  \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* 

# VOLUME directive must happen after setting up permissions and content
VOLUME "${OPENSCAD_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${OPENSCAD_AGENT_HOME}"

ENV LANG='C.UTF-8' LC_ALL='C.UTF-8'
ENV PATH="${OPENSCAD_AGENT_HOME}/.local/share/OpenSCAD/libraries/NopSCADlib/scripts:${PATH}"

RUN echo "PATH=${PATH}" >> /etc/environment

USER ${user}

# Install BOSL2 Library
RUN cd "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    && git clone https://github.com/revarbat/BOSL2.git \
# Install NOPSCAD Library
    && git clone https://github.com/nophead/NopSCADlib.git \
# Install Bolts Library
    && curl -L https://github.com/boltsparts/BOLTS_archive/releases/download/v0.4.1/boltsfc_0.4.1.tar.gz | tar xz \
# Install Threads Library \
    && git clone https://github.com/rcolyer/threads-scad.git \
# Install funcutils Library \
    && git clone https://github.com/thehans/funcutils.git \
# Install dotSCAD Library
    && git clone https://github.com/JustinSDK/dotSCAD.git && cd dotSCAD && mv src/* . && rm -rf src

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