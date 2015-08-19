<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    TODO: Describe this XSL file
    Author: Alexey Maslov

-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman util">

    <!--<xsl:import href="../dri2xhtml-alt/dri2xhtml.xsl"/>-->
    <xsl:import href="aspect/artifactbrowser/artifactbrowser.xsl"/>
    <xsl:import href="core/global-variables.xsl"/>
    <xsl:import href="core/elements.xsl"/>
    <xsl:import href="core/forms.xsl"/>
    <xsl:import href="core/page-structure.xsl"/>
    <xsl:import href="core/navigation.xsl"/>
    <xsl:import href="core/attribute-handlers.xsl"/>
    <xsl:import href="core/utils.xsl"/>
    <xsl:import href="aspect/general/choice-authority-control.xsl"/>
    <xsl:import href="aspect/general/vocabulary-support.xsl"/>
    <!--<xsl:import href="xsl/aspect/administrative/administrative.xsl"/>-->
    <xsl:import href="aspect/artifactbrowser/common.xsl"/>
    <xsl:import href="aspect/artifactbrowser/item-list.xsl"/>
    <xsl:import href="aspect/artifactbrowser/item-view.xsl"/>
    <xsl:import href="aspect/artifactbrowser/community-list.xsl"/>
    <xsl:import href="aspect/artifactbrowser/collection-list.xsl"/>
    <xsl:import href="aspect/artifactbrowser/browse.xsl"/>
    <xsl:import href="aspect/discovery/discovery.xsl"/>
    <xsl:import href="aspect/artifactbrowser/one-offs.xsl"/>
    <xsl:import href="aspect/submission/submission.xsl"/>
    <xsl:output indent="yes"/>


    <xsl:template
            match="dri:referenceSet[@id='aspect.artifactbrowser.CommunityBrowser.referenceSet.community-browser']">
        <div id="sidetree">
            <div id="sidetreecontrol"><a href="?#" class="ds-button-field btn btn-default">Collapse All</a>&#160;
                <a href="?#" class="ds-button-field btn btn-default">Expand All</a>
            </div>
            <ul id="tree">
                <xsl:apply-templates select="*[not(name()='head')]" mode="summaryList"/>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="text()[not(../*)]">
        <xsl:call-template name="replace">
            <xsl:with-param name="text" select="."/>
            <xsl:with-param name="search" select="'&amp;nbsp;'"/>
            <xsl:with-param name="replace" select="''"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="replace">
        <xsl:param name="text"/>
        <xsl:param name="search"/>
        <xsl:param name="replace"/>
        <xsl:choose>
            <xsl:when test="contains($text, $search)">
                <xsl:variable name="replace-next">
                    <xsl:call-template name="replace">
                        <xsl:with-param name="text" select="substring-after($text, $search)"/>
                        <xsl:with-param name="search" select="$search"/>
                        <xsl:with-param name="replace" select="$replace"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(substring-before($text, $search),$replace,$replace-next)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
            match="dri:list[@n='language']/dri:item/dri:xref/text()
            | dri:list[@id='aspect.discovery.SidebarFacetsTransformer.list.language']/dri:item/text()
            | dri:div[@id='aspect.discovery.SearchFacetFilter.div.browse-by-language-results']/dri:table/dri:row/dri:cell/dri:xref/text()">
        <xsl:apply-templates select="*[not(name()='head')]"/>
        <xsl:variable name="language">
            <xsl:value-of select="substring-before(.,' (')"/>
        </xsl:variable>
        <xsl:for-each select=".">
            <xsl:value-of select="concat(util:isoLanguageToDisplay($language),' (', substring-after(.,'('))"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
            match="dri:list[@id='aspect.discovery.SidebarFacetsTransformer.list.subject' and @n='subject']/dri:item//text()
                        | dri:list[@id='aspect.discovery.SidebarFacetsTransformer.list.subject']//text()
                        | dri:div[@id='aspect.discovery.SearchFacetFilter.div.browse-by-subject-results']/dri:table/dri:row/dri:cell//text()">
        <xsl:apply-templates select="*[not(name()='head')]"/>
        <xsl:variable name="translate">
            <xsl:value-of select="substring-before(.,' (')"/>
        </xsl:variable>
        <xsl:variable name="subject-sidebar-facet">
        <xsl:choose>
            <xsl:when test="$active-locale!='en'">
                <xsl:variable name="current-locale">
                    <xsl:if test="$active-locale='fr'">
                        <xsl:text>FRE</xsl:text>
                    </xsl:if>
                    <xsl:if test="$active-locale='zh'">
                        <xsl:text>CHN</xsl:text>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="translation">
                    <xsl:value-of select="util:lookupBabelMeSH($translate,$current-locale)"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$translation=''">
                        <xsl:value-of select="$translate"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$translation"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$translate"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:for-each select=".">
            <xsl:value-of select="concat($subject-sidebar-facet,' (', substring-after(.,'('))"/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
