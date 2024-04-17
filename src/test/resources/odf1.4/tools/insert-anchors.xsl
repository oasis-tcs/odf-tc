<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:rng="http://relaxng.org/ns/structure/1.0"                
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                exclude-result-prefixes="xsl rng">
  <xsl:output method="xml"/>
  <xsl:variable name="non-tag-suffix-regex" select="'&gt;[^&gt;]+$'"/>
  <xsl:variable name="non-name-suffix-regex" select="'\s+\([Dd]eprecated\)\s*'"/>
  <xsl:variable name="non-tag-prefix-regex" select="'^Deprecated &lt;'"/>
  <xsl:variable name="non-name-prefix-regex" select="'^Deprecated '"/>
      
<xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
</xsl:template>

<!-- Find headed sections that define elements, attributes, properties and datatypes, 
	 and at the end of each section insert a paragraph styled 'P2' that contains 
	 <prefix> '-' <name>, where <prefix> is one of 'element-', 'attribute-', 'property-' or 
	 'datatype-' and <name> is the (qualified) name of the element, attribute, property or 
	 datatype. 
-->
	
<xsl:template match="//text:h|//text:list[@text:style-name='Appendix' and not(preceding::text:list[@text:style-name='Appendix'])]">
      <xsl:variable name="name">
            <xsl:variable name="raw">
                  <xsl:value-of select="preceding-sibling::text:h[1]"/>
            </xsl:variable>
            <xsl:choose>
                  <xsl:when test="matches($raw,'General')">
                        <xsl:value-of select="preceding-sibling::text:h[2]"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="preceding-sibling::text:h[1]"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>
      <xsl:variable name="prefix">
            <xsl:choose>
                  <xsl:when test="preceding-sibling::text:h[.='Metadata Manifest Files']"/>
                  <xsl:when test="preceding-sibling::text:h[.='Digital Signatures Attributes']">
                        <xsl:text>attribute-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='Digital Signatures File']">
                        <xsl:text>element-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='Manifest Attributes']">
                        <xsl:text>attribute-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='Manifest File']">
                        <xsl:text>element-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='Formatting Attributes']">
                        <xsl:text>property-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='General Attributes']">
                        <xsl:text>attribute-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='Datatypes']">
                        <xsl:text>datatype-</xsl:text>
                  </xsl:when>
                  <xsl:when test="preceding-sibling::text:h[.='manifest.rdf'] and (.='Non-RDF Metadata' or following-sibling::text:h[.='Non-RDF Metadata'])"/>
                  <xsl:otherwise>
                        <xsl:text>element-</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>
      <xsl:if test="matches($name,':') and not($prefix='') and not(preceding-sibling::*[1][self::text:h]) and not(($prefix='attribute-' or $prefix='property-' or $prefix='datatype-') and preceding-sibling::text:h[1][.='General'])">
            <text:p text:style-name="P2">
                  <xsl:choose>
                        <xsl:when test="($prefix='attribute-' or $prefix='property-') and matches($name,'&gt;(,| and) &lt;')">
                              <xsl:variable name="att-name">
                                    <xsl:value-of select="normalize-space(preceding-sibling::text:h[matches(.,':') and not(matches(.,'&lt;.+&gt;'))][1])"/>
                              </xsl:variable>
                              <xsl:choose>
                                    <xsl:when test="matches($att-name,$non-name-suffix-regex)">
                                          <xsl:value-of select="concat($prefix,normalize-space(tokenize($att-name,$non-name-suffix-regex)[1]))"/>
                                    </xsl:when>
                                    <xsl:when test="matches($att-name,$non-tag-prefix-regex)">
                                          <xsl:value-of select="concat($prefix,normalize-space(tokenize($att-name,$non-name-prefix-regex)[2]))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <xsl:value-of select="concat($prefix,$att-name)"/>
                                    </xsl:otherwise>
                              </xsl:choose>
                              <xsl:for-each select="tokenize($name,'&gt;(,| and) &lt;')">
                                    <xsl:choose>
                                          <xsl:when test="matches(.,$non-tag-suffix-regex)">
                                                <xsl:value-of select="translate(concat('_element-',tokenize(.,$non-tag-suffix-regex)[1]),'&gt;&lt;','')"/>
                                          </xsl:when>
                                          <xsl:when test="matches(.,$non-tag-prefix-regex)">
                                                <xsl:value-of select="translate(concat('_element-',tokenize(.,$non-tag-prefix-regex)[2]),'&gt;&lt;','')"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:value-of select="translate(concat('_element-',.),'&gt;&lt;','')"/>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="($prefix='attribute-' or $prefix='property-') and matches($name,'&lt;.+&gt;')">
                              <xsl:variable name="att-name">
                                    <xsl:value-of select="normalize-space(preceding-sibling::text:h[matches(.,':') and not(matches(.,'&lt;.+&gt;'))][1])"/>
                              </xsl:variable>
                              <xsl:choose>
                                    <xsl:when test="matches($att-name,$non-name-suffix-regex)">
                                          <xsl:value-of select="concat($prefix,tokenize($att-name,$non-name-suffix-regex)[1])"/>
                                    </xsl:when>
                                    <xsl:when test="matches($att-name,$non-name-prefix-regex)">
                                          <xsl:value-of select="concat($prefix,tokenize($att-name,$non-name-prefix-regex)[2])"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <xsl:value-of select="concat($prefix,$att-name)"/>
                                    </xsl:otherwise>
                              </xsl:choose>
                              <xsl:choose>
                                    <xsl:when test="matches($name,$non-tag-suffix-regex)">
                                          <xsl:value-of select="translate(concat('_element-',tokenize($name,$non-tag-suffix-regex)[1]),'&gt;&lt;','')"/>
                                    </xsl:when>
                                    <xsl:when test="matches($name,$non-tag-prefix-regex)">
                                          <xsl:value-of select="translate(concat('_element-',tokenize($name,$non-tag-prefix-regex)[2]),'&gt;&lt;','')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <xsl:value-of select="translate(concat('_element-',$name),'&gt;&lt;','')"/>
                                    </xsl:otherwise>
                              </xsl:choose>
                        </xsl:when>
                        <xsl:when test="($prefix='attribute-' or $prefix='property-') and matches($name,$non-name-suffix-regex)">
                              <xsl:value-of select="concat($prefix,tokenize($name,$non-name-suffix-regex)[1])"/>
                        </xsl:when>
                        <xsl:when test="($prefix='attribute-' or $prefix='property-') and matches($name,$non-name-prefix-regex)">
                              <xsl:value-of select="concat($prefix,tokenize($name,$non-name-prefix-regex)[2])"/>
                        </xsl:when>
                        <xsl:when test="matches($name,$non-tag-suffix-regex)">
                              <xsl:value-of select="translate(concat($prefix,tokenize($name,$non-tag-suffix-regex)[1]),'&gt;&lt;','')"/>
                        </xsl:when>
                        <xsl:when test="matches($name,$non-tag-prefix-regex)">
                              <xsl:value-of select="translate(concat($prefix,tokenize($name,$non-tag-prefix-regex)[2]),'&gt;&lt;','')"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:value-of select="translate(concat($prefix,$name), '&gt;&lt;', '')" />
                        </xsl:otherwise>
                  </xsl:choose>
            </text:p>
      </xsl:if>
      <xsl:if test="$prefix='datatype-' and .='Other Datatypes'">
            <xsl:for-each select="preceding-sibling::text:list[1]/text:list-item[text:p]">
                  <xsl:variable name="datatype">
                        <xsl:value-of select="text:p[1]"/>
                  </xsl:variable>
                  <text:p text:style-name="P2">
                        <xsl:value-of select="concat('datatype-',$datatype)"/>
                  </text:p>
            </xsl:for-each>
      </xsl:if>
      <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
      </xsl:copy>
</xsl:template>

  
</xsl:stylesheet>
