
<%@ page language = "java" %>
<%@ page import = "java.util.*" %> 
<%@ page import = "java.sql.ResultSet" %> 
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->

<%

            if (session.getValue("REPORT_SALES_ITEM") != null) {
                session.removeValue("REPORT_SALES_ITEM");
            }

            if (session.getValue("REPORT_SALES_ITEM_PARAMETER") != null) {
                session.removeValue("REPORT_SALES_ITEM_PARAMETER");
            }

            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");

            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long groupId = JSPRequestValue.requestLong(request, "src_category_id");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            Vector vpar = new Vector();
            vpar.add("" + locationId);
            vpar.add("" + JSPFormater.formatDate(invStartDate, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(invEndDate, "dd/MM/yyyy"));
            vpar.add("" + groupId);
            vpar.add("" + srcCode);
            vpar.add("" + srcName);
            vpar.add("" + user.getFullName());
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>        
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptSalesByItemXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmsales.action="rptSalesByItem.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
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
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
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
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Report By Item<br>
                                                                                                                                </span></font></b></td>
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
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="100" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td width="1">&nbsp;</td>
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Date Between</td>
                                                                                                                                            <td width="1" class="fontarial">:</td>
                                                                                                                                            <td > 
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                                                                                        </td>    
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>       
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Cashier Location</td>
                                                                                                                                            <td width="1" class="fontarial">:</td>
                                                                                                                                            <td > 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id" class="fontarial">
                                                                                                                                                    <%if (vLoc.size() == totLocationxAll) {%>
                                                                                                                                                    <option value="0"> - All Location -</option>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Category</td>
                                                                                                                                            <td width="1" class="fontarial">:</td>
                                                                                                                                            <td > 
                                                                                                                                                <%
            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_category_id" class="fontarial">    
                                                                                                                                                    <option value="0">- All Category -</option>
                                                                                                                                                    <%if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ic.getOID()%>" <%if (ic.getOID() == groupId) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Barcode/SKU</td>
                                                                                                                                            <td width="1" class="fontarial">:</td>
                                                                                                                                            <td> 
                                                                                                                                                <input type="text" name="src_code" value="<%=srcCode%>" class="fontarial">
                                                                                                                                            </td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr>
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Item Name</td>
                                                                                                                                            <td width="1" class="fontarial">:</td>                                                                                                                                            
                                                                                                                                            <td > 
                                                                                                                                                <input type="text" name="src_name" value="<%=srcName%>" class="fontarial">
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td nowrap>&nbsp;&nbsp;</td>
                                                                                                                                            <td width="1" class="fontarial">&nbsp;</td>  
                                                                                                                                            <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                        </tr>                                                                                                                                      
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top" height="25"> 
                                                                                                                                <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="1120" border="0" cellspacing="1" cellpadding="0">                                                                                                                                        
                                                                                                                                        <tr height="26">                                                                                                 
                                                                                                                                            <td width="25" class="tablearialhdr">No</td>
                                                                                                                                            <td width="70" class="tablearialhdr">SKU</td>
                                                                                                                                            <td width="90" class="tablearialhdr">Barcode</td>
                                                                                                                                            <td  class="tablearialhdr">Item Name</td>
                                                                                                                                            <td width="110" class="tablearialhdr">Category</td>
                                                                                                                                            <td width="180" class="tablearialhdr">Suplier</td>
                                                                                                                                            <td width="50" class="tablearialhdr">Qty</td>
                                                                                                                                            <td width="80" class="tablearialhdr">Selling Price</td>
                                                                                                                                            <td width="80" class="tablearialhdr">Discount</td>
                                                                                                                                            <td width="80" class="tablearialhdr">Total</td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%
            if (iJSPCommand == JSPCommand.SEARCH) {
                try {

                    CONResultSet crs = null;
                    String where = "";

                    if (locationId != 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
                    }

                    if (groupId != 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " = " + groupId;
                    }

                    if (srcName != null && srcName.length() > 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName.trim() + "%' ";
                    }

                    if (srcCode != null && srcCode.length() > 0) {
                        if (where.length() > 0) {
                            where = where + " and ";
                        }
                        where = where + " (im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode.trim() + "%' or im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcCode.trim() + "%' or im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcCode.trim() + "%' or im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcCode.trim() + "%')";
                    }

                    if (where.length() > 0) {
                        where = where + " and ";
                    }

                    where = where + " to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, " yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, " yyyy-MM-dd") + "') ";

                    if (where.length() > 0) {
                        where = " and " + where;
                    }

                    String sql = "select gid, cdx,igname,cd,barcode,masterid,nm,sum(ttqty) as ttqtyx,sum(ttqty * seliing)/sum(ttqty) as selling,sum(tttot) as tttotx, vndx, sum(tdiskon) as tdiskonx  from ( " +
                            " select gid, cdx,igname,cd,barcode,masterid,nm, sum(totqty) as ttqty,seliing,sum(tot) as tttot, vndx, sum(totdis) as tdiskon " +
                            " from (select ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                            " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid, " +
                            " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd, " +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " as barcode, " +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                            " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as totqty, " +
                            " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                            " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                            " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + ") as totdis, " +
                            " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + ") as tot, " +
                            " ps." + DbSales.colNames[DbSales.COL_TYPE] + " as type " +
                            " from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                            " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (0,1) " + where +
                            " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " union " +
                            " select ig." + DbItemGroup.colNames[DbItemGroup.COL_CODE] + " as cdx," +
                            " ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " as gid," +
                            " ig." + DbItemGroup.colNames[DbItemGroup.COL_NAME] + " as igname, " +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as cd," +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as masterid," +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " as barcode, " +
                            " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as nm, " +
                            " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + " * -1) as totqty, " +
                            " psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " as seliing," +
                            " vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " vndx, " +
                            " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT] + " * -1) as totdis, " +
                            " sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_TOTAL] + " * -1) as tot, " +
                            " ps." + DbSales.colNames[DbSales.COL_TYPE] + " as type " +
                            " from " + DbSalesDetail.DB_SALES_DETAIL + " psd inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " inner join " + DbSales.DB_SALES + " ps on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " = ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] + " left join " + DbVendor.DB_VENDOR + " vnd on im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                            " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (2,3) " + where + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ",psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE] + " ) as xx group by masterid,seliing ) as x group by masterid order by ttqtyx desc ";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    String style = "";
                    int nomor = 1;

                    double subQty = 0;
                    double subTotal = 0;

                    Vector report = new Vector();

                    while (rs.next()) {
                        if (nomor % 2 == 0) {
                            style = "tablearialcell";
                        } else {
                            style = "tablearialcell1";
                        }


                        String groupName = rs.getString("igname");
                        String code = rs.getString("cd");
                        String barcode = rs.getString("barcode");
                        String itemName = rs.getString("nm");
                        double totalQty = rs.getDouble("ttqtyx"); // total qty
                        String vendor = rs.getString("vndx");
                        double selling = rs.getDouble("selling"); // harga jual                        
                        double diskon = rs.getDouble("tdiskonx"); // diskon

                        Vector tmpReport = new Vector();
                        tmpReport.add(groupName);
                        tmpReport.add(code);
                        tmpReport.add(barcode);
                        tmpReport.add(itemName);
                        tmpReport.add("" + totalQty);
                        tmpReport.add(vendor);
                        tmpReport.add("" + selling);
                        tmpReport.add("" + diskon);
                        report.add(tmpReport);

                        double total = (totalQty * selling) - diskon;
                        subQty = subQty + totalQty;
                        subTotal = subTotal + total;
                                                                                                                                        %>
                                                                                                                                        
                                                                                                                                        <tr height="22">                                                                                                                                                                                                 
                                                                                                                                            <td class="<%=style%>" align="center"><%=nomor%>.</td>
                                                                                                                                            <%
                                                                                                                                                    nomor++;
                                                                                                                                            %>
                                                                                                                                            <td class="<%=style%>" align="center"><%=code %></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;"><%=barcode %></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;"><%=itemName%></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;"><%=groupName%></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;"><%=vendor%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalQty, "###,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(selling, "###,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(diskon, "###,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(total, "###,###.##") %></td>
                                                                                                                                        </tr>
                                                                                                                                        <%

                                                                                                                                                }
                                                                                                                                                if (nomor != 1) {

                                                                                                                                                    session.putValue("REPORT_SALES_ITEM_PARAMETER", vpar);
                                                                                                                                                    session.putValue("REPORT_SALES_ITEM", report);
                                                                                                                                        %>    
                                                                                                                                        <tr height="22">
                                                                                                                                            <td  bgcolor="#F3A78D" colspan="6" align="center" class="fontarial"><b>T O T A L</b></td>                                                                                                                                            
                                                                                                                                            <td  bgcolor="#F3A78D" align="right" style="padding:3px;" class="fontarial"><b><%=JSPFormater.formatNumber(subQty, "###,###.##") %></b></td>
                                                                                                                                            <td  bgcolor="#F3A78D" colspan="2" align="center" class="fontarial"></td>
                                                                                                                                            <td  bgcolor="#F3A78D" align="right" style="padding:3px;" class="fontarial"><b><%=JSPFormater.formatNumber(subTotal, "###,###.##") %></b></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="10">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%if(privPrint){%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="10"> 
                                                                                                                                                <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                            </td>     
                                                                                                                                        </tr>  
                                                                                                                                        <%}%>
                                                                                                                                        <%
                                                                                                                                                }
                                                                                                                                        %>
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        <%} catch (Exception e) {
                }
            }
                                                                                                                                        
                                                                                                                                        %>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                        </table>
                                                                                                                    </td>
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
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

