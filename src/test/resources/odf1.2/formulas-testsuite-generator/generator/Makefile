#!/bin/sh

## CONFIGURATION ###

SPEC=OpenFormula.odt
OUTPUT=TestSuite.ods
TEMPLATE=template.ods

####################

main: debug clean

debug: $(TEMPLATE) $(SPEC)
	cp $(TEMPLATE) $(OUTPUT)
	# Template
	unzip -oq $(OUTPUT) content.xml
	mv content.xml template.xml
	# Spec / tests
	unzip -oq $(SPEC) content.xml
	perl -pi clean.pl content.xml
	mv content.xml tests.xml
	# Process
	xsltproc step1.xsl template.xml > step1.xml
	xsltproc step2.xsl step1.xml > content.xml
	zip -q $(OUTPUT) content.xml

clean:
	rm -f content.xml template.xml tests.xml step1.xml
