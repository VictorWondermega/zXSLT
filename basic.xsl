<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

  <xsl:output method="xml" media-type="text/html" encoding="utf-8" omit-xml-declaration="yes" version="1.0" indent="yes" cdata-section-elements="description" />

  <xsl:strip-space elements="*" />
  <xsl:preserve-space elements="aero sys url lng db" />

  <xsl:variable name="vis" select="/r/i[./ca='vis']" />
  <xsl:variable name="vrs" select="/r/i[./ca='vrs']" />
  <xsl:variable name="me" select="/r/i[./ca='me']" />
  <xsl:variable name="mn" select="/r/i[./ca='mn']" />
  <xsl:variable name="lng" select="/r/i[./ca='lng']" />
  <xsl:variable name="cmn" select="/r/i[./id=$vrs/cmn]" />
  <xsl:variable name="cnt" select="/r/i[./pl and ./pl!='' and ./pl!='adm' and ./pl!='hdr' and ./pl!='ftr' ]" /> 
  <xsl:variable name="zmsg" select="/r/i[./ca='zmsg']" />

  <xsl:variable name="base" ><xsl:value-of select="concat($vrs/https,'://',$vrs/host)" /></xsl:variable>
  <xsl:variable name="link" select="concat('/',$vrs/lng,'/')" /> <!-- $vrs/aero,'/', -->
  <xsl:variable name="notimestamp" ><xsl:if test="contains($vrs/fullurl,'/timestamp')" ><xsl:value-of select="substring-before($vrs/fullurl,'/timestamp')" /></xsl:if><xsl:if test="not(contains($vrs/fullurl,'/timestamp'))" ><xsl:value-of select="$vrs/fullurl" /></xsl:if></xsl:variable><!-- <xsl:value-of select="$vrs/base" /> $vrs/aero,'/', -->

  <xsl:variable name="page" ><xsl:choose><xsl:when test="$vrs/page" ><xsl:value-of select="$vrs/page" /></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:variable>
  
  <xsl:variable name="mp" select="($cmn/li='' and not($vrs/e404) and not($vrs/itm))" />
  
<!-- ///////////////////////////////////////////////////// //-->

  <xsl:template match="text()" >
	<xsl:value-of select="." disable-output-escaping="yes" />
  </xsl:template>
  
  <xsl:template name="sA" >
	<xsl:param name="i" />
	<xsl:if test="$i" >
		<ul class="sA">
			<xsl:for-each select="$i" >
			<xsl:sort select="name()" />
			<li>
				<span>&lt;<b><xsl:value-of select="name()" /></b> <xsl:for-each select="./@*" >&#160;<xsl:value-of select="name()" />="<xsl:value-of select="." />" </xsl:for-each> <xsl:if test="string-length(./text())&lt;1 and count(./*)&lt;1" >/&gt;</xsl:if><xsl:if test="string-length(./text())&gt;0 or count(./*)&gt;0" >&gt;</xsl:if></span>
				<xsl:value-of select="./text()" />
				<xsl:call-template name="sA" >
					<xsl:with-param name="i" select="./*" />
				</xsl:call-template>          
				<xsl:if test="string-length(./text())&gt;0 or count(./*)&gt;0" >
					<span>&lt;<b>/<xsl:value-of select="name()" /></b>&gt;</span>
				</xsl:if>
			</li>
			</xsl:for-each>
		</ul>
	</xsl:if>
</xsl:template>

<!-- ///////////////////////////////////////////////////// //-->

  <xsl:template match="/" >
	<xsl:choose>
	<xsl:when test="$vrs and $vis" >
		<xsl:apply-templates select="$vis/page" />
	</xsl:when><xsl:otherwise>
		<html>
			<xsl:call-template name="hdr" />
			<xsl:call-template name="bdy" />
		</html>
	</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <!-- main magic done there, also: match="i|page//*" //--> <!-- match="i|//*" //-->
  <xsl:template match="*" ><xsl:param name="h" select="string(2)" /><xsl:apply-templates select="." mode="s" ><xsl:with-param name="h" select="$h" /></xsl:apply-templates></xsl:template>
  
