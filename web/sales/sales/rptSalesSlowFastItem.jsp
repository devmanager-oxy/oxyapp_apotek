
<%-- 
    Document   : rptsalesbyqty
    Created on : Jan 8, 2013, 4:12:09 PM
    Author     : Ngurah Wirata
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
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<%!
    public Vector drawList(Vector objectClass, int start, Date startDate, Date endDate, long locId, double qtySales, int src_slow) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell1");
        jsplist.setCellStyle1("tablecell");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Category", "10%");
        jsplist.addHeader("Sub Category", "10%");
        jsplist.addHeader("Code/SKU", "10%");
        jsplist.addHeader("Barcode", "10%");
        jsplist.addHeader("Name", "31%");
        jsplist.addHeader("Supplier", "10%");
        jsplist.addHeader("Qty Sold", "7%");
        jsplist.addHeader("Qty Stock", "7%");


        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        jsplist.setLinkPrefix("javascript:cmdEdit('");
        jsplist.setLinkSufix("')");
        jsplist.reset();
        int index = -1;
        int no = 0;
        Vector vitem = new Vector();
        for (int i = 0; i < objectClass.size(); i++) {
            boolean isItem = false;
            Vector rowx = new Vector();
            double totSales = 0;
            double qtyStock = 0;
            ItemMaster im = (ItemMaster) objectClass.get(i);
            if (locId != 0) {
                qtyStock = DbStock.getItemTotalStock(locId, im.getOID());
            } else {
                qtyStock = DbStock.getItemTotalStock(im.getOID());
            }

            totSales = DbStock.getTotalQtySales(locId, im.getOID(), startDate, endDate);
            if (totSales == 0 && qtyStock == 0) {
                isItem = false;
            } else {
                isItem = true;
            }
            Vector vitemDet = new Vector();
            if (src_slow == 0) {
                if ((totSales <= qtySales) && isItem) {
                    no = no + 1;
                    ItemGroup ig = new ItemGroup();
                    ItemCategory ic = new ItemCategory();
                    Vendor ven = new Vendor();
                    try {
                        ig = DbItemGroup.fetchExc(im.getItemGroupId());
                        ic = DbItemCategory.fetchExc(im.getItemCategoryId());
                        ven = DbVendor.fetchExc(im.getDefaultVendorId());
                    } catch (Exception ex) {

                    }
                    rowx.add("<div align=\"center\">" + "" + no + "</div>");
                    rowx.add(ig.getName());//category
                    rowx.add(ic.getName());//sub category
                    rowx.add(im.getCode());//sku
                    rowx.add(im.getBarcode());//barcode
                    rowx.add(im.getName());//nama barang
                    rowx.add(ven.getName());//vendor
                    rowx.add("" + totSales);
                    rowx.add("" + qtyStock);
                    lstData.add(rowx);
                    vitemDet.add("" + no);
                    vitemDet.add(ig.getName());
                    vitemDet.add(ic.getName());
                    vitemDet.add(im.getCode());
                    vitemDet.add(im.getBarcode());
                    vitemDet.add(im.getName());
                    vitemDet.add(ven.getName());
                    vitemDet.add("" + totSales);
                    vitemDet.add("" + qtyStock);

                    vitem.add(vitemDet);
                }
            } else {
                if ((totSales >= qtySales) && isItem) {
                    no = no + 1;
                    ItemGroup ig = new ItemGroup();
                    ItemCategory ic = new ItemCategory();
                    Vendor ven = new Vendor();
                    try {
                        ig = DbItemGroup.fetchExc(im.getItemGroupId());
                        ic = DbItemCategory.fetchExc(im.getItemCategoryId());
                        ven = DbVendor.fetchExc(im.getDefaultVendorId());
                    } catch (Exception ex) {

                    }
                    rowx.add("<div align=\"center\">" + "" + no + "</div>");
                    rowx.add(ig.getName());//category
                    rowx.add(ic.getName());//sub category
                    rowx.add(im.getCode());//sku
                    rowx.add(im.getBarcode());//barcode
                    rowx.add(im.getName());//nama barang
                    rowx.add(ven.getName());//vendor
                    rowx.add("" + totSales);
                    rowx.add("" + qtyStock);
                    vitemDet.add("" + no);
                    vitemDet.add(ig.getName());
                    vitemDet.add(ic.getName());
                    vitemDet.add(im.getCode());
                    vitemDet.add(im.getBarcode());
                    vitemDet.add(im.getName());
                    vitemDet.add(ven.getName());
                    vitemDet.add("" + totSales);
                    vitemDet.add("" + qtyStock);
                    lstData.add(rowx);
                    vitem.add(vitemDet);
                }
            }
        }

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(vitem);
        return v;
    }

%>

