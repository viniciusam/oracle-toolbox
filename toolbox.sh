
WORKDIR=$(pwd)

sh download.sh -p se12c
mv linuxamd64_12102_database_se2_1of2.zip ./dockerfiles/12.1.0.2
mv linuxamd64_12102_database_se2_2of2.zip ./dockerfiles/12.1.0.2

cd dockerfiles
sh buildDockerImage.sh -s

cd $WORKDIR
sh run_se12.sh
