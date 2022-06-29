<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Objects">
		<Objects>
			<xsl:apply-templates select="Object">
				<xsl:sort select="@ID" data-type="number"/>
			</xsl:apply-templates>
		</Objects>
	</xsl:template>

	<xsl:template match="Object[number(@ID) mod 2 != 0]"/>
	
</xsl:stylesheet>