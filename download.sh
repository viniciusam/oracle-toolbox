#!/bin/sh -e

#export AGREEMENT_URL="http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html"
#export DOWNLOAD_URL="https://edelivery.oracle.com/akam/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip";
export AGREEMENT_URL="http://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html"
export DOWNLOAD_URL="http://download.oracle.com/otn/java/sqldeveloper/sqlcl-4.2.0.16.355.0402-no-jre.zip"

export OUTPUT_FILE="sqlcl-4.2.0.16.355.0402-no-jre.zip"

npm install -g phantomjs-prebuilt casperjs

downloadUrl=$(exec casperjs download.js $AGREEMENT_URL $DOWNLOAD_URL $ORACLE_OTN_USER $ORACLE_OTN_PASWORD)
curl $downloadUrl -o $OUTPUT_FILE
