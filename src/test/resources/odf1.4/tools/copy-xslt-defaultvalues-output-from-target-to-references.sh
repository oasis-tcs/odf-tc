#!/bin/bash
# Using bash strict mode
# see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# copy extracted default value output 
    # from target/generated-resources/xml/xslt
    # to   src/test/resources/odf1.4/references/xslt-default
cp ../../../../../target/generated-resources/xml/xslt/*.xml ../references/xslt-default
for f in ../references/xslt-default/*
do
	echo "Processing default file: $f"
    xmllint --format $f > $$tmp
    mv $$tmp $f
done