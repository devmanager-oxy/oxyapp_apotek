
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
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesRetur || mSalReportSalesClosing || mSalReportSalesMonthly || mSalAccounting ||mSalReportByItem || mSalReportBeliPutus || mSalReportMargin || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalReporKomisi || mSalReporGA || mSalReporSetoran || mSalReporCreditCard || mSalReporTopSales || mSalBonus || mSalByStartDate || mSalVoidReport) {%> 
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";
            <%}%>                        
            <%if (mSalAccounting || mSalJurRetur || mSalEditor || mSalJournalCashBack) {%>
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
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesRetur || mSalReportSalesClosing || mSalReportSalesMonthly || mSalAccounting ||mSalReportByItem || mSalReportBeliPutus || mSalReportMargin || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalReporKomisi || mSalReporGA || mSalReporSetoran || mSalReporCreditCard || mSalReporTopSales || mSalBonus || mSalByStartDate || mSalVoidReport) {%> 
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";
            <%}%>                        
            <%if (mSalAccounting || mSalJurRetur || mSalEditor || mSalJournalCashBack) {%>
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
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesRetur || mSalReportSalesClosing || mSalReportSalesMonthly || mSalAccounting ||mSalReportByItem || mSalReportBeliPutus || mSalReportMargin || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalReporKomisi || mSalReporGA || mSalReporSetoran || mSalReporCreditCard || mSalReporTopSales || mSalBonus || mSalByStartDate || mSalVoidReport) {%> 
            document.all.laporan1.style.display="none";
            document.all.laporan2.style.display="";
            document.all.laporan.style.display="";			
            <%}%>                        
            <%if (mSalAccounting || mSalJurRetur || mSalEditor || mSalJournalCashBack) {%> 
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
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesRetur || mSalReportSalesClosing || mSalReportSalesMonthly || mSalAccounting ||mSalReportByItem || mSalReportBeliPutus || mSalReportMargin || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalReporKomisi || mSalReporGA || mSalReporSetoran || mSalReporCreditCard || mSalReporTopSales || mSalBonus || mSalByStartDate || mSalVoidReport) {%>  
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";			
            <%}%>                        
            <%if (mSalAccounting || mSalJurRetur || mSalEditor || mSalJournalCashBack) {%> 
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
            <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesRetur || mSalReportSalesClosing || mSalReportSalesMonthly || mSalAccounting ||mSalReportByItem || mSalReportBeliPutus || mSalReportMargin || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalReporKomisi || mSalReporGA || mSalReporSetoran || mSalReporCreditCard || mSalReporTopSales || mSalBonus || mSalByStartDate || mSalVoidReport) {%> 
            document.all.laporan1.style.display="";
            document.all.laporan2.style.display="none";
            document.all.laporan.style.display="none";
            <%}%>                        
            <%if (mSalAccounting || mSalJurRetur || mSalEditor || mSalJournalCashBack) {%>
            document.all.acc1.style.display="";
            document.all.acc2.style.display="none";
            document.all.acc.style.display="none";
            <%}%>                         
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
                <%if ((mSalUploadSales || mSalOpening || mSalNewSales || mSalNewArchives || mSalCreditPayment || mSalClosing)) {%>
                <tr id="sales1"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Sales</a></td>
                </tr>
                <tr id="sales2"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Sales</a><a href="javascript:cmdChangeMenu('0')"></a></td>
                </tr>
                <tr id="sales"> 
                    <td class="submenutd"> 
                        <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                            <%if (mSalUploadSales) {%>  
                            <tr>
                                <td class="menu1"><a href="<%=approot%>/datasync/upload.jsp?menu_idx=1">Upload sales</a></td>
                            </tr>   
                            <%}%>  
                            <%if (mSalOpening) {%>  
                            <tr>
                                <td class="menu1"><a href="<%=approot%>/sales/opening.jsp?menu_idx=1">Opening</a></td>
                            </tr>  
                            <%}%>
                            <%if (mSalNewSales) {%> 
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/sales.jsp?menu_idx=1&command=<%=JSPCommand.ADD%>">New Sales</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalNewArchives) {%> 
                            <tr>
                                <td class="menu1"><a href="<%=approot%>/sales/saleslist.jsp?menu_idx=1">Archives</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalCreditPayment) {%>
                            <tr>
                                <td class="menu1"><a href="<%=approot%>/sales/saleslistCredit.jsp?menu_idx=1">Credit Payment</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalClosing) {%>
                            <tr>
                                <td class="menu1"><a href="<%=approot%>/sales/closing.jsp?menu_idx=1">Closing</a></td>
                            </tr>     
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
                
                <%if (mSalReport || mSalReportLocation || mSalReportCashier || mSalReportMember || mSalCreditPaymentReport || mSalReportSalesCanceled || mSalReportSalesRetur || mSalReportSalesClosing || mSalReportSalesMonthly || mSalAccounting ||mSalReportByItem || mSalReportBeliPutus || mSalReportMargin || mSalByStartDate || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalReporKomisi || mSalReporGA || mSalReporSetoran || mSalReporCreditCard || mSalReporTopSales || mSalBonus || mSalVoidReport) {%> 
                <tr id="laporan1"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')">Report</a></td>
                </tr>
                <tr id="laporan2"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Report</a></td>
                </tr>
                <tr id="laporan"> 
                    <td class="submenutd"> 
                        <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                            <%if (mSalReportLocation || mSalReportSalesCategory || mSalReportByItem || mSalReportCashier || mSalReportMember || mSalReporGA || mSalReporKomisi || mSalReportBeliPutus || mSalReportMargin || mSalReportCogsSection || mSalReportGolPrice || mSalReportPromotion || mSalReporBySuplier || mSalReporSlowFast || mSalByStartDate || mSalVoidReport) {%> 
                            <tr> 
                                <td class="menu1"><B>Sales Report</B></td>
                            </tr>                            
                            <%if (mSalReportLocation) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/<%=reportFolder%>/rptsalesByLocation.jsp?target_page=1&menu_idx=3">Report By Location </a></td>
                            </tr>
                            <%}%>
                            <%if(mSalReportSalesCategory){%>
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalesbycategory.jsp?target_page=1&menu_idx=3">Report By Category</a></td>
                            </tr>
                            <%}%>
                            <%if(mSalReportByItem){%>
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptSalesByItem.jsp?target_page=1&menu_idx=3">Report By Item</a></td>
                            </tr>
                            <%}%>
                            <%if(mSalVoidReport){ %>
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptvoidsales.jsp?target_page=1&menu_idx=3">Report Void Sales</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReportCashier) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalesCashier.jsp?target_page=1&menu_idx=3">Report Cashier </a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReportMember) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalesbymember.jsp?target_page=1&menu_idx=3">Report By Member</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReporGA) {%>
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/reportsales_ga.jsp?target_page=1&menu_idx=3">Report General Affair</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReporKomisi) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptkomisi.jsp?target_page=1&menu_idx=3">Report Komisi</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReportBeliPutus) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptbeliputus.jsp?target_page=1&menu_idx=3">Report Beli Putus</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReportMargin) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalesmargin.jsp?target_page=1&menu_idx=3">Report Sales Margin</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalByStartDate) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/reportsalesbystartdate.jsp?target_page=1&menu_idx=3">Report Sales (Start Date)</a></td>
                            </tr>
                            <%}%>
                            
                            <%if (mSalReportCogsSection) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptcogssection.jsp?target_page=1&menu_idx=3">Report Cogs by section</a></td>
                            </tr>	
                            <%}%>
                            <%if (mSalReportGolPrice) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalesbygolprice.jsp?target_page=1&menu_idx=3">Report Sales By Gol Price</a></td>
                            </tr>	
                            <%}%>
                            <%if (mSalReportPromotion) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalespromotionbygolprice.jsp?target_page=1&menu_idx=3">Report Sales Promotion </a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReporBySuplier) {%>  
                            <tr>  
                                <td class="menu2"><a href="<%=approot%>/sales/rptsalesbyvendor.jsp?target_page=1&menu_idx=3">Report Sales By Supplier</a></td>
                            </tr>	
                            <%}%>
                            <%if (mSalReporSlowFast) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptSalesSlowFastItem.jsp?target_page=1&menu_idx=3">Report Slow/Fast Moving</a></td>
                            </tr>
                            <%}%>                            
                            <%}%>
                            <%if (mSalReportKonsinyasiBeli || mSalReportKonsinyasiJual) {%>  
                            <tr> 
                                <td class="menu1"><B>Consigned Report</B></td>
                            </tr>
                            <%if (mSalReportKonsinyasiBeli) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptconsignedbycost.jsp?target_page=1&menu_idx=3">Consigned By Cost</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReportKonsinyasiJual) {%>  
                            <tr> 
                                <td class="menu2"><a href="<%=approot%>/sales/rptconsignbysellingvalue.jsp?target_page=1&menu_idx=3">Consigned By Price</a></td>
                            </tr>
                            <%}%>
                            <%}%>
                            <%if (mSalCreditPaymentReport) {%>  
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/rptSalesCredit.jsp?target_page=1&menu_idx=3">Credit Payment Report </a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReportSalesRetur) {%>
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
                            <%if (mSalReporSetoran) {%>
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/rptselisihsetoran.jsp?target_page=1&menu_idx=3">Setoran Cashier</a></td>
                            </tr>
                            <%}%>
                            <%if (mSalReporCreditCard) {%>
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/reportcreditcard.jsp?target_page=1&menu_idx=3">Credit Card</a></td>
                            </tr>
                            <%}%>                            
                            <%if (mSalReporTopSales) {%>
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/closing/rptsalestop.jsp?target_page=1&menu_idx=3">Top 10 Sales Report</a></td>
                            </tr>		
                            <%}%>
                            <%if (mSalBonus) {%>
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/salesbonus.jsp?target_page=1&menu_idx=3">Sales Bonus</a></td>
                            </tr>		
                            <%}%>
                            <%if (mSalAccounting) {%>
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/needposting.jsp?target_page=1&menu_idx=3">Posting Report</a></td>
                            </tr>
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
                <%if (mSalAccounting || mSalJurRetur || mSalEditor || mSalJournalCashBack) {%>
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
                            <%}%>
                            <%if (mSalJurRetur) {%>  
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/paymentcreditlist.jsp?menu_idx=4">Credit Payment</a></td>
                            </tr>
                            <%}%>        
                            <%if (mSalJournalCashBack) {%>  
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/journalmemberpoint.jsp?menu_idx=4">Process Cash Back</a></td>
                            </tr>
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
                
                <%if (mSalMaster) {%>
                <tr id="masterdata1"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Master Data</a></td>
                </tr>
                <tr id="masterdata2"> 
                    <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')">Master Data</a></td>
                </tr>
                <tr id="masterdata"> 
                    <td class="submenutd"> 
                        <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                            <%if (mSalMaster) {%>
                            <tr> 
                                <td class="menu1"><a href="<%=approot%>/sales/itemlist.jsp?target_page=1&menu_idx=2">Sales Item</a></td>
                            </tr>
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
                    <td class="menu0"><a href="<%=approot%>/logoutsl.jsp">Logout</a></td>
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

<script language="JavaScript">
    cmdChangeMenu('<%=menuIdx%>');
        </script>