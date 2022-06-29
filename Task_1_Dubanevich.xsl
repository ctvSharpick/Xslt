<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:ms="urn:schemas-microsoft-com:xslt"
  exclude-result-prefixes="ms">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="Hotels">
		<Lists>
			<Names>
				<xsl:apply-templates select="Hotel/Name" />
			</Names>
			<Prices>
				<xsl:apply-templates select="Hotel" />
			</Prices>
			<Addresses>
				<xsl:apply-templates select="Hotel/Address" />
			</Addresses>
		</Lists>		
	</xsl:template>

	<xsl:template match="Hotels/Hotel/Name">		
		<xsl:variable name="State" select="../Address/State"/>		
		<xsl:if test="contains(.,'Hilton') and (ms:string-compare($State,'NEW YORK','','i')=0 or ms:string-compare($State,'NY','','i')=0)">
				<xsl:copy-of select="." />
		</xsl:if>		
	</xsl:template>
	
	<xsl:template match="Hotels/Hotel">		
		<xsl:variable name="State" select="Address/State"/>		
		<xsl:if test="contains(./Name,'Hilton') and (ms:string-compare($State,'NEW YORK','','i')=0 or ms:string-compare($State,'NY','','i')=0)">
			<Price>
				<xsl:value-of select="./@Price"/>
			</Price>
		</xsl:if>		
	</xsl:template>
	
	<xsl:template match="Hotels/Hotel/Address">		
		<xsl:variable name="State" select="State"/>		
		<xsl:if test="contains(../Name,'Hilton') and (ms:string-compare($State,'NEW YORK','','i')=0 or ms:string-compare($State,'NY','','i')=0)">
				<xsl:copy-of select="./AddressLine" />
		</xsl:if>		
	</xsl:template>

</xsl:stylesheet>