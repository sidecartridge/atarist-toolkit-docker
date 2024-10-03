#!/bin/bash

if [ -x "$(command -v docker)" ]; then
    echo "Docker is installed..."
else
    echo "Docker not installed. Please install Docker first and then run this script again."
    exit 1
fi

VERSION=$1
if [ $# -eq 0 ]
  then
    echo "No version supplied. Using latest version."
    VERSION="latest"
fi
ARCH=`arch`

THEDOCKER="logronoide/atarist-toolkit-docker-${ARCH}:${VERSION}"
echo "Pulling image ${THEDOCKER}..."
docker pull ${THEDOCKER}

echo "Installing the command stcmd in /usr/local/bin. Please enter your root password if prompted..."
cat << EOF > /usr/local/bin/stcmd
#!/bin/bash
if [ -z "\$VERSION" ]
then
    VERSION="latest"
fi
if [ -z "\$ST_WORKING_FOLDER" ]
then
      echo 'ST_WORKING_FOLDER is empty. It should have the absolute path to the source code working folder.'
      exit 1
fi
ARCH=`arch`
THEDOCKER="logronoide/atarist-toolkit-docker-\${ARCH}:\${VERSION}"
THEUSER=\$(id -u)
THEGROUP=\$(id -g)
docker run -it --rm  -v \${ST_WORKING_FOLDER}:'/tmp' --user "\${THEUSER}:\${THEGROUP}" \${THEDOCKER} \$@
EOF

chmod +x /usr/local/bin/stcmd
