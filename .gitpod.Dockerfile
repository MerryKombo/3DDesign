FROM gitpod/workspace-full-vnc

ENV TIGERVNC_GEOMETRY=1280x800

RUN sudo apt-get update && sudo apt-get install -y git openscad
RUN mkdir -p $HOME/.local/share/OpenSCAD/libraries && \
    cd $HOME/.local/share/OpenSCAD/libraries && \
    git clone https://github.com/ridercz/A2D.git && \
    git clone https://github.com/BelfrySCAD/BOSL2.git && \
    git clone https://github.com/nophead/NopSCADlib.git && \
    git clone https://github.com/hominoids/SBC_Model_Framework.git && \
    git clone https://github.com/UBaer21/UB.scad.git && \
    git clone https://github.com/boltsparts/boltsparts.git && \
    git clone https://github.com/solidboredom/constructive.git && \
    git clone https://github.com/JustinSDK/dotSCAD.git && \
    git clone https://github.com/chrisspen/openscad-extra.git && \
    git clone https://github.com/rcolyer/smooth-prim.git && \
    git clone https://github.com/rcolyer/threads-scad.git
