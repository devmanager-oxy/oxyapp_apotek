
<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
%>
<script language="JavaScript">
    
    function cmdChangeMenu(idx){
        var x = idx;
        
        switch(parseInt(idx)){
            
            case 1 : 
            <%if (mSalUploadSales || mSalOpening || mSalNewSales || mSalNewArchives || mSalCreditPayment || mSalClosing) {%>
            document.all.sales1.style.display="none";                            
            document.all.sales2.style.display="";
            document.all.sales.style.display="";
            <%}%>                         
            <%if (mSalMaster) {%>
            document.all.masterdata1.style.display="";
            document.all.masterdata2.style.display="none";
            document.all.masterdata.style.display="none";
            <%}%>                         
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesClosing) {%> 
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";
            <%}%>                        
            <%if (mSalAccounting) {%>
            document.all.acc1.style.display="";
            document.all.acc2.style.display="none";
            document.all.acc.style.display="none";
            <%}%>                         
            break;	
            
            case 2 : 
            <%if (mSalUploadSales || mSalOpening || mSalNewSales || mSalNewArchives || mSalCreditPayment || mSalClosing) {%>
            document.all.sales1.style.display="";
            document.all.sales2.style.display="none";
            document.all.sales.style.display="none";
            <%}%>                         
            <%if (mSalMaster) {%>
            document.all.masterdata1.style.display="none";
            document.all.masterdata2.style.display="";
            document.all.masterdata.style.display="";
            <%}%>                        
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesClosing) {%> 
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";
            <%}%>                        
            <%if (mSalAccounting) {%>
            document.all.acc1.style.display="";
            document.all.acc2.style.display="none";
            document.all.acc.style.display="none";
            <%}%>				
            break;
            
            case 3 : 
            <%if (mSalUploadSales || mSalOpening || mSalNewSales || mSalNewArchives || mSalCreditPayment || mSalClosing) {%>
            document.all.sales1.style.display="";
            document.all.sales2.style.display="none";
            document.all.sales.style.display="none";
            <%}%>                         
            <%if (mSalMaster) {%>
            document.all.masterdata1.style.display="";
            document.all.masterdata2.style.display="none";
            document.all.masterdata.style.display="none";
            <%}%>                        
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesClosing) {%> 
            document.all.laporan1.style.display="none";
            document.all.laporan2.style.display="";
            document.all.laporan.style.display="";			
            <%}%>                        
            <%if (mSalAccounting) {%> 
            document.all.acc1.style.display="";
            document.all.acc2.style.display="none";
            document.all.acc.style.display="none";
            <%}%>				
            break;		
            
            case 4 : 
            <%if (mSalUploadSales || mSalOpening || mSalNewSales || mSalNewArchives || mSalCreditPayment || mSalClosing) {%>
            document.all.sales1.style.display="";
            document.all.sales2.style.display="none";
            document.all.sales.style.display="none";
            <%}%>                         
            <%if (mSalMaster) {%>
            document.all.masterdata1.style.display="";
            document.all.masterdata2.style.display="none";
            document.all.masterdata.style.display="none";
            <%}%>                         
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesClosing) {%>  
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";			
            <%}%>                        
            <%if (mSalAccounting) {%> 
            document.all.acc1.style.display="none";
            document.all.acc2.style.display="";
            document.all.acc.style.display="";
            <%}%>				
            break;
            
            case 0 :
            <%if (mSalUploadSales || mSalOpening || mSalNewSales || mSalNewArchives || mSalCreditPayment || mSalClosing) {%>
            document.all.sales1.style.display="";
            document.all.sales2.style.display="none";
            document.all.sales.style.display="none";
            <%}%>                         
            <%if (mSalMaster) {%>
            document.all.masterdata1.style.display="";
            document.all.masterdata2.style.display="none";
            document.all.masterdata.style.display="none";
            <%}%>                        
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesClosing) {%> 
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";
            <%}%>                        
            <%if (mSalAccounting) {%>
            document.all.acc1.style.display="";
            document.all.acc2.style.display="none";
            document.all.acc.style.display="none";
            <%}%>                         
            break;				
        }
    }
    
    </script>
