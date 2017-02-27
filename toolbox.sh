
WORKDIR=$(pwd)

free -m
df -h

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
