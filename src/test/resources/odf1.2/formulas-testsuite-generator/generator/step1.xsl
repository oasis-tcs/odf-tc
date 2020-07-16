<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
 xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
 xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
 xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
 xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
 xmlns:oooc="http://openoffice.org/2004/calc"
 xmlns:odf="http://opendocumentfellowship.org/1.0/spec"
 office:version="1.0">

<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:template match="/office:document">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*">
  <xsl:copy><xsl:copy-of select="@*"/><xsl:apply-templates/></xsl:copy>
</xsl:template>

<xsl:template match="office:automatic-styles">
  <xsl:copy>
    <style:style style:name="WideRowStyle" style:family="table-row">
      <style:table-row-properties style:row-height="1cm"
                 style:use-optimal-row-height="false"/>
    </style:style>
    <style:style style:name="WarningCellStyle" style:family="table-cell" 
                 style:parent-style-name="Default">
     <style:text-properties fo:color="#dd2222" fo:font-size="11pt"
							fo:font-weight="bold"/>
    </style:style>
    <!-- Conditional style -->
    <style:style style:name="PassFailStyle" style:family="table-cell" 
				 style:parent-style-name="Default">
   <style:text-properties style:font-name="Bitstream Vera Sans"/>
   <style:map style:condition="cell-content()=1" style:apply-style-name="Green"/>
   <style:map style:condition="cell-content()!=1" style:apply-style-name="Red"/>
    </style:style>
    <xsl:copy-of select="@*"/><xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="office:spreadsheet">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
	<xsl:apply-templates select="table:calculation-settings"/>
    <!-- We only care about the first table. -->
    <xsl:apply-templates select="table:table[1]"/>
	<xsl:apply-templates select="table:named-expressions"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="table:table">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
    <xsl:apply-templates select="document('tests.xml')//table:table" mode="tests"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="table:table" mode="tests">
  <!-- First figure out whether to process this table. -->
  <xsl:if test="table:table-row/table:table-cell/text:p[@text:style-name='Table_20_Heading']='Expression' and table:table-row/table:table-cell/text:p[@text:style-name='Table_20_Heading']='Result' and table:table-row/table:table-cell/text:p[@text:style-name='Table_20_Heading']='Comment'">
    <xsl:apply-templates select="table:table-row" mode="tests"/>
  </xsl:if>
</xsl:template>

<xsl:template match="table:table-row" mode="tests">
  <!-- Copy any row other than the header -->
  <xsl:if test="not(table:table-cell/text:p[@text:style-name='Table_20_Heading']='Expression')">
    <table:table-row table:style-name="WideRowStyle">
      <xsl:call-template name="section"/>
      <xsl:call-template name="expression"/>
      <xsl:call-template name="expected"/>
      <xsl:call-template name="level"/>
      <xsl:call-template name="comment"/>
      <xsl:call-template name="actual-result"/>
      <odf:test-result/>
    </table:table-row>
  </xsl:if>
</xsl:template>

<!-- 1st column - section -->
<xsl:template name="section">
  <xsl:call-template name="pass-as-string">
    <xsl:with-param name="node" select="../preceding-sibling::text:h[1]"/>
  </xsl:call-template>
</xsl:template>

<!-- 2nd column - expression -->
<xsl:template name="expression">
  <xsl:call-template name="pass-as-string">
    <xsl:with-param name="node" select="table:table-cell[1]"/>
  </xsl:call-template>
</xsl:template>

<!-- 4th column - level -->
<xsl:template name="level">
  <xsl:call-template name="pass-as-string">
    <xsl:with-param name="node" select="table:table-cell[3]"/>
  </xsl:call-template>
</xsl:template>

<!-- 5th column - comment -->
<xsl:template name="comment">
  <xsl:call-template name="pass-as-string">
    <xsl:with-param name="node" select="table:table-cell[4]"/>
  </xsl:call-template>
</xsl:template>

<!-- 6th column - actual result -->
<xsl:template name="actual-result">
  <xsl:variable name="formula" select="table:table-cell[1]/text:p"/>
  <table:table-cell table:formula="oooc:{normalize-space($formula)}"/>
</xsl:template>

<!-- 3rd column - expected result -->
<xsl:template name="expected">
  <xsl:variable name="val" select="normalize-space(table:table-cell[2]/text:p)"/>

  <!-- These variables also remove the round brackets (). -->
  <xsl:variable name="downcase"
				select="translate($val,'AEFLNORSTU()','aeflnorstu')"/>
  <xsl:variable name="upcase"
				select="translate($val,'aeflnorstu()','AEFLNORSTU')"/>
  <xsl:choose>
    <!-- Logical -->
    <xsl:when test="$downcase='false' or $downcase='true'">
      <table:table-cell office:boolean-value="{$downcase}"
                        office:value-type="boolean"/>
    </xsl:when>
    <!-- Errors -->
    <xsl:when test="$upcase='NA' or $upcase='=NA'">
      <!-- I want to pickup =NA() in order to add odf:type="error" -->
      <table:table-cell table:formula="oooc:=NA()" odf:type="error"/>
    </xsl:when>
    <xsl:when test="$downcase='error'">
      <!-- I want to pickup 'Error' in order to add odf:type="error" -->
      <table:table-cell office:value-type="string" odf:type="error">
        <text:p>Error</text:p>
      </table:table-cell>
    </xsl:when>
    <!-- Number -->
    <xsl:when test="number($val)=$val">
      <table:table-cell office:value="{$val}" office:value-type="float">
        <text:p><xsl:value-of select="$val"/></text:p>
      </table:table-cell>
    </xsl:when>
    <!-- Formulas -->
    <xsl:when test="substring($val,1,1)='='">
      <table:table-cell table:formula="oooc:{$val}"/>
    </xsl:when>
    <!-- String - &quot; -->
    <xsl:when test="starts-with($val,'&quot;')">
      <table:table-cell table:formula="oooc:={$val}" office:value-type="string"/>
    </xsl:when>
    <!-- Default to string -->
    <xsl:otherwise>
      <xsl:variable name="str" select="string($val)"/>
      <table:table-cell office:value="{$str}" office:value-type="string">
        <text:p><xsl:value-of select="$str"/></text:p>
      </table:table-cell>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="pass-as-string">
  <xsl:param name="node"/>
  <table:table-cell office:value-type="string">
    <text:p><xsl:value-of select="normalize-space($node)"/></text:p>
  </table:table-cell>
</xsl:template>

</xsl:stylesheet>
