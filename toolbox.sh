
WORKDIR=$(pwd)

free -m
df -h

npm install -g phantomjs-prebuilt casperjs
sh download.sh -p se12c

VOLUME_DIR=$WORKDIR/oracle12c/u01

mkdir -p $VOLUME_DIR/install
mv linuxamd64_12102_database_se2_1of2.zip $VOLUME_DIR/install/linuxamd64_12102_database_se2_1of2.zip
mv linuxamd64_12102_database_se2_2of2.zip $VOLUME_DIR/install/linuxamd64_12102_database_se2_2of2.zip
cd $VOLUME_DIR/install
unzip -q linuxamd64_12102_database_se2_1of2.zip
rm linuxamd64_12102_database_se2_1of2.zip
unzip -q linuxamd64_12102_database_se2_2of2.zip
rm linuxamd64_12102_database_se2_2of2.zip

free -m
df -h

cd $WORKDIR/oracle_12c_se
docker build -t viniciusam/orace-12c-se .
docker run -d --privileged --name oracle12c -p 1521:1521 -v $VOLUME_DIR:/u01 viniciusam/orace-12c-se

docker logs -f oracle12c | grep -m 1 "DATABASE IS READY!" --line-buffered
rm -rf $VOLUME_DIR/install
docker commit oracle12c oracle12c

cd $CACHE_DIR
docker export --output="./oracle12c_img.tar" oracle12c
tar -zcvf oracle12c_install.tar.gz $VOLUME_DIR

ls -la

free -m
df -h

exit 0

#cd $WORKDIR
#sh run_se12.sh

# if [ ! -f $CACHE_DIR/linuxamd64_12102_database_se2_2of2.zip ]; then
#     npm install -g phantomjs-prebuilt casperjs
#     sh download.sh -p se12c
#     mv linuxamd64_12102_database_se2_1of2.zip $CACHE_DIR/linuxamd64_12102_database_se2_1of2.zip
#     mv linuxamd64_12102_database_se2_2of2.zip $CACHE_DIR/linuxamd64_12102_database_se2_2of2.zip
# fi

# cp $CACHE_DIR/linuxamd64_12102_database_se2_1of2.zip dockerfiles/12.1.0.2/linuxamd64_12102_database_se2_1of2.zip
# cp $CACHE_DIR/linuxamd64_12102_database_se2_2of2.zip dockerfiles/12.1.0.2/linuxamd64_12102_database_se2_2of2.zip

# cd dockerfiles
# sh buildDockerImage.sh -s

# cd $WORKDIR
# sh run_se12.sh

# if [ ! -f $CACHE_DIR/oracle-xe-11.2.0-1.0.x86_64.rpm.zip ]; then
#     npm install -g phantomjs-prebuilt casperjs
#     sh download.sh -p xe11g
#     mv oracle-xe-11.2.0-1.0.x86_64.rpm.zip $CACHE_DIR/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
# fi

# cp $CACHE_DIR/oracle-xe-11.2.0-1.0.x86_64.rpm.zip dockerfiles/11.2.0.2/oracle-xe-11.2.0-1.0.x86_64.rpm.zip

# cd dockerfiles
# sh buildDockerImage.sh -v 11.2.0.2

# cd $WORKDIR
# sh run_xe11.sh
