FROM gitpod/workspace-full-vnc

ENV TIGERVNC_GEOMETRY=1280x800

RUN sudo apt-get update && sudo apt-get install -y openscad
