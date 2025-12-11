podman stop debian-toolbox-guigui
toolbox rm debian-toolbox-guigui
buildah bud -t toolbox .
toolbox create -c debian-toolbox-guigui -i localhost/toolbox:latest