<!-- ///////////////////////////////////////////////////// //-->

<xsl:template match="i/page" mode="s" >
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;
</xsl:text>
<html xml:lang="{$vrs/lng}" lang="{$vrs/lng}" prefix="og: http://ogp.me/ns# twitter: http://api.twitter.com" >
	<xsl:if test="$vrs/timestamp and $vrs/itm" >
		<xsl:apply-templates select="/r/i[./id=$vrs/itm]" />
	</xsl:if><xsl:if test="not($vrs/timestamp) or not($vrs/itm)" >
		<xsl:for-each select="$vis/page/*[name()!='ca']" >
		<xsl:sort select="z" data-type="number" />
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:if>
</html>
</xsl:template>

  <xsl:template match="page/hdr" mode="s" >
	<head>
		<title>
			<xsl:if test="$mn[./id = $vrs/cmn]/li != ''" ><xsl:value-of select="$mn[./id = $vrs/cmn]/ti" /> - </xsl:if>
			<xsl:value-of select="$me/ti" /> &#160;
		</title>
		<meta charset="utf-8" />

		<meta name="keywords" content="{$me/kw}" />
		<meta name="description" content="{$me/de}" />

		<meta http-equiv="Content-Language" content="{$vrs/lng}" />

		<meta name="MobileOptimized" content="width" />
		<meta name="HandheldFriendly" content="true" />
		<meta name="format-detection" content="telephone=no"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="initial-scale=1, user-scalable=no, width=device-width, shrink-to-fit=no, minimal-ui" />

		<meta name="generator" content="zagata.rock" />
		<base href="{$base}" />

		<xsl:for-each select="./*[name()!='z']" >
			<xsl:comment> <xsl:value-of select="name()" />/</xsl:comment>
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</head>
  </xsl:template>

  <xsl:template match="page/bdy" mode="s" >
	<body>
	<xsl:attribute name="class" ><xsl:if test="$cmn/li=''" >main</xsl:if><xsl:if test="$cmn/li!=''" ><xsl:value-of select="$cmn/li" /></xsl:if></xsl:attribute>
		<xsl:apply-templates select="./*[name()!='z']" />
	</body>
  </xsl:template>
  
  <xsl:template match="page/bdy/cnt" mode="s" >
	<xsl:variable name="vcrd" select="//r/i[./ca='vcard']" />

	<!-- header //-->
	<header class="header" >
		<div class="container row header__container" >
			<xsl:call-template name="lg" ><xsl:with-param name="cl" >header</xsl:with-param></xsl:call-template>
			<nav class="menu header__menu" >
				<ul class="row menu__list" >
					<xsl:for-each select="$mn[./pl='hdr']" >
						<li class="menu__item md-hide" ><a href="./{./li}" title="{./de}" ><xsl:value-of select="./ti" /></a></li>
					</xsl:for-each>
					<li class="menu__item social header__social sm-hide" >
						<ul class="row social__list" >
							<li class="social__item social__item--vk" ><a href="./#" title="vkontakte" >vkontakte</a></li>
							<li class="social__item social__item--tg" ><a href="./#" title="telegram" >telegram</a></li>
							<li class="social__item social__item--wa" ><a href="./#" title="whatsapp" >whatsapp</a></li>
						</ul>
					</li>
					<xsl:comment> <li class="menu__item sm-hide" ><a href="./#" title="Записаться" class="btn btn--ol" >Записаться</a></li> </xsl:comment>

					<xsl:if test="$vcrd/ph" >
						<li class="menu__item sm-hide header__ph" ><a href="tel:{$vcrd/ph}"><xsl:value-of select="$vcrd/ph" /></a></li>
					</xsl:if>

					<li id="mobile_menu" class="menu__item mobile lg-hide" >&#160;</li>
				</ul>
			</nav>
		</div>
	</header>

	<!-- main //-->
	<main class="content" >
		<xsl:variable name="srt" ><xsl:if test="$cmn/srt='desc'" >descending</xsl:if><xsl:if test="not($cmn/srt) or $cmn/srt!='desc'" >ascending</xsl:if></xsl:variable>

		<!-- 404 //-->
		<xsl:if test="$vrs/e404" >
			<section class="e404" >
				<div class="container" >
					<h1>404</h1>
					<p><a href="/" >Главная</a></p>
				</div>
			</section>
		</xsl:if>

		<!-- content //-->
		<xsl:for-each select="$cnt[./idp=$cmn/id or ./id=$vrs/itm or ./li=$vrs/itm]" >
			<xsl:sort select="z" data-type="number" order="{$srt}" />
			<xsl:variable name="tag" >
				<xsl:choose><xsl:when test="(./ca!='sldr' and position() = 1) or position() = 2" >div</xsl:when><xsl:when test="./ca!='sldr' or ./ca!='blk'" >section</xsl:when><xsl:otherwise>article</xsl:otherwise></xsl:choose>
			</xsl:variable>
			<xsl:element name="{$tag}" ><xsl:attribute name="class" ><xsl:value-of select="normalize-space(concat(./ca,' ',./li))" /> <xsl:if test="./src" > <xsl:value-of select="concat(' ',./ca,'--img ',./li,'--img')" /></xsl:if></xsl:attribute><div class="container" >
				<xsl:apply-templates select="." ><xsl:with-param name="h" ><xsl:if test="$tag='div'" >1</xsl:if><xsl:if test="$tag!='div'" >2</xsl:if></xsl:with-param></xsl:apply-templates>
			</div></xsl:element>
		</xsl:for-each>
	</main>

	<!-- footer //-->
	<footer class="footer" >
		<div class="container footer__container" >
			<xsl:call-template name="lg" ><xsl:with-param name="cl" >footer</xsl:with-param></xsl:call-template>

			<nav class="menu footer__menu" >
				<ul class="row menu__list" >
					<li class="menu__item" >
						<a href="./about" title="О нас" >О нас</a>
						<ul class="menu__list submenu__list" >
							<xsl:for-each select="$mn[./li != 'about' and ./li != 'contacts' and (./pl='hdr' or ./pl='ftr')]" >
								<li class="menu__item" ><a href="./{./li}" title="{./de}" ><xsl:value-of select="./ti" /></a></li>
							</xsl:for-each>
						</ul>
					</li>
					<li class="menu__item" >
						<xsl:if test="$vcrd/adr/*[string-length(.) &gt; 1]" >
							<a href="./contacts" title="Контакты" >Контакты</a>
							<ul class="menu__list submenu__list adr" >
								<xsl:if test="$vcrd/adr/plz != ''" ><li class="postal-code" ><xsl:value-of select="$vcrd/adr/plz" /></li></xsl:if>
								<xsl:if test="$vcrd/adr/cntr != ''" ><li class="country-name" ><xsl:value-of select="$vcrd/adr/cntr" /></li></xsl:if>
								<xsl:if test="$vcrd/adr/twn != ''" ><li class="locality" ><xsl:value-of select="$vcrd/adr/twn" /></li></xsl:if>
								<xsl:if test="$vcrd/adr/str != ''" ><li class="street-address" ><xsl:value-of select="$vcrd/adr/str" /></li></xsl:if>
							</ul>
						</xsl:if><![CDATA[]]>
					</li>
					<li class="menu__item" >
						<xsl:if test="$vcrd/ph" >
							<xsl:if test="$vcrd/adr/*[string-length(.) &gt; 1]" >&#160;<br/></xsl:if>
							<xsl:if test="not($vcrd/adr/*[string-length(.) &gt; 1])" ><a href="./contacts" title="Контакты" >Контакты</a></xsl:if>
							<ul class="menu__list submenu__list" >
								<li class="menu__item" ><a href="tel:{$vcrd/ph}" ><xsl:value-of select="$vcrd/ph" /></a></li>
								<li class="menu__item" ><a href="email:{$vcrd/em}" ><xsl:value-of select="$vcrd/em" /></a></li>
							</ul>
						</xsl:if><![CDATA[]]>
					</li>
					<li class="menu__item social" >Поделиться
						<ul class="menu__list submenu__list social__list" >
							<li class="menu__item social__item social__item--vk" ><a href="./#" title="vkontakte" >vkontakte</a></li>
							<li class="social__item social__item--tg" ><a href="./#" title="telegram" >telegram</a></li>
							<li class="social__item social__item--wa" ><a href="./#" title="whatsapp" >whatsapp</a></li>
						</ul>
					</li>
				</ul>
			</nav>
			
			<p class="footer__text" >
				&#169; <xsl:value-of select="$me/ti" /> <br/>
				<xsl:value-of select="$me/de" />
			</p>
			
		</div>
	</footer>
	
	<!-- messages $zmsg //-->
	<aside id="zmsg" class="zmsg"><ul>
		<xsl:if test="$zmsg">
		<xsl:for-each select="$zmsg">
		<li class="{./cat}" ondblclick=" this.parentNode.removeChild(this);"><b><xsl:value-of select="./m"/></b> <xsl:value-of select="./de"/></li>
		</xsl:for-each>
		</xsl:if>
		<![CDATA[ ]]>
	</ul></aside>	
	
	<!-- to top //-->
	<div class="cl totop"><div class="container">
			<a href="#" id="totop"><svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="14px" height="8px" viewBox="0 0 14 8"><path fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M13,7L7,1L1,7"/></svg></a>
	</div></div>

  </xsl:template>

