<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="Hotel">
		<Property>
			<xsl:apply-templates select="HotelName" />
			<xsl:apply-templates select="HotelName/@category" />
			<xsl:apply-templates select="HotelName/@rating" />
			<ContactInfo>
				<xsl:apply-templates select="Address/ContactItem[@class='address']" />
				<xsl:apply-templates select="Contact/ContactItem[@class='phone']" />
				<xsl:apply-templates select="Contact/ContactItem[@class='website']/Link/@href" />
			</ContactInfo>
		</Property>
	</xsl:template>

	<xsl:template match="HotelName">
		<PropertyName>
			<xsl:value-of select="text()" />
		</PropertyName>
	</xsl:template>

	<xsl:template match="HotelName/@category">
		<PropertyType>
			<xsl:value-of select="." />
		</PropertyType>
	</xsl:template>

	<xsl:template match="HotelName/@rating">
		<StarRating>
			<xsl:attribute name="type">
				<xsl:value-of select="substring-before(., '-')" />
			</xsl:attribute>
			<xsl:value-of select="substring-after(., '-')" />
		</StarRating>
	</xsl:template>

	<xsl:template match="ContactItem[@class='address']">
		<Address>
			<AddressLine>
				<xsl:value-of select="text()" />
			</AddressLine>
			<StreetNumber>
				<xsl:value-of select="substring-before(text(), ',')" />
			</StreetNumber>
		</Address>
	</xsl:template>

	<xsl:template match="ContactItem[@class='phone']">
		<Phone>
			<xsl:value-of select="concat('+1 ', translate(text(), ' ()', '-'))" />
		</Phone>
	</xsl:template>

	<xsl:template match="ContactItem[@class='website']/Link/@href">
		<xsl:variable name="TempUrl">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param
					name="input"
					select="." />
				<xsl:with-param
						  name="search-string"
						  select="'%2F'" />
				<xsl:with-param
						  name="replace-string"
						  select="'/'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Url">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param
					name="input"
					select="$TempUrl" />
				<xsl:with-param
						  name="search-string"
						  select="'%3A'" />
				<xsl:with-param
						  name="replace-string"
						  select="':'" />
			</xsl:call-template>
		</xsl:variable>
		<Website>
			<xsl:value-of select="substring-after($Url, 'url=')"/>
		</Website>
	</xsl:template>

	<xsl:template name="search-and-replace">
		<xsl:param name="input" />
		<xsl:param name="search-string" />
		<xsl:param name="replace-string" />
		
		<xsl:choose>
			<xsl:when test="$search-string and contains($input,$search-string)">
				
				<xsl:value-of select="substring-before($input,$search-string)" />
				<xsl:value-of select="$replace-string" />
				
				<xsl:call-template name="search-and-replace">
					<xsl:with-param
					  name="input"
					  select="substring-after($input,$search-string)" />
					<xsl:with-param
					  name="search-string"
					  select="$search-string" />
					<xsl:with-param
					  name="replace-string"
					  select="$replace-string" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$input" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>