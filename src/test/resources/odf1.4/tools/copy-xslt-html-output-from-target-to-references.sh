#!/bin/bash
# Using bash strict mode
# see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# copy XHTML test output 
    # from target/generated-resources/xml/xslt
    # to   src/test/resources/odf1.4/references/xslt-html
cp ../../../../../target/generated-resources/xml/xslt/content.odf14-*.html ../references/xslt-html 
for f in ../references/xslt-html/*
do
	echo "Processing HTML spec file: $f"
    xmllint --format $f > $$tmp
    mv $$tmp $f
done