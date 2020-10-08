
<%-- 
    Document   : inventoryreport
    Created on : Dec 14, 2013, 10:00:00 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_INVENTORY_STOCK") != null) {
                session.removeValue("REPORT_INVENTORY_STOCK");
            }
            
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long groupId = JSPRequestValue.requestLong(request, "src_category_id");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
                
                function cmdPrintJournalXls(){	                       
                    window.open("<%=printroot%>.report.RptInventoryStockXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>&location_id=<%=locationId%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdSearch(){
                        document.frmsalescategory.command.value="<%=JSPCommand.SEARCH%>";
                        document.frmsalescategory.action="inventoryreport.jsp?menu_idx=<%=menuIdx%>";
                        document.frmsalescategory.submit();
                    }
                    
                    //-------------- script control line -------------------
                    function MM_swapImgRestore() { //v3.0
                        var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
                    }
                    
                    function MM_preloadImages() { //v3.0
                        var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                    }
                    
                    function MM_findObj(n, d) { //v4.0
                        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                        if(!x && document.getElementById) x=document.getElementById(n); return x;
                    }
                    
                    function MM_swapImage() { //v3.0
                        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                    }
                    
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form name="frmsalescategory" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                    <span class="lvl2">Inventory Report<br></span></font></b>
                                                                                                                                </td>
                                                                                                                                <td width="40%" height="23"> 
                                                                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="400">                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td class="tablecell1" >                                                                                                                                                
                                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" style="border:1px solid #ABA8A8">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="5" nowrap colspan="4" height="4"></td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="5" nowrap>&nbsp;</td>
                                                                                                                                                        <td height="14" nowrap class="fontarial"><b><i>Searching Parameter :</i></b></td>
                                                                                                                                                        <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="5" nowrap>&nbsp;</td>
                                                                                                                                                        <td width="100" height="14" class="fontarial">Stock Until</td>
                                                                                                                                                        <td colspan="3">
                                                                                                                                                            <table cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>                                                                                                                                                                    
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>                                                                                                                                                        
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>                                                                                                                                        
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="5" nowrap>&nbsp;</td>
                                                                                                                                                        <td height="14" class="fontarial">Location</td>
                                                                                                                                                        <td height="14"> 
                                                                                                                                                            <%
            Vector vLoc = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
                                                                                                                                                            %>
                                                                                                                                                            <select name="src_location_id" class="fontarial">                                                                              
                                                                                                                                                            <option value="0" <%if (0 == locationId) {%>selected<%}%>>All Location..</option>
                                                                                                                                                                <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                                <%}
            }%>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="14">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="5" nowrap>&nbsp;</td>
                                                                                                                                                        <td height="14" class="fontarial">Category</td>
                                                                                                                                                        <td height="14"> 
                                                                                                                                                            <%
            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
                                                                                                                                                            %>
                                                                                                                                                            <select name="src_category_id" class="fontarial">    
                                                                                                                                                                <option value="0">All Category..</option>
                                                                                                                                                                <%if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=ic.getOID()%>" <%if (ic.getOID() == groupId) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                                                                <%}
            }%>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                        <td height="14">&nbsp;</td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                    <tr> 
                                                                                                                                                        <td colspan="4" >&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4" height="30">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%


            try {
                if (iJSPCommand == JSPCommand.SEARCH) {

                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr height="20">                                                                                                                                             
                                                                                                                                            <td class="tablearialhdr" width="10%">SKU</td>
                                                                                                                                            <td class="tablearialhdr">ITEM NAME</td>
                                                                                                                                            <td class="tablearialhdr" width="13%">QTY</td>
                                                                                                                                            <td class="tablearialhdr" width="13%">PRICE</td>
                                                                                                                                            <td class="tablearialhdr" width="13%">TOTAL</td>                                                                                                                                            
                                                                                                                                        </tr>  
                                                                                                                                        <%
                                                                                                                                                CONResultSet crs = null;
                                                                                                                                                int seq = 0;
                                                                                                                                                try {

                                                                                                                                                    Hashtable hIS = SessReportInventory.inventoryReport(invEndDate, locationId);
                                                                                                                                                    String sql = "select " + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as im_id ," + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as code," + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as name " + " from " + DbItemMaster.DB_ITEM_MASTER + " where " + DbItemMaster.colNames[DbItemMaster.COL_IS_ACTIVE] + " = 1 ";

                                                                                                                                                    if (groupId != 0) {
                                                                                                                                                        sql = sql + " and " + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = " + groupId;
                                                                                                                                                    }
                                                                                                                                                    
                                                                                                                                                    
                                                                                                                                                    
                                                                                                                                                    
                                                                                                                                                    

                                                                                                                                                    crs = CONHandler.execQueryResult(sql);
                                                                                                                                                    ResultSet rs = crs.getResultSet();

                                                                                                                                                    double totStock = 0;
                                                                                                                                                    double totPrice = 0;
                                                                                                                                                    double totPriceStock = 0;
                                                                                                                                                    
                                                                                                                                                    Vector result = new Vector();
                                                                                                                                                    while (rs.next()) {
                                                                                                                                                        InventoryStock iStock = new InventoryStock();

                                                                                                                                                        String style = "";
                                                                                                                                                        if (seq % 2 == 0) {
                                                                                                                                                            style = "tablearialcell";
                                                                                                                                                        } else {
                                                                                                                                                            style = "tablearialcell1";
                                                                                                                                                        }

                                                                                                                                                        long itemId = rs.getLong("im_id");
                                                                                                                                                        String name = rs.getString("name");
                                                                                                                                                        String code = rs.getString("code");
                                                                                                                                                        double stock = 0;
                                                                                                                                                        try {
                                                                                                                                                            InventoryStock is = (InventoryStock) hIS.get("" + itemId);
                                                                                                                                                            stock = is.getStock();
                                                                                                                                                        } catch (Exception e) {
                                                                                                                                                            stock = 0;
                                                                                                                                                        }

                                                                                                                                                        double price = SessReportInventory.getPrice(invEndDate, itemId);
                                                                                                                                                        double priceStock = stock * price;

                                                                                                                                                        totStock = totStock + stock;
                                                                                                                                                        totPrice = totPrice + price;
                                                                                                                                                        totPriceStock = totPriceStock + priceStock;
                                                                                                                                                        iStock.setItemMasterId(itemId);
                                                                                                                                                        iStock.setName(name);
                                                                                                                                                        iStock.setSku(code);
                                                                                                                                                        iStock.setPrice(price);
                                                                                                                                                        iStock.setStock(stock);
                                                                                                                                                        result.add(iStock);
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="<%=style%>"><%=code%></td>                                                                                                                                            
                                                                                                                                            <td class="<%=style%>"><%=name%></td>
                                                                                                                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(stock, "#,###") %></td>
                                                                                                                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(price, "#,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(priceStock, "#,###.##") %></td>                                                                                    
                                                                                                                                        </tr>                                                                                                                                         
                                                                                                                                        <%
                                                                                                                                                seq++;
                                                                                                                                            }%>
                                                                                                                                        <%
                                                                                                                                        if (seq > 0) {
                                                                                                                                            session.putValue("REPORT_INVENTORY_STOCK",result);
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" colspan="2" align="center"><b>GRAND TOTAL</b></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                            <td class="tablearialcell1" align="right"><b><%=JSPFormater.formatNumber(totStock, "#,###") %></b></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><b><%=JSPFormater.formatNumber(totPrice, "#,###.##") %></b></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><b><%=JSPFormater.formatNumber(totPriceStock, "#,###.##") %></b></td>                                                                                    
                                                                                                                                        </tr>  
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="4">&nbsp;</td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="4">                                                                                                                                                 
                                                                                                                                                <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                            </td>     
                                                                                                                                        </tr>    
                                                                                                                                        <%}%>
                                                                                                                                        <%} catch (Exception e) {
                                                                                                                                                }
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        %>
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                            <%  } else {%>
                                                                                                                            <tr align="left" valign="top">                                                                                                                                 
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial">&nbsp;</td>
                                                                                                                            </tr>    
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <%if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial"><i>Data not found..</i></td>
                                                                                                                                <%} else {%>
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial"><i>Click serach buton to seraching the data..</i></td>
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <%}
            } catch (Exception exc) {
            }%>                                                                                                             
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </form>
                                                                                                    </td>
                                                                                                </tr>                                                                                               
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    <!-- #EndEditable --> </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>
