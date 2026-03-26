#!/bin/bash

if [ -x "$(command -v docker)" ]; then
    echo "Docker is installed..."
else
    echo "Docker not installed. Please install Docker first and then run this script again."
    exit 1
fi

if [ -z "${DOCKER_ACCOUNT}" ]; then
    DOCKER_ACCOUNT=logronoide
fi
STCMD_IMAGE_TAG=$1
if [ $# -eq 0 ]; then
    echo "No version supplied. Using latest version."
    STCMD_IMAGE_TAG="latest"
fi
ARCH=$(arch)
if [ "${ARCH}" = "i386" ]; then
    ARCH="x86_64"
fi
if [ "${ARCH}" = "aarch64" ]; then
    ARCH="arm64"
fi

THEDOCKER="${DOCKER_ACCOUNT}/atarist-toolkit-docker-${ARCH}:${STCMD_IMAGE_TAG}"
echo "Pulling image ${THEDOCKER}..."
docker pull ${THEDOCKER}

echo "Installing the command stcmd in /usr/local/bin. Please enter your root password if prompted..."
cat << EOF > /usr/local/bin/stcmd
#!/bin/bash
if [ -z "\${DOCKER_ACCOUNT}" ]; then
    DOCKER_ACCOUNT=${DOCKER_ACCOUNT}
fi
if [ -z "\${STCMD_IMAGE_TAG}" ]; then
    STCMD_IMAGE_TAG="${STCMD_IMAGE_TAG}"
fi
if [ -z "\${ST_WORKING_FOLDER}" ]; then
    ST_WORKING_FOLDER=\$(pwd)
    if [ "\${STCMD_QUIET}" != "1" ]; then
        echo "ST_WORKING_FOLDER is empty: using \${ST_WORKING_FOLDER} as absolute path to source code working folder."
    fi
elif [ "\${STCMD_QUIET}" != "1" ]; then
    echo "ST_WORKING_FOLDER is set: using \${ST_WORKING_FOLDER} as absolute path to source code working folder."
fi
THEDOCKER="\${DOCKER_ACCOUNT}/atarist-toolkit-docker-${ARCH}:\${STCMD_IMAGE_TAG}"
THEUSER=\$(id -u)
THEGROUP=\$(id -g)
TTY_FLAG="-it"
if [ "\${STCMD_NO_TTY}" = "1" ]; then
    TTY_FLAG=""
fi
docker run --platform linux/${ARCH} \${TTY_FLAG} --rm -v \${ST_WORKING_FOLDER}:'/tmp' --user "\${THEUSER}:\${THEGROUP}" \${THEDOCKER} \$@
EOF

chmod +x /usr/local/bin/stcmd
