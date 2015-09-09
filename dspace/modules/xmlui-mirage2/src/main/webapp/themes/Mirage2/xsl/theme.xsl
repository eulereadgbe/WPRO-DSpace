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
        <xsl:choose>
            <xsl:when
                    test="starts-with($request-uri,'community-list')">
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
            </xsl:when>
            <xsl:otherwise>
                <h3 class="ds-list-head">
                    <i18n:text>xmlui.ArtifactBrowser.CommunityViewer.head_sub_communities</i18n:text>
                </h3>
                <ul class="ds-artifact-list list-unstyled">
                    <!-- External Metadata URL: cocoon://metadata/handle/10665.1/9972/mets.xml?sections=dmdSec,fileSec&fileGrpTypes=THUMBNAIL-->
                    <li class="ds-artifact-item odd">
                        <div class="artifact-description">
                            <h4 class="artifact-title">
                                <a href="/handle/10665.1/9972">
                                    <span class="Z3988">Regional Committee for the Western Pacific - Comité régional
                                        pour le Pacifique occidental
                                    </span>
                                </a>
                            </h4>
                        </div>
                    </li>
                </ul>
                <h3 class="ds-list-head">
                    <i18n:text>xmlui.ArtifactBrowser.CommunityViewer.head_sub_collections</i18n:text>
                </h3>
                <ul class="ds-artifact-list list-unstyled">
                    <!-- External Metadata URL: cocoon://metadata/handle/10665.1/10963/mets.xml?sections=dmdSec,fileSec&fileGrpTypes=THUMBNAIL-->
                    <li class="ds-artifact-item odd">
                        <div class="artifact-description">
                            <h4 class="artifact-title">
                                <a href="/handle/10665.1/10963">
                                    <span class="Z3988">Bulletins (Measles, Polio, Rubella) - in process</span>
                                </a>
                            </h4>
                        </div>
                    </li>
                    <!-- External Metadata URL: cocoon://metadata/handle/10665.1/1280/mets.xml?sections=dmdSec,fileSec&fileGrpTypes=THUMBNAIL-->
                    <li class="ds-artifact-item even">
                        <div class="artifact-description">
                            <h4 class="artifact-title">
                                <a href="/handle/10665.1/1280">
                                    <span class="Z3988">Information products</span>
                                </a>
                            </h4>
                        </div>
                    </li>
                    <!-- External Metadata URL: cocoon://metadata/handle/10665.1/1278/mets.xml?sections=dmdSec,fileSec&fileGrpTypes=THUMBNAIL-->
                    <li class="ds-artifact-item odd">
                        <div class="artifact-description">
                            <h4 class="artifact-title">
                                <a href="/handle/10665.1/1278">
                                    <span class="Z3988">Meeting reports</span>
                                </a>
                            </h4>
                        </div>
                    </li>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dri:div[@id='aspect.artifactbrowser.ItemViewer.div.item-view']
    | dri:div[@id='aspect.artifactbrowser.CollectionViewer.div.collection-home']
    | dri:div[@id='aspect.artifactbrowser.CommunityViewer.div.community-home']
    | dri:div[@id='aspect.artifactbrowser.ConfigurableBrowse.div.browse-by-dateissued']
    | dri:div[@id='aspect.artifactbrowser.ConfigurableBrowse.div.browse-by-author']
    | dri:div[@id='aspect.artifactbrowser.ConfigurableBrowse.div.browse-by-title']
    | dri:div[@id='aspect.artifactbrowser.ConfigurableBrowse.div.browse-by-mesh']
    | dri:div[@id='aspect.discovery.SimpleSearch.div.search']">
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

    <xsl:template match="dri:list[@id='aspect.viewArtifacts.Navigation.list.account']">
        <xsl:if test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
            <xsl:apply-templates />
        </xsl:if>
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
