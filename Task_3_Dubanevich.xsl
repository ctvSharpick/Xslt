<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable
		name="uppercase"
		select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable
		name="lowercase"
		select="'abcdefghijklmnopqrstuvwxyz'" />
		
	<xsl:template name="upper">
		<xsl:param name="string" />

		<xsl:value-of select="translate($string, $lowercase, $uppercase)" />
    </xsl:template>
	
	<xsl:template name="delete-first-space">
		<xsl:param name="string" />
	
		<xsl:choose>
			<xsl:when test="starts-with($string, ' ')">
				<xsl:value-of select="normalize-space(substring($string, 2))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space($string)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:template name="_tokenize-delimiters">
    <xsl:param name="string" />
    <xsl:param name="delimiters" />
    <xsl:param name="last-delimit" />
	<xsl:param name="ASH" />
	<xsl:param name="Desc" />
	
    <xsl:choose>
        <xsl:when test="not($delimiters)">
			<xsl:choose>
				<xsl:when test="string-length(translate($string, ' ', '')) &lt; 31 and not($Desc)">
					<Service>
						<xsl:value-of select="concat($ASH, '/')"/>
						<xsl:call-template name="delete-first-space">
							<xsl:with-param name="string" select="$string" />
						</xsl:call-template>	
					</Service>
				</xsl:when>
				<xsl:when test="string-length(translate($string, ' ', '')) &gt; 30 and $Desc">		
						<Text>
							<xsl:call-template name="delete-first-space">
								<xsl:with-param name="string" select="$string" />
							</xsl:call-template>
						</Text>		
				</xsl:when>	  
			</xsl:choose>
        </xsl:when>
        <xsl:when test="contains($string, $delimiters)">
            <xsl:if test="not(starts-with($string, $delimiters))">
                <xsl:call-template name="_tokenize-delimiters">
                    <xsl:with-param name="string" select="substring-before($string, $delimiters)" />
                    <xsl:with-param name="delimiters" select="substring($delimiters, 2)" />
					<xsl:with-param name="ASH" select="$ASH" />
					<xsl:with-param name="Desc" select="$Desc" />
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="_tokenize-delimiters">
                <xsl:with-param name="string" select="substring-after($string, $delimiters)" />
                <xsl:with-param name="delimiters" select="$delimiters" />
				<xsl:with-param name="ASH" select="$ASH" />
				<xsl:with-param name="Desc" select="$Desc" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="_tokenize-delimiters">
                <xsl:with-param name="string" select="$string" />
                <xsl:with-param name="delimiters" select="substring($delimiters, 2)" />
				<xsl:with-param name="ASH" select="$ASH" />
				<xsl:with-param name="Desc" select="$Desc" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>	
		
	<xsl:template match="Amenities">
		<root>
			<Services>
				<xsl:apply-templates select="TopAmenityList" mode="Services" />
				<xsl:apply-templates select="AmenityList" mode="Services" />
				<xsl:apply-templates select="AmenitiesString" mode="Services" />
				<xsl:apply-templates select="//div[@data-reach-accordion]" mode="Services" />
			</Services>
			<Descriptions>
				<xsl:apply-templates select="TopAmenityList" mode="Descriptions" />	
				<xsl:apply-templates select="AmenityList" mode="Descriptions" />
				<xsl:apply-templates select="AmenitiesString" mode="Descriptions" />
				<xsl:apply-templates select="//div[@data-reach-accordion]" mode="Descriptions" />
			</Descriptions>
		</root>
	</xsl:template>

	<xsl:template match="Amenities/TopAmenityList" mode="Services">
		<xsl:for-each select="TopAmenityItem">
			<xsl:if test="string-length(translate(., ' ', '')) &lt; 31">
				<Service>
					<xsl:call-template name="TopAmenityItem">
						<xsl:with-param name="Item" select="." />
					</xsl:call-template>
				</Service>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="Amenities/TopAmenityList" mode="Descriptions">
		<xsl:for-each select="TopAmenityItem">
			<xsl:if test="string-length(translate(., ' ', '')) &gt; 30">
				<Description>
					<xsl:call-template name="TopAmenityItem">
						<xsl:with-param name="Item" select="." />
					</xsl:call-template>
				</Description>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="TopAmenityItem">
		<xsl:param name="Item" />
		
		<xsl:value-of select="ancestor::Amenities/TopAmenityHeader" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="normalize-space($Item)" />
					<xsl:if test="$Item/@class = 'inactive'">
						<xsl:text> (absent)</xsl:text>
					</xsl:if>
	</xsl:template>
		
	<xsl:template match="Amenities/AmenityList" mode="Services">
		<xsl:for-each select="AmenityItem">
			<xsl:if test="string-length(translate(., ' ', '')) &lt; 31">
				<Service>
					<xsl:call-template name="AmenityItem">
						<xsl:with-param name="Item" select="." />
					</xsl:call-template>
				</Service>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="Amenities/AmenityList" mode="Descriptions">
		<xsl:for-each select="AmenityItem">
			<xsl:if test="string-length(translate(., ' ', '')) &gt; 30">
				<Description>
					<xsl:call-template name="AmenityItem">
						<xsl:with-param name="Item" select="." />
					</xsl:call-template>
				</Description>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="AmenityItem">
		<xsl:param name="Item" />

		<xsl:value-of select="ancestor::Amenities/AmenityHeader" />
		<xsl:text>/</xsl:text>
		<xsl:choose>
			<xsl:when test="contains($lowercase, substring($Item, 1, 1))">
				<xsl:call-template name="upper">
					<xsl:with-param name="string" select="substring($Item, 1, 1)" />
				</xsl:call-template>
				<xsl:value-of select="normalize-space(substring($Item, 2))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space($Item)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template match="Amenities/AmenitiesString" mode="Services">
		<xsl:call-template name="_tokenize-delimiters">
	        <xsl:with-param name="string" select="." />
		    <xsl:with-param name="delimiters" select="','" />
			<xsl:with-param name="ASH" select="ancestor::Amenities/AmenityStringHeader" />
	    </xsl:call-template>
	</xsl:template>
	
	<xsl:template match="Amenities/AmenitiesString" mode="Descriptions">
		<Description>
			<xsl:attribute name="Title">
				<xsl:value-of select="../AmenityStringHeader"/>
			</xsl:attribute>
		<xsl:call-template name="_tokenize-delimiters">
	        <xsl:with-param name="string" select="." />
		    <xsl:with-param name="delimiters" select="','" />
			<xsl:with-param name="Desc" select="1" />
	    </xsl:call-template>
		</Description>
	</xsl:template>

	<xsl:template match="div[@data-reach-accordion]" mode="Services">
		<xsl:for-each select="div[@data-reach-accordion-item]">
			<xsl:for-each select="div/div/ul/li">
				<xsl:if test="string-length(translate(span[2], ' ', '')) &lt; 31">
					<xsl:choose>
					<xsl:when test="not(ul)">
						<Service>
							<xsl:value-of select="ancestor::div[3]/h3/button/span[1]"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="normalize-space(concat(span[1], ' ', span[2]))"/>
						</Service>
					</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="ul/li">
								<Service>
									<xsl:value-of select="ancestor::div[3]/h3/button/span[1]"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="ancestor::li[1]/span[1]"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="."/>
								</Service>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="not(div/div/node()[1]/node()[1])">
				<xsl:if test="string-length(translate(div/div, ' ', '')) &lt; 31">
					<Service>
						<xsl:value-of select="h3/button/span[1]"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="normalize-space(div/div)"/>
					</Service>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="div[@data-reach-accordion]" mode="Descriptions">
		<xsl:for-each select="div[@data-reach-accordion-item and (div/div/ul/li[string-length(translate(span[2], ' ', '')) &gt; 30]
							  or (not(div/div/node()[1]/node()[1]) and string-length(translate(div/div, ' ', '')) &gt; 30))]">
			<Description>
				<xsl:attribute name="Title">
					<xsl:value-of select="h3/button/span[1]"/>
				</xsl:attribute>
				<xsl:for-each select="div/div/ul/li">
					<xsl:if test="string-length(translate(span[2], ' ', '')) &gt; 30">
						<Text>
							<xsl:value-of select="normalize-space(concat(span[1], ' ', span[2]))"/>
						</Text>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not(div/div/node()[1]/node()[1]) and string-length(translate(div/div, ' ', '')) &gt; 30">
						<Text>
							<xsl:value-of select="normalize-space(div/div)"/>
						</Text>
				</xsl:if>
			</Description>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>