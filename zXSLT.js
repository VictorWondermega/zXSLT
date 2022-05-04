
// version: 1

// ザガタ。六 /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

function zXSLT(za,a,n) {
	/* Zagata.XSLT */

	this.za = (typeof(za)=='undefined')?false:za; // core
	var a = (typeof(a)=='undefined')?false:a; // attr
	this.n = (typeof(n)=='undefined')?'zXSLT':n; // name

	this.show = function(xml,xsl) {
		xsl = (typeof(xsl)=='undefined')?this.xsl:xsl;
	
		this.re = new XSLTProcessor();
		this.re.importStylesheet(xsl);
		this.re = this.re.transformToDocument(xml);
	return this.re;
	};
	
	this.load = function(t,s,x) {
		console.log('xsl loaded '+x);
		//this.za.msg('ntf','vis', 'basic.xsl loaded');
		
		this.xsl = x;
		if(this.xsl==null) { this.xsl = (new DOMParser()).parseFromString(t,'application/xml'); } else {} // firefox ???
		
		this.za.ee(this.n+'_ready');
	};
	
	///////////////////////////////
	// funcs
	this.xslt = function() {
	return 'not yet ready';
	};
	
	this.prse = function() {
		
	};	
	
	///////////////////////////////
	// ini
	var vis = {
		'ca':'vis', 
		'page':{
			'hdr':{'css':new Array(),'js':new Array(),'z':10},
			'bdy':{'cnt':false,'z':20}
		},
		'tmplts':new Array(
			'/usr/xslt/basic.xsl',
		),
	};
	this.za.mm(false, vis);
	
	this.za.e['ax_con'] = new Array();
	this.za.ee('ax_con',new Array(this,'load'));
	
	this.za.msg('ntf','vis', 'start loading basic.xsl');
	this.za.m['ax'].url = '/usr/xslt/basic.xsl';
	this.za.m['ax'].fn = this.load;
	this.za.m['ax'].upd();
};

////////////////////////////////////////////////////////////////
if(typeof(zlo)=='object') {
	zlo.da('zXSLT');
} else {
  console.log('zXSLT');
}
