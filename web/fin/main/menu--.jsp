<%  menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
	Periode per13x = DbPeriode.getOpenPeriod13();
	boolean gereja = DbSystemProperty.getModSysPropGereja();
	String transactionFolder = "";
	if(gereja){ transactionFolder = "transactionact"; 	}else{	transactionFolder = "transaction";	}
        
        boolean rptOnlyBTDC = true;
        
%>
<script language="JavaScript">
    
    	function cmdHelp(){
        	window.open("<%=approot%>/help.htm"); 
        }        
        function cmdChangeMenu(idx){
            var x = idx;         
            switch(parseInt(idx)){                
                case 1 :                
					<%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
					document.all.cash1.style.display="none"; document.all.cash2.style.display=""; document.all.cash.style.display="";
					<%}
					if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
					document.all.bank1.style.display=""; document.all.bank2.style.display="none"; document.all.bank.style.display="none";
					<%}%>
					<%if (arAging || arList) {%>
					document.all.ar1.style.display=""; document.all.ar2.style.display="none"; 	document.all.ar.style.display="none";
					<%}%>
					<%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
					document.all.ap1.style.display=""; document.all.ap2.style.display="none"; document.all.ap.style.display="none";
					<%}%>
					<%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
					document.all.gl1.style.display=""; document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
					<%}%>                
                    <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	                    
                    document.all.master1.style.display="";  document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>		
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display=""; document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>                    
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none";  document.all.dtransfer.style.display="none";
                    <%}%>                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none";   document.all.inv.style.display="none";
                    <%}%>                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";   document.all.closing.style.display="none";
                    <%}%>                    
                    <%if (admin){%>
                    document.all.admin1.style.display="";   document.all.admin2.style.display="none";   document.all.admin.style.display="none";
                    <%}%>                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";   document.all.akrual.style.display="none";
                    <%}%>                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";    document.all.titip2.style.display="none";   document.all.titip.style.display="none";
                    <%}%>                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display=""; //document.all.jr2.style.display="none";  //document.all.jr.style.display="none";
                    <%}%>                    
                    break;
                    
              case 2 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>			
                    document.all.bank1.style.display="none"; document.all.bank2.style.display="";  document.all.bank.style.display="";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display=""; document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display=""; document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                    <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>                    
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display=""; document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>			                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none"; document.all.inv.style.display="none";
                    <%}%>                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display=""; document.all.titip2.style.display="none"; document.all.titip.style.display="none";
                    <%}%>                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display=""; document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";  //document.all.jr2.style.display="none"; //document.all.jr.style.display="none";
                    <%}%>                    
                    break;                    
               case 3 :                    
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="none";  document.all.ap2.style.display=""; document.all.ap.style.display="";
                    <%}%>
                    <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display=""; document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display=""; document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>			                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none";	document.all.inv.style.display="none";			
                    <%}%>                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";   document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";   document.all.titip2.style.display="none"; document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display=""; document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;	
                    
                    case 4 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display=""; document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display=""; document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>
                    
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="none";  document.all.frpt2.style.display="";  document.all.frpt.style.display="";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display=""; document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none";  document.all.dtransfer.style.display="none";
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none";	document.all.inv.style.display="none";						
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display=""; document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display=""; document.all.titip2.style.display="none"; document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display=""; document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 5 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none";  document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";  document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastWp || mastComp || mastGen) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";   document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="none";  document.all.drpt2.style.display=""; document.all.drpt.style.display="";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none";  document.all.dtransfer.style.display="none";
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none"; document.all.inv.style.display="none";						
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display=""; document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 6 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";   document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="none";  document.all.master2.style.display="";  document.all.master.style.display="";
                    <%}%>
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none";  document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display=""; document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 7 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display=""; document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display=""; document.all.ap2.style.display="none";  document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="none";  document.all.dtransfer2.style.display=""; document.all.dtransfer.style.display="";
                    <%}%>
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none"; document.all.inv.style.display="none";						
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display=""; document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display=""; document.all.titip2.style.display="none"; document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    //---
                    case 8 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display=""; document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display=""; document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none"; document.all.inv.style.display="none";			
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;	
                    
                    case 9 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none";  document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";  document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="none";  document.all.gl2.style.display="";  document.all.gl.style.display="";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";   document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none";  document.all.dtransfer.style.display="none";
                    <%}%>		
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none"; document.all.inv.style.display="none";			
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";   document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 10 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="none";
                    //document.all.pr2.style.display="";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none";  document.all.dtransfer.style.display="none";
                    <%}%>		
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";   document.all.inv2.style.display="none";	document.all.inv.style.display="none";	
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 11 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>			
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>		
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="none";  document.all.inv2.style.display=""; document.all.inv.style.display="";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;		
                    
                    case 12 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if(bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none";  document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";   document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                    <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none"; document.all.gl.style.display="none";						
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none";  document.all.dtransfer.style.display="none";
                    <%}%>		
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none";  document.all.inv.style.display="none";	
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="none";  document.all.admin2.style.display=""; document.all.admin.style.display="";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";   document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";   document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;	
                    
                    case 13 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none";  document.all.gl.style.display="none";						
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display=""; document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>		
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none"; document.all.inv.style.display="none";	
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="none"; document.all.closing2.style.display="";  document.all.closing.style.display="";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 14 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="none"; document.all.ar2.style.display=""; document.all.ar.style.display="";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display=""; document.all.dtransfer2.style.display="none";	document.all.dtransfer.style.display="none";			
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none";  document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display=""; document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 15 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none";  document.all.ar.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                    document.all.master1.style.display="";  document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";			
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none";  document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="none"; document.all.akrual2.style.display="";  document.all.akrual.style.display="";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display=""; document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 16 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display=""; document.all.ar2.style.display="none";  document.all.ar.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";			
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none"; document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none"; document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="none";  document.all.titip2.style.display="";  document.all.titip.style.display="";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;						
                    
                    case 17 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display=""; document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display="";  document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none";  document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display=""; document.all.dtransfer2.style.display="none";	document.all.dtransfer.style.display="none";			
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none";  document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="none"; document.all.anggota2.style.display=""; document.all.anggota.style.display="";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 18 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none";  document.all.ar.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display=""; document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none";	document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none"; document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";			
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none"; document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="none"; document.all.bymhd2.style.display=""; document.all.bymhd.style.display="";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;
                    
                    case 0 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display="";  document.all.cash2.style.display="none";  document.all.cash.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none"; document.all.bank.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display=""; document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display=""; document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                    
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display=""; document.all.master2.style.display="none"; document.all.master.style.display="none";		
                    <%}%>
                    
                    //document.all.pr1.style.display="";
                    //document.all.pr2.style.display="none";
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display="";  document.all.frpt2.style.display="none"; document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display=""; document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";			
                    <%}%>
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display=""; document.all.inv2.style.display="none"; document.all.inv.style.display="none";
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display=""; document.all.closing2.style.display="none";  document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display="";  document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none";  document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display="";  document.all.titip2.style.display="none"; document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display="";  document.all.anggota2.style.display="none";  document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display="";  document.all.bymhd2.style.display="none";  document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="";
                    //document.all.jr2.style.display="none";
                    //document.all.jr.style.display="none";
                    <%}%>
                    
                    break;	
                    
                    case 19 :
                    <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || COp || fnCR) {%>
                    document.all.cash1.style.display=""; document.all.cash2.style.display="none"; document.all.cash.style.display="none";
                    <%}%>
                    <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                    document.all.bank1.style.display="";  document.all.bank2.style.display="none";  document.all.bank.style.display="none";
                    <%}%>
                    <%if (arAging || arList) {%>
                    document.all.ar1.style.display="";  document.all.ar2.style.display="none"; document.all.ar.style.display="none";
                    <%}%>
                    <%if (1 == 2) {//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
                    document.all.ap1.style.display="";  document.all.ap2.style.display="none"; document.all.ap.style.display="none";
                    <%}%>
                     <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                    document.all.gl1.style.display="";  document.all.gl2.style.display="none";  document.all.gl.style.display="none";			
                    <%}%>
                         <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>		
                    document.all.master1.style.display="";  document.all.master2.style.display="none";  document.all.master.style.display="none";		
                    <%}%>
                    
                    <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                    document.all.frpt1.style.display=""; document.all.frpt2.style.display="none";  document.all.frpt.style.display="none";
                    <%}%>
                    <%if (dreportPriv && applyActivity) {%>
                    document.all.drpt1.style.display="";  document.all.drpt2.style.display="none"; document.all.drpt.style.display="none";
                    <%}%>
                    <%if (datasyncPriv){%>
                    document.all.dtransfer1.style.display="";  document.all.dtransfer2.style.display="none"; document.all.dtransfer.style.display="none";
                    <%}%>		
                    
                    <%if (payIGL || payILI || payAAN || payPAL) {%>
                    document.all.inv1.style.display="";  document.all.inv2.style.display="none"; document.all.inv.style.display="none";			
                    <%}%>
                    
                    <%if (closePer) {%>
                    document.all.closing1.style.display="";  document.all.closing2.style.display="none"; document.all.closing.style.display="none";
                    <%}%>
                    
                    <%if (admin) {%>
                    document.all.admin1.style.display=""; document.all.admin2.style.display="none";  document.all.admin.style.display="none";
                    <%}%>
                    
                    //--------------------
                    
                    <%if (akrualSetupPriv || akrualProcessPriv) {%>
                    document.all.akrual1.style.display="";  document.all.akrual2.style.display="none"; document.all.akrual.style.display="none";
                    <%}%>
                    
                    <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                    document.all.titip1.style.display=""; document.all.titip2.style.display="none";  document.all.titip.style.display="none";
                    <%}%>
                    
                    <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji) {%>
                    document.all.anggota1.style.display=""; document.all.anggota2.style.display="none"; document.all.anggota.style.display="none";
                    <%}%>
                    
                    <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                    document.all.bymhd1.style.display=""; document.all.bymhd2.style.display="none"; document.all.bymhd.style.display="none";
                    <%}%>
                    
                    <%if (1 == 1) {%>
                    //document.all.jr1.style.display="none";
                    //document.all.jr2.style.display="";
                    //document.all.jr.style.display="";
                    <%}%>
                    
                    break;
                }
            }
            
            <%

            String strAccountPeriod = "Account Period";

            String strCT = "Cash Transaction";   String strCTCashReceipt = "Cash Receipt";  String strCTAdvanceReceipt = "Advance Refund";
            String strCTPettyCash = "Cash Transaction"; String strCTCashPayment = "Disbushment"; String strCTCashPay = "Cash Payment";
            String strCTKasbon = "Advance Release";  String strCTReplenishment = "Replenishment"; String strKasOpname = "Cash Opname"; String strCTArchives = "Archives";
