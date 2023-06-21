#!/bin/bash
# Using bash strict mode
# see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# test input, ouput and reference follow a pattern according to the test name and ODF version:
TEST_NAMES=("frames-without-wrap" "floating_image_as_character" "frames-without-wrap" "tdf146264" "floating" "spec-fragment" "default-styles")
ODF_VERSION=odf1.4
TEST_INPUT_FILE=content.xml
TEST_STYLESHEET=src/test/resources/${ODF_VERSION}/tools/odf2html/export/xhtml/opendoc2xhtml.xsl

for TEST_NAME in ${TEST_NAMES[@]}; do
    echo Starting transformation of $TEST_NAME to HTML:
    # DO NOT ALTER BELOW..
    TEST_INPUT_DIR=src/test/resources/html-export/input/${TEST_NAME}
    TEST_OUTPUT_FILE=${TEST_NAME}.html
    TEST_REFERENCE_FILE=src/test/resources/${ODF_VERSION}/references/xslt-html/${TEST_NAME}.html

    # OUTPUT FILE is named like the TEST_INPUT_FILE just with html suffix
    # OUTPUT directory is originally: ./target/generated-resources/xml/xslt/ 
    # Final OUTPUT DIR is ./target
    # Results from previous build are at ./target/generated-resources/last-build-deliverables
    # the XSLT plugin does not transform if the output already exists
    # remove if only there is something to move (without error if not existent), doing the following move silently:
    [[ -e ./target/generated-resources/xml/xslt/$TEST_INPUT_FILE ]] &&  rm ./target/generated-resources/xml/xslt/$TEST_INPUT_FILE
    mvn test -Ptestfile -DtestInputDir=$TEST_INPUT_DIR -DtestInputFile=$TEST_INPUT_FILE -DtestStylesheet=$TEST_STYLESHEET
    [[ -e ./target/generated-resources/xml/xslt/$TEST_INPUT_FILE ]] && cp ./target/generated-resources/xml/xslt/$TEST_INPUT_FILE ./target/$TEST_OUTPUT_FILE
    outputTruncName="${TEST_OUTPUT_FILE%.*}"
    echo 
    echo Comparing:
    echo ref: ${TEST_REFERENCE_FILE}
    echo new: ./target/${outputTruncName}.html
    diff ${TEST_REFERENCE_FILE} ./target/$TEST_OUTPUT_FILE
done