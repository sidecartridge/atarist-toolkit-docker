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
VERSION=$1
if [ $# -eq 0 ]; then
    echo "No version supplied. Using latest version."
    VERSION="latest"
fi
ARCH=$(arch)
if [ "${ARCH}" = "i386" ]; then
    ARCH="x86_64"
fi
if [ "${ARCH}" = "aarch64" ]; then
    ARCH="arm64"
fi

THEDOCKER="${DOCKER_ACCOUNT}/atarist-toolkit-docker-${ARCH}:${VERSION}"
echo "Pulling image ${THEDOCKER}..."
docker pull ${THEDOCKER}

echo "Installing the command stcmd in /usr/local/bin. Please enter your root password if prompted..."
cat << EOF > /usr/local/bin/stcmd
#!/bin/bash
if [ -z "\${DOCKER_ACCOUNT}" ]; then
    DOCKER_ACCOUNT=logronoide
fi
if [ -z "\${VERSION}" ]; then
    VERSION="latest"
fi
if [ -z "\${ST_WORKING_FOLDER}" ]; then
    ST_WORKING_FOLDER=\$(pwd)
    if [ "\${STCMD_QUIET}" != "1" ]; then
        echo "ST_WORKING_FOLDER is empty: using \${ST_WORKING_FOLDER} as absolute path to source code working folder."
    fi
elif [ "\${STCMD_QUIET}" != "1" ]; then
    echo "ST_WORKING_FOLDER is set: using \${ST_WORKING_FOLDER} as absolute path to source code working folder."
fi
THEDOCKER="\${DOCKER_ACCOUNT}/atarist-toolkit-docker-${ARCH}:\${VERSION}"
THEUSER=\$(id -u)
THEGROUP=\$(id -g)
docker run --platform linux/${ARCH} -it --rm -v \${ST_WORKING_FOLDER}:'/tmp' --user "\${THEUSER}:\${THEGROUP}" \${THEDOCKER} \$@
EOF

chmod +x /usr/local/bin/stcmd
