<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>
	<xsl:key name="param_group" match="Param" use="@Name"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Param[count(key('param_group',@Name)) > 1]/@Name">
				<xsl:attribute name="Name">
					<xsl:value-of select="concat(../@Name, ../@pos)" />
				</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>