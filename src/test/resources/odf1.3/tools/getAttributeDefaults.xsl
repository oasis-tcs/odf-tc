<?xml version="1.0" encoding="UTF-8"?>
<!--
  Use is subject to license terms.

  Licensed under the Apache License, Version 2.0 (the "License"); you may not
  use this file except in compliance with the License. You may obtain a copy
  of the License at http://www.apache.org/licenses/LICENSE-2.0. You can also
  obtain a copy of the License at http://odftoolkit.org/docs/license.txt

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

  See the License for the specific language governing permissions and
  limitations under the License.

-->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xt="http://www.jclark.com/xt" xmlns:common="http://exslt.org/common" xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi xt common xalan" xmlns="http://www.w3.org/1999/xhtml">
    <!-- Extracting default values from the ODF schema specification
        Idea by Daniel Carrera - https://danielcarrera.space/
		Since ODF 1.2 maintained by Svante Schubert -->
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />
    <xsl:param name="debug" select="false()" /> <!-- HERE! ENABLE DEBUG OUTPUT! -->

    <!-- ********************************************************** -->
    <!-- *** Get the default attribute values for ODF attributes ** -->
    <!-- ********************************************************** -->
    <xsl:template match="/">
        <config xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:rdfa="http://docs.oasis-open.org/opendocument/meta/rdfa#" office:version="1.2">
            <attributes>
                <xsl:apply-templates />
            </attributes>
        </config>
    </xsl:template>

    <!-- match every paragraph within the ODF specification declaring a default value (ie. has a 'Default_20_Value' style)  -->
    <xsl:template match="text:p[@text:style-name='Default_20_Value']">
        <xsl:call-template name="get-default-value-declaration">
            <xsl:with-param name="attributeName">
                <!-- get the attribute name of the default value by traversing backwards in the document to the previous attribute name (found in a heading) -->
                <xsl:apply-templates select="preceding::text:h[1]" mode="get-attribute-name" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <!-- find the attribute name of the defaults value  -->
    <xsl:template match="text:h" mode="get-attribute-name">

        <xsl:if test="$debug=true()">
            <xsl:message></xsl:message>
            <xsl:message></xsl:message>
            <xsl:message></xsl:message>
            <xsl:message>Preceding Header containing the ODF attribute name:</xsl:message>
            <xsl:message><xsl:copy-of select="."/></xsl:message>
        </xsl:if>

        <!-- Within the header is a reference mark, which gives clues about the default value's attribute for instance:
            <text:reference-mark-start text:name="attribute-table:number-columns-repeated_element-table:table-cell"/>
                possible names of the reference-mark:
                    attribute-draw:may-script
                    attribute-draw:type_element-draw:connector
                    attribute-draw:type_element-draw:enhanced-geometry
                    property-style:run-through
        -->
        <xsl:variable name="referenceMark" select="text:reference-mark-start/@text:name[contains(.,'attribute-') or contains(.,'property-')]" />
        <xsl:choose>
            <xsl:when test="contains($referenceMark, '_element') and contains($referenceMark,'attribute-')">
                <!-- example names of matched reference-mark:
                        attribute-draw:may-script
                        attribute-draw:type_element-draw:connector
                        attribute-draw:type_element-draw:enhanced-geometry
                        property-style:run-through
                  -->
                <xsl:value-of select="substring-after(substring-before($referenceMark, '_element'), 'attribute-')" />
            </xsl:when>
        	<xsl:when test="contains($referenceMark,'attribute-')">
                <!-- example names of matched reference-mark:
                        attribute-draw:may-script
                  -->
        		<xsl:value-of select="substring-after($referenceMark, 'attribute-')" />
        	</xsl:when>
            <xsl:otherwise>
            	<xsl:value-of select="substring-after($referenceMark, 'property-')" />
                <!-- example name of matched reference-mark:
                        property-style:run-through
                  -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Context is the paragraph with "Default_20_Value" styled -->
    <xsl:template name="get-default-value-declaration">
        <xsl:param name="attributeName" /><!-- extraced from text reference from preceding header -->

        <xsl:if test="$debug=true()">
            <xsl:message>.</xsl:message>
            <xsl:message>From header extracted ODF attribute:</xsl:message>
            <xsl:message>@<xsl:value-of select="$attributeName"/></xsl:message>
            <xsl:message>.</xsl:message>
            <xsl:message>The paragraph with default value within:</xsl:message>
            <xsl:message><xsl:copy-of select="."/></xsl:message>
        </xsl:if>

        <xsl:variable name="defaultValue">
            <!-- get the default Value (ie. the sum of all spans with 'Attribute_20_Value' style)  -->
            <xsl:variable name="defaultValueString" select="string-join(text:span[@text:style-name='Attribute_20_Value' or @text:style-name='Attribute_20_Value_20_Instance'])" />
            <xsl:choose>
                <xsl:when test="normalize-space($defaultValueString) != ''">
                    <xsl:value-of select="normalize-space($defaultValueString)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$defaultValueString" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- With ODF 1.2 this no longer occurs as all default values were removed from the schema,
            due to the problem default value insertion into the XML by parsers
            see https://github.com/oasis-tcs/odf-tc/blob/master/src/test/resources/odf1.3/tools/How_to_prepare_ODF_specification_documents.md
             -->
        <xsl:if test="*[@text:style-name='Attribute_20_Value_20_Instance']">
            <xsl:if test="$debug=true()">
                <xsl:message>WARNING:</xsl:message>
                <xsl:message>   Style 'Attribute_20_Value_20_Instance' should be deprecated in favor to 'Attribute_20_Value'.</xsl:message>
                <xsl:message>   The attribute '<xsl:value-of select="$attributeName"/>' does not have a default value in the ODF schema since ODF 1.2.</xsl:message>
                <xsl:message>   Default avlues were removed due to the problem of (re)insertion during loading by XML by parsers!</xsl:message>
            </xsl:if>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="text:span[@text:style-name='Element']">

                <!-- sometimes a default values only occurs on a certain element or elements -->
                <xsl:for-each select="text:span[@text:style-name='Element']">

                    <xsl:if test="$debug=true()">
                        <xsl:message>.</xsl:message>
                        <xsl:message>Span with 'Element' style:</xsl:message>
                        <xsl:message><xsl:copy-of select="."/></xsl:message>
                    </xsl:if>

                    <!-- use the element name without the brackets -->
                    <xsl:variable name="elementName">
                        <xsl:call-template name="get-element-name">
                            <xsl:with-param name="nameString" select="normalize-space(.)" />
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="$elementName != ''">
                        <xsl:if test="$debug=true()">
                            <xsl:message>.</xsl:message>
                            <xsl:message>Default applies only for ODF element:</xsl:message>
                            <xsl:message>* <xsl:value-of select="$elementName" /></xsl:message>
                        </xsl:if>
                        <xsl:element name="attribute">
                            <xsl:attribute name="name">
                                <xsl:value-of select="$attributeName" />
                            </xsl:attribute>
                            <xsl:attribute name="defaultValue">
                                <xsl:value-of select="$defaultValue" />
                            </xsl:attribute>
                            <xsl:attribute name="element">
                                <xsl:value-of select="$elementName" />
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="attribute">
                    <!-- if the default value occurs for all elements -->
                    <xsl:attribute name="name">
                        <xsl:value-of select="$attributeName" />
                    </xsl:attribute>
                    <xsl:attribute name="defaultValue">
                        <xsl:value-of select="$defaultValue" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- recursivly the element name is being gathered (span by span), as sometimes the element name was split by multiple spans
        these span contents are being concatenated until both element delimeter ('<' and '>') are found within the string -->
    <xsl:template name="get-element-name">
        <xsl:param name="nameString" />

        <xsl:if test="$debug=true()">
            <xsl:message>Evaluating parent element name: '<xsl:copy-of select="$nameString"/>'</xsl:message>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="contains($nameString, '&lt;') and contains($nameString, '&gt;')">
                <!-- the name of the element -->
                <xsl:value-of select='substring-after(substring-before($nameString, "&gt;"), "&lt;")' />
            </xsl:when>
            <xsl:when test="not(contains($nameString, '&gt;'))">
                <!-- the name of the element was separated into several text:span -->
                <xsl:call-template name="get-element-name">
                    <xsl:with-param name="nameString" select="concat($nameString, normalize-space(string-join(following-sibling::text:span)))" />
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="@*|comment()|text()" />

    <xsl:template match="*">
        <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>
