#!bin/bash
set -e

if [ -f $CACHE_DIR/oracle-12c.tar ]; then
    echo "Oracle 12c is already cached, nothing to do..."
    exit 0
fi

ORACLE12c_FILE1=linuxamd64_12102_database_se2_1of2.zip
ORACLE12c_FILE2=linuxamd64_12102_database_se2_2of2.zip

# Download Oracle 12c Install Files
bash download.sh -p se12c
mv $ORACLE12c_FILE1 ./oracle_12c_se
mv $ORACLE12c_FILE2 ./oracle_12c_se

# Build and Save Docker image
cd ./oracle_12c_se
docker build --no-cache=true --force-rm=true -t oracle-12c .
#docker rmi $(docker images -q -f dangling=true)
docker save oracle-12c > $CACHE_DIR/oracle-12c.tar
docker rmi oracle-12c