<table width="180" border="0" cellspacing="1" cellpadding="0" height="100%">
    <tr> 
        <td style="border-right:1px solid #A3B78E" bgcolor="AFB8D9" valign="top" align="left" >            
            <table border="0" cellspacing="0" cellpadding="0" width="180">
                <tr> 
                    <td valign="top" height="10">&nbsp;</td>
                </tr>                
                <tr> 
                    <td valign="top" height="1"> 
                        <table border="0" cellspacing="0" cellpadding="0" width="190">
                            <tr> 
                                <td><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="1" /></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                            </tr>   
                            <tr > 
                                <td class="menu0" > <a href="<%=approot%>/homesl.jsp">Home</a></td>
                            </tr>
                            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesClosing) {%> 
                            <tr id="laporan1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')">Report</a></td>
                            </tr>
                            <tr id="laporan2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Report</a></td>
                            </tr>
                            <tr id="laporan"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport) {%> 
                                        <tr > 
                                            <td height="26" class="menu2"><B>&nbsp;&nbsp;Sales Report</B></td>
                                        </tr>    
                                        <tr >
                                            <td> 
                                                <table width="80%" border="0" cellspacing="0" cellpadding="0" style="padding-left:10px;">  
                                                    <%if (mSalReportLocation) {%>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptsalesByLocation.jsp?target_page=1&menu_idx=3">Report By Location</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptsalesbycategory.jsp?target_page=1&menu_idx=3">Report By Category</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptSalesByItem.jsp?target_page=1&menu_idx=3">Report By Item</a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if (mSalReportCashier) {%>  
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptsalesCashier.jsp?target_page=1&menu_idx=3">Report Cashier </a></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if (mSalReportMember) {%>  
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptsalesbymember.jsp?target_page=1&menu_idx=3">Report By Member</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptkomisi.jsp?target_page=1&menu_idx=3">Report Komisi</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptbeliputus.jsp?target_page=1&menu_idx=3">Report Beli Putus</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptsalesmargin.jsp?target_page=1&menu_idx=3">Report Sales Margin</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptSalesSlowFastItem.jsp?target_page=1&menu_idx=3">Slow/Fast Moving</a></td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1" height="26"><B>&nbsp;&nbsp;Consigned Report</B></td>
                                        </tr>
                                        <tr > 
                                            <td> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:10px;">
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptconsignedbycost.jsp?target_page=1&menu_idx=3">Consigned By Cost</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="menu3"><a href="<%=approot%>/sales/rptconsignbysellingvalue.jsp?target_page=1&menu_idx=3">Consigned By Price</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (mSalCreditPaymentReport) {%>  
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/rptSalesCredit.jsp?target_page=1&menu_idx=3">Credit Payment Report </a></td>
                                        </tr>
                                        <%}%>
                                        <%if (mSalReportSalesCanceled) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/rptsalesRetur.jsp?target_page=1&menu_idx=3">Retur Sales</a></td>
                                        </tr>
                                        <%}%>                   
                                        <%if (mSalReportSalesCanceled) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/rptsalescancel.jsp?target_page=1&menu_idx=3">Sales Canceled</a></td>
                                        </tr>
                                        <%}%>
                                        <%if (mSalReportSalesClosing) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/closing/rptsalesclosing.jsp?target_page=1&menu_idx=3">Closing Sales Report</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/closing/rptsalessummaryclosing.jsp?target_page=1&menu_idx=3">Closing Summary Report</a></td>
                                        </tr>                    
                                        <%}%>
                                        <%if (mSalReportSalesCanceled) {%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/closing/rptsalessummary.jsp?target_page=1&menu_idx=3">Sales Summary</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/closing/rptsalestop.jsp?target_page=1&menu_idx=3">Top 10 Sales Report</a></td>
                                        </tr>		
                                        <%}%>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/topsalesbyuser.jsp?target_page=1&menu_idx=3">Top User Sales Report</a></td>
                                        </tr>
                                        <%if (mSalAccounting) {%>
                                        
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/needposting.jsp?target_page=1&menu_idx=3">Posting Report</a></td>
                                        </tr>
                                        <%}%>                                                                              
                                    </table>
                                </td>
                            </tr>
                            <%}%>              
                            <%if (mSalAccounting) {%>
                            <tr id="acc1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Accounting</a></td>
                            </tr>
                            <tr id="acc2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Accounting</a></td>
                            </tr>
                            <tr id="acc"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <%if (mSalAccounting) {%>  
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/jurnalsales.jsp?target_page=1&menu_idx=4">Process Journal</a></td>
                                        </tr>			
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/paymentcreditlist.jsp?menu_idx=4">Credit Payment</a></td>
                                        </tr>
                                        <%}%>                                                            
                                    </table>
                                </td>
                            </tr>                
                            <%}%>
                            <tr> 
                                <td class="menu0"><a href="<%=approot%>/logoutsl.jsp">Logout</a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/imagessl/spacer.gif" width="1" height="2"></td>
                            </tr>                
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>   
</table>

<script language="JavaScript">
    cmdChangeMenu('<%=menuIdx%>');
        </script>