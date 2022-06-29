<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>
	<xsl:key name="function_group" match="Function" use="@Name"/>
	<xsl:key name="procedure_group" match="Procedure" use="@Name"/>
	
	<xsl:template match="Objects">
		<root>
			<Functions>				
				<xsl:apply-templates mode="Functions" />
			</Functions>
			<Procedures>
				<xsl:apply-templates mode="Procedures" />			
			</Procedures>
		</root>
	</xsl:template>

	<xsl:template match="Function" mode="Functions">
		<xsl:if test="count(key('function_group',@Name)) > 1 and generate-id(.) = generate-id(key('function_group',@Name))">
			<xsl:for-each select="key('function_group',@Name)">
				<xsl:copy-of select ="."/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Procedure"  mode="Procedures">
		<xsl:if test="count(key('procedure_group',@Name)) > 1 and generate-id(.) = generate-id(key('procedure_group',@Name))">
			<xsl:for-each select="key('procedure_group',@Name)">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!--<xsl:template match="@*[ancestor::Function]|node()[ancestor::Function]">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*[ancestor::Procedure]|node()[ancestor::Procedure]">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="Function" mode="Functions">
		<xsl:if test="count(key('function_group',@Name)) > 1 and generate-id(.) = generate-id(key('function_group',@Name))">
			<xsl:for-each select="key('function_group',@Name)">
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Procedure"  mode="Procedures">
		<xsl:if test="count(key('procedure_group',@Name)) > 1 and generate-id(.) = generate-id(key('procedure_group',@Name))">
			<xsl:for-each select="key('procedure_group',@Name)">
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:for-each>
		</xsl:if>
</xsl:template>-->

</xsl:stylesheet>