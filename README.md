# ODF Specification Tooling

## Overview

The purpose of this project is to provide:

1. Automated tooling for the deliverables of the OASIS ODF TC foremost for its specification and grammar.
2. Test documents according to the new ODF features provided by the specification.

The project aligns to the [standard directory layout of a Maven build system](http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html).

We are using GitHub pages - our [docs directory](https://github.com/oasis-tcs/odf-tc/tree/master/docs) - to store our latest HTML & default value transformations:

Latest ODF 1.3 artifacts | Latest ODF 1.2 artifacts
------------ | -------------
[ODF 1.3 Intro HTML](https://oasis-tcs.github.io/odf-tc/odf1.3/content.odf13-intro.html) | [ODF 1.2 Intro HTML](https://oasis-tcs.github.io/odf-tc/odf1.2/content.odf12-intro.html)
[ODF 1.3 Packages HTML](https://oasis-tcs.github.io/odf-tc/odf1.3/content.odf13-packages.html) | [ODF 1.2 Packages HTML](https://oasis-tcs.github.io/odf-tc/odf1.2/content.odf12-packages.html)
[ODF 1.3 Schema HTML](https://oasis-tcs.github.io/odf-tc/odf1.3/content.odf13-schema.html) | [ODF 1.2 Schema HTML](https://oasis-tcs.github.io/odf-tc/odf1.2/content.odf12-schema.html)
[ODF 1.3 Formula HTML](https://oasis-tcs.github.io/odf-tc/odf1.3/content.odf13-formula.html) | [ODF 1.2 Formula HTML](https://oasis-tcs.github.io/odf-tc/odf1.2/content.odf12-formula.html)
[ODF 1.3 Attribute Default Values](https://github.com/oasis-tcs/odf-tc/blob/master/docs/odf1.3/content.odf13-default-values.xml) | [ODF 1.2 Attribute Default Values](https://github.com/oasis-tcs/odf-tc/blob/master/docs/odf1.2/content.odf12-default-values.xml)

### Automated Tests

For the usage of the test environment have installed:

1. [Java JDK](https://openjdk.java.net/install/) - tested with JDK 11.
2. [Apache Maven](https://maven.apache.org/)

#### Building & Running (Linux & Windows)

All tests are triggered from command line:

```shell
cd odf-tc
mvn clean install
```

#### Default Value Extraction (not yet a test)

It's first automated test will be the extraction of default values from ODF 1.2, an enhanced ODF 1.2 version, ODF 1.3 and the most recent enhanced ODF 1.3 version with default values.

There had been three fixes on the ODF 1.2 specification being made by adding a character style to the default values making them extractable again on:

1. @form:echo-char for value "*"
see "The default value for this attribute is "*" (U+002A, ASTERISK)." compare the definition beyond form:enctype.
2. @smil:fadeColor for value value "#000000"
3. @style:leader-text for value value " " (Space)

A complete list of ODF 1.2 default values can be found in the [ODF Toolkit](https://github.com/tdf/odftoolkit/blob/1.0.0_SNAPSHOT/odfdom/src/codegen/resources/config.xml#L218).

The most recent & stable SAXON XSLT processing engine will be used to extract the default values.

**NOTE**: All XSLT output will be written into the directory: *target/generated-resources/xml/xslt*

#### ODF2HTML transformation (not yet a test)

The second automated test will be the transformation of the ODT specifications part 3 of ODF 1.2 and ODF 1.3 to HTML.
The most recent & stable SAXON XSLT processing engine will be used to transform the documents into HTML.

The ODF 1.3 HTML shows problems with:

1. Upper border of paragraph boxes
2. Line indent

**NOTE**: All XSLT output will be written into the directory: *target/generated-resources/xml/xslt*

**NOTE**: To get MathML handled properly, the XSLT must be run from LibreOffice; this is because the XSLT require the MathML to be *inline* which means Flat ODT, but only LibreOffice supports Flat ODT currently.

To use LibreOffice to generate XHTML:

1. install Saxon extension: [xslt2-transformer.oxt](https://github.com/dtardon/xslt2-transformer/releases/download/v1.0.0/xslt2-transformer.oxt)
2. in LibreOffice menu, Tools/Macros/XML Filter settings..., click XHTML Writer file, Edit.../Transformation, check "The filter needs XSLT 2.0 processor", and edit "XSLT for export" to point to the file src/test/resources/odf1.3/tools/odf2html/export/xhtml/opendoc2xhtml.xsl in this repository
3. File/Export..., select "XHTML (.html,.xhtml)", click Save

## Editor Workflow & Tools

Our Git repository is containing the ODF TC deliverables in the GitHub directories:

1. src/main/resources/odf1.2
2. src/main/resources/odf1.3

Within the above folders the TC deliverables are saved under the following restrictions:

1. Ordered in a single flat directory hierarchy. They might be still delivered by OASIS in various directories later to the users.
2. Their file names will not contain the usual OASIS state abbreviation within the file names (e.g. OS). Versioning is being done by using GIT tags instead.
3. ODT specification documents are for ease of use duplicated as:
    1. ODT files - being zipped XML files & pictures
    2. Unpacked directory named as the document with the suffix '.' exchanged as '_'

To unzip and zip the ODT we are offering following tools:

```shell
java -cp target/test-classes org.oasis_open.odf_tc.Unzip src/main/resources/odf1.3/OpenDocument-v1.3-part1-introduction.odt
java -cp target/test-classes org.oasis_open.odf_tc.Zip   src/main/resources/odf1.3/OpenDocument-v1.3-part1-introduction.odt
```

These tools are available after being build by:

```shell
mvn install
```

As mentioned before the directory is used aside the ODT file with ".odt" replaced by "_odt".
In the future, providing a new ODT should trigger an automated process:

1. Unzip the changed ODT & commit the unzipped ODT XML to GIT as well
2. Transform the changed ODT to HTML & commit the results beyond reference /docs/odf&lt;VERSION&gt;
3. In case of ODT schema - extract the default values & compare them with the reference beyond /docs/odf&lt;VERSION&gt;

### ODF Editing Tool

#### LibreOffice paralell installation

Currently, [LibreOffice 7.1.5](https://www.libreoffice.org/download/download/?version=7.1.5&lang=en-US) is being used to edit the ODT files by all editors in en-US.
It might be helpful to install the Editor LibreOffice version in parallel with other LibreOffice (LO) installations to avoid automatic exchange (see [LO documentation](https://wiki.documentfoundation.org/Installing_in_parallel)).

#### LibreOffice unique configuration

In addition, to the parallel installation the configuration should not be shared. As only one LO instance of one configuration can run at one time.
This can be done manually after installation - likely before the first start - editing the file <LO_PATH>/program/bootstraprc (or
<LO_PATH>/program/bootstrap.ini on Windows) and change the last line to:

```shell
    UserInstallation=$ORIGIN/..
```

The above puts the profile directory as a sibling of "program".

#### LibreOffice pretty printing XML within ODT/ZIP

It's convenient to enable the XML pretty-printing in LibreOffice: go to "Tools-->Options...-->Advanced"
Press on the "Open Expert Configuration" button.
Search for "prettyprinting" and toggle it on, or alternatively add this line in registrymodifications.xcu in $HOME/.config/libreoffice/4

```xml
<item oor:path="/org.openoffice.Office.Common/Save/Document"><prop oor:name="PrettyPrinting" oor:op="fuse"><value>true</value></prop></item>
```

#### LibreOffice XHTML XSLT export taking from our GitHub

In the LO menu go to "Tools-->Macros-->XML Filter Settings, in this window select the "XHTML Writer export filter", press "Edit" and choose the "Transformation" label.
Exchange the existing "XSLT for export" from your

```shell
<LO_PATH>\program\..\share\xslt\export\xhtml\opendoc2xhtml.xsl
```

```shell
<GITHUB_ODF-TC_PATH>\src\test\resources\odf1.3\tools\odf2html\export\xhtml\opendoc2xhtml.xsl
```

**NOTE:**: You need to enable the checkbox "The filter needs XSLT 2.0 processor".

Finally, you need to **select your Java installation** used by the XHTML XSLT export via the menue: "Tools-->Options...-->Advanced".
We suggest the long-term-support JDK 11 version, others should work.

## Background

Members of the [Open Document Format for Office Applications (OpenDocument) TC](https://www.oasis-open.org/committees/office/) create and manage technical content in this [TC GitHub repository](https://github.com/oasis-tcs/odf-tc/) as part of the TC's chartered work (the program of work and deliverables described in its [charter](https://www.oasis-open.org/committees/odf-tc/charter.php).

OASIS TC GitHub repositories, as described in [GitHub Repositories for OASIS TC Members' Chartered Work](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work), are governed by the OASIS [TC Process](https://www.oasis-open.org/policies-guidelines/tc-process), [IPR Policy](https://www.oasis-open.org/policies-guidelines/ipr), and other policies. While they make use of public GitHub repositories, these repositories are distinct from [OASIS Open Repositories](https://www.oasis-open.org/resources/open-repositories), which are used for development of open source [licensed](https://www.oasis-open.org/resources/open-repositories/licenses) content.

## Description

The purpose of this repository is to provide version control for developing the OpenDocument Format (ODF) file format and related tools beginning with ODF CS 1.3.

## Contributions

As stated in this repository's [CONTRIBUTING](https://github.com/oasis-tcs/odf-tc/blob/master/CONTRIBUTING.md) file, contributors to this repository must be Members of the OASIS OpenDocument TC for any substantive contributions or change requests.  Anyone wishing to contribute to this GitHub project and [participate](https://www.oasis-open.org/join/participation-instructions) in the TC's technical activity is invited to join as an OASIS TC Member. Public feedback is also accepted, subject to the terms of the [OASIS Feedback License](https://www.oasis-open.org/policies-guidelines/ipr#appendixa).

## Licensing

Please see the [LICENSE](https://github.com/oasis-tcs/odf-tc/blob/master/LICENSE.md) file for description of the license terms and OASIS policies applicable to the TC's work in this GitHub project. Content in this repository is intended to be part of the OpenDocument TC's permanent record of activity, visible and freely available for all to use, subject to applicable OASIS policies, as presented in the repository [LICENSE](https://github.com/oasis-tcs/odf-tc/blob/master/LICENSE.md).

## Further Description of this Repository

*Any narrative content may be provided here by the TC, for example, if the Members wish to provide an extended statement of purpose.*

## Contact

Please send questions or comments about [OASIS TC GitHub repositories](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work) to the [OASIS TC Administrator](mailto:tc-admin@oasis-open.org).  For questions about content in this repository, please contact the TC Chair or Co-Chairs as listed on the the OpenDocument TC's [home page](https://www.oasis-open.org/committees/office/).
