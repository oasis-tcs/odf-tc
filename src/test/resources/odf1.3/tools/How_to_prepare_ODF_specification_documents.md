# Introduction

<!-- <<TableOfContents>> -->

Parts of the ODF specification text are generated from the schema. For this reason, the ODF TC maintains so called [*editor drafts*](#EditorDraftConventions). The editor drafts do not contain the generated text (or at least not up-to date versions of it), but only [*anchors*](#Anchors) where text shall be inserted. Before an ODF specification is submitted for a CSD vote, the anchors need to be replaced with the generated text. Further, The editor drafts of the formula specification part contain some annotations sections that have to be removed before submitting a draft for a CSD vote, and cross references have to be updated. All this is done by a set of XSLT style sheets, which are referred as [*text update style sheets*](#TextUpdateProcess) in the following..

The anchors and style information is also used to run [*consistency checks*](#ConsistencyChecks) between the specification documents and the schema, and to insert and check cross references.

## Editor Draft Conventions

The insertion of the generated text and the annotation sections in the formula parts are based on some convention regarding styles and paragraph content that are described here.

### Anchors

*Anchors* are paragraphs that mark the places where text shall be inserted, and that also provide the information for which XML element, attribute or spreadsheet function information shall be inserted. The following anchors are used:

**Anchor** | **Information inserted** | **Overview** | **Part 1** | **Part 2** | **Part 3** | **Note**
------------ | -------------------------- | -------------- | ------------ | ------------ | ------------ | ----------
element-*&lt;elem&gt;*; | Insert information regarding element *&lt;elem&gt;* | no | yes | no | yes(1) |  
attribute-*&lt;attr&gt;*; | Insert information regarding attribute *&lt;attr&gt;* | no | yes | no | yes(1) | The attribute definitions must be equal for all elements where the attribute may occur.
attribute-*&lt;attr&gt;*_element-*&lt;e1&gt;* | Insert information regarding attribute *&lt;attr&gt;* defined for element *&lt;e1&gt;* | no | yes | no | yes(1) | 
attribute-*&lt;attr&gt;*_element-*&lt;e1&gt;*_element-*&lt;e1&gt;* | Insert information regarding attribute *&lt;attr&gt;* defined for element *&lt;e1&gt;* and *&lt;e2&gt;* | no | yes | no | yes(1) | Any number of _element-&lt;e&gt; sequences is permitted
property-*&lt;attr&gt*; | Insert information regarding formatting property attribute *&lt;attr&gt;* | no | yes | no | yes(1) | A formatting property attribute is an attribute defined for any of the **&lt;style:*-properties&gt;** elements.The attribute definitions must be equal for all elements where the attribute may occur.
property-*&lt;attr&gt;*_element-*&lt;e1&gt;* | Insert information regarding formatting property attribute *&lt;attr&gt;* defined for element *&lt;e1&gt;* | no | yes | no | yes(1) | Any number of _element-&lt;e&gt; sequences is permitted
datatype-*&lt;dt&gt;*; | Insert information regarding datatype *&lt;dt&gt;* | no | yes | no | yes(1) |  
anchor:*&lt;func&gt;*; | Insert information regarding function *&lt;func&gt;* | no | no | yes(2) | no |  
toc-*&lt;part&gt;* | Insert table of content for part *&lt;part&gt;* | yes | no | no | no | *&lt;part&gt;* must be one of **part1**, **part2** or **part3**.

(1) In part 3, all anchors refer to the manifest schema. Information regarding the digital signature schema in part 3 is maintained manually.

(2) Currently no information is added.

Anchors are removed by the text update style sheets.

### Paragraph Styles

The following paragraph styles are used for generated texts or otherwise considered by the text update style sheets.
**Style Name** | **Meaning** | **Overview** | **Part 1** | **Part 2** | **Part 3** | **Note**
------------ | -------------------------- | -------------- | ------------ | ------------ | ------------ | ----------
Attribute List | List of all attributes defined for an element | no | yes | no | yes(1) |  
Child Element List | List of all child elements defined for an element | no | yes | no | yes(1) |  
Parent Element List | List of possible parent elements of an element or attribute | no | yes | no | yes(1) |  
Attribute Value List | Description of the possible values of an attribute | no | yes | no | yes(1) |  
Default Value | The definition of a default value | no | yes | no | yes(1) | Default values have been generated once when removing the dependency on the RNG DTD Compatibility specification. They are not updated any longer.
TODO | A todo | yes | yes | yes | yes | Paragraphs that have this style applied are removed
Rationale | A rationale | no | no | yes | no | Only used in part 2 consistency checks
Offset Note | An offset note | no | no | yes | no | Only used in part 2 consistency checks

(1) In part 3, only text regarding the manifest schema is generated. Information regarding the digital signature schema in part 3 is maintained manually and has to use different styles.

### Text Styles

In addition to the paragraph styles, a set of text styles is used in the generated text, but also manually. Some of these styles may also considered by the consistency checks.
**Style Name** | **Meaning** | **Overview** | **Part 1** | **Part 2** | **Part 3** | **Note**
------------ | -------------------------- | -------------- | ------------ | ------------ | ------------ | ----------
Element | The name of an element defined by the ODF specification | no | yes | no | yes(1) |  
Attribute | The name of an attribute defined by the ODF specification | no | yes | no | yes(1) |  
Attribute Value | An attribute value literally defined by the ODF specification | no | yes | no | yes(1) | Attribute values marked by this style literally must be defined by the schema (i.e. constants).
Attribute Value Instance | An instance of a datatype value | no | yes | no | yes(1) | Attribute values marked by this style are instances of a datatype (i.e. integer or length values)
Datatype | The name of datatype defined by the ODF specification | no | yes | no | yes(1) |  
Alien Element | The name of an element not defined by the ODF specification | no | yes | no | yes(1) |  
Alien Attribute | The name of an attribute not defined by the ODF specification | no | yes | no | yes(1) |  
Alien Attribute Value | An attribute value not defined by the ODF specification | no | yes | no | yes(1) |  
Def | A definition | yes | yes | yes | yes |  
Note Label | The label of a note | yes | yes | yes | yes |  

(1) In part 3, all element and attribute names refer to the manifest schema. Information regarding the digital signature schema in part 3 is maintained manually.

### Cross References

Cross reference marks for elements, attributes and datatypes are automatically inserted by the text update style sheets.

* Cross reference marks for elements start with **element-**, followed by the name of the element.
* Cross reference marks for attributes start with **attribute-**, followed by the name of the attribute.
* Cross reference marks for formatting property attributes start with **property-**, followed by the name of the attribute.
* Cross reference marks for data types start with **datatype-**, followed by the name of the datatype.

For the formula part, the text update style sheets convert all bookmarks into same named reference marks. Hyperlinks that reference bookmark in the same document are converted into references.

### Bibliography

The text update style sheets update the normative an non normative reference sections to include only the specific type of references.

* The bibliographic index for normative references must have the name **NormativeReferences**.
* The bibliographic index for non normative references must have the name **NonNormativeReferences**.
* Non normative references are marked by the value **informative** in their **user-defined5** field.

### Other Conventions

* Annotation sections in part 2 are marked with the condition **Note==0**. Text sections that are hidden based on this condition (or hidden unconditionally) are removed by the text update style sheets.

## Text Update Process

### Introduction

The text update process is based on XSLT style sheets. The style sheets are currently included in the [http://odftoolkit.org/sources/odf-xslt-Runner-src/show](hg repository) of the [http://odftoolkit.org/projects/odftoolkit/pages/ODFXSLTRunner](ODF Toolkit's ODFXSLTRunner) tool as [http://odftoolkit.org/projects/odftoolkit/sources/odf-xslt-Runner-src/show/sample_xslt](sample XSLT style sheets).

Some of them have to be applied to the content.xml of the ODF specification document. There are several ways to apply these style sheets:

 1. The ODF specification may be unzipped, the style sheet applied, and the ODF specification zipped again.
 1. The [http://odftoolkit.org/projects/odftoolkit/pages/ODFXSLTRunner](ODF Toolkit's ODFXSLTRunner) tool may be used. It allows to apply an XSLT style sheet to an ODF package without having to unzip the document.
 1. The [http://odftoolkit.org/projects/odftoolkit/pages/ODFXSLTRunnerTask](ODF Toolkit's ODFXSLTRunnerTask) Netbeans project includes an [http://odftoolkit.org/projects/odftoolkit/sources/odf-xslt-runner-task-src/content/build-xref.xml](build-xref.xml) file which defines several ant targets to apply the style sheets.

### Preparations

For all parts, before running the text update style sheets, the normative and non-normative bibliographic indexes have to be updated using an office application.

### Part 1

Before the text update style sheet for part 1 can be applied, a so called flat version of the OpenDocument (part 1) schema has to be prepared. The flat schema is a schema where all RNG **<ref>** elements are replaced withe the content of the referenced **<define>** elements, and where certain RNG elements like **<interleave>** or **<zeroOrMore>** that are not required to generate text for the ODF specification are removed. The flat schema is created by applying the **create-flat-schema.xsl** to the OpenDocument schema.

**Example:**

```shell
java -jar saxon9.jar -s:OpenDocument-v1.2-cd05-rev02-schema.rng -o:OpenDocument-v1.2-cd05-rev02-schema.rng create-flat-schema.xsl
```

**Note:** The **create-flat-schema.xsl** style sheet has several [*parameters*](#StyleSheetParameters).

Next, the text update style sheet itself can be applied. It is called **add-embedded-xref.xsl** and has to be applied to the context.xml file of an ODF part 1 editor revision. The flat schema has to be passed as parameter **xref-schema-file**.

**Example using ODFXSLTRunner**

```shell
java -jar odfxsltrunner.jar create-embedded-xref.xsl OpenDocument-v1.2-cd05-part1-editor-revision-10.odt OpenDocument-v1.2-cd05-rev02-part1.odt
 xref-schema-file=OpenDocument-v1.2-cd05-rev02-xref-schema-flat.rng
```

The result of the transformation is already the target document. However, text update style sheet did neither update the table of content, nor dies it insert any section number within cross references. For this reason, the document has to be loaded into an office application, where the table of content has to be updated. This also updates the section numbers within cross references.

**Note:** The text update style sheet updates the normative and non-normative bibliographic indexes by removing all entries that do not belong into the one or the other index. When updating the table of content, make sure that the bibliographic entries are *not* updated.

**Note:** The **create-embedded-xref.xsl** style sheet has several [*parameters*](#StyleSheetParameters).

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project, the ant target for creating an ODF part 1 document is **add-v12-part1-xref-product**.

### Part 2

For part 2, no flat schema file is required. In all other aspects, the application of the text update style sheet equals that of part 1.

**Example using ODFXSLTRunner:**

```shell
java -jar odfxsltrunner.jar create-embedded-xref.xsl OpenDocument-v1.2-cd05-part2-editor-revision-5.odt OpenDocument-v1.2-cd05-rev02-part2.odt
```

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project, the ant target for creating an ODF part 2 document is **add-v12-part2-xref-product**.

### Part 3

The application of the text update style sheets for part 3 equals that of part 1, except that a flat schema has to be created for the ODF manifest schema.

**Example using ODFXSLTRunner:**

```shell
java -jar saxon9.jar -s:OpenDocument-v1.2-cd05-rev02-manifest-schema.rng -o:OpenDocument-v1.2-cd05-rev02-manifest-schema.rng create-flat-schema.xsl
java -jar odfxsltrunner.jar create-embedded-xref.xsl OpenDocument-v1.2-cd05-part3-editor-revision-7.odt OpenDocument-v1.2-cd05-rev02-part3.odt
 xref-schema-file=OpenDocument-v1.2-cd05-rev02-xref-manifest-schema-flat.rng
```

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project, the ant target for creating an ODF part 2 document is **add-v12-part3-xref-product**.

### Overview Document

For the OpenDocument overview document, the text update style sheet copies the table of content of the other three parts into the target document. It is therefore required that this document is prepared as last document, and that the table of content of the three parts have been updated already after the text update style sheets have been applied to these parts.

For the overview document, the text update style sheet does not require a flat schema, but the paths of the content.xml files of the three parts have to be passed as parameters. The names of these parameters are **part1-content-path**, **part2-content-path** and **part3-content-path**. To avoid unzipping of the three parts, jar-URLs may be used.

When copying the table of content, the hyperlinks in the table of content are adapted to link to the three parts. It is therefore required to also pass the relative paths of the three parts as they shall appear in the hyperlinks as parameters. The names of these parameters are: **part1-toc-rel-path**, **part2-toc-rel-path** and **part3-toc-rel-path**.

**Example using ODFXSLTRunner:**

```shell
java -jar odfxsltrunner.jar create-embedded-xref.xsl OpenDocument-v1.2-cd05-editor-revision-02.odt OpenDocument-v1.2-cd05-rev02.odt
 "part1-content-path=jar:file:OpenDocument-v1.2-cd05-rev02-part1.odt\!/content.xml"
 "part2-content-path=jar:file:OpenDocument-v1.2-cd05-rev02-part2.odt\!/content.xml"
 "part3-content-path=jar:file:OpenDocument-v1.2-cd05-rev02-part3.odt\!/content.xml"
 part1-toc-rel-path=OpenDocument-v1.2-cd05-rev02-part1.odt
 part2-toc-rel-path=OpenDocument-v1.2-cd05-rev02-part2.odt
 part3-toc-rel-path=OpenDocument-v1.2-cd05-rev02-part3.odt
```

**Note:** This example shows the command line for a csh. For other shells, the necessary quoting/escaping may differ.

As for the other parts, the table of content of the target document has to be updated using an office application.

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project, the ant target for creating an ODF overview document is **add-v12-part0-xref-product**.

### Style Sheet Parameters

The text update style sheets have a couple of parameters that control the update process. The defaults of the parameters do work for the update process, so that the parameters usually don't have to be passed to the transformation.

The parameters of the **create-flat-schema.xsl** style sheet are:

**Name** | **Values** | **Description** | **Note**
---------- | ------------ | ----------------- | ----------
incl-default-values | **true**,false | If **true**, default values specified by **a:defaultValue** attributes are preserved. | Not meaningful for ODF 1.2, because the ODF 1.2 schemas don't define any default values
incl-types | **true**,false | If **true**, the content of RNG **<attribute>** elements is preserved. **<ref>** elements within attribute definitions are not resolved. |  
incl-conditions | **true**,false | If **true**, **<attribute>** and **<element>** elements get a **condition** attribute that contains all ancestor  **<choice>**, **<optional>**, etc. elements as an XPath expression, up to the next **<element>** element. **combine="interleave"** attributes that occur at **<define>** elements that are resolved are converted into an **<interleave>** XPath component. **combine="interleave"** attributes are converted into **<interleave>**. |  
incl-elements | **true**,false | If **true**, information regarding child elements is included. |  

Defaults appear in **bold**.

The parameters of the **create-embedded-xref.xsl** style sheet are:

**Name** | **Values** | **Description** | **Note**
---------- | ------------ | ----------------- | ----------
xref-schema-file | an URI | The URI of the flat RNG schema. Only required if **add-xref** is set to **true** | Mandatory for part 1 and part 2
keep-anchors | **true**,false | Specifies whether or not anchors are kept |  
add-xrefs | **true**,false | Specifies whether information from the schema shall be added |  
part1-content-path | an URI | The URI of the content.xml file of part 1 | Mandatory for the overview document only
part2-content-path | an URI | The URI of the content.xml file of part 2 | Mandatory for the overview document only
part3-content-path | an URI | The URI of the content.xml file of part 3 | Mandatory for the overview document only
part1-toc-rel-path | a relative URI | The relative URI that refers from the overview document to part 1 | Mandatory for the overview document only
part2-toc-rel-path | a relative URI | The relative URI that refers from the overview document to part 2 | Mandatory for the overview document only
part3-toc-rel-path | a relative URI | The relative URI that refers from the overview document to part 3 | Mandatory for the overview document only
toc-hyperlink-mode | adapt,**none** or empty | Specifies how hyperlinks are processed when the table of contents for part 1 to 3 is copied to the overview document. **adapt** means that their path is replaced with the relative path specified by the **part*n*-toc-rel-path** parameters. **none** means that hyperlinks are removed. An empty parameter means that hyperlinks are not changed. | Relevant for the overview document only

Defaults appear in **bold**.

## Consistency Checks

### Text Update Style Sheets

The text update style sheet **create-embedded-xref.xsl** includes a couple of consistency checks. The following items are checked:

* For all **element-**, **attribute-** and **property-** anchors it is checked whether the schema contains a definition for the element or attribute.
* For **element-** fragments in **attribute-** anchors it is checked whether schema contains a definition for the element.
* For **anchor:** anchors in part 2 it is checked whether there is a heading with the name of the anchor.
* For all headings that are attribute or element names it is checked whether there is an attribute or element definition in the schema, and whether there is also an anchor.
* For annotation sections in part 2, it is checked whether the section contains paragraphs which don't start with "Test case" and whose style is not one of: Rationale, Offset Note, TODO.

### Cross References Check

The style sheet **check-xrefs.xsl** checks whether all document internal cross references (ODF **text:reference-ref** elements) can be resolved. It is applied to the content.xml of ODF specification documents on which the text update style sheets have been applied already. The target of the style sheet is a text file that list unresolvable references.

**Example using ODFXSLTRunner:**

```shell
java -jar odfxsltrunner.jar check-xrefs.xsl OpenDocument-v1.2-cd05-rev02-part1.odt -o OpenDocument-v1.2-cd05-rev02-part1.log
``` 

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project, the ant targets for checking cross references are **check-v12-part1-xref**, **check-v12-part2-xref** and **check-v12-part3-xref**.

### Completeness

The style sheet **check-completeness.xsl** checks whether an ODF specification document contains  references and headings for all element and attributes defined in the ODF schema. It is applied to the content.xml of part1 and and part 3 of the ODF specification. The flat RNG schema (or flat RNG manifest schema) has to be passed as parameter **xref-schema-file**. The target is a text file listing all errors that have been found.

**Example using ODFXSLTRunner:**

```shell
java -jar odfxsltrunner.jar check-completeness.xsl OpenDocument-v1.2-cd05-part1-editor-revision-10.odt -o OpenDocument-v1.2-cd05-rev02-part1.log
 xref-schema-file=OpenDocument-v1.2-cd05-rev02-xref-schema-flat.rng
```

For part 3, the name of the Manifest Attributes section has to be passed as parameter **attributes-heading**.

```shell
java -jar odfxsltrunner.jar check-completeness.xsl OpenDocument-v1.2-cd05-part3-editor-revision-6.odt -o OpenDocument-v1.2-cd05-rev02-part3.log
 xref-schema-file=OpenDocument-v1.2-cd05-rev02-xref-schema-flat.rng
 "attributes-heading=Manifest Attributes"
```

**Note:** To check part 3, it is further required to set the **attributes-heading-level** variable in the style sheet itself to the value **2**.

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project, the ant targets for checking cross references are **check-v12-part1-completeness** and **check-v12-part3-completeness**.

## XHTML Specifications

XHTML versions of the ODF specification may be created as described [http://odftoolkit.org/projects/conformancetools/pages/ODFXSLTRunnerExamples#XHTML](here).

For part 1 and 2, the embedded formula objects have to be replaced with images before the XHTML transformation can be applied to the specification documents. The process to replace the embedded formula objects is described [http://odftoolkit.org/projects/conformancetools/pages/ODFXSLTRunnerExamples#Replace_embedded_objects_with_bitmap_images](here).

For the ODF overview document, the hyperlinks in the table of content for part 1, 2 and 3 don't work in the resulting HTML document, since they refer to the ODF rather than to the HTML versions of part 1, 2 and 3. This is corrected by XSLT style sheet **adapt-html-hrefs.xsl**, which is applied to the XHTML version of the overview document.

**Example:**

```shell
java -jar saxon9.jar -s:OpenDocument-v1.2-cd05-rev02.html -o:OpenDocument-v1.2-cd05-rev02-new.html adapt-html-hrefs.xsl
```

In the **build-xref.xml** file of the **ODFXSLTRunnerTask** project has the targets **create-v12-part0-html**, **create-v12-part1-html**, **create-v12-part2-html** and **create-v12-part3-html** for preparing XHTML versions of the HTML specification. These targets also replace MathML objects with bitmap images as described [http://odftoolkit.org/projects/odftoolkit/pages/ODFXSLTRunnerExamples#Replace_embedded_objects_with_bitmap_images](here).