<?php
// version: 1
namespace za\zXSLT;

// ザガタ。六 /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

class zXSLT {
	/* Zagata.XSLT */
	private $za = null;
	public $n = '';
		
	public $cd = '';
	public $rd = '';
	public $dd = '/';

	public $xsl = false;
	// public $xpt = false;

	public function show($xml,$xsl=false) {
		$xsl = ($xsl)?$xsl:$this->xsl;
		if(is_string($xml)) {
			$xxml = new \DomDocument; $xxml->loadXML($xml);
		} else {
			$xxml = $xml;
		}
		
		$transform = new \XSLTProcessor;
		$transform->importStyleSheet($xsl);
	return $transform->transformToXML($xxml);
	}
	
	public function load() {
		$tmp = $this->za->mm('vis');

		if($tmp) {
			foreach($tmp[0]['tmplts'] as $i) {
				$this->prse($i);
			}
		} else {}
		
		$this->za->ee($this->n.'_ready');
	}
	
	/////////////////////////////// 
	// funcs
	
	public function xslt() {
		$this->xsl->formatOutput = true;
	return $this->xsl->saveXML();
	}
	
	private function prse($fle) {
		$flenm = explode('/',str_replace('\\','/',$fle));
		$flenm = end($flenm);
		
		$fle = $this->cd.$this->dd.str_replace(array('\\','/'),$this->dd,$fle);

		if($this->xsl) {
			if(is_file($fle)) {
				$tmp = new \DOMDocument;
				$tmp->load($fle);
				/* 
				change output 
				$z = $tmp->getElementsByTagNameNS('http://www.w3.org/1999/XSL/Transform','output');
				*/
				
				$nodes = array('variable','template');
				foreach($nodes as $z) {
					foreach($tmp->getElementsByTagNameNS('http://www.w3.org/1999/XSL/Transform',$z) as $y) {
						if($y->parentNode->tagName=='xsl:stylesheet') {
							// remove previous elements with similar names
							// can add there priority parsing, like mode="s" but flexible
							if($z == 'template' && $y->getAttribute('name')) {
								foreach($this->xsl->getElementsByTagNameNS('http://www.w3.org/1999/XSL/Transform',$z) as $yy) {
									if($yy->getAttribute('name') == $y->getAttribute('name')) {
										$yy->parentNode->removeChild($yy);
									} else {}
								}
							} 

							$y = $this->xsl->importNode($y,true);
							$this->xsl->documentElement->appendChild($y);
						} else {}
					}
				}
				// $this->za->msg('ntf','vis', $flenm.' loaded');
			} else {
				$this->za->msg('err','vis', 'no file '.$flenm);
			}
		} else {
			$this->xsl = new \DOMDocument;
			$this->xsl->load($fle);
			// $this->xpt = \DOMXPath( $this->xsl );
			// $this->za->msg('ntf','vis', $flenm.' loaded');
		}
	}
	
	public function isvalid($xml) {
		$tmp = new \DOMDocument;
		return $tmp->loadXML($xml);
	}
	
	/////////////////////////////// 
	// ini
	function __construct($za,$a=false,$n=false) {
		$this->za = $za;
		$this->n = (($n)?$n:'zXSLT');

		$this->cd = realpath( __DIR__.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR );
		$this->rd = realpath( $this->cd.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR );
		$this->dd = DIRECTORY_SEPARATOR;

		$vis = array(
			'ca'=>'vis', 
			'page'=>array(
				'hdr'=>array(
					'css'=>array(),
					'js'=>array(),
					'z'=>10
				),
				'bdy'=>array('hdr'=>'', 'cnt'=>'', 'ftr'=>'', 'z'=>20)
			),
			'tmplts'=>array(
				'./zXSLT/basic.xsl'
			),
		);

		if(is_file($this->cd.$this->dd.'zXSLT'.$this->dd.'css.css')) { 
			$vis['page']['hdr']['css'][] = '/za/zXSLT/css.css'; 
		} else {}

		if(is_file($this->cd.$this->dd.'zZ'.$this->dd.'zZ.js')) { 
			$vis['page']['hdr']['js'][] = '/za/zZ/zZ.js?'.filemtime($this->cd.$this->dd.'zZ'.$this->dd.'zZ.js'); 
		} else {}

		if(is_file($this->rd.$this->dd.'usr'.$this->dd.'xslt'.$this->dd.'za6.js')) { 
			$vis['page']['hdr']['js'][] = '/usr/xslt/za6.js?'.filemtime($this->rd.$this->dd.'usr'.$this->dd.'xslt'.$this->dd.'za6.js'); 
		} else {}

		$this->za->mm(false, $vis);
		$this->za->ee($this->n,array($this,'load'));
		
	}
}

// ザガタ。六 /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

if(class_exists('\zlo')) {
	\zlo::da('zXSLT');
} elseif(realpath(__FILE__) == realpath($_SERVER['DOCUMENT_ROOT'].$_SERVER['SCRIPT_NAME'])) {
	header("content-type: text/plain;charset=utf-8");
	exit('zXSLT');
} else {}

?>