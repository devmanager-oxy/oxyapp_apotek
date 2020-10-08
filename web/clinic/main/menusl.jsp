
<%
menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
//out.println(idx1);
%>
<script language="JavaScript">         

function cmdChangeMenu(idx){   
	var x = idx;
	
	//document.frm_data.menu_idx.value=idx;  
	
	switch(parseInt(idx)){
	
		case 1 :  
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%> 
			document.all.sales1.style.display="none";
			document.all.sales2.style.display="";
			document.all.sales.style.display="";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.masterdata1.style.display="";
			document.all.masterdata2.style.display="none";
			document.all.masterdata.style.display="none";
			<%}%>
		    //document.all.laporan1.style.display="";
			//document.all.laporan2.style.display="none";
			//document.all.laporan.style.display="none";
			
			document.all.acc1.style.display="";
			document.all.acc2.style.display="none";
			document.all.acc.style.display="none";
								
			break;	

		case 2 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.sales1.style.display="";
			document.all.sales2.style.display="none";
			document.all.sales.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.masterdata1.style.display="none";
			document.all.masterdata2.style.display="";
			document.all.masterdata.style.display="";
			<%}%>
			//document.all.laporan1.style.display="";
			//document.all.laporan2.style.display="none";
			//document.all.laporan.style.display="none";
			
			document.all.acc1.style.display="";
			document.all.acc2.style.display="none";
			document.all.acc.style.display="none";
		    					
			break;
		
		case 3 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.sales1.style.display="";
			document.all.sales2.style.display="none";
			document.all.sales.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.masterdata1.style.display="";
			document.all.masterdata2.style.display="none";
			document.all.masterdata.style.display="none";
			<%}%>
			//document.all.laporan1.style.display="none";
			//document.all.laporan2.style.display="";
			//document.all.laporan.style.display="";
			
			document.all.acc1.style.display="";
			document.all.acc2.style.display="none";
			document.all.acc.style.display="none";
		    					
			break;		
		
		case 4 : 
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.sales1.style.display="";
			document.all.sales2.style.display="none";
			document.all.sales.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.masterdata1.style.display="";
			document.all.masterdata2.style.display="none";
			document.all.masterdata.style.display="none";
			<%}%>
			//document.all.laporan1.style.display="";
			//document.all.laporan2.style.display="none";
			//document.all.laporan.style.display="none";
			
			document.all.acc1.style.display="none";
			document.all.acc2.style.display="";
			document.all.acc.style.display="";
		    					
			break;
		
		case 0 :
			<%if(pRequestPriv || pOrderPriv || pArcPriv){%>
			document.all.sales1.style.display="";
			document.all.sales2.style.display="none";
			document.all.sales.style.display="none";
			<%}%>
			<%if(iReceiptPriv || iArcPriv){%>
			document.all.masterdata1.style.display="";
			document.all.masterdata2.style.display="none";
			document.all.masterdata.style.display="none";
			<%}%>
			//document.all.laporan1.style.display="";
			//document.all.laporan2.style.display="none";
			//document.all.laporan.style.display="none";
			
			document.all.acc1.style.display="";
			document.all.acc2.style.display="none";
			document.all.acc.style.display="none";
		   					
			break;
				
	}
}

</script>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td valign="top" style="background:url(<%=approot%>/imagessl/leftmenu-bg.gif) repeat-y"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td valign="top" height="32"><img src="<%=approot%>/imagessl/logo-finance2.jpg" width="216" height="32" /></td>
        </tr>
        <tr> 
          <td><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td style="padding-left:10px" valign="top" height="1"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="1" /></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <!--tr> 
                <td height="49" valign="top"> 
                  <div align="center"> Operator : <%=appSessUser.getLoginId()%><br>
                    <a href="<%=approot%>/updatepwd.jsp?menu_idx=0">[ 
                    update password ]</a></div>
                </td>
              </tr-->
              <%if(pRequestPriv || pOrderPriv || pArcPriv){%>
              <tr id="sales1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Reservasi</a></td>
              </tr>
              <tr id="sales2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Reservasi</a><a href="javascript:cmdChangeMenu('0')"></a></td>
              </tr>
              <tr id="sales"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaksi/reservation.jsp?menu_idx=1">Reservasi 
                        </a></td>
                    </tr>
                    <tr>
                      <td class="menu1">Registrasi</td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaksi/reservationupdate.jsp?menu_idx=1">Ubah 
                        Status</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
			  
			  <tr id="acc1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Pasien</a></td>
              </tr>
              <tr id="acc2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('4')">Pasien</a></td>
              </tr>
              <tr id="acc"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaksi/patienthome.jsp?menu_idx=4">Data 
                        Pasien</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/transaksi/medicalrecord.jsp?target_page=1&menu_idx=4">Rekam 
                        Medik </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1">Test Lab</td>
                    </tr>
                    <tr> 
                      <td class="menu1">Photo XRay/Rotgen</td>
                    </tr>
                    <!--tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/billingtype.jsp?target_page=2&menu_idx=2">Outlet</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/itemoutletsetup.jsp?target_page=3&menu_idx=2">Item 
                        Outlet Setup</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/installationbudgettype.jsp?target_page=3&menu_idx=2">Cashier 
                        Shift </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/installationexpensetype.jsp?target_page=3&menu_idx=2">Cashier</a></td>
                    </tr-->
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="2"></td>
              </tr>
              <%if(iReceiptPriv || iArcPriv){%>
              <tr id="masterdata1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Master 
                  Data </a></td>
              </tr>
              <tr id="masterdata2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Master 
                  Data </a></td>
              </tr>
              <tr id="masterdata"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <%if(true){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/master/deseas.jsp?target_page=1&menu_idx=2">Penyakit</a></td>
                    </tr>
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/master/insurance.jsp?target_page=1&menu_idx=2">Asuransi</a></td>
                    </tr>
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/master/insurancerelation.jsp?target_page=1&menu_idx=2">Relasi 
                        Asuransi</a></td>
                    </tr>
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/master/diagnosis.jsp?target_page=1&menu_idx=2">Daftar 
                        Diagnosa </a></td>
                    </tr>   
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/master/doctor.jsp?target_page=1&menu_idx=2">Dokter 
                        &amp; Staff</a></td>
                    </tr>
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/master/testlab.jsp?target_page=1&menu_idx=2">Daftar 
                        Test Lab </a></td>
                    </tr>
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/master/specialty.jsp?target_page=1&menu_idx=2">Spesialisasi 
                        Dokter </a></td>
                    </tr>
                    <!--tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/billingtype.jsp?target_page=2&menu_idx=2">Outlet</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/itemoutletsetup.jsp?target_page=3&menu_idx=2">Item 
                        Outlet Setup</a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/installationbudgettype.jsp?target_page=3&menu_idx=2">Cashier 
                        Shift </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/project/installationexpensetype.jsp?target_page=3&menu_idx=2">Cashier</a></td>
                    </tr-->
                    <%}%>
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="2"></td>
              </tr>
              <%}%>
			  <tr> 
                <td class="menu0"><a href="<%=approot%>/logoutls.jsp">Logout</a></td>
              </tr>
			  <tr> 
                <td ><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="100%">&nbsp;</td>
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
