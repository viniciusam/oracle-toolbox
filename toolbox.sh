
WORKDIR=$(pwd)

if [ ! -f $CACHE_DIR/linuxamd64_12102_database_se2_1of2.zip ]; then
    sh download.sh -p se12c
    mv linuxamd64_12102_database_se2_1of2.zip $CACHE_DIR
    mv linuxamd64_12102_database_se2_2of2.zip $CACHE_DIR
fi

ln -s $CACHE_DIR/linuxamd64_12102_database_se2_1of2.zip dockerfiles/12.1.0.2/linuxamd64_12102_database_se2_1of2.zip
ln -s $CACHE_DIR/linuxamd64_12102_database_se2_2of2.zip dockerfiles/12.1.0.2/linuxamd64_12102_database_se2_2of2.zip

cd dockerfiles
sh buildDockerImage.sh -s

cd $WORKDIR
sh run_se12.sh