<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_SALES_QTY") != null) {
                session.removeValue("REPORT_SALES_QTY");
            }
            if (session.getValue("REPORT_SALES_QTY_DETAIL") != null) {
                session.removeValue("REPORT_SALES_QTY_DETAIL");
            }
            if (session.getValue("REPORT_SALES_SLOW") != null) {
                session.removeValue("REPORT_SALES_SLOW");
            }

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int chkInvDate = 0;
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            long groupId = JSPRequestValue.requestLong(request, "src_category_id");
            long categoryId = JSPRequestValue.requestLong(request, "src_sub_category_id");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            double qtySales = JSPRequestValue.requestDouble(request, "src_qty_sales");
            int recordToGet = 10;
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int srcSlow = JSPRequestValue.requestInt(request, "src_slow");

            session.putValue("REPORT_SALES_SLOW", "" + srcSlow);
            String whereClause = "";

            if (groupId != 0) {
                whereClause = DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + "=" + groupId;
            }
            if (categoryId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + "=" + categoryId;
            }
            if (vendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + "=" + vendorId;
            }
            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " (" + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcCode + "%' ) ";
            }
            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }
            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_IS_ACTIVE] + "=1";

            CmdItemMaster cmdItemMaster = new CmdItemMaster(request);
            JSPLine ctrLine = new JSPLine();
            int vectSize = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            Vector result = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH || (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.PREV || iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.LAST)) {
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setIgnore(chkInvDate);
                rp.setCategoryId(groupId);
                rp.setVendorId(vendorId);

                session.putValue("REPORT_SALES_QTY", rp);
                try {
                    result = DbItemMaster.list(0, 0, whereClause, "");
                } catch (Exception e) {
                }
            }
%>
<html>
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Sales System</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            
            
            function cmdPrintXls(){	
                //alert("tes");
                window.open("<%=printroot%>.report.RptSalesSlowFastItemXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdSearch(){
                    document.frmsalescategory.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmsalescategory.action="rptSalesSlowFastItem.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsalescategory.submit();
                }
                
                
                function cmdListFirst(){
                    document.frmsalescategory.command.value="<%=JSPCommand.FIRST%>";
                    document.frmsalescategory.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmsalescategory.action="rptSalesSlowFastItem.jsp";
                    document.frmsalescategory.submit();
                }
                
                function cmdListPrev(){
                    document.frmsalescategory.command.value="<%=JSPCommand.PREV%>";
                    document.frmsalescategory.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmsalescategory.action="rptSalesSlowFastItem.jsp";
                    document.frmsalescategory.submit();
                }
                
                function cmdListNext(){
                    document.frmsalescategory.command.value="<%=JSPCommand.NEXT%>";
                    document.frmsalescategory.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmsalescategory.action="rptSalesSlowFastItem.jsp";
                    document.frmsalescategory.submit();
                }
                
                function cmdListLast(){
                    document.frmsalescategory.command.value="<%=JSPCommand.LAST%>";
                    document.frmsalescategory.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmsalescategory.action="rptSalesSlowFastItem.jsp";
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
                                                                                                                                <td class="container" width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Report Slow/Fast Moving Items <br></span></font></b></td>
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
                                                                                                                                            <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="14">Date Between</td>
                                                                                                                                            <td colspan="3">
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td>&nbsp;&nbsp;and&nbsp;&nbsp;</td>
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
                                                                                                                                            <td width="8%" height="14">Location</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id"> 
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
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Category</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_category_id">    
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ic.getOID()%>" <%if (ic.getOID() == groupId) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Sub Category</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vsubCategory = DbItemCategory.list(0, 0, "", "" + DbItemCategory.colNames[DbItemCategory.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_sub_category_id">    
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vsubCategory != null && vsubCategory.size() > 0) {
                for (int i = 0; i < vsubCategory.size(); i++) {
                    ItemCategory ic = (ItemCategory) vsubCategory.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ic.getOID()%>" <%if (ic.getOID() == categoryId) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Suplier</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vVendor = DbVendor.list(0, 0, "", "" + DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_vendor_id">    
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor vnd = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=vnd.getOID()%>" <%if (vnd.getOID() == vendorId) {%>selected<%}%>><%=vnd.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">SKU/Barcode</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <input type="text" name="src_code" value="<%=srcCode%>" >
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Name</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <input type="text" name="src_name" value="<%=srcName%>" >
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Qty Sold</td>
                                                                                                                                            <td colspan="3" width="38%" height="14"> 
                                                                                                                                            <input type="text" size="10" name="src_qty_sales" value="<%=qtySales%>" >
                                                                                                                                            <input type="radio" name="src_slow" value="0" <%if (srcSlow == 0) {%>checked<%}%>> Slow Moving
                                                                                                                                                   <input type="radio" name="src_slow" value="1" <%if (srcSlow == 1) {%>checked<%}%>> Fast Moving
                                                                                                                                                   </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="33">&nbsp;</td>
                                                                                                                                            <td width="38%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td width="54%" height="33">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="15">&nbsp;</td>
                                                                                                                                            <td width="38%" height="15">&nbsp;</td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
            try {
                if (result.size() > 0) {
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                                                                    <%
                                                                                                                                    Vector x = drawList(result, start, invStartDate, invEndDate, locationId, qtySales, srcSlow);
                                                                                                                                    String strList = (String) x.get(0);
                                                                                                                                    Vector rptObj = (Vector) x.get(1);
                                                                                                                                    session.putValue("REPORT_SALES_QTY_DETAIL", rptObj);
                                                                                                                                    %>
                                                                                                                                <%=strList%>                                                                                                              </td>
                                                                                                                            </tr>
                                                                                                                            <%  }
            } catch (Exception exc) {
            }%>
                                                                                                                  
                                                                                                                                                                                                                                        
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%if (result.size() > 0) {%>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="4"> 
                                                                                                                        &nbsp; <a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                        
                                                                                                                    </td>     
                                                                                                                </tr>   
                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                        </form>
                                                                                                    </td>
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
