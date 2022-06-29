<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />

	<xsl:key name="roomGroup" match="h3" use="@roomCode" />

	<xsl:template match="RoomList">
		<GuestRooms>
			<xsl:apply-templates select="div/h3" />
		</GuestRooms>
	</xsl:template>

	<xsl:template match="RoomList/div/h3">
		<xsl:if test="generate-id(.) = generate-id(key('roomGroup',@roomCode))">
			<GuestRoom>
				<xsl:attribute name="Code">
					<xsl:value-of select="substring-after(., ' ')"/>
				</xsl:attribute>
				<xsl:attribute name="RoomTypeName">
					<xsl:value-of select="@roomCode" />
				</xsl:attribute>
				<xsl:call-template name="Amenities">
					<xsl:with-param name="Ul" select="../div/div[2]/ul" />
				</xsl:call-template>
				<MultimediaDescriptions>
					<MultimediaDescription>
						<xsl:call-template name="ImageItems">
							<xsl:with-param name="Img" select="../div[1]/picture/img" />
						</xsl:call-template>
					</MultimediaDescription>
					<MultimediaDescription>
						<xsl:call-template name="TextItems">
							<xsl:with-param name="Div" select="../div/div[1]" />
						</xsl:call-template>
					</MultimediaDescription>
				</MultimediaDescriptions>
			</GuestRoom>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Amenities">
		<xsl:param name="Ul" />

		<Amenities>
			<xsl:for-each select="$Ul/li">
				<Amenity>
					<DescriptiveText>
						<xsl:value-of select="preceding::h4[1]"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="."/>
					</DescriptiveText>
				</Amenity>
			</xsl:for-each>
		</Amenities>
	</xsl:template>

	<xsl:template name="ImageItems">
		<xsl:param name="Img" />
	
				<ImageItems>
					<ImageItem>
						<ImageFormat>
							<URL>
								<xsl:value-of select="$Img/@src"/>
							</URL>
						</ImageFormat>
						<Description>
							<xsl:attribute name="Caption">
								<xsl:value-of select="$Img/@alt"/>
							</xsl:attribute>
						</Description>
					</ImageItem>
				</ImageItems>
	</xsl:template>

	<xsl:template name="TextItems">
		<xsl:param name="Div" />

		<TextItems>
			<TextItem>
				<xsl:attribute name="Title">
					<xsl:value-of select="$Div/h4"/>
				</xsl:attribute>
				<Description>
					<xsl:attribute name="Language">
						<xsl:text>en</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="normalize-space($Div/p)"/>
				</Description>
			</TextItem>
		</TextItems>
	</xsl:template>
	
</xsl:stylesheet>