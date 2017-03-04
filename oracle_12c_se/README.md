This image doesn't contain a running instance of Oracle Database. You need to download the installation files manually.

http://download.oracle.com/otn/linux/oracle12c/121020/linuxamd64_12102_database_se2_1of2.zip
http://download.oracle.com/otn/linux/oracle12c/121020/linuxamd64_12102_database_se2_2of2.zip

### Building

I will add it later to Docker Hub, but for now you need to build it yourself.

```
docker build -t viniciusam/oracle-12c-se .
```

### Running

First, you need to unzip your install files into the volume that will be used for installation.

```
mkdir -p ~/oracle12
cd ~/oracle12
unzip -q linuxamd64_12102_database_se2_1of2.zip
unzip -q linuxamd64_12102_database_se2_2of2.zip
```

You can remove the .zip files after this step.

```
rm linuxamd64_12102_database_se2_1of2.zip
rm linuxamd64_12102_database_se2_2of2.zip
```

Now you can run the image. When you first run the image, the database will be installed on the same volume of the install files.

```
docker run --privileged --name oracle12c \
    -p 1521:1521 -p 8080:8080 \
    -v ~/oracle12/u01:/u01 \
    viniciusam/oracle-12c-se
```

After the installtion finishes, you can commit your image, so next time it won't be installed again.

```
docker commit oracle12c oracle12c
```

Now you should be able to connect on the running instance!

```
sqlplus system/oracle@//oracle12c:1521/orcl12c
```
