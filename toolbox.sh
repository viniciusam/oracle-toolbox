
export WORKDIR=$(pwd)

free -m
df -h

npm install -g phantomjs-prebuilt casperjs
sh download.sh -p se12c

INSTALL_DIR=$WORKDIR/oracle12c_install/

mkdir -p $INSTALL_DIR
mv linuxamd64_12102_database_se2_1of2.zip $INSTALL_DIR/linuxamd64_12102_database_se2_1of2.zip
mv linuxamd64_12102_database_se2_2of2.zip $INSTALL_DIR/linuxamd64_12102_database_se2_2of2.zip

cd $INSTALL_DIR
unzip -q linuxamd64_12102_database_se2_1of2.zip
rm linuxamd64_12102_database_se2_1of2.zip
unzip -q linuxamd64_12102_database_se2_2of2.zip
rm linuxamd64_12102_database_se2_2of2.zip

free -m
df -h

cd $WORKDIR/oracle_12c_se

echo "Building Docker Image"
docker build -q -t viniciusam/orace-12c-se .

echo "Installing Oracle 12c"
docker run -d --privileged --name oracle12c -p 1521:1521 -v $INSTALL_DIR:/install viniciusam/orace-12c-se
docker logs -f oracle12c | grep -m 1 "DATABASE IS READY!" --line-buffered

echo "Removing Install Dir"
rm -rf $INSTALL_DIR

echo "Creating Image Snapshot"
docker commit oracle12c oracle12c

free -m
df -h

cd $CACHE_DIR

echo "Exporting Snapshot"
docker export --output="./oracle12c_img.tar" oracle12c

ls -la
free -m
df -h

exit 0