//String strCTCashPayment = "Cash Payment";disbushment
            
            String strCTCashRegister = "Kas Register"; String strCTCashAccountLink = "Cash Account Link"; String strPostJournal = "Post Journal";
            String strBT = "Bank Transaction";  String strBTBankDeposit = "Bank Deposit"; String strBTPayment = "Payment";
            String strBTPaymentOfPO = "Invoice Selection";  String strBTCashPayment = "Invoice Payment";  String strBTNonPOPayment = "Direct Bank Payment";
            String strBTNPost = "Post Jurnal";  String strBTArchives = "Archives";  String strBTBankAccountLink = "Bank Account Link";

            String strAR = "Account Receivable";  String strARTransaction = "Transaction";  String strARNewInvoice = "New Invoice";
            String strARPayment = "Payment";   String strARAgingAnalysis = "Aging Analysis";  String strARArchives = "Archives";
            String strARMaster = "Master";   String strARBankAccount = "Bank Account";  String strARCustomer = "Customer";
            String strARAccList = "AR Acc. List";  String strAP = "Account Payable"; String strAPIncomingGoodsList = "Incoming Good List";
            String strAPInvoiceList = "Invoice List";  String strAPAgingAnalysis = "Aging Analysis"; String strAPPurchaseAccList = "Purchase Acc. List";
			String strDP = "Deposit/Titipan";  String strDPMemberOrUnit = "Member/Unit";  String strDPNew = "New Deposit";
            String strDPReturn = "Return Deposit";  String strDPSaldo = "Deposit Saldo";  String strDPArchives = "Archives";
			String strBYMHD = "BYMHD"; String strBYMHDList = "BYMHD List";  String strBYMHDNew = "New BYMHD";
            String strBYMHDPayment = "BYMHD Payment";  String strBYMHDSaldo = "BYMHD Saldo";  String strBYMHDArchives = "Archives";
            String strAT = "Recurring Journal";  String strATSetup = "Journal Setup"; String strATProcess = "Process";
            String strATArchives = "Archives";   String strMs = "Membership";  String strMsMember = "Member";
            String strMsMemberList = "Member List";  String strMsNewMember = "New Member";  String strMsSimpanPinjam = "Simpan Pinjam";
            String strMsDaftarBank = "Daftar Bank";  String strMsPinjamanKoperasi = "Pinjaman Koperasi";  String strMsAngsuran = "Angsuran";
            String strMsArsipKoperasi = "Arsip Pinjaman Koperasi";  String strMsPinjamanBank = "Pinjaman Bank"; String strMsAngsuranBank = "Angsuran Pinjaman Bank";
            String strMsArsipBank = "Arsip Pinjaman Bank"; String strMsRekapPotonganGaji = "Rekap Potongan Gaji"; String strMsDaftarPinjaman = "Daftar Pinjaman";
            String strPO = "Purchase Order"; String strPONew = "New Order";  String strPOVendor = "Vendor"; String strPOArchives = "Archives";
            String strPOPurchaseAccList = "Purchase Acc. List";  String strJournal = "Journal";  String strGJ = "General Journal";
            String strGJNew = "New Journal";  String strGJAdvance = "Advance Reimbursement";  String strGJArchives = "Archives";
            String strGJ13 = "Journal 13th Period";  String strGJNew13 = "New Journal 13";  String strGJArchives13 = "Archives 13";
			String strGJBackdated = "Backdated Journal";  String strGJNewBackdated = "New Backdated Journal";  String strGJArchivesBackdated = "Archives Bacdated";
			String strPostJurnalBackdated = "Post Bacdated Jurnal";
            String strJR = "Journal Reversal";  String strJRNew = "New Journal";  String strJRDo = "Process";
            String strJRPosted = "Reverse Posted Journal";  String strJRArchives = "Archives"; String strPostJurnal = "Post Jurnal";
            String strPostJurnal13 = "Post Jurnal 13";   String strFR = "Financial Report";  String strFRJournalDetail = "Journal Detail";
            String strFRGeneralLedger = "General Ledger";  String strFRBalanceSheet = "Balance Sheet";  String strFRPenjelasan = "Detail";
            String strFRPenjelasanNeraca = "Balance Sheet";   String strFRPenjelasanIncome = "Profit & Loss";   String strFRPenjelasanExpense = "Expenses";
            String strFRBsStandard = "Standard";  String strFRDetail = "Detail";  String strFRMultiplePeriods = "Multiple Periods";
            String strFRProfitLoss = "Profit & Loss";   String strFRPlStandard = "Standard";  String strFRPlStandardBudget = "Budget Base";
            String strFRPlRekapAll = "Rekap Biaya Seluruhnya";   String strFRBiayaOperasiDireksi = "Biaya Operasi Direksi";  String strFRDepartmental = "Departmental Base";
            String strFRSectional = "Sectional Base";  String strFRMultiplePeriod = "Multiple Period";  String strFRAdditionalReport = "Additioanal Report";
            String strFRNeraca = "Balance Sheet";  String strFRNeracaAkhir = "Neraca Akhir";  String strFRNeracaSP = "Neraca SP";
            String strFRNeracaNSP = "Neraca NSP";  String strFRPortofolio = "Portofolio";//String strFRPenjelasanNeraca = "Penjelasan Neraca";
            String strFRBiaya = "Biaya";  String strFRPendapatan = "Pendapatan";  String strFRRasio = "Analisa Rasio";
            String strFRIktisarLabaRugi = "Iktisar Laba Rugi"; String strFRKinerja = "Kinerja";  String strFROustandingKasbon = "Oustanding Advance";
            String strFRSaldoBYMHD = "Saldo BYMHD";  String strFRTitipan = "Saldo Titipan";  String strFRAktivaTetap = "Aktiva Tetap";String strNeracaSaldo = "Trial Balance";

            String strDR = "Aktivity";	String strDRCheck = "Aktivity Check"; String strDRSummary = "Summary";
            String strDRWorkplan = "Workplan - Detail";  String strDRCategory = "By Category";  String strDRGroup = "By Group - Detail";
            String strDS = "Data Synchronization";  String strDSBackup = "Backup";  String strDSTransfer = "Transfer To File";
            String strDSMaintenance = "Maintenance";  String strDSUpload = "Upload"; String strMD = "Master Data";
			String strMDApproval = "Document"; String strMDSetupApproval = "Doc. Approval Setup"; String strMDDesignPrint = "Printout Design"; String strMDDocCode = "Doc. Code Setup";
            String strMDSystemConfiguration = "System Configuration";   String strMDAccounting = "Accounting"; String strMDChartOfAccount = "Chart of Account";
            String strMDAccountBudgetTarget = "Account Budget/Target";  String strMDPortofolioSetup = "Portofolio Setup"; String strMDSegment = "Segment";
            String strMDAccountCategory = "Account Category"; String strMDAccountGroupAliases = "Account Group Aliases"; String strMDBookkeepingRate = "Bookkeeping Rate";
            String strMDPeriod = "Period";  String strMDStupLaporan = "Report Setup"; String strMDWorkplan = "Activity List";
			String strMDWorkplanCheck = "Activity Check";  String strMDExpense = "Expense Allocation to Activity"; String strMDDonorList = "Donor List";
            String strMDActivityPeriod = "Activity Period"; String strMDCompany = "Company"; String strMDEmployeeList = "User";
            String strMDDepartmentList = "Department List"; String strMDGeneral = "General"; String strMDCountry = "Country";
            String strMDCurrency = "Currency";  String strMDTermOfPayment = "Term of Payment"; String strMDShippingAddress = "Shipping Address";
            String strMDPaymentMethod = "Payment Method"; String strMDLocationList = "Location List"; String strMDSubDistrict = "Sub-District Area";
            String strMDVillage = "Village Area";  String strMDOccupationList = "Occupation List"; String strMDOfficial = "Official";
            String strMDOfficialUnit = "Official Unit";  String strCP = "Close Period";  String strCPMonthlyClosing = "Monthly Closing"; 
			String strCPNewPeriod = "Open New Period";
            String strCPYearlyClosing = "Yearly Closing";  String strCPActivityClosing = "Activity Closing"; String strCPPer13Closing = "13th Periode";
            String strAdministrator = "Administrator";  String strSystemProperties = "System Properties"; String strUserList = "User List";
            String strUserGroup = "User Group";

            if (lang == LANG_ID) {

                strAccountPeriod = "Periode Perkiraan"; strCT = "Transaksi Tunai";  strCTCashReceipt = "Penerimaan Tunai";
                strCTAdvanceReceipt = "Pengembalian Sisa Kasbon";  strCTPettyCash = "Transaksi Kas";   //strCTCashPayment = "Pelunasan Tunai";
                strCTCashPayment = "Pengakuan Biaya"; strCTCashPay = "Pembayaran Tunai";  strCTKasbon = "Pemberian Kasbon";
                strCTReplenishment = "Pengisian Kembali";  strKasOpname = "Kas Opname"; strCTArchives = "Arsip";  strCTCashRegister = "Kas Register";
                strCTCashAccountLink = "Setup Perkiraan Tunai";  strPostJournal = "Post Jurnal";  strBT = "Transaksi Bank";
                strBTBankDeposit = "Setoran Bank";  strBTPayment = "Pelunasan";  strBTPaymentOfPO = "Pilih/Seleksi Invoice";
                strBTCashPayment = "Pelunasan Invoice";  strBTNonPOPayment = "Pembayaran Bank Langsung"; strBTNPost = "Post Jurnal";
                strBTArchives = "Arsip"; strBTBankAccountLink = "Setup Perkiraan Bank"; strAR = "Piutang";
                strARTransaction = "Transaksi";  strARNewInvoice = "Faktur Baru"; strARPayment = "Pelunasan";
                strARAgingAnalysis = "Aging Analysis";  strARArchives = "Arsip";  strARMaster = "Data Induk";
                strARBankAccount = "Perkiraan Bank";  strARCustomer = "Pelanggan";  strARAccList = "AR Acc. List";
                strAP = "Hutang"; strAPIncomingGoodsList = "Daftar Penerimaan Barang"; strAPInvoiceList = "Daftar Faktur";
                strAPAgingAnalysis = "Aging Analysis";  strAPPurchaseAccList = "Purchase Acc. List";  strDP = "Deposit/Titipan";
                strDPMemberOrUnit = "Member/Unit";  strDPNew = "New Deposit";  strDPReturn = "Return Deposit";
                strDPSaldo = "Deposit Saldo"; strDPArchives = "Archives"; strBYMHD = "BYMHD";
				strBYMHDList = "BYMHD List";  strBYMHDNew = "New BYMHD";  strBYMHDPayment = "BYMHD Payment";
                strBYMHDSaldo = "BYMHD Saldo"; strBYMHDArchives = "Archives"; strAT = "Jurnal Berulang";
                strATSetup = "Setup Jurnal";  strATProcess = "Proses";  strATArchives = "Arsip";
                strMs = "Keanggotaan";  strMsMember = "Anggota";  strMsMemberList = "Daftar Anggota";
                strMsNewMember = "Tambah Anggota"; strMsSimpanPinjam = "Simpan Pinjam";  strMsDaftarBank = "Daftar Bank";
                strMsPinjamanKoperasi = "Pinjaman Koperasi"; strMsAngsuran = "Angsuran";  strMsArsipKoperasi = "Arsip Pinjaman Koperasi";
                strMsPinjamanBank = "Pinjaman Bank"; strMsAngsuranBank = "Angsuran Pinjaman Bank";  strMsArsipBank = "Arsip Pinjaman Bank";
                strMsRekapPotonganGaji = "Rekap Potongan Gaji"; strMsDaftarPinjaman = "Daftar Pinjaman"; strPO = "Purchase Order";
                strPONew = "Order Baru";  strPOVendor = "Vendor";  strPOArchives = "Arsip";
				 strPOPurchaseAccList = "Purchase Acc. List"; strJournal = "Jurnal"; strGJ = "Jurnal Umum";
                strGJNew = "Jurnal Baru";  strGJAdvance = "Pemakaian Kasbon";  strGJArchives = "Arsip";
                strGJ13 = "Journal Periode-13";  strGJNew13 = "Journal Baru 13"; strGJArchives13 = "Arsip 13";
                strJR = "Jurnal Reversal"; strJRNew = "Jurnal Baru"; strJRDo = "Proses";
                strJRPosted = "Jurnal Pembalikkan"; strJRArchives = "Arsip";  strPostJurnal = "Posting Jurnal";
                strPostJurnal13 = "Posting Jurnal 13"; strFR = "Laporan Keuangan"; strFRJournalDetail = "Jurnal Detail";
				strGJBackdated = "Journal Periode Closed";  strGJNewBackdated = "Jurnal Baru";  strGJArchivesBackdated = "Archives Jurnal";
				strPostJurnalBackdated = "Post Jurnal";
                strFRGeneralLedger = "Buku Besar";  strFRBalanceSheet = "Neraca";  strFRPenjelasan = "Penjelasan";
                strFRPenjelasanNeraca = "Neraca";  strFRPenjelasanIncome = "Laba Rugi";  strFRPenjelasanExpense = "Biaya";
                strFRBsStandard = "Standar";  strFRDetail = "Detail";  strFRMultiplePeriods = "Multi Periode";                strFRProfitLoss = "Laba Rugi";
                strFRPlStandard = "Standar";  strFRPlStandardBudget = "Laba Rugi Dengan Budget";  strFRPlRekapAll = "Rekap Biaya Seluruhnya";
                strFRBiayaOperasiDireksi = "Biaya Operasi Direksi";  strFRDepartmental = "Berdasarkan Departemen";  strFRSectional = "Berdasarkan Bagian";
                strFRMultiplePeriod = "Multi Periode";  strFRAdditionalReport = "Laporan Lainnya";   strFRNeraca = "Neraca";
                strFRNeracaAkhir = "Neraca Akhir";  strFRNeracaSP = "Neraca SP";  strFRNeracaNSP = "Neraca NSP";
                strFRPortofolio = "Portofolio"; //strFRPenjelasanNeraca = "Penjelasan Neraca";
                strFRBiaya = "Biaya";  strFRPendapatan = "Pendapatan";  strFRRasio = "Analisa Rasio";
                strFRIktisarLabaRugi = "Iktisar Laba Rugi";  strFRKinerja = "Kinerja";  strFROustandingKasbon = "Kasbon Outstanding";
                strFRSaldoBYMHD = "Saldo BYMHD";  strFRTitipan = "Saldo Titipan"; strFRAktivaTetap = "Aktiva Tetap"; strNeracaSaldo = "Neraca Saldo";
                strDR = "Kegiatan";	strDRCheck = "Cek Kegiatan"; strDRSummary = "Summary";
                strDRWorkplan = "Workplan - Detail";  strDRCategory = "By Category";  strDRGroup = "By Group - Detail";
                strDS = "Sinkronisasi Data";  strDSBackup = "Backup";  strDSTransfer = "Simpan ke File";
                strDSMaintenance = "Perawatan";  strDSUpload = "Upload";  strMD = "Data Induk";
				strMDApproval = "Dokumen"; strMDSetupApproval = "Setup Persetujuan Dok."; strMDDesignPrint = "Design Printout"; strMDDocCode = "Setup Kode Dok.";
                strMDSystemConfiguration = "Pengaturan Sistem";  strMDAccounting = "Akuntansi"; strMDChartOfAccount = "Daftar Perkiraan";
                strMDAccountBudgetTarget = "Anggaran/Target"; strMDPortofolioSetup = "Portofolio Setup"; strMDSegment = "Segmen";
                strMDAccountCategory = "Kategori Perkiraan";  strMDAccountGroupAliases = "Pengelompokan Perkiraan"; strMDBookkeepingRate = "Kurs Pembukuan";
                strMDPeriod = "Periode";  strMDStupLaporan = "Setup Laporan";  strMDWorkplan = "Daftar Kegiatan";
				strMDWorkplanCheck = "Cek Kegiatan";  strMDExpense = "Alokasi Biaya Kegiatan"; strMDDonorList = "Daftar Donor";
                strMDActivityPeriod = "Activity Period"; strMDCompany = "Perusahaan"; strMDEmployeeList = "Pengguna";
                strMDDepartmentList = "Daftar Departemen";  strMDGeneral = "Umum";  strMDCountry = "Negara";
                strMDCurrency = "Mata Uang";  strMDTermOfPayment = "Term Pembayaran";  strMDShippingAddress = "Alamat Pengiriman";
                strMDPaymentMethod = "Metode Pembayaran";  strMDLocationList = "Daftar Lokasi";  strMDSubDistrict = "Kecamatan";
                strMDVillage = "Desa";  strMDOccupationList = "Daftar Pekerjaan"; strMDOfficial = "Dinas";
                strMDOfficialUnit = "Unit Dinas"; strCP = "Tutup Periode";  strCPMonthlyClosing = "Tutup Bulanan";
				strCPNewPeriod = "Buka Periode Baru";
                strCPYearlyClosing = "Tutup Tahunan";  strCPActivityClosing = "Activity Closing";  strCPPer13Closing = "Tutup Periode 13";
                strAdministrator = "Administrator";  strSystemProperties = "Sistem Properti";  strUserList = "Daftar Pengguna";
                strUserGroup = "Pengelompokan Pengguna";
            }
