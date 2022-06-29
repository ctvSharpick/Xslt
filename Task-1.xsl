<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:strip-space elements="*" />
<xsl:output method="xml" indent="yes"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="Procedure[count(*)=0]" />
	<xsl:template match="Function[count(*)=0]" />
	<xsl:template match="@java_package[string-length(.)=0]" >
		<!--<xsl:if test="string-length(.)!=0">
			<xsl:copy />
		</xsl:if>-->
	</xsl:template>
</xsl:stylesheet>