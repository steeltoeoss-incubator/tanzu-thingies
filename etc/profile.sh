PROG=`basename $0`
BASE_DIR=$(cd $(dirname $BASH_SOURCE)/.. && pwd)
CONFIG_DIR=$BASE_DIR/etc
LIB_DIR=$BASE_DIR/lib
DATA_DIR=$BASE_DIR/share
TOOL_DIR=$BASE_DIR/tools
DISTFILE_DIR=${DISTFILE_DIR:=$BASE_DIR/distfiles}
LOCAL_DIR=${LOCAL_DIR:=$BASE_DIR/local}
WORK_DIR=${WORK_DIR:=$BASE_DIR/work}

OS=darwin
ARCH=amd64

source $LIB_DIR/functions.sh
source $CONFIG_DIR/tanzu.sh
source $CONFIG_DIR/versions.sh
source $CONFIG_DIR/credentials.sh

TANZUNET_USERNAME=$(echo $TANZUNET_CREDENTIALS | cut -d: -f1)
TANZUNET_PASSWORD=$(echo $TANZUNET_CREDENTIALS | cut -d: -f2)
DOCKER_USERNAME=$(echo $DOCKER_CREDENTIALS | cut -d: -f1)
DOCKER_PASSWORD=$(echo $DOCKER_CREDENTIALS | cut -d: -f2)

PATH=$LOCAL_DIR/bin:$PATH
