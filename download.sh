#!/bin/sh -e

#npm install -g phantomjs-prebuilt casperjs

downloadUrl=$(exec casperjs download.js $ORACLE_OTN_USER $ORACLE_OTN_PASWORD --product=sqlcl)
curl $downloadUrl -o