<!-- ///////////////////////////////////////////////////// //-->

  <xsl:template match="*/*[name()='z' or name()='ca']" mode="s" />

  <xsl:template name="lg" > <!-- logo //-->
  <xsl:param name="cl" />
	<xsl:variable name="tag" ><xsl:if test="$mp" >span</xsl:if><xsl:if test="not($mp)" >a</xsl:if></xsl:variable>
	<xsl:element name="{$tag}" >
		<xsl:attribute name="class" >logo <xsl:if test="$cl" > <xsl:value-of select="$cl"/>__logo</xsl:if></xsl:attribute>
		<xsl:if test="not($mp)" >
			<xsl:attribute name="href" >/</xsl:attribute>
		</xsl:if>
		
		<span style="display: block; height: 64px; overflow: visible; " ><img src="/usr/loqo.png" style=" height: 96px; " /></span>

		<!-- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 239.51 65"><path d="M22.53,65A32.54,32.54,0,0,1,1.76,57.49a2.65,2.65,0,1,1,3.39-4.08,27.19,27.19,0,1,0,0-41.82A2.65,2.65,0,1,1,1.76,7.51,32.5,32.5,0,1,1,22.53,65Z" class="shir1"/><path d="M22.89,55.38a23,23,0,1,1,0-46.09h0a23.07,23.07,0,0,1,14.62,5.45A3.08,3.08,0,0,1,37.9,19a2.94,2.94,0,0,1-4.12.57l0,0A16.54,16.54,0,0,0,23,15.81h0a16,16,0,0,0-12,4.83,16.69,16.69,0,0,0-5,11.9,16.88,16.88,0,0,0,27.7,13,3,3,0,1,1,3.81,4.58A22.91,22.91,0,0,1,22.89,55.38Z" class="shir0"/><path d="M32.48,29.29H26V22.55a3.51,3.51,0,0,0-7,0v6.74H12.59a3,3,0,0,0,0,6H19v7.16a3.51,3.51,0,0,0,7,0V35.29h6.48a3,3,0,0,0,0-6h0Z" class="kuro"/><path d="M70.34,50.17V14.78a3.49,3.49,0,0,1,.56-1.93A1.77,1.77,0,0,1,72.47,12H87.93q2.13,0,2.13,2.35a2,2,0,0,1-2.25,2.35H75.32V29H87.18a2,2,0,0,1,2.25,2.21,2,2,0,0,1-2.25,2.21H75.32V48.16H87.91q2.13,0,2.14,2.46,0,2.24-2.46,2.24H72.8Q70.34,52.86,70.34,50.17Z" class="kuro"/><path d="M97.55,50.73V14.34a2.85,2.85,0,0,1,.66-1.91,2.2,2.2,0,0,1,1.77-.79,2.26,2.26,0,0,1,2.55,2.58v15l18.09-16.58a3.38,3.38,0,0,1,2.24-1,1.92,1.92,0,0,1,1.54.69A2.45,2.45,0,0,1,125,14a2.67,2.67,0,0,1-1.05,2.1L107.07,31.23l18.71,17.93a2.68,2.68,0,0,1,.89,2q0,2.13-2.46,2.13a3.64,3.64,0,0,1-2.58-1.23l-19.1-18.7V50.72a2.46,2.46,0,0,1-4.26,1.8A2.58,2.58,0,0,1,97.55,50.73Z" class="kuro"/><path d="M162.29,31.92q0,8.79-4.2,14.5-4.65,6.44-13.16,6.44H134.18a3,3,0,0,1-1.85-.62,1.92,1.92,0,0,1-.84-1.62v-36a2.38,2.38,0,0,1,2.69-2.69h10.3a16.24,16.24,0,0,1,13.16,5.94A21.19,21.19,0,0,1,162.29,31.92Zm-5.38,0q0-6.64-3.2-10.83a11.94,11.94,0,0,0-10.05-4.69h-7.19v32h7.86a10.88,10.88,0,0,0,9.77-5.3,20.71,20.71,0,0,0,2.81-11.18h0Z" class="kuro"/><path d="M185.47,53.2a16,16,0,0,1-13.22-6.38,22.37,22.37,0,0,1-4.7-14.34A22.75,22.75,0,0,1,172.14,18a17.16,17.16,0,0,1,26.71,0q4.54,5.82,4.54,14.45a22.4,22.4,0,0,1-4.65,14.34A16.09,16.09,0,0,1,185.47,53.2Zm0-4.54a11,11,0,0,0,7.73-2.91,14.63,14.63,0,0,0,4.14-7.28,24.8,24.8,0,0,0,.67-6.1q0-6.77-2.8-11.09a11.86,11.86,0,0,0-19.49,0q-2.8,4.31-2.8,11.09a20.22,20.22,0,0,0,2.86,11.09A10.92,10.92,0,0,0,185.47,48.66Z" class="kuro"/><path d="M208.71,32.42q0-8.68,4.59-14.5a16.27,16.27,0,0,1,13.44-6.27,15.36,15.36,0,0,1,10.92,3.92,3.15,3.15,0,0,1,1.06,2.35,1.92,1.92,0,0,1-.67,1.46,2.18,2.18,0,0,1-1.51.62,4.1,4.1,0,0,1-2-1l-2-1.49a12.82,12.82,0,0,0-2.38-1,13.71,13.71,0,0,0-3.84-.39q-5.66,0-9.18,5.53a20,20,0,0,0-3,10.85,19.68,19.68,0,0,0,3,10.85q3.41,5.37,9.24,5.37a15.7,15.7,0,0,0,7.22-1.62l2-1.12a4.62,4.62,0,0,1,2.13-.67q1.9,0,1.9,2.24a2.48,2.48,0,0,1-.78,1.9,12.83,12.83,0,0,1-5.78,2.84,23.75,23.75,0,0,1-6.44.9,16,16,0,0,1-13.33-6.38A22.52,22.52,0,0,1,208.71,32.42Z" class="kuro"/></svg> //-->
		
	</xsl:element>
  </xsl:template>

  <xsl:template match="hdr/js" mode="s" >
	<xsl:for-each select="./*" >
		<script src="{.}" defer="defer" ><xsl:text><![CDATA[]]></xsl:text></script>
	</xsl:for-each>
  </xsl:template>
  
  <xsl:template match="hdr/css" mode="s" >
	<xsl:for-each select="./*" >
		<link rel="stylesheet" type="text/css" href="{.}" />
	</xsl:for-each>
  </xsl:template>

