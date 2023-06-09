<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
    <!-- copy everything without altering it -->
    <xsl:template match="node()|@*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*|processing-instruction()|comment()" />
        </xsl:copy>
    </xsl:template> 
</xsl:stylesheet>