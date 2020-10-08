
<%-- 
    Document   : menuconsigment
    Created on : Dec 1, 2011, 11:13:16 AM
    Author     : Roy Andika
--%>

<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
%>
<script language="JavaScript">
    
    function cmdChangeMenu(idx){
        var x = idx;
        
        switch(parseInt(idx)){ 
            
            case 1 :             
                document.all.incominggoods1.style.display="none";
                document.all.incominggoods2.style.display="";
                document.all.incominggoods.style.display="";
                
                document.all.stockmanagement1.style.display="";
                document.all.stockmanagement2.style.display="none";
                document.all.stockmanagement.style.display="none";
                
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                
                document.all.sales1.style.display="";
                document.all.sales2.style.display="none";
                document.all.sales.style.display="none";
                
                document.all.masterItem1.style.display="";
                document.all.masterItem2.style.display="none";
                document.all.masterItem.style.display="none";
                break;	
                
            case 2 :             
                document.all.incominggoods1.style.display="";
                document.all.incominggoods2.style.display="none";
                document.all.incominggoods.style.display="none";
                
                document.all.stockmanagement1.style.display="none";
                document.all.stockmanagement2.style.display="";
                document.all.stockmanagement.style.display="";
                
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                
                document.all.sales1.style.display="";
                document.all.sales2.style.display="none";
                document.all.sales.style.display="none";
                
                document.all.masterItem1.style.display="";
                document.all.masterItem2.style.display="none";
                document.all.masterItem.style.display="none";
                break;	    
            
            case 3 :             
                document.all.incominggoods1.style.display="";
                document.all.incominggoods2.style.display="none";
                document.all.incominggoods.style.display="none";
                
                document.all.stockmanagement1.style.display="";
                document.all.stockmanagement2.style.display="none";
                document.all.stockmanagement.style.display="none";
                
                document.all.report1.style.display="none";
                document.all.report2.style.display="";
                document.all.report.style.display="";
                
                document.all.sales1.style.display="";
                document.all.sales2.style.display="none";
                document.all.sales.style.display="none";
                
                document.all.masterItem1.style.display="";
                document.all.masterItem2.style.display="none";
                document.all.masterItem.style.display="none";
                break;	    
            case 4 :             
                document.all.incominggoods1.style.display="";
                document.all.incominggoods2.style.display="none";
                document.all.incominggoods.style.display="none";
                
                document.all.stockmanagement1.style.display="";
                document.all.stockmanagement2.style.display="none";
                document.all.stockmanagement.style.display="none";
                
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                
                document.all.sales1.style.display="none";
                document.all.sales2.style.display="";
                document.all.sales.style.display="";
                
                document.all.masterItem1.style.display="";
                document.all.masterItem2.style.display="none";
                document.all.masterItem.style.display="none";
                break;	
            case 5 :             
                document.all.incominggoods1.style.display="";
                document.all.incominggoods2.style.display="none";
                document.all.incominggoods.style.display="none";
                
                document.all.stockmanagement1.style.display="";
                document.all.stockmanagement2.style.display="none";
                document.all.stockmanagement.style.display="none";
                
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                
                document.all.sales1.style.display="";
                document.all.sales2.style.display="none";
                document.all.sales.style.display="none";
                
                document.all.masterItem1.style.display="none";
                document.all.masterItem2.style.display="";
                document.all.masterItem.style.display="";
                break;	
            case 0 :
                document.all.incominggoods1.style.display="";
                document.all.incominggoods2.style.display="none";
                document.all.incominggoods.style.display="none";
                
                document.all.stockmanagement1.style.display="";
                document.all.stockmanagement2.style.display="none";
                document.all.stockmanagement.style.display="none";
                
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                
                document.all.sales1.style.display="";
                document.all.sales2.style.display="none";
                document.all.sales.style.display="none";
                
                document.all.masterItem1.style.display="";
                document.all.masterItem2.style.display="none";
                document.all.masterItem.style.display="none";
                break;
            
        }
    }
    
    </script>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td valign="top" height="32"><img src="<%=approot%>/images/logo-finance2.jpg" width="216" height="32" /></td>
                </tr>
                <tr> 
                    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
                </tr>
                <tr> 
                    <td style="padding-left:10px" valign="top" height="1"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td><img src="<%=approot%>/images/spacer.gif" width="1" height="1" /></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;</td>
                            </tr>
                            <tr id="incominggoods1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"> <a href="javascript:cmdChangeMenu('1')">Incoming Goods</a></td>
                            </tr>
                            <tr id="incominggoods2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Incoming Goods</span></a></td>
                            </tr>
                            <tr id="incominggoods"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/receiveItemConsigment.jsp?menu_idx=1">Direct Incoming</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/receivelistConsigment.jsp?menu_idx=1">Incoming Archieves</a></td>
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
                            <tr id="stockmanagement1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"> <a href="javascript:cmdChangeMenu('2')">Stock Management</a></td>
                            </tr>
                            <tr id="stockmanagement2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Stock Management</span></a></td>
                            </tr>
                            <tr id="stockmanagement"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/transferItemConsigment.jsp?menu_idx=2">Transfer</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/adjusmentlistConsigment.jsp?menu_idx=2">Adjustment</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/postransaction/opnamelistConsigment.jsp?menu_idx=2">Opname</a></td>
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
                            <tr id="report1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')">Report</a></td>
                            </tr>
                            <tr id="report2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Report</span></a></td>
                            </tr>
                            <tr id="report"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/rptsalesConsigment.jsp?menu_idx=3">Sales Report</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/posreport/stock-card-consigment.jsp?menu_idx=3">Stock Card</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1">Item Transfer</td>
                                        </tr>
                                        <tr id="report3"
                                            <td class ="submenutd">
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/treport-locationConsigment.jsp?menu_idx=3">By Location</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/treport-categoryConsigment.jsp?menu_idx=3">By Item Category</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/treport-subcategoryConsigment.jsp?menu_idx=3">By Item Sub Category</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/treport-itemmasterConsigment.jsp?menu_idx=3">By Item</a></td>
                                                </tr>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1">Stock Report</td>
                                        </tr>
                                        <tr id="report4"
                                            <td class ="submenutd">
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/stock-location-consigment.jsp?menu_idx=3">By Location</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/stock-categoryConsigment.jsp?menu_idx=3">By Item Category</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="menu2"><a href="<%=approot%>/posreport/stock-subcategoryConsigment.jsp?menu_idx=3">By Item Sub Category</a></td>
                                                </tr>
                                                
                                            </td>
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
                            <tr id="sales1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"> <a href="javascript:cmdChangeMenu('4')">Sales</a></td>
                            </tr>
                            <tr id="sales2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Sales</span></a></td>
                            </tr>
                            <tr id="sales"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/sales_consigment.jsp?menu_idx=4">New Sales</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/saleslistConsigment.jsp?menu_idx=4">Archives</a></td>
                                        </tr>
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/jurnalsalesConsigment.jsp?menu_idx=4">Proses Jurnal</a></td>
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
                            <tr id="masterItem1"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('5')"> <a href="javascript:cmdChangeMenu('5')">Master Data</a></td>
                            </tr>
                            <tr id="masterItem2"> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('0')"> <a href="javascript:cmdChangeMenu('0')"><span class="selected">Master Data</span></a></td>
                            </tr>
                            <tr id="masterItem"> 
                                <td class="submenutd"> 
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                                        <tr> 
                                            <td class="menu1"><a href="<%=approot%>/sales/itemlistConsigment.jsp?menu_idx=5">Item Consigment</a></td>
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