<!-- ///////////////////////////////////////////////////// //-->

  <xsl:template match="i" mode="s" >
  <xsl:param name="h" select="string(2)" />
	<!-- if image //-->
	<xsl:if test="./src" ><div class="{concat(./ca,'__image ',./li,'__image')}" style=" background-image: url({./src}); " >&#160;</div></xsl:if>
	
	<!-- data //-->
	<div class="{concat(./ca,'__content ',./li,'__content')}" >
		<xsl:if test="./ti and string-length(./pre)&gt;0" ><h6 class="{concat(./ca,'__pre ',./li,'__pre')}" ><xsl:value-of select="./pre" /></h6></xsl:if>
		<xsl:if test="./ti and string-length(./ti)&gt;0" ><xsl:element name="h{$h}"><xsl:attribute name="class" ><xsl:value-of select="./ca" />__title <xsl:value-of select="./li" />__title</xsl:attribute><xsl:value-of select="./ti" /></xsl:element></xsl:if>
		<xsl:if test="./dlbd" ><time datetime="{./xlbd}" class="{concat(./ca,'__time ',./li,'__time')}" ><xsl:value-of select="substring-before(./dlbd,' ')" /></time></xsl:if>
		<xsl:if test="./de and string-length(./de)&gt;0" ><div class="{concat(./ca,'__txt ',./li,'__txt')}" ><xsl:value-of select="./de" disable-output-escaping="yes" /></div></xsl:if>

		<!-- child elements //-->
		<xsl:variable name="cid" select="./id" />
		<xsl:variable name="cli" select="./li" />
		<xsl:if test="$cnt[./idp=$cid]" >
			<div class="{concat(./ca,'__child ',./li,'__child')}" >
				<xsl:for-each select="$cnt[./idp=$cid]" >
				<xsl:sort select="z" data-type="number" />
					<xsl:variable name="block" ><xsl:choose><xsl:when test="string-length(./ti)&lt;1 or ./ca='url'" >div</xsl:when><xsl:when test=" $h=1 " >article</xsl:when><xsl:otherwise>section</xsl:otherwise></xsl:choose></xsl:variable>
					<xsl:element name="{$block}">
						<xsl:attribute name="class" ><xsl:value-of select="concat(./ca,' ',./li,' ',$cli,'__',./li,' pos',(3 - (position() mod 3)))" /></xsl:attribute>
						<xsl:apply-templates select="." ><xsl:with-param name="h"><xsl:choose><xsl:when test="number($h)&lt;6" ><xsl:value-of select="number($h) + 1" /></xsl:when><xsl:otherwise>6</xsl:otherwise></xsl:choose></xsl:with-param></xsl:apply-templates>
					</xsl:element>
				</xsl:for-each>
			</div>
		</xsl:if>
	</div>
	<div class="cl" >&#160;</div>
  </xsl:template>

  <xsl:template match="i[./ca='fls']" mode="s" >
	
	<xsl:variable name="dot" select="string('.')" />
	<xsl:variable name="ext" select="substring-after(./src,$dot)" />
	<a href="{./src}" class="{concat(./ca,'__content ',./li,'__content ', ./ext)}" target="_blank" >
		<xsl:if test="./ti and string-length(./ti)&gt;0" >
			<span class="{concat(./ca,'__title ',./li,'__title')}"><xsl:value-of select="./ti" /></span>
		</xsl:if>
		<xsl:if test="./dlbd" >
			<time datetime="{./xlbd}" class="{concat(./ca,'__time ',./li,'__time')}" ><xsl:value-of select="substring-before(./dlbd,' ')" /></time>
		</xsl:if>
		<xsl:if test="./de and string-length(./de)&gt;0" >
			<span class="{concat(./ca,'__txt ',./li,'__txt')}"><xsl:value-of select="./de" /></span>
		</xsl:if>
	</a>
	<div class="cl" >&#160;</div>
  </xsl:template>

</xsl:stylesheet>