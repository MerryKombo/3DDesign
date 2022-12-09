FROM debian:sid-20221205-slim

ARG user=openscad
ARG group=openscad
ARG uid=1000
ARG gid=1000

ARG OPENSCAD_AGENT_HOME=/home/${user}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${OPENSCAD_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}" \
    # Prepare subdirectories
    && mkdir -p "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/ \
    # Make sure that user 'openscad' own these directories and their content
    && chown -R "${uid}":"${gid}" "${OPENSCAD_AGENT_HOME}" "${OPENSCAD_AGENT_HOME}"/.local/share/OpenSCAD/libraries/

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    imagemagick \
    openscad \
    python3 \
    python3-pip \
    xauth \
    xvfb \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip install colorama codespell markdown \
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

# And then... \
    # find . -type f -name "*scad" -print0 | xargs -I{} --null xvfb-run -a openscad {} -o {}.png
    # and
    # find . -type f -name "*scad" -print0 | xargs -I{} --null openscad {} -o {}.stl