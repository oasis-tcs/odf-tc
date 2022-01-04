#!/bin/bash


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