%>
    
    </script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src="<%=approot%>/images/logo-finance2.jpg" width="216" height="32" /></td>
                </tr>
                <tr> 
                    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
                </tr>
                <tr> 
                    <td style="padding-left:10px"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <%
            Periode periodeXXX = DbPeriode.getOpenPeriod();
			//out.println("periodeXXX : "+periodeXXX.getOID());
            String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");
                                %>
                                <td height="49"> 
                                    <div align="center"><%=strAccountPeriod%> : <br>
                                        <%=openPeriodXXX%><br>
                                    </div>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="4"></td>
                            </tr>
							<tr> 
                                <td class="menu0"><a href="<%=approot%>/home.jsp">Home</a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || fnCR || COp ) {%>
                            <tr id="cash1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')"><%=strCT%></a></td>
                            </tr>
                            <tr id="cash2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strCT%></a></td>
                            </tr>
                            <tr id="cash"> 
                                <td class="submenutd"> 
                                    <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                                        <%if (cashRecPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/cashreceivedetail.jsp?menu_idx=1"><%=strCTCashReceipt%></a></td>
                                        </tr>
                                        <%}%>	
                                        <%if (cashRecAdPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/penerimaan_kasbon.jsp?menu_idx=1"><%=strCTAdvanceReceipt%></a></td>
                                        </tr>
                                        <%}%>
                                        <%
                                        if (cashPPayPriv || cashPayPriv){
                                        %>
                                        <tr> 
                                            <td class="menu1"><%=strCTPettyCash%></td>
                                        </tr>
                                        <%if (cashPPayPriv) {%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/pettycashpaymentdetail.jsp?menu_idx=1"><%=strCTCashPayment%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (cashPayPriv) {%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/cash_receive.jsp?menu_idx=1"><%=strCTCashPay%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if(cashPPARriv){%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/kasbon.jsp?menu_idx=1"><%=strCTKasbon%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (cashPRPriv) {%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/pettycashreplenishment.jsp?menu_idx=1"><%=strCTReplenishment%></a></td>
                                        </tr>
                                        <%}
    }%>
                                        <%if(COp){%>
										<tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/kasopname.jsp?menu_idx=1"><%=strKasOpname%></a></td>
                                        </tr>
										<%}%>
                                        <%if(fnCR){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/cashregister.jsp?menu_idx=1"><%=strCTCashRegister%></a></td>
                                        </tr>
                                        <%}if (cashRPPriv) {%>
                                        <tr>  
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/casharchivepost.jsp?menu_idx=1"><%=strPostJournal%></a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if (cashArPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/casharchive.jsp?menu_idx=1"><%=strCTArchives%></a></td>
                                        </tr>
                                        <%}%>                                        
                                        <%if (cashArcPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/master/cashacclink.jsp?menu_idx=1"><%=strCTCashAccountLink%></a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>                            
                            <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                            <tr id="bank1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')"><%=strBT%></a></td>
                            </tr>
                            <tr id="bank2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strBT%></a></td>
                            </tr>
                            <tr id="bank"> 
                                <td class="submenutd"> 
                                    <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                                        <%if (bankDepPriv){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/bankdepositdetail.jsp?menu_idx=2"><%=strBTBankDeposit%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (bankPOPriv || bankNonPriv || bankCpPriv ){%>
                                        <tr> 
                                            <td class="menu1"><%=strBTPayment%></td>
                                        </tr>
                                        <%if (bankPOPriv) {%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/bankpopaymentsrc.jsp?menu_idx=2"><%=strBTPaymentOfPO%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if(bankCpPriv){%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/pelunasanbank.jsp?menu_idx=2"><%=strBTCashPayment%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if(bankNonPriv) {%>
                                        <tr> 
                                            <td class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/banknonpopaymentdetail.jsp?menu_idx=2"><%=strBTNonPOPayment%></a></td>
                                        </tr>
                                        <%}%>
                                        <%}%>
                                        <%if(bankPostPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/posting_transaksi_bank.jsp?menu_idx=2"><%=strBTNPost%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (bankArcPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/bankarchive.jsp?menu_idx=2"><%=strBTArchives%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (bankLinkPriv) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/master/bankacclink.jsp?menu_idx=2"><%=strBTBankAccountLink%></a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                           
                            <%if (arAging || arList) {%>
                            <tr id="ar1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('14')"><a href="javascript:cmdChangeMenu('14')"><%=strAR%></a> </td>
                            </tr>
                            <tr id="ar2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strAR%></a></td>
                            </tr>
                            <tr id="ar"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <%if(arAging){%>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu1"><%=strARTransaction%></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/ar/newarsrc.jsp?menu_idx=14">< %=strARNewInvoice%></a></td>
                                </tr-->
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/ar/paymentsrc.jsp?menu_idx=14">< %=strARPayment%></a></td>
                                </tr-->
                                                                <%if(arAging){%>
                                                                <tr> 
                                                                    <td height="18" width="80%" class="menu2"><a href="<%=approot%>/ar/aging.jsp?menu_idx=14"><%=strARAgingAnalysis%></a></td>
                                                                </tr>
                                                                <%}%>
                                                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/ar/archives.jsp?menu_idx=14">< %=strARArchives%></a></td>
                                </tr-->
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                    
                                                    <%if(arList){%>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu1"><%=strARMaster%></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/general/bankaccount.jsp?menu_idx=14">< %=strARBankAccount%></a></td>
                                </tr-->
                                <!--tr> 
                                  <td height="18" width="80%" class="menu2"><a href="< %=approot%>/general/customer.jsp?menu_idx=14">< %=strARCustomer%></a></td>
                                </tr-->
                                                                <%if(arList){%>
                                                                <tr> 
                                                                    <td height="18" width="80%" class="menu2"><a href="<%=approot%>/master/aracclink.jsp?menu_idx=14"><%=strARAccList%></a></td>
                                                                </tr>
                                                                <%}%>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                        <td height="18" width="90%"> </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (payIGL || payILI || payAAN || payPAL){%>
                            <tr id="inv1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('11')"> <a href="javascript:cmdChangeMenu('11')"><%=strAP%></a> </td>
                            </tr>
                            <tr id="inv2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strAP%></a></td>
                            </tr>
                            <tr id="inv"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (payIGL) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="#"><%=strAPIncomingGoodsList%></a> </td>
                                        </tr>
                                        <%}%>
                                        <!--tr> 
                                        <td height="18" width="90%" class="menu1">New Invoice</td>
                                                 </tr-->
                                        <%if (payILI) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="#"><%=strAPInvoiceList%></a></td>
                                        </tr>
                                        <!--tr> 
                      <td height="18" width="90%" class="menu1">Purchase Retur</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/adjusmentlist.jsp?menu_idx=11">Stock 
                        Adjustment</a></td>
                                        </tr-->
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="#"><%=strAPAgingAnalysis%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="#"><%=strAPPurchaseAccList%></a> </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (depoList || newDepo || returDepo || sadloDepo || depoArchives) {%>
                            <tr id="titip1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('16')"> <a href="javascript:cmdChangeMenu('16')"><%=strDP%></a></td>
                            </tr>
                            <tr id="titip2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strDP%></a></td>
                            </tr>
                            <tr id="titip"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (depoList) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/penitip.jsp?menu_idx=16"><%=strDPMemberOrUnit%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (newDepo) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/titipanbaru.jsp?menu_idx=16"><%=strDPNew%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (returDepo) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/kembalikantitipan.jsp?menu_idx=16"><%=strDPReturn%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (sadloDepo) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/saldotitipan.jsp?menu_idx=16"><%=strDPSaldo%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (depoArchives) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/titipanarchive.jsp?menu_idx=16"><%=strDPArchives%></a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                            <tr id="bymhd1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('18')"> <a href="javascript:cmdChangeMenu('18')"><%=strBYMHD%></a></td>
                            </tr>
                            <tr id="bymhd2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strBYMHD%></a></td>
                            </tr>
                            <tr id="bymhd"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/penitipbymhd.jsp?menu_idx=18"><%=strBYMHDList%></a></td>
                                        </tr>
                                        <%if (newBymhd) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/bymhdnew.jsp?menu_idx=18"><%=strBYMHDNew%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/bymhd.jsp?menu_idx=18"><%=strBYMHDPayment%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/bymhdsaldo.jsp?menu_idx=18"><%=strBYMHDSaldo%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (bymhdArchives) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/bymhdarchive.jsp?menu_idx=18"><%=strBYMHDArchives%></a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || daftarBank || akunPinjaman) {%>
                            <tr id="anggota1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('17')"> <a href="javascript:cmdChangeMenu('17')"><%=strMs%></a> 
                                </td>
                            </tr>
                            <tr id="anggota2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strMs%></a> 
                                </td>
                            </tr>
                            <tr id="anggota"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (anggotaKop) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strMsMember%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/member/scrmember.jsp?menu_idx=17"><%=strMsMemberList%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/member/member.jsp?menu_idx=17"><%=strMsNewMember%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || daftarBank || akunPinjaman) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strMsSimpanPinjam%></td>
                                        </tr>
                                        <%}
    if (daftarBank) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/bank.jsp?menu_idx=17"><%=strMsDaftarBank%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (newPinjam) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/pinjaman.jsp?menu_idx=17"><%=strMsPinjamanKoperasi%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (angsurPinjam) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/srcbayarpinjaman.jsp?menu_idx=17"><%=strMsAngsuran%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/arsippinjaman.jsp?menu_idx=17"><%=strMsArsipKoperasi%></a> </td>
                                        </tr>
                                        <%}%>
                                        <%if (newPinjamBank) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/pinjamanbank.jsp?menu_idx=17"><%=strMsPinjamanBank%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (angsurPinjamBank) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/srcbayarpinjaman.jsp?menu_idx=17&src_type=1"><%=strMsAngsuranBank%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/arsippinjamanbank.jsp?menu_idx=17"><%=strMsArsipBank%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (rekapPotonganGaji) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/invoicearchive.jsp?menu_idx=11"><%=strMsRekapPotonganGaji%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (akunPinjaman) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/pinjamanacclink.jsp?menu_idx=17"><%=strMsDaftarPinjaman%></a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%
            if (1 == 2) {
                if ((purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv)) {%>
                            <tr id="ap1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')"><%=strPO%></a> 
                                </td>
                            </tr>
                            <tr id="ap2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strPO%></a> 
                                </td>
                            </tr>
                            <tr id="ap"> 
                                <td class="submenutd"> 
                                    <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (purchaseOrdPriv) {%>
                                        <tr> 
                                            <td height="19" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/purchaseitem.jsp?menu_idx=3"><%=strPONew%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (purchaseVndPriv) {%>
                                        <tr> 
                                            <td height="19" width="90%" class="menu1"><a href="<%=approot%>/general/vendor.jsp?menu_idx=3"><%=strPOVendor%></a></td>
                                        </tr>
                                        <%}%>
                                        <!--tr> 
                                        <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/ap-proto.jsp?menu_idx=3">New 
                                                         Order Proto --</a></td>
                                                 </tr-->
                    <%if (purchaseArcPriv) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/purchasearchive.jsp?menu_idx=3"><%=strPOArchives%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (purchaseLinkPriv) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=3"><%=strPOPurchaseAccList%></a> </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}
            }%>
                           
                            <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                            <tr id="gl1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('9')"> <a href="javascript:cmdChangeMenu('9')"><%=strJournal%></a></td>
                            </tr>
                            <tr id="gl2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strJournal%></a></td>
                            </tr>
                            <tr id="gl"> 
                                <td class="submenutd"> 
                                    <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (glPriv){%>                                        
                                        <tr> 
                                            <td class="menu1"><%=strGJ%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/gldetail.jsp?menu_idx=9"><%=strGJNew%></a></td>
                                        </tr>                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/glkasbon.jsp?menu_idx=9"><%=strGJAdvance%></a></td>
                                        </tr>
                                        
                                        <!--tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/journal-proto.jsp?menu_idx=9">New JournaL Proto--</a></td>
                                        </tr-->
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/glarchive.jsp?menu_idx=9"><%=strGJArchives%></a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><%=strJR%></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/journalreversal.jsp?menu_idx=9"><%=strJRNew%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/glreverse.jsp?menu_idx=9"><%=strJRPosted%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/glreversearchive.jsp?menu_idx=9"><%=strJRArchives%></a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><%=strAT%></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/akrualsetup.jsp?menu_idx=9"><%=strATSetup%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/akrualproses.jsp?menu_idx=9"><%=strATProcess%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/akrualarsip.jsp?menu_idx=9"><%=strATArchives%></a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <%if(glBackdatedPriv || postGlBackdatedPriv) {%>
                                        <tr> 
                                            <td class="menu1"><%=strGJBackdated%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/gldetailbd.jsp?menu_idx=9"><%=strGJNewBackdated%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/glarchivebd.jsp?menu_idx=9"><%=strGJArchivesBackdated%></a></td>
                                        </tr>
                                        <%if (postGlBackdatedPriv) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/posting_glbd.jsp?menu_idx=9"><%=strPostJurnalBackdated%></a></td>
                                        </tr>
                                        <%}%>                                        
                                        <%}%>
										<%if(postGlPriv){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/<%=transactionFolder%>/posting_gl.jsp?menu_idx=9"><%=strPostJurnal%></a></td>
                                        </tr>                                                                                
                                        <%}%>
                                        <%if(((per13x.getOID() != 0) && (gl13Priv || postGl13Priv))) {%>
                                        <tr> 
                                            <td class="menu1"><%=strGJ13%></td>
                                        </tr>
                                        <%if (gl13Priv){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/gldetail13.jsp?menu_idx=9"><%=strGJNew13%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/glarchive13.jsp?menu_idx=9"><%=strGJArchives13%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (postGl13Priv) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/posting_gl13.jsp?menu_idx=9"><%=strPostJurnal13%></a></td>
                                        </tr>
                                        <%}%>                                        
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            <%if (1 == 2){%>
                            <tr id="pr1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('10')"> <a href="javascript:cmdChangeMenu('10')">Payroll</a> 
                                </td>
                            </tr>
                            <tr id="pr2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Payroll</a> 
                                </td>
                            </tr>
                            <tr id="pr"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Payroll ...</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Archives</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                            <tr id="frpt1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')"><%=strFR%></a></td>
                            </tr>
                            <tr id="frpt2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strFR%></a></td>
                            </tr>
                            <tr id="frpt"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">                                        
                                        <%if(fnSTR){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/report/rptformat.jsp?menu_idx=4"><%=strMDStupLaporan%></a></td>
                                        </tr>
                                        <%}%>                                        
                                        <%if(fnGlDet){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/worksheet.jsp?menu_idx=4"><%=strFRJournalDetail%></a></td>
                                        </tr>
										<%}%>      
										<%if(fnGl){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/glreport.jsp?menu_idx=4"><%=strFRGeneralLedger%></a></td>
                                        </tr>
                                        <%}%>
										<%if(fnNeraca){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/neraca.jsp?menu_idx=4"><%=strFRBalanceSheet%></a></td>
                                        </tr>
										<%}%>
										<%if(fn){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/profitloss_rpt.jsp?menu_idx=4"><%=strFRProfitLoss%></a></td>
                                        </tr>                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strFRPenjelasan%></td>
                                        </tr>                                        
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/neraca_penjelasan.jsp?menu_idx=4"><%=strFRPenjelasanNeraca%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/income_penjelasan.jsp?menu_idx=4"><%=strFRPenjelasanIncome%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/neracasaldo.jsp?menu_idx=4"><%=strNeracaSaldo%></a></td>
                                        </tr> 
                                        <%if(rptOnlyBTDC == false){ %>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strFRBalanceSheet%>-org</td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard.jsp?menu_idx=4"><%=strFRBsStandard%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail.jsp?menu_idx=4"><%=strFRDetail%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsmultiple.jsp?menu_idx=4"><%=strFRMultiplePeriods%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strFRProfitLoss%></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss.jsp?menu_idx=4"><%=strFRPlStandard%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss_budget.jsp?menu_idx=4"><%=strFRPlStandardBudget%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss0_v01.jsp?menu_idx=4"><%=strFRDepartmental%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss1.jsp?menu_idx=4"><%=strFRSectional%></a></td>
                                        </tr>                                        
                                        <%if (sysCompany.getDepartmentLevel() == DbDepartment.LEVEL_SUB_SECTION || sysCompany.getDepartmentLevel() == DbDepartment.LEVEL_JOB) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss2.jsp?menu_idx=4">Sub 
                                            Section Base</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (sysCompany.getDepartmentLevel() == DbDepartment.LEVEL_JOB) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss3.jsp?menu_idx=4">Job 
                                            Base</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (false) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitlossmultiple.jsp?menu_idx=4"><%=strFRMultiplePeriod%></a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strFRAdditionalReport%></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard_v02.jsp?menu_idx=4"><%=strFRNeraca%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard_v01.jsp?menu_idx=4"><%=strFRNeracaAkhir%></a></td>
                                        </tr>
                                        
                                        <!--tr> 
                      <td height="18" width="90%" class="menu2"><a href="< %=approot%>/freport/bsstandard_classv01.jsp?id_class=2&menu_idx=4">< %=strFRNeracaSP%></a></td>
                    </tr-->
                    <!--tr> 
                      <td height="18" width="90%" class="menu2"><a href="< %=approot%>/freport/bsstandard_classv01.jsp?id_class=1&menu_idx=4">< %=strFRNeracaNSP%></a></td>
                                        </tr-->
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/portofolio.jsp?menu_idx=4""><%=strFRPortofolio%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail_v01.jsp?menu_idx=4"><%=strFRPenjelasanNeraca%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/biaya_v01.jsp?menu_idx=4&pnl_type=0"><%=strFRBiaya%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/pendapatan_v01.jsp?menu_idx=4&pnl_type=1"><%=strFRPendapatan%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/ratio.jsp?menu_idx=4"><%=strFRRasio%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/iktisarlabarugi.jsp?menu_idx=4"><%=strFRIktisarLabaRugi%></a></td>
                                        </tr>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/kinerja.jsp?menu_idx=4"><%=strFRKinerja%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/outstanding_kasbon.jsp?menu_idx=4"><%=strFROustandingKasbon%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Laporan Advanced</td>
                                        </tr>
                                        <%if (false) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss_budget.jsp?menu_idx=4"><%=strFRPlStandardBudget%></a></td>
                                        </tr>
                                        <%}%>
                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail_v01.jsp?menu_idx=4"><%=strFRPenjelasanNeraca%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/rekap_biaya_all.jsp?menu_idx=4"><%=strFRPlRekapAll%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/biaya_v02.jsp?menu_idx=4"><%=strFRBiayaOperasiDireksi%></a></td>
                                        </tr>   
                                        <%}%>
                                        <%if (1 == 2) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/bymhdsaldo.jsp?menu_idx=4"><%=strFRSaldoBYMHD%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/<%=transactionFolder%>/saldotitipan.jsp?menu_idx=4"><%=strFRTitipan%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/asset/assetreport.jsp?menu_idx=4"><%=strFRAktivaTetap%></a></td>
                                        </tr>
                                        <%}%>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu2">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%
            if (applyActivity) { //jika pake aktivity

                if (dreportPriv) {%>
                            <tr id="drpt1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('5')"> <a href="javascript:cmdChangeMenu('5')"><%=strDR%></a> </td>
                            </tr>
                            <tr id="drpt2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strDR%></a> </td>
                            </tr>
                            <tr id="drpt"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if(gereja){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/activity/moduleg.jsp?menu_idx=5"><%=strMDWorkplan%></a></td>
                                        </tr>
										<tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/activity/modulegcheck.jsp?menu_idx=5"><%=strMDWorkplanCheck%></a></td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/activity/module.jsp?menu_idx=5"><%=strMDWorkplan%></a></td>
                                        </tr>
										<tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/activity/modulecheck.jsp?menu_idx=5"><%=strMDWorkplanCheck%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (dreportPriv) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/summary.jsp?menu_idx=5"><%=strDRSummary%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/workplandetail.jsp?menu_idx=5"><%=strDRWorkplan%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/expensecategory.jsp?menu_idx=5"><%=strDRCategory%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/natureexpensecategory.jsp?menu_idx=5"><%=strDRGroup%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                                            </td>
                                        </tr>
                                        <%}%>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}

            }//end non activity %>
                            <%if (datasyncPriv){%>
                            <tr id="dtransfer1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('7')"> <a href="javascript:cmdChangeMenu('7')"><%=strDS%></a> </td>
                            </tr>
                            <tr id="dtransfer2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strDS%></a> </td>
                            </tr>
                            <tr id="dtransfer"> 
                                <td class="submenutd"> 
                                    <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (datasyncPriv){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Backup</td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/backup.jsp?menu_idx=7"><%=strDSTransfer%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/maintain.jsp?menu_idx=7"><%=strDSMaintenance%></a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/datasync/upload.jsp?menu_idx=7"><%=strDSUpload%></a></td>
                                        </tr>
                                        <!--tr>
                                                   <td height="18" width="90%" class="menu1"><a href="<%=approot%>/datasync/backuphistory.jsp?menu_idx=7"">History</a></td>
                                        </tr-->
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                                            </td>
                                        </tr>
                                        <%}%>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	

                            <tr id="master1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('6')"> <a href="javascript:cmdChangeMenu('6')"><%=strMD%></a></td>
                            </tr>
                            <tr id="master2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strMD%></a></td>
                            </tr>
                            <tr id="master"> 
                                <td class="submenutd"> 
                                    <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                                        <%if (mastSysConf) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/company.jsp?menu_idx=6"><%=strMDSystemConfiguration%></a></td>
                                        </tr>
                                        <%}%>                                        
                                        <%if (mastAcc || mastBgt) {%>                                        
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strMDAccounting%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                            
                                                    <%if(mastAcc){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coa.jsp?menu_idx=6"><%=strMDChartOfAccount%></a></td>
                                                    </tr>
                                                    <%}if(mastBgt){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coabudget_edt.jsp?menu_idx=6"><%=strMDAccountBudgetTarget%></a></td>
                                                    </tr>
                                                    <%}if(mastAcc){%>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coaportofoliosetup.jsp?menu_idx=6"><%=strMDPortofolioSetup%></a> </td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/segment/segment.jsp?menu_idx=6"><%=strMDSegment%></a> </td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coaexpensecategory.jsp?menu_idx=6"><%=strMDAccountCategory%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coanatureexpensecategory.jsp?menu_idx=6"><%=strMDAccountGroupAliases%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/exchangerate.jsp?menu_idx=6"><%=strMDBookkeepingRate%></a> </td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/periode.jsp?menu_idx=6"><%=strMDPeriod%></a></td>
                                                    </tr>
													<%}%>
                                                </table>
                                            </td>
                                        </tr>
										<%if(mastAcc){%>
										<tr> 
                                            <td height="18" width="90%" class="menu1"><%=strMDApproval%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/systemdoccode.jsp?menu_idx=6"><%=strMDDocCode%></a></td>
                                                    </tr>
													<tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/approval.jsp?menu_idx=6"><%=strMDSetupApproval%></a></td>
                                                    </tr>
													<tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/printdesign.jsp?menu_idx=6"><%=strMDDesignPrint%></a></td>
                                                    </tr>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <%}}%>
                                        
                                        
                                        <%if (applyActivity && mastWp) {%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1">Workplan </td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%" nowrap> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coaexpensebudget.jsp?menu_idx=6"><%=strMDExpense%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/donor.jsp?menu_idx=6"><%=strMDDonorList%></a></td>
                                                    </tr>
                                                    <!-- tr> 
                                                    <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/donorcomponent.jsp?menu_idx=6">Donor 
                                                                   Component </a></td>
                                                           </tr -->
                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/activityperiod.jsp?menu_idx=6"><%=strMDActivityPeriod%></a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (mastComp){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strMDCompany%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/employee.jsp?menu_idx=6"><%=strMDEmployeeList%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/department.jsp?menu_idx=6"><%=strMDDepartmentList%></a></td>
                                                    </tr>
                                                    <!--tr> 
                                                    <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/section.jsp?menu_idx=6">Section</a></td>
                                                    </tr-->
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if(mastGen){%>
                                        <tr> 
                                            <td height="18" width="90%" class="menu1"><%=strMDGeneral%></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/country.jsp?menu_idx=6"><%=strMDCountry%></a></td>
                                                    </tr>
                                                    
                                                    <tr> 
                                                        <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/currency.jsp?menu_idx=6"><%=strMDCurrency%></a></td>
                                                    </tr>
                                                    <!--tr> 
                                                    <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/itemtype.jsp?menu_idx=6">Item 
                                                                   Type</a> </td>
                                                           </tr-->
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/termofpayment.jsp?menu_idx=6"><%=strMDTermOfPayment%></a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/shipaddress.jsp?menu_idx=6"><%=strMDShippingAddress%></a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/paymentmethod.jsp?menu_idx=6"><%=strMDPaymentMethod%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/location.jsp?menu_idx=6"><%=strMDLocationList%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/kecamatan.jsp?menu_idx=6"><%=strMDSubDistrict%></a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/desa.jsp?menu_idx=6"><%=strMDVillage%></a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/pekerjaan.jsp?menu_idx=6"><%=strMDOccupationList%></a></td>
                                                    </tr>                                                    
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/dinas.jsp?menu_idx=6"><%=strMDOfficial%></a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/dinasunit.jsp?menu_idx=6"><%=strMDOfficialUnit%></a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            <%if (closePer) {%>
                            <tr id="closing1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('13')"> <a href="javascript:cmdChangeMenu('13')"><%=strCP%></a></td>
                            </tr>
                            <tr id="closing2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strCP%></a></td>
                            </tr>
                            <tr id="closing"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                                        <%if (closePer) {%>
										<tr> 
                                            <td class="menu1"> 
                                                    <%if (!isYearlyClose) {%>
													<a href="<%=approot%>/closing/periodenew.jsp?menu_idx=13">
                                                    <%=strCPNewPeriod%>
													</a>
                                                    <%}%>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/closing/periode.jsp?menu_idx=13"> 
                                                    <%if (!isYearlyClose) {%>
                                                    <%=strCPMonthlyClosing%>
                                                    <%} else {%>
                                                    <%=strCPYearlyClosing%>
                                                    <%}%>
                                            </a></td>
                                        </tr>
                                        <%}%>
                                        <%if (closePer && 1 == 2) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/closing/yearlyclose.jsp?menu_idx=13"><%=strCPYearlyClosing%></a></td>
                                        </tr>
                                        <%}%>
                                        <%if (per13x.getOID() != 0 && closePer){%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/closing/periode13.jsp?menu_idx=13"><%=strCPPer13Closing%></a></td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                            <td class="menu1">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (admin){%>
                            <tr id="admin1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('12')"> <a href="javascript:cmdChangeMenu('12')"><%=strAdministrator%></a> 
                                </td>
                            </tr>
                            <tr id="admin2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><%=strAdministrator%></a>
                                </td>
                            </tr>
                            <tr id="admin"> 
                                <td class="submenutd"> 
                                    <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">                                        
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/system/sysprop.jsp?menu_idx=12"><%=strSystemProperties%></a></td>
                                        </tr>                                        
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/admin/userlist.jsp?menu_idx=12"><%=strUserList%></a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/admin/grouplist.jsp?menu_idx=12"><%=strUserGroup%></a></td>
                                        </tr>
                                        <tr> 
                                            <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <tr> 
                                <td class="menu0"><a href="<%=approot%>/logout.jsp">Logout</a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script language="JavaScript">
    cmdChangeMenu('<%=menuIdx%>');
        </script>
