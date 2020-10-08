
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
			<%}%>
		
			//-			
			//document.all.ar.style.display="none";			
			
			//document.all.pr.style.display="none";
			
								
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="none";
			document.all.anggota2.style.display="";
			document.all.anggotax.style.display="";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="none";
			document.all.pinjaman2.style.display="";
			document.all.pinjaman.style.display="";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="none";
			document.all.simpanan2.style.display="";
			document.all.simpanan.style.display="";
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
			<%if(1==2){//(purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv){%>
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
			
			<%if(anggotaKop){%>
			document.all.anggota1.style.display="";
			document.all.anggota2.style.display="none";
			document.all.anggotax.style.display="none";
			<%}%>
			
			<%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
			document.all.pinjaman1.style.display="";
			document.all.pinjaman2.style.display="none";
			document.all.pinjaman.style.display="none";
			<%}%>
			
			<%if(rekapPotonganGaji || bukutabungan){%>
			document.all.simpanan1.style.display="";
			document.all.simpanan2.style.display="none";
			document.all.simpanan.style.display="none";
			<%}%>
						
			break;	
	}
}

</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/imagessp/logo-finance2.jpg" width="216" height="32" /></td>
        </tr>
        <tr> 
          <td><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td style="padding-left:10px"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <%
					Periode periodeXXX = DbPeriode.getOpenPeriod();
					String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");        
				%>
                <td height="5"> 
                  
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="4"></td>
              </tr>
              <%if(cashRecPriv || cashPayPriv || cashRepPriv || cashLinkPriv || cashArcPriv){%>
              <tr id="cash1"> 
                <td class="menu0"" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Transaksi 
                  Kas </a></td>
              </tr>
              <tr id="cash2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Transaksi 
                  Kas </a></td>
              </tr>
              <tr id="cash"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <%if(cashRecUpdate){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/cashreceivedetail.jsp?menu_idx=1">Penerimaan 
                        Kas</a></td>
                    </tr>
                    <%}		
							if(cashPayUpdate || cashRefUpdate){
							%>
                    <tr> 
                      <td class="menu1">Kas Kecil</td>
                    </tr>
                    <%if(cashPayUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/pettycashpaymentdetail.jsp?menu_idx=1">Pembayaran</a></td>
                    </tr>
                    <%}%>
                    <%if(cashRefUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/pettycashreplenishment.jsp?menu_idx=1">Pengisian 
                        Kas Kecil</a></td>
                    </tr>
                    <%}
							}%>
                    <%if(cashArcPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/casharchive.jsp?menu_idx=1">Arsip</a></td>
                    </tr>
                    <%}%>
                    <%if(cashLinkPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/master/cashacclink.jsp?menu_idx=1">Daftar 
                        Akun Kas</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
			  <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              
              <%if(bankDepPriv || bankPOPriv || bankNonPriv || bankLinkPriv || bankArcPriv){%>
              <tr id="bank1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Transaksi 
                  Bank</a> </td>
              </tr>
              <tr id="bank2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Transaksi 
                  Bank</a> </td>
              </tr>
              <tr id="bank"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <%if(bankDepUpdate){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/bankdepositdetail.jsp?menu_idx=2">Penerimaan 
                        Bank </a></td>
                    </tr>
                    <%}%>
                    <%if(bankPOUpdate || bankNonpoUpdate){%>
                    <tr> 
                      <td class="menu1">Pembayaran</td>
                    </tr>
                    <%if(bankPOUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/bankpopaymentsrc.jsp?menu_idx=2">Pembayaran 
                        PO </a></td>
                    </tr>
                    <%}%>
                    <%if(bankNonpoUpdate){%>
                    <tr> 
                      <td class="menu2"><a href="<%=approot%>/transaction/banknonpopaymentdetail.jsp?menu_idx=2">Pembayaran 
                        Non PO</a></td>
                    </tr>
                    <%}%>
                    <%}%>
                    <%if(bankArcPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaction/bankarchive.jsp?menu_idx=2">Arsip</a></td>
                    </tr>
                    <%}%>
                    <%if(bankLinkPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/master/bankacclink.jsp?menu_idx=2">Daftar 
                        Akun Bank</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
			  <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              
              <%if(arCreate || arArchives || arCustomer){%>
              <tr id="ar1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('14')"><a href="javascript:cmdChangeMenu('14')">Piutang</a> 
                </td>
              </tr>
              <tr id="ar2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Piutang</a> 
                </td>
              </tr>
              <tr id="ar"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(arCreate){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">New Receivable</td>
                    </tr>
                    <%}
						if(arCustomer){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/customer.jsp?menu_idx=14">Customer</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    <%if(arArchives){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Archives</td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(payableInvPriv || payableArcPriv){%>
              <tr id="inv1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('11')"> <a href="javascript:cmdChangeMenu('11')">Hutang</a> 
                </td>
              </tr>
              <tr id="inv2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Hutang</a> 
                </td>
              </tr>
              <tr id="inv"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(payableInvPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/invoicesrc.jsp?menu_idx=11">New 
                        Invoice</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    <%if(payableArcPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/invoicearchive.jsp?menu_idx=11">Archives</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(depoList || newDepo || returDepo || sadloDepo || depoArchives){%>
              <tr id="titip1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('16')"> <a href="javascript:cmdChangeMenu('16')">Titipan 
                  Uang </a></td>
              </tr>
              <tr id="titip2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Titipan 
                  Uang </a></td>
              </tr>
              <tr id="titip"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(depoList){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/penitip.jsp?menu_idx=16">Penitip/Unit</a></td>
                    </tr>
                    <%}%>
                    <%if(newDepo){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/titipanbaru.jsp?menu_idx=16">Titipan 
                        Baru</a></td>
                    </tr>
                    <%}%>
                    <%if(returDepo){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/kembalikantitipan.jsp?menu_idx=16">Pengembalian 
                        Titipan</a></td>
                    </tr>
                    <%}%>
                    <%if(sadloDepo){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/saldotitipan.jsp?menu_idx=16">Saldo 
                        Titipan</a></td>
                    </tr>
                    <%}%>
                    <%if(depoArchives){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/titipanarchive.jsp?menu_idx=16">Arsip</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(akrualSetupPriv || akrualProcessPriv){%>
              <tr id="akrual1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('15')"> <a href="javascript:cmdChangeMenu('15')">Transaksi 
                  Akrual </a> </td>
              </tr>
              <tr id="akrual2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Transaksi 
                  Akrual</a> </td>
              </tr>
              <tr id="akrual"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(akrualSetupPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/akrualsetup.jsp?menu_idx=15">Setup 
                        Transaksi Akrual</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1">New Invoice</td>
						</tr-->
                    <%if(akrualProcessPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/akrualproses.jsp?menu_idx=15">Proses 
                        Transaksi Akrual</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/akrualarsip.jsp?menu_idx=15">Arsip</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
			  <%if(anggotaKop){%>
              <tr id="anggota1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('17')"> <a href="javascript:cmdChangeMenu('17')">Keanggotaan</a> 
                </td>
              </tr>
              <tr id="anggota2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Keanggotaan</a> 
                </td>
              </tr>
              <tr id="anggotax"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(anggotaKop){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/member/scrmember.jsp?menu_idx=17">Daftar 
                        Anggota</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/member/member.jsp?menu_idx=17">Anggota 
                        Baru</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank){%>
              <tr id="pinjaman1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('18')"> <a href="javascript:cmdChangeMenu('18')">Proses 
                  Pinjaman</a> </td>
              </tr>
              <tr id="pinjaman2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Proses 
                  Pinjaman</a> </td>
              </tr>
              <tr id="pinjaman"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(anggotaKop){%>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/general/bank.jsp?menu_idx=18">Daftar 
                        Bank</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Pinjaman Koperasi</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/pinjamankopbankanuitas.jsp?menu_idx=18">Pinjaman 
                        Baru</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/srcbayarpinjamankop.jsp?menu_idx=18">Angsuran</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/arsippinjamankopbank.jsp?menu_idx=18">Arsip</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Pinjaman Anggota</td>
                    </tr>
                    <%if(newPinjam){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2">Pinjaman Ke Koperasi</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu3"><a href="<%=approot%>/pinjaman/pinjaman.jsp?menu_idx=18">Pinjaman 
                        Baru</a></td>
                    </tr>
                    <%}%>
                    <%if(angsurPinjam){%>
                    <tr> 
                      <td height="18" width="90%" class="menu3"><a href="<%=approot%>/pinjaman/srcbayarpinjaman.jsp?menu_idx=18">Angsuran</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu3"><a href="<%=approot%>/pinjaman/arsippinjaman.jsp?menu_idx=18">Arsip</a></td>
                    </tr>
                    <%if(newPinjamBank){%>
                    <tr> 
                      <td height="18" width="90%" class="menu2">Pinjaman Bank</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu3"><a href="<%=approot%>/pinjaman/pinjamanbankselect.jsp?menu_idx=18">Pinjaman 
                        Baru</a></td>
                    </tr>
                    <%}%>
                    <%if(angsurPinjamBank){%>
                    <tr> 
                      <td height="18" width="90%" class="menu3"><a href="<%=approot%>/pinjaman/srcbayarpinjaman.jsp?menu_idx=18&src_type=1">Angsuran</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu3"><a href="<%=approot%>/pinjaman/arsippinjamanbank.jsp?menu_idx=18">Arsip</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Laporan</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/saldohutang.jsp?menu_idx=18">Saldo Hutang</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/pinjaman/saldopiutang.jsp?menu_idx=18">Saldo 
                        Piutang</a></td>
                    </tr>
                    <tr>
                      <td height="18" width="90%" class="menu1">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/pinjamanacclink.jsp?menu_idx=18">Daftar 
                        Akun Piutang</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/pinjamancostacclink.jsp?menu_idx=18">Daftar 
                        Akun Hutang</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
			  <%if(rekapPotonganGaji || bukutabungan){%>
              <tr id="simpanan1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('17')"> <a href="javascript:cmdChangeMenu('19')">Proses 
                  Simpanan</a> </td>
              </tr>
              <tr id="simpanan2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Proses 
                  Simpanan</a> </td>
              </tr>
              <tr id="simpanan"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/pinjaman/perioderekap.jsp?menu_idx=19">Periode 
                        Rekap</a></td>
                    </tr>
                    <%if(rekapPotonganGaji){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/pinjaman/rekappotongangaji.jsp?menu_idx=19">Rekap 
                        Potongan Gaji</a></td>
                    </tr>
                    <%}%>
                    <%if(bukutabungan){%> 
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/pinjaman/srcmember.jsp?menu_idx=19">Buku 
                        Simpanan</a></td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"> </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
			  
			  
              <%
			  if(1==2){
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
                      <td height="19" width="90%" class="menu1"><a href="<%=approot%>/transaction/purchaseitem.jsp?menu_idx=3">New 
                        Order </a></td>
                    </tr>
                    <%}%>
                    <%if(purchaseVndPriv){%>
                    <tr> 
                      <td height="19" width="90%" class="menu1"><a href="<%=approot%>/general/vendor.jsp?menu_idx=3">Vendor</a></td>
                    </tr>
                    <%}%>
                    <!--tr> 
						  <td height="18" width="90%" class="menu1"><a href="<%=approot%>/journal/ap-proto.jsp?menu_idx=3">New 
							Order Proto --</a></td>
						</tr-->
                    <%if(purchaseArcPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/transaction/purchasearchive.jsp?menu_idx=3">Archives</a></td>
                    </tr>
                    <%}%>
                    <%if(purchaseLinkPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/purchaseacclink.jsp?menu_idx=3">Purchase 
                        Acc. List</a> </td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td height="18" width="90%"></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}}%>
              <%if(glNewPriv || glArcPriv){%>
              <tr id="gl1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('9')"> <a href="javascript:cmdChangeMenu('9')">Jurnal 
                  Umum</a></td>
              </tr>
              <tr id="gl2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Jurnal 
                  Umum</a></td>
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
			  <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              
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
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(freportPriv){%>
              <tr id="frpt1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Laporan 
                  Keuangan</a></td>
              </tr>
              <tr id="frpt2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Laporan 
                  Keuangan</a
					></td>
              </tr>
              <tr id="frpt"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(freportPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/worksheet.jsp?menu_idx=4">Trial 
                        Balance</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/freport/glreport.jsp?menu_idx=4">General 
                        Ledger</a></td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Balance Sheet</td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsstandard.jsp?menu_idx=4">Standard</a></td>
                    </tr>
                    <tr> 
                      <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail.jsp?menu_idx=4">Detail</a></td>
                    </tr>
                    <!--tr> 
						  <td height="19" width="90%" class="menu2"><a href="<%=approot%>/freport/bsdetail.jsp?menu_idx=4">Detail</a></td>
						</tr-->
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
                      <td height="18" width="90%" class="menu2"><a href="<%=approot%>/freport/profitloss0.jsp?menu_idx=4">Departmental 
                        Base</a></td>
                    </tr>
                    <%if(sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_SECTION || sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_SUB_SECTION || 
						sysCompany.getDepartmentLevel()==DbDepartment.LEVEL_JOB){%>
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
                      <td height="18" width="90%" class="menu1">&nbsp;</td>
                    </tr>
                    <%}%>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
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
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
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
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(masterConfPriv || masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv || masterWorkPlanPriv || 
					   masterAllocationPriv || masterDonorPriv || masterActPeriodPriv || masterEmpPriv || masterDepartmentPriv ||
					   masterCountryPriv || masterCurrencyPriv || masterTopPriv || masterShipPriv || masterPayMetPriv || masterLocationPriv){%>
              <tr id="master1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('6')"> <a href="javascript:cmdChangeMenu('6')">Data 
                  Master </a></td>
              </tr>
              <tr id="master2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Data 
                  Master </a></td>
              </tr>
              <tr id="master"> 
                <td class="submenutd"> 
                  <table class="submenu" width="99%" cellpadding="0" cellspacing="0">
                    <%if(masterConfPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1"><a href="<%=approot%>/master/company.jsp?menu_idx=6">Konfigurasi 
                        System </a></td>
                    </tr>
                    <%}%>
                    <%if(masterCoaPriv || masterCatPriv || masterGroupPriv || masterBookPriv || masterPeriodPriv){%>
                    <tr> 
                      <td height="18" width="90%" class="menu1">Akunting</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterCoaPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/coa.jsp?menu_idx=6">Daftar 
                              Akun</a></td>
                          </tr>
                          <%}%>
                          <%if(masterCatPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coaexpensecategory.jsp?menu_idx=6">Kategori 
                              Akun</a></td>
                          </tr>
                          <%}%>
                          <%if(masterGroupPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/activity/coanatureexpensecategory.jsp?menu_idx=6">Akun 
                              Group Alias</a></td>
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
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/master/periode.jsp?menu_idx=6">Periode</a></td>
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
                      <td height="18" width="90%" class="menu1">Perusahaan</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterEmpPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/employee.jsp?menu_idx=6">Daftar 
                              Pegawai Sbg User</a></td>
                          </tr>
                          <%}%>
                          <%if(masterDepartmentPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/payroll/department.jsp?menu_idx=6">Departemen</a></td>
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
                      <td height="18" width="90%" class="menu1">Umum</td>
                    </tr>
                    <tr> 
                      <td height="18" width="90%"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <%if(masterCountryPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/country.jsp?menu_idx=6">Negara</a></td>
                          </tr>
                          <%}%>
                          <%if(masterCurrencyPriv){%>
                          <tr> 
                            <td width="80%" height="18" class="menu2"><a href="<%=approot%>/general/currency.jsp?menu_idx=6">Mata 
                              Uang </a></td>
                          </tr>
                          <%}%>
                          <!--tr> 
								<td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/itemtype.jsp?menu_idx=6">Item 
								  Type</a> </td>
							  </tr-->
                          <%if(masterTopPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/termofpayment.jsp?menu_idx=6">Term 
                              Pembayaran</a></td>
                          </tr>
                          <%}%>
                          <%if(masterShipPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/shipaddress.jsp?menu_idx=6">Alamat 
                              Pengiriman</a></td>
                          </tr>
                          <%}%>
                          <%if(masterPayMetPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/paymentmethod.jsp?menu_idx=6">Metode 
                              Pembayaran</a></td>
                          </tr>
                          <%}%>
                          <%if(masterLocationPriv){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/location.jsp?menu_idx=6">Lokasi</a></td>
                          </tr>
                          <%}%>
                          <%if(true){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/kecamatan.jsp?menu_idx=6">Kecamatan</a></td>
                          </tr>
                          <%}%>
                          <%if(true){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/desa.jsp?menu_idx=6">Desa</a></td>
                          </tr>
                          <%}%>
                          <%if(true){%>
                          <tr> 
                            <td height="18" width="90%" class="menu2"><a href="<%=approot%>/master/pekerjaan.jsp?menu_idx=6">Pekerjaan</a></td>
                          </tr>
                          <%}%>
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
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              <%if(closingPeriodPriv || closingYearlyPriv || closingActPriv){%>
              <tr id="closing1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('13')"> <a href="javascript:cmdChangeMenu('13')">Penutupan 
                  Periode </a></td>
              </tr>
              <tr id="closing2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"> 
                  Penutupan Periode</a></td>
              </tr>
              <tr id="closing"> 
                <td class="submenutd"> 
                  <table  class="submenu" width="99%" border="0" cellspacing="0" cellpadding="0">
                    <%if(closingPeriodPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/closing/periode.jsp?menu_idx=13"> 
                        <%if(!isYearlyClose){%>
                        Tutup Bulan 
                        <%}else{%>
                        Tutup Tahun 
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
			  <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
              
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
                      <td class="menu1"><a href="<%=approot%>/system/sysprop.jsp?menu_idx=12">Property 
                        System </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/admin/userlist.jsp?menu_idx=12">Daftar 
                        User</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/admin/grouplist.jsp?menu_idx=12">Daftar 
                        Group User</a></td>
                    </tr>
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
			  <tr> 
                <td class="menu0"><a href="<%=approot%>/logoutsp.jsp">Logout</a></td>
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
