<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:html="http://www.w3.org/1999/xhtml"
 xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" encoding="UTF-8"/>

    <!-- style inside head -->
    <xsl:template match="html:style">
        <xsl:copy-of select="."/>
        <!-- adding MathML handling JavaScript -
               <script type="text/javascript" src="..."/> -->
        <xsl:element name="script">
            <xsl:attribute name="type">text/javascript</xsl:attribute>
            <xsl:attribute name="src">styles/mml-svg.js</xsl:attribute>
            <xsl:comment>Because browsers are utterly terrible, here is a comment to force a script end tag to be generated from XSLT so you don't see a blank page</xsl:comment>
        </xsl:element>
    </xsl:template>

    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
