#!/bin/sh
#
# Make a signed news.su3 file
# Requires I2P 0.9.17 or higher
# zzz Oct. 2014 public domain
#

# input Atom format
IN=news.atom.xml
# output su3 format
OUT=news.su3

. ./etc/su3.vars
[ -f ./etc/su3.vars.custom ] && . ./etc/su3.vars.custom

TMP=/tmp/su3tmp$$.gz

# Verify it is valid XML using our parser
java -cp $I2P/lib/i2p.jar:$I2P/lib/router.jar:$I2P/lib/routerconsole.jar net.i2p.router.news.NewsXMLParser $IN
if [ $? -ne 0 ]
then
	echo "XML verification of $IN failed"
	exit 1
fi

gzip -c -n $IN > $TMP

NOW=`date +%s`
java -cp $I2P/lib/i2p.jar net.i2p.crypto.SU3File \
   sign -c NEWS -f XML_GZ -t RSA_SHA512_4096 $TMP $OUT $KS $NOW $SIGNER

if [ $? -ne 0 ]
then
	echo "Failed to create $OUT"
	exit 1
fi

java -cp $I2P/lib/i2p.jar net.i2p.crypto.SU3File \
   showversion $OUT
ls -l $OUT

rm -f $TMP
