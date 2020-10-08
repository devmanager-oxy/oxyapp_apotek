
<%
menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
//out.println(idx1);
%>
<script language="JavaScript">

function cmdHelp(){
	window.open("<%=approot%>/help.htm");
}

function cmdChangeMenu(idx){
	var x = idx;
	
	//document.frm_data.menu_idx.value=idx;
	
	switch(parseInt(idx)){
	
		case 1 : 
			
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="none";
			document.all.cash2.style.display="";
			document.all.cash.style.display="";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>			
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>		
			
			////document.all.pr1.style.display="";
			////document.all.pr2.style.display="none";
			
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
		
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
		
			break;
		
		case 2 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>			
			document.all.bank1.style.display="none";
			document.all.bank2.style.display="";
			document.all.bank.style.display="";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>			
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;
		
		case 3 :
			
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="none";
			document.all.ap2.style.display="";
			document.all.ap.style.display="";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>			
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";			
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;	
			
		case 4 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
				document.all.cash1.style.display="";
				document.all.cash2.style.display="none";
				document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="none";
			document.all.frpt2.style.display="";
			document.all.frpt.style.display="";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";						
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;
			
		case 5 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="none";
			document.all.drpt2.style.display="";
			document.all.drpt.style.display="";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";						
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
						
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;
					
		case 6 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="none";
			document.all.master2.style.display="";
			document.all.master.style.display="";
			<%}%>
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
									
			break;
		
		case 7 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="none";
			document.all.dtransfer2.style.display="";
			document.all.dtransfer.style.display="";
			<%}%>
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";	
			document.all.inv.style.display="none";						
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;
		//---
		case 8 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";			
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;	
		
		case 9 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="none";
			document.all.gl2.style.display="";
			document.all.gl.style.display="";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>		
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";			
			document.all.inv.style.display="none";			
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;
		
		case 10 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="none";
			//document.all.pr2.style.display="";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>		
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";	
			document.all.inv.style.display="none";	
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;
			
		case 11 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>			
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>		
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="none";
			document.all.inv2.style.display="";	
			document.all.inv.style.display="";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;		
		
		case 12 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";						
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>		
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";	
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="none";
			document.all.admin2.style.display="";
			document.all.admin.style.display="";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;	
		
		case 13 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";						
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";
			document.all.dtransfer.style.display="none";
			<%}%>		
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";	
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="none";
			document.all.closing2.style.display="";
			document.all.closing.style.display="";
			<%}%>
			
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
			
			break;
			
		case 14 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="none";
			document.all.ar2.style.display="";
			document.all.ar.style.display="";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;
		
		case 15 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="none";
			document.all.akrual2.style.display="";
			document.all.akrual.style.display="";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;
		
		case 16 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="none";
			document.all.titip2.style.display="";
			document.all.titip.style.display="";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;						
		
		case 17 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="none";
			document.all.anggota2.style.display="";
			document.all.anggota.style.display="";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;
		
		case 18 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="none";
			document.all.bymhd2.style.display="";
			document.all.bymhd.style.display="";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;
		
		case 19 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="none";
			document.all.asset2.style.display="";
			document.all.asset.style.display="";
			<%}%>
						
			break;	
		
		case 20 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="none";
			document.all.dp2.style.display="";
			document.all.dp.style.display="";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;
				
		case 0 :
			<%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
			document.all.cash1.style.display="";
			document.all.cash2.style.display="none";
			document.all.cash.style.display="none";
			<%}%>
			<%if(arCreate || arArchives){%>
			document.all.ar1.style.display="";
			document.all.ar2.style.display="none";
			document.all.ar.style.display="none";
			<%}%>
			<%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
			document.all.bank1.style.display="";
			document.all.bank2.style.display="none";
			document.all.bank.style.display="none";
			<%}%>
			<%if(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
			document.all.ap1.style.display="";
			document.all.ap2.style.display="none";		
			document.all.ap.style.display="none";
			<%}%>
			<%if(glNewPriv || glArcPriv){%>
			document.all.gl1.style.display="";
			document.all.gl2.style.display="none";
			document.all.gl.style.display="none";			
			<%}%>
			<%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
			   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
			   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
			document.all.master1.style.display="";
			document.all.master2.style.display="none";
			document.all.master.style.display="none";		
			<%}%>
			
			//document.all.pr1.style.display="";
			//document.all.pr2.style.display="none";
			<%if(freportPriv ){%>
			document.all.frpt1.style.display="";
			document.all.frpt2.style.display="none";
			document.all.frpt.style.display="none";
			<%}%>
			<%if(dreportPriv && applyActivity){%>
			document.all.drpt1.style.display="";
			document.all.drpt2.style.display="none";
			document.all.drpt.style.display="none";
			<%}%>
			<%if(1==2){//(datasyncPriv){%>
			document.all.dtransfer1.style.display="";
			document.all.dtransfer2.style.display="none";	
			document.all.dtransfer.style.display="none";			
			<%}%>
			
			<%if(payableInvPriv || payableArcPriv){%>
			document.all.inv1.style.display="";
			document.all.inv2.style.display="none";
			document.all.inv.style.display="none";
			<%}%>
			
			<%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
			document.all.closing1.style.display="";
			document.all.closing2.style.display="none";
			document.all.closing.style.display="none";
			<%}%>
		
			<%if(adminPriv){%>
			document.all.admin1.style.display="";
			document.all.admin2.style.display="none";
			document.all.admin.style.display="none";
			<%}%>
			
			//--------------------
			
			<%if(akrualSetupPriv || akrualProcessPriv){%>
			document.all.akrual1.style.display="";
			document.all.akrual2.style.display="none";
			document.all.akrual.style.display="none";
			<%}%>
			
			<%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
			document.all.titip1.style.display="";
			document.all.titip2.style.display="none";
			document.all.titip.style.display="none";
			<%}%>
			
			<%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
			document.all.dp1.style.display="";
			document.all.dp2.style.display="none";
			document.all.dp.style.display="none";
			<%}%>
			
			<%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || rekapPotonganGaji){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggota.style.display="none";
			<%}%>
			
			<%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
			document.all.bymhd1.style.display="";
			document.all.bymhd2.style.display="none";
			document.all.bymhd.style.display="none";
			<%}%>
			
			<%if(assetSetupPriv || assetProcessPriv){%>
			document.all.asset1.style.display="";
			document.all.asset2.style.display="none";
			document.all.asset.style.display="none";
			<%}%>
						
			break;	
	}
}

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
					String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");        
				%>
                <td height="49"> 
                  <div align="center">Periode Akunting : <br>
                    <%=openPeriodXXX%><br>
                  </div>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="4"></td>
              </tr>
              <%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
              <tr id="cash1"> 
                <td class="menu0"" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Cash 
                  Transaction </a></td>
              </tr>
              <tr id="cash2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Cash 
                  Transaction </a></td>
              </tr>
              <tr id="cash"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <%if(cashRecUpdate){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/cashreceivedetail.jsp?menu_idx=1">Cash 
                        Receipt</a></td>
                    </tr>
                    <%}		
							if(cashPayUpdate || cashRefUpdate){
							%>
                    <tr> 
                      <td class="menu1">Petty Cash</td>
                    </tr>
                    <%if(cashPayUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/pettycashpaymentdetail.jsp?menu_idx=1">Cash 
                        Payment </a></td>
                    </tr>
                    <%}%>
                    <%if(cashRefUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/pettycashreplenishment.jsp?menu_idx=1">Replenishment</a></td>
                    </tr>
                    <%}
							}%>
                    <%if(cashArcPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/casharchive.jsp?menu_idx=1">Archives</a></td>
                    </tr>
                    <%}%>
                    <%if(cashLinkPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/master/cashacclink.jsp?menu_idx=1">Cash 
                        Account Link</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <%}%>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
              <tr id="bank1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Bank 
                  Transaction </a></td>
              </tr>
              <tr id="bank2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Bank 
                  Transaction </a></td>
              </tr>
              <tr id="bank"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <%if(bankDepUpdate){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/bankdepositdetail.jsp?menu_idx=2">Bank 
                        Deposit</a></td>
                    </tr>
                    <%}%>
                    <%if(bankPOUpdate || bankNonpoUpdate){%>
                    <tr> 
                      <td class="menu1">Payment</td>
                    </tr>
                    <%if(bankPOUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/bankpopaymentsrc.jsp?menu_idx=2">Payment 
                        of PO </a></td>
                    </tr>
                    <%}%>
                    <%if(bankNonpoUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/banknonpopaymentdetail.jsp?menu_idx=2">Non 
                        PO Payment</a></td>
                    </tr>
                    <%}%>
                    <%}%>
                    <%if(bankArcPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/bankarchive.jsp?menu_idx=2">Archives</a></td>
                    </tr>
                    <%}%>
                    <%if(bankLinkPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/master/bankacclink.jsp?menu_idx=2">Bank 
                        Account Link</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <%}%>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%if(arCreate || arArchives || arCustomer){%>
              <tr id="ar1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('14')"><a href="javascript:cmdChangeMenu('14')">Account 
                  Receivable </a> </td>
              </tr>
              <tr id="ar2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Account 
                  Receivable </a></td>
              </tr>
              <tr id="ar"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td height="18" width="90%" class="menu1">Transaction</td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/ar/newarsrc.jsp?menu_idx=14">New 
                                    Invoice</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/ar/paymentsrc.jsp?menu_idx=14">Payment</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/ar/aging.jsp?menu_idx=14">Aging 
                                    Analysis</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/ar/archives.jsp?menu_idx=14">Archives</a></td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%" class="menu1">Master</td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/general/bankaccount.jsp?menu_idx=14">Bank 
                                    Account</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/general/customer.jsp?menu_idx=14">Customer</a></td>
                                </tr>
                                <tr> 
                                  <td height="18" width="80%" class="menu2"><a href="<%=approot%>/master/aracclink.jsp?menu_idx=14">AR 
                                    Acc. List</a></td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%"> </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(payableInvPriv || payableArcPriv){%>
              <tr id="inv1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('11')"> <a href="javascript:cmdChangeMenu('11')">Account 
                  Payable </a> </td>
              </tr>
              <tr id="inv2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Account 
                  Payable </a></td>
              </tr>
              <tr id="inv"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(payableInvPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/invoicesrc.jsp?menu_idx=11">Incoming 
                        Goods List</a> </td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    <%if(payableArcPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/invoicearchive.jsp?menu_idx=11">Invoice 
                        List </a></td>
                    </tr>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1">Purchase Retur</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/adjusmentlist.jsp?menu_idx=11">Stock 
                        Adjustment</a></td>
                    </tr-->
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/apaging.jsp?menu_idx=11">Aging 
                        Analysis</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=11">Purchase 
                        Acc. List</a> </td>
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
              <%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
              <tr id="titip1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('16')"> <a href="javascript:cmdChangeMenu('16')">Titipan</a></td>
              </tr>
              <tr id="titip2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Titipan</a></td>
              </tr>
              <tr id="titip"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(depoList){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/penitip.jsp?menu_idx=16">Member/Unit</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldotitipanmapping.jsp?menu_idx=16">Transaksi 
                        Titipan</a></td>
                    </tr>
                    <%}%>
                    <%//if(newDepo){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/titipanbaru.jsp?menu_idx=16">New 
                        Deposit</a></td>
                    </tr-->
                    <%//}%>
                    <%//if(returDepo){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/kembalikantitipan.jsp?menu_idx=16">Return 
                        Deposit</a></td>
                    </tr-->
                    <%//}%>
                    <%if(sadloDepo){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldotitipan.jsp?menu_idx=16"> 
                        Saldo Titipan</a></td>
                    </tr>
                    <%}%>
                    <%if(depoArchives){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/titipanarchive.jsp?menu_idx=16">Archives</a></td>
                    </tr-->
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
              <%if(bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives){%>
              <tr id="bymhd1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('18')"> <a href="javascript:cmdChangeMenu('18')">BYMHD</a></td>
              </tr>
              <tr id="bymhd2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">BYMHD</a></td>
              </tr>
              <tr id="bymhd"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/penitipbymhd.jsp?menu_idx=18">BYMHD 
                        Uraian </a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldobymhdmapping.jsp?menu_idx=18">Transaksi 
                        BYMHD</a></td>
                    </tr>
                    <%//if(newBymhd){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/bymhdnew.jsp?menu_idx=18">BYMHD 
                        Baru </a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/bymhd.jsp?menu_idx=18">BYMHD 
                        Payment</a></td>
                    </tr-->
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldobymhd.jsp?menu_idx=18">Saldo 
                        BYMHD</a></td>
                    </tr>
                    <%//}%>
                    <%if(bymhdArchives){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/bymhdarchive.jsp?menu_idx=18">Arsip</a></td>
                    </tr-->
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
              <%if(xxdepoList || xxnewDepo || xxreturDepo || xxsadloDepo || xxdepoArchives){%>
              <tr id="dp1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('20')"> <a href="javascript:cmdChangeMenu('20')">Deposit/DP</a></td>
              </tr>
              <tr id="dp2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Deposit/DP</a></td>
              </tr>
              <tr id="dp"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(xxdepoList){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/penitipdp.jsp?menu_idx=20">Supplier/Vendor</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldodepositmapping.jsp?menu_idx=20">Transaksi 
                        Deposit</a></td>
                    </tr>
                    <%}%>
                    <%//if(xxnewDepo){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/dpbaru.jsp?menu_idx=20">New 
                        DP</a></td>
                    </tr>
                    <%//}%>
                    <%//if(xxreturDepo){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/kembalikandp.jsp?menu_idx=20">Return 
                        DP</a></td>
                    </tr-->
                    <%//}%>
                    <%if(xxsadloDepo){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldodp.jsp?menu_idx=20"> 
                        Saldo DP</a></td>
                    </tr>
                    <%}%>
                    <%//if(xxdepoArchives){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/dparchive.jsp?menu_idx=20">Archives</a></td>
                    </tr-->
                    <%//}%>
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
              <%if(akrualSetupPriv || akrualProcessPriv){%>
              <tr id="akrual1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('15')"> <a href="javascript:cmdChangeMenu('15')">Accrual 
                  Transaction </a> </td>
              </tr>
              <tr id="akrual2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Accrual 
                  Transaction </a></td>
              </tr>
              <tr id="akrual"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(akrualSetupPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/akrualsetup.jsp?menu_idx=15">Setup 
                        Accrual Transaction</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    <%if(akrualProcessPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/akrualproses.jsp?menu_idx=15">Accrual 
                        Process </a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/akrualarsip.jsp?menu_idx=15">Archives</a></td>
                    </tr>
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
              <%if(assetSetupPriv || assetProcessPriv){%>
              <tr id="asset1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('19')"> <a href="javascript:cmdChangeMenu('19')">Asset 
                  Management</a> </td>
              </tr>
              <tr id="asset2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Asset 
                  Management</a></td>
              </tr>
              <tr id="asset"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(assetSetupPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/asset/asset.jsp?menu_idx=19">Asset 
                        List</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    <%if(assetProcessPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/asset/assetdepre.jsp?menu_idx=19">Depreciation 
                        Process </a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/asset/assetdepre_archives.jsp?menu_idx=19">Archives</a></td>
                    </tr>
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
              <%if(anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || daftarBank || akunPinjaman){%>
              <tr id="anggota1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('17')"> <a href="javascript:cmdChangeMenu('17')">Keanggotaan</a> 
                </td>
              </tr>
              <tr id="anggota2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Keanggotaan</a> 
                </td>
              </tr>
              <tr id="anggota"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(anggotaKop){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Anggota</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/member/scrmember.jsp?menu_idx=17">List 
                        Anggota</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/member/member.jsp?menu_idx=17">Anggota 
                        Baru</a></td>
                    </tr>
                    <%}%>
                    <%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || daftarBank || akunPinjaman){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Simpan Pinjam</td>
                    </tr>
                    <%}
					if(daftarBank){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/bank.jsp?menu_idx=17">Daftar 
                        Bank</a></td>
                    </tr>
                    <%}%>
                    <%if(newPinjam){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/pinjaman.jsp?menu_idx=17">Pinjaman 
                        Koperasi</a></td>
                    </tr>
                    <%}%>
                    <%if(angsurPinjam){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/srcbayarpinjaman.jsp?menu_idx=17">Angsuran</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/arsippinjaman.jsp?menu_idx=17">Arsip 
                        Pinjaman Koperasi</a> </td>
                    </tr>
                    <%}%>
                    <%if(newPinjamBank){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/pinjamanbank.jsp?menu_idx=17">Pinjaman 
                        Bank</a></td>
                    </tr>
                    <%}%>
                    <%if(angsurPinjamBank){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/srcbayarpinjaman.jsp?menu_idx=17&src_type=1">Angsuran 
                        Pinjaman Bank</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/arsippinjamanbank.jsp?menu_idx=17">Arsip 
                        Pinjaman Bank </a></td>
                    </tr>
                    <%}%>
                    <%if(rekapPotonganGaji){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/transaction/invoicearchive.jsp?menu_idx=11">Rekap 
                        Potongan Gaji</a></td>
                    </tr>
                    <%}%>
                    <%if(akunPinjaman){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/pinjamanacclink.jsp?menu_idx=17">Daftar 
                        Akun Pinjaman</a></td>
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
			  if(true){
			  if((purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv)){%>
              <tr id="ap1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')">Purchases</a> 
                </td>
              </tr>
              <tr id="ap2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Purchases</a> 
                </td>
              </tr>
              <tr id="ap"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(purchaseOrdPriv){%>
					<tr> 
                      <td height="19" width="90%" class="menu1"><a href="<%=approot%>/fd/purchasesharemain.jsp?menu_idx=3">New 
                        Purchase </a></td>
                    </tr>
                    
                    <!--tr> 
                      <td height="19" width="90%" class="menu1"><a href="<%=approot%>/transaction/purchaseitem.jsp?menu_idx=3">New 
                        Order </a></td>
                    </tr-->
                    <tr> 
                      <td height="19" width="90%" class="menu1"><a href="<%=approot%>/fd/costsharring.jsp?menu_idx=3">Cost 
                        Sharing</a></td>
                    </tr>
                    <%}%>
                    <%if(purchaseVndPriv){%>
                    <!--tr> 
                      <td height="19" width="90%" class="menu1"><a href="<%=approot%>/general/vendor.jsp?menu_idx=3">Vendor</a></td>
                    </tr-->
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/ap-proto.jsp?menu_idx=3">New 
							Order Proto --</a></td>
						</tr-->
                    <%if(purchaseArcPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/casharchiveshare.jsp?menu_idx=3">Archives</a></td>
                    </tr>
                    <%}%>
                    <%if(purchaseLinkPriv){%>
                    <!--tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=3">Purchase 
                        Acc. List</a> </td>
                    </tr-->
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
              <%}}%>
              <%if(glNewPriv || glArcPriv){%>
              <tr id="gl1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('9')"> <a href="javascript:cmdChangeMenu('9')">General 
                  Journal </a></td>
              </tr>
              <tr id="gl2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">General 
                  Journal </a></td>
              </tr>
              <tr id="gl"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(glNewPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/gldetail.jsp?menu_idx=9">New 
                        Journal</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/journal-proto.jsp?menu_idx=9">New 
							JournaL Proto--</a></td>
						</tr-->
                    <%if(glArcPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/glarchive.jsp?menu_idx=9">Archives</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"><font color="#FFFFFF">&nbsp;</font> 
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <%}%>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%if(1==2){%>
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
              <%if(freportPriv){%>
              <tr id="frpt1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Financial 
                  Report </a></td>
              </tr>
              <tr id="frpt2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Financial 
                  Report </a
					></td>
              </tr>
              <tr id="frpt"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(freportPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/worksheet.jsp?menu_idx=4">Jurnal 
                        Detail </a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/glreport.jsp?menu_idx=4">General 
                        Ledger</a></td>
                    </tr>
                    <%if(true){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Balance Sheet</td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard.jsp?menu_idx=4">Standard</a></td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail.jsp?menu_idx=4">Detail</a></td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsmultiple.jsp?menu_idx=4">Multiple 
                        Periods</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Profit & Loss</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss.jsp?menu_idx=4">Standard</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitlossdep.jsp?menu_idx=4">Departmental 
                        Base</a></td>
                    </tr>
                    <!--tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss0_v01.jsp?menu_idx=4">Departmental 
                        Base</a></td>
                    </tr-->
                    <%if(sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_SECTION || sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_SUB_SECTION || 
						sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_JOB){
					//if(true){
					%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss1.jsp?menu_idx=4">Sectional 
                        Base</a></td>
                    </tr>
                    <%}%>
                    <%if(sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_SUB_SECTION ||	sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_JOB){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss2.jsp?menu_idx=4">Sub 
                        Section Base</a></td>
                    </tr>
                    <%}%>
                    <%if(sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_JOB){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss3.jsp?menu_idx=4">Job 
                        Base</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitlossmultiple.jsp?menu_idx=4">Multiple 
                        Periods</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitlossmultipledep.jsp?menu_idx=4">Multiple 
                        Departmental</a></td>
                    </tr>
                    <%}//end 1==2
					if(1==2){
					%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Laporan Keuangan</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard_v01.jsp?menu_idx=4">Neraca 
                        Akhir</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard_classv01.jsp?id_class=2&menu_idx=4">Neraca 
                        SP</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard_classv01.jsp?id_class=1&menu_idx=4">Neraca 
                        NSP</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/portofolio.jsp?menu_idx=4"">Portofolio</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail_v01.jsp?menu_idx=4">Penjelasan 
                        Neraca</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/biaya_v01.jsp?menu_idx=4&pnl_type=0">Biaya</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/pendapatan_v01.jsp?menu_idx=4&pnl_type=1">Pendapatan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/ratio.jsp?menu_idx=4">Rasio</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/iktisarlabarugi.jsp?menu_idx=4">Iktisar 
                        Laba Rugi</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/kinerja.jsp?menu_idx=4">Kinerja</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/transaction/bymhdsaldo.jsp?menu_idx=4">BYMHD</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/transaction/saldotitipan.jsp?menu_idx=4">Titipan</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/asset/assetreport.jsp?menu_idx=4">Aktiva 
                        Tetap</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu2">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2">&nbsp;</td>
                    </tr>
                    <%}%>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%
				  if(applyActivity){ //jika pake aktivity
				  
				  if(dreportPriv){%>
              <tr id="drpt1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('5')"> <a href="javascript:cmdChangeMenu('5')">Donor 
                  Report</a> </td>
              </tr>
              <tr id="drpt2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Donor 
                  Report</a> </td>
              </tr>
              <tr id="drpt"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(dreportPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/summary.jsp?menu_idx=5">Summary 
                        </a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/workplandetail.jsp?menu_idx=5">Workplan 
                        - Detail</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/expensecategory.jsp?menu_idx=5">By 
                        Category</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/dreport/natureexpensecategory.jsp?menu_idx=5">By 
                        Group - Detail</a></td>
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
              <%if(1==2){//(datasyncPriv){%>
              <tr id="dtransfer1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('7')"> <a href="javascript:cmdChangeMenu('7')">Data 
                  Synchronization</a> </td>
              </tr>
              <tr id="dtransfer2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Data 
                  Synchronization</a> </td>
              </tr>
              <tr id="dtransfer"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(1==2){//(datasyncPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Backup</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/backupcheck.jsp?menu_idx=7">Transfer 
                              To File</a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/datasync/maintain.jsp?menu_idx=7">Maintenance</a></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/datasync/upload.jsp?menu_idx=7">Upload</a></td>
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
              <%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
					   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
					   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
              <tr id="master1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('6')"> <a href="javascript:cmdChangeMenu('6')">Master 
                  Data </a></td>
              </tr>
              <tr id="master2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Master 
                  Data </a></td>
              </tr>
              <tr id="master"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(masterConfPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/company.jsp?menu_idx=6">System 
                        Configuration</a></td>
                    </tr>
                    <%}%>
                    <%if(masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Accounting</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterCoaPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coa.jsp?menu_idx=6">Chart 
                              of Account</a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coabudget_edt.jsp?menu_idx=6">Account 
                              Budget/Target </a></td>
                          </tr>
                          <%}
						  
						  if(false){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coaportofoliosetup.jsp?menu_idx=6">Portofolio 
                              Setup</a> </td>
                          </tr>
                          <%}
						  if(masterCatPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coaexpensecategory.jsp?menu_idx=6">Account 
                              Category </a></td>
                          </tr>
                          <%}
						  if(false){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/iktisarsetup.jsp?menu_idx=6">Setup 
                              Iktisar RL</a> </td>
                          </tr>
                          <%}%>
                          <%if(masterGroupPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coanatureexpensecategory.jsp?menu_idx=6">Account 
                              Group Aliases</a></td>
                          </tr>
                          <%}%>
                          <%if(masterBookPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/exchangerate.jsp?menu_idx=6">Bookkeeping 
                              Rate</a> </td>
                          </tr>
                          <%}%>
                          <%if(masterPeriodPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/periode.jsp?menu_idx=6">Period</a></td>
                          </tr>
                          <%}%>
                        </table>
                      </td>
                    </tr>
                    <%}%>
                    <%if(applyActivity && (masterWorkPlanPriv || masterAllocationPriv || masterDonorPriv || masterActPeriodPriv)){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Workplan </td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" nowrap> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterWorkPlanPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/module.jsp?menu_idx=6">Workplan 
                              Data</a></td>
                          </tr>
                          <%}%>
                          <%if(masterAllocationPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coaexpensebudget.jsp?menu_idx=6">Expense 
                              Allocation to Activity</a></td>
                          </tr>
                          <%}%>
                          <%if(masterDonorPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/donor.jsp?menu_idx=6">Donors 
                              List</a></td>
                          </tr>
                          <%}%>
                          <!-- tr> 
								<td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/donorcomponent.jsp?menu_idx=6">Donor 
								  Component </a></td>
							  </tr -->
                          <%if(masterActPeriodPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/activityperiod.jsp?menu_idx=6">Period</a></td>
                          </tr>
                          <%}%>
                        </table>
                      </td>
                    </tr>
                    <%}%>
                    <%if(masterEmpPriv || masterDepartmentPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Company</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterEmpPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/employee.jsp?menu_idx=6">Employee 
                              List as User</a></td>
                          </tr>
                          <%}%>
                          <%if(masterDepartmentPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/department.jsp?menu_idx=6">Department 
                              List </a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/unitusaha.jsp?menu_idx=6">Unit 
                              Usaha </a></td>
                          </tr>
                          <%}%>
                          <!--tr> 
								<td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/section.jsp?menu_idx=6">Section</a></td>
							  </tr-->
                        </table>
                      </td>
                    </tr>
                    <%}%>
                    <%if(masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">General</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterCountryPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/country.jsp?menu_idx=6">Country</a></td>
                          </tr>
                          <%}%>
                          <%if(masterCurrencyPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/currency.jsp?menu_idx=6">Currency</a></td>
                          </tr>
                          <%}%>
                          <!--tr> 
								<td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/itemtype.jsp?menu_idx=6">Item 
								  Type</a> </td>
							  </tr-->
                          <%if(masterTopPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/termofpayment.jsp?menu_idx=6">Term 
                              of Payment</a></td>
                          </tr>
                          <%}%>
                          <%if(masterShipPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/shipaddress.jsp?menu_idx=6">Shipping 
                              Address </a></td>
                          </tr>
                          <%}%>
                          <%if(masterPayMetPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/paymentmethod.jsp?menu_idx=6">Payment 
                              Method</a></td>
                          </tr>
                          <%}%>
                          <%if(masterLocationPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/location.jsp?menu_idx=6">Location 
                              List </a></td>
                          </tr>
                          <%}%>
                          <%if(true){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/kecamatan.jsp?menu_idx=6">Kecamatan 
                              Area </a></td>
                          </tr>
                          <%}%>
                          <%if(true){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/desa.jsp?menu_idx=6">Desa 
                              Area </a></td>
                          </tr>
                          <%}%>
                          <%if(true){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/pekerjaan.jsp?menu_idx=6">Occupation 
                              List </a></td>
                          </tr>
                          <%}%>
                          <%if(false){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/dinas.jsp?menu_idx=6">Dinas</a></td>
                          </tr>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/general/dinasunit.jsp?menu_idx=6">Dinas 
                              Unit</a></td>
                          </tr>
                          <%}%>
                        </table>
                      </td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Fdms</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/fd/sharegroup.jsp?menu_idx=6">Share 
                              Group </a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/fd/sharecategory.jsp?menu_idx=6">Share 
                              Category </a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/fd/sharealloc.jsp?menu_idx=6">Share 
                              Allocation</a></td>
                          </tr>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/fd/expensecategory.jsp?menu_idx=6">Expense 
                              Category</a></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
              <tr id="closing1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('13')"> <a href="javascript:cmdChangeMenu('13')">Close 
                  Period </a></td>
              </tr>
              <tr id="closing2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"> 
                  Close Period</a></td>
              </tr>
              <tr id="closing"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <%if(closingPeriodPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/closing/periode.jsp?menu_idx=13"> 
                        <%if(!isYearlyClose){%>
                        Mohtly Closing 
                        <%}else{%>
                        Yearly Closing 
                        <%}%>
                        </a></td>
                    </tr>
                    <%}%>
                    <%if(closingYearlyPriv && 1==2){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/closing/yearlyclose.jsp?menu_idx=13">Yearly 
                        Closing </a></td>
                    </tr>
                    <%}%>
                    <%if(applyActivity && closingActPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/closing/activityclose.jsp?menu_idx=13">Activity 
                        Closing </a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <%}%>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <%if(adminPriv){%>
              <tr id="admin1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('12')"> <a href="javascript:cmdChangeMenu('12')">Administrator</a> 
                </td>
              </tr>
              <tr id="admin2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Administrator</a> 
                </td>
              </tr>
              <tr id="admin"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/system/sysprop.jsp?menu_idx=12">System 
                        Property</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/admin/userlist.jsp?menu_idx=12">User 
                        List</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/admin/grouplist.jsp?menu_idx=12">User 
                        Group </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <%}%>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
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
