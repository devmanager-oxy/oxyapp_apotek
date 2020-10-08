
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
		    document.all.laporan1.style.display="";
			document.all.laporan2.style.display="none";
			document.all.laporan.style.display="none";
			
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
			document.all.laporan1.style.display="";
			document.all.laporan2.style.display="none";
			document.all.laporan.style.display="none";
			
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
			document.all.laporan1.style.display="none";
			document.all.laporan2.style.display="";
			document.all.laporan.style.display="";
			
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
			document.all.laporan1.style.display="";
			document.all.laporan2.style.display="none";
			document.all.laporan.style.display="none";
			
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
			document.all.laporan1.style.display="";
			document.all.laporan2.style.display="none";
			document.all.laporan.style.display="none";
			
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
                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Sales</a></td>
              </tr>
              <tr id="sales2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Sales</a><a href="javascript:cmdChangeMenu('0')"></a></td>
              </tr>
              <tr id="sales"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr>
                      <td class="menu1"><a href="<%=approot%>/datasync/upload.jsp?menu_idx=1">Upload sales</a></td>
                    </tr>   
                    <tr>
                      <td class="menu1"><a href="<%=approot%>/sales/opening.jsp?menu_idx=1">Opening</a></td>
                    </tr>  
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/sales.jsp?menu_idx=1&command=<%=JSPCommand.ADD%>">New 
                        Sales</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=approot%>/sales/saleslist.jsp?menu_idx=1">Archives</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=approot%>/sales/saleslistCredit.jsp?menu_idx=1">Credit Payment</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=approot%>/sales/closing.jsp?menu_idx=1">Closing</a></td>
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
			  <tr id="laporan1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')">Report</a></td>
              </tr>
              <tr id="laporan2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Report</a></td>
              </tr>
              <tr id="laporan"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/rptsales.jsp?target_page=1&menu_idx=3">Sales 
                        Report </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/rptsalesByLocation.jsp?target_page=1&menu_idx=3">Sales 
                        Report By Location </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/rptsalesCashier.jsp?target_page=1&menu_idx=3">Sales 
                        Report Cashier </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/rptSalesByMember.jsp?target_page=1&menu_idx=3">Sales
                        Report By Member </a></td>
                    </tr>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/rptSalesCredit.jsp?target_page=1&menu_idx=3">Credit
                        Payment Report </a></td>
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
			  <tr id="acc1"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Accounting</a></td>
              </tr>
              <tr id="acc2"> 
                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Accounting</a></td>
              </tr>
              <tr id="acc"> 
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/jurnalsales.jsp?target_page=1&menu_idx=4">Process 
                        Journal </a></td>
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
                    <%if(iReceiptPriv){%>
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/sales/itemlist.jsp?target_page=1&menu_idx=2">Sales 
                        Item </a></td>
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
