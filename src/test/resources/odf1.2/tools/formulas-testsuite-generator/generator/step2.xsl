<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
 xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
 xmlns:oooc="http://openoffice.org/2004/calc"
 xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
 xmlns:odf="http://opendocumentfellowship.org/1.0/spec"
 office:version="1.0">

<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<!-- ================================================
     step1.xsl produces the entire spreadsheet except
     for one column: Is the test result correct?
     This stylsheet produces that column.
     ================================================
 -->

<xsl:template match="/office:document">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*">
  <xsl:copy><xsl:copy-of select="@*"/><xsl:apply-templates/></xsl:copy>
</xsl:template>

<xsl:template match="odf:test-result">
  <xsl:variable name="row" select="count(../preceding-sibling::table:table-row)+sum(../preceding-sibling::table:table-row/@table:number-rows-repeated) - count(../preceding-sibling::table:table-row/@table:number-rows-repeated) + 1"/>

  <!-- COLUMN G
       Inform the implementor if the result is correct
    -->
  <xsl:variable name="expected" select="../table:table-cell[3]"/>
  <xsl:choose>
    <!-- Tests that should give an error. -->
    <xsl:when test="translate($expected/text:p,'ERROR','error')='error'">
      <table:table-cell table:style-name="PassFailStyle"
					table:formula="oooc:=IF(ISERROR([.F{$row}]);1;0)"/>
    </xsl:when>
    <xsl:when test="$expected[@table:formula='oooc:=NA()']">
      <table:table-cell table:style-name="PassFailStyle"
					table:formula="oooc:=IF(ISNA([.F{$row}]);1;0)"/>
    </xsl:when>
    <!-- Tests that allow a margin of error. -->
    <xsl:when test="contains($expected/text:p,'±ε')">
      <xsl:variable name="val" select="substring-before($expected/text:p,'±ε')"/>
      <table:table-cell table:style-name="PassFailStyle"
				table:formula="oooc:=IF(ABS([.F{$row}]-{$val})&lt;[.D1];1;0)"/>
    </xsl:when>
    <xsl:when test="contains($expected/text:p,'±')">
      <xsl:variable name="val" select="substring-before($expected/text:p,'±')"/>
      <xsl:variable name="eps" select="substring-after($expected/text:p,'±')"/>
      <table:table-cell table:style-name="PassFailStyle"
				table:formula="oooc:=IF(ABS([.F{$row}]-{$val})&lt;{$eps};1;0)"/>
    </xsl:when>
    <!-- Default to plain = comparison -->
    <xsl:otherwise>
      <table:table-cell table:style-name="PassFailStyle"
 				table:formula="oooc:=IF(ISERROR([.F{$row}]);0;IF([.C{$row}]=[.F{$row}];1;0))"/>
    </xsl:otherwise>
  </xsl:choose>

  <!-- COLUMN H
       Additional error reporting.
    -->
  <xsl:variable name="expression" select="normalize-space(../table:table-cell[2]/text:p)"/>
  <xsl:choose>
    <xsl:when test="not(starts-with($expression,'='))">
      <!-- Expression doesn't begin with an '=' sign. -->
      <table:table-cell table:style-name="WarningCellStyle">
        <text:p>SPEC ERROR: Expression does not begin with an '=' sign.</text:p>
      </table:table-cell>
    </xsl:when>
    <xsl:when test="contains($expression,',')">
      <!-- It is unlikely that an expression would contain a , -->
      <table:table-cell table:style-name="WarningCellStyle">
        <text:p>SPEC WARNING: Expression contains a comma.</text:p>
      </table:table-cell>
    </xsl:when>
    <xsl:when test="$expected/@odf:type='error'">
		<!-- Do nothing. -->
    </xsl:when>
	<xsl:otherwise>
      <table:table-cell table:style-name="WarningCellStyle"
	    table:formula="oooc:=IF(ISERROR([.F{$row}]);&quot;App gives unexpected error.&quot;;&quot;&quot;)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
