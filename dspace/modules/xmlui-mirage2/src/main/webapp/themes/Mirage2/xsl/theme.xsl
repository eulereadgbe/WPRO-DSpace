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
	xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc util">

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
            <div id="sidetreecontrol">
                <a href="?#" class="ds-button-field btn btn-default">
                    <i18n:text>wpro.treeview.collapse.all</i18n:text>
                </a>
                &#160;
                <a href="?#" class="ds-button-field btn btn-default">
                    <i18n:text>wpro.treeview.expand.all</i18n:text>
                </a>
            </div>
            <ul id="tree">
                <xsl:apply-templates select="*[not(name()='head')]" mode="summaryList"/>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="dri:div[@id='aspect.artifactbrowser.ItemViewer.div.item-view']
    | dri:div[@id='aspect.artifactbrowser.CollectionViewer.div.collection-home']
    | dri:div[@id='aspect.artifactbrowser.CommunityViewer.div.community-home']">
        <xsl:choose>
            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                <p>
                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="dri:trail">
        <xsl:if test="position()>1 and position() != last()">
            &#160;<i class="fa fa-angle-double-right" aria-hidden="true"/>&#160;
        </xsl:if>
        <!-- Determine whether we are dealing with a link or plain text trail link -->
        <xsl:choose>
            <xsl:when test="./@target">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="./@target"/>
                    </xsl:attribute>
                    <xsl:if test="position()=1">
                        <i class="fa fa-home fa-lg" aria-hidden="true"/>&#160;
                    </xsl:if>
                    <xsl:apply-templates />
                </a>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dri:list[@id='aspect.viewArtifacts.Navigation.list.account']"/>

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
