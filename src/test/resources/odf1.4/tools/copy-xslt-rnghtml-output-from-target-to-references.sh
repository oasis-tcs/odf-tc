#!/bin/bash
# Using bash strict mode
# see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# copy RNG-HTML files with added references
    # from target/generated-resources/xml/xslt
    # to   src/test/resources/odf1.4/references/xslt-rng
cp ../../../../../target/generated-resources/xml/xslt/*-rng.html ../references/xslt-rng
# 2DO: browser exorted HTML no valid XML - automated process not ready yet!
#for f in ../references/xslt-rng/*
#do
	#echo "Processing RNG-HTML file: $f"
    #xmllint --format $f > $$tmp
    #mv $$tmp $f
#done

