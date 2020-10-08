
<%-- 
    Document   : jurnalsalesretur
    Created on : Jun 12, 2012, 11:00:25 AM
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
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true; boolean privUpdate = true; boolean privDelete = true;
            boolean masterPriv = true; boolean masterPrivView = true; boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%
            int salesType = JSPRequestValue.requestInt(request, "sales_type");            
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");  
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");            
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long periodId = JSPRequestValue.requestLong(request, "period");

            String whereClause = "";

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and date <= '"+JSPFormater.formatDate(invStartDate, "yyyy-MM-dd")+" 23:59:59'";

            if (locationId != 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " " + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = "+locationId;
            }
            
            if (iJSPCommand == JSPCommand.NONE || salesType == -1){
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                
                whereClause = whereClause + " ( type = " + DbSales.TYPE_RETUR_CASH+" or type = " + DbSales.TYPE_RETUR_CREDIT+" ) ";
                
            }else{
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " type = " + salesType;
            }

            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }
            
            whereClause = whereClause + " " + DbSales.colNames[DbSales.COL_STATUS] + " = 0 ";

            if (whereClause != ""){
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " sales_type=" + DbSales.TYPE_NON_CONSIGMENT;

            Vector listSales = DbSales.list(0, 0, whereClause, "date, unit_usaha_id, number");

            if (iJSPCommand == JSPCommand.POST && periodId != 0){
                Vector temp = new Vector();
                if (listSales != null && listSales.size() > 0) {
                    for (int i = 0; i < listSales.size(); i++) {
                        Sales sales = (Sales) listSales.get(i);
                        int xxx = JSPRequestValue.requestInt(request, "sale_" + sales.getOID());
                        if (xxx == 1) {
                            temp.add(sales);
                        }
                    }
                    if (temp != null && temp.size() > 0) {                                                
                        DbSales.postJourRetur(temp, user.getOID() ,periodId);
                    }
                }
                listSales = DbSales.list(0, 0, whereClause, "date, unit_usaha_id, number");
            }
%>
<html>
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Oxy-Sales</title>
    <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        <%if (!masterPriv || !masterPrivView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function cmdPostJournal(){
            document.frmsales.command.value="<%=JSPCommand.POST%>";
            document.frmsales.action="jurnalsalesretur.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdSearch(){
            document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsales.action="jurnalsalesretur.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function setChecked(val){
                 <%
            for (int k = 0; k < listSales.size(); k++) {
                Sales osl = (Sales) listSales.get(k);
                 %>
                     document.frmsales.sale_<%=osl.getOID()%>.checked=val.checked;
                     <% }%>
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
                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                                        </font><font class="tit1">&raquo; 
                                                                            <span class="lvl2">Post Journal Sales Retur<br>
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
                                                                            <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                            <td colspan="3" height="14">&nbsp;</td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="14" nowrap>Date Transaction</td>
                                                                            <td colspan="3" height="14"> 
                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                        </td>    
                                                                                        <td>
                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                        </td>                                                                                           
                                                                                        <td width="120">&nbsp;&nbsp;&nbsp;&nbsp;</td>     
                                                                                        <td>
                                                                                            Periode
                                                                                        </td> 
                                                                                        <%
            Vector periods = new Vector();
            Periode preClosedPeriod = new Periode();
            Periode openPeriod = new Periode();

            Vector vPreClosed = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE]);

            openPeriod = DbPeriode.getOpenPeriod();

            if (vPreClosed != null && vPreClosed.size() > 0) {
                for (int i = 0; i < vPreClosed.size(); i++) {
                    Periode prClosed = (Periode) vPreClosed.get(i);
                    if (i == 0) {
                        preClosedPeriod = prClosed;
                    }
                    periods.add(prClosed);
                }
            }

            if (openPeriod.getOID() != 0) {
                periods.add(openPeriod);
            }

                                                                                        %>
                                                                                        
                                                                                        <td>&nbsp;&nbsp;
                                                                                            <select name="period">
                                                                                                <%
            if (periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);

                                                                                                %>
                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == periodId) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                <%}%><%}%>
                                                                                            </select>
                                                                                        </td>                   
                                                                                    </tr>    
                                                                                </table>    
                                                                            </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="14" nowrap>Location</td>
                                                                            <td width="33%" height="14"> 
                                                                                <%
            Vector loc = DbLocation.list(0, 0, "", "name");
                                                                                %>
                                                                                <select name="src_location_id">
                                                                                    <option value="0">-- All --</option>
                                                                                    <%if (loc != null && loc.size() > 0) {
                for (int i = 0; i < loc.size(); i++) {
                    Location lc = (Location) loc.get(i);
                                                                                    %>
                                                                                    <option value="<%=lc.getOID()%>" <%if (lc.getOID() == locationId) {%>selected<%}%>><%=lc.getName()%></option>
                                                                                    <%}
            }%>
                                                                                </select>
                                                                            </td>
                                                                            <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                            <td width="49%" height="14" nowrap>&nbsp; 
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="10%" height="14">Sales Type</td>
                                                                            <td width="33%" height="14"> 
                                                                                <select name="sales_type">
                                                                                    <option value="-1" <%if (salesType == -1) {%>selected<%}%>>-- All --</option>	
                                                                                    <option value="2" <%if (salesType == 2) {%>selected<%}%>>RETUR CASH</option>
                                                                                    <option value="3" <%if (salesType == 3) {%>selected<%}%>>RETUR CREDIT</option>
                                                                                </select>
                                                                            </td>
                                                                            <td width="8%" height="14">&nbsp;</td>
                                                                            <td width="49%" height="14">&nbsp;</td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="33">&nbsp;</td>
                                                                            <td width="33%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            <td width="8%" height="33">&nbsp;</td>
                                                                            <td width="49%" height="33">&nbsp; 
                                                                            </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="15">&nbsp;</td>
                                                                            <td width="33%" height="15">&nbsp; 
                                                                            </td>
                                                                            <td width="8%" height="15">&nbsp;</td>
                                                                            <td width="49%" height="15">&nbsp;</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>                                                            
                                                            <%
            try {
                if (listSales != null && listSales.size() > 0) {
                                                            %>
                                                            <tr align="left" valign="top"> 
                                                                <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td class="boxed1">
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                    <tr> 
                                                                                        <td class="tablehdr" width="2%">No</td>
                                                                                        <td class="tablehdr" width="6%">Date</td>
                                                                                        <td class="tablehdr" width="6%">Sales No.</td>
                                                                                        <td class="tablehdr" width="13%">Description</td>
                                                                                        <td class="tablehdr" width="13%">Group</td>
                                                                                        <td class="tablehdr" width="3%">Qty</td>
                                                                                        <td class="tablehdr" width="7%">Price</td>
                                                                                        <td class="tablehdr" width="7%">Amount</td>
                                                                                        <td class="tablehdr" width="7%">Discount</td>
                                                                                        <td class="tablehdr" width="7%">PPN</td>
                                                                                        <td class="tablehdr" width="8%">Kwitansi</td>
                                                                                        <td class="tablehdr" width="7%">HPP</td>
                                                                                        <td class="tablehdr" width="8%">Laba</td>
                                                                                        <td class="tablehdr" width="6%"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                    </tr>
                                                                                    <%
                                                                    double totalQty = 0;
                                                                    double totalAmount = 0;
                                                                    double totalDiscount = 0;
                                                                    double totalVat = 0;
                                                                    double grandTotal = 0;
                                                                    double grandDiscountAmount = 0;
                                                                    double grandTotalHpp = 0;
                                                                    double grandTotalLaba = 0;
                                                                    double totallaba = 0;
                                                                    double totalhpp = 0;
                                                                    int no = 1;

                                                                    if (listSales != null && listSales.size() > 0) {
                                                                        for (int i = 0; i < listSales.size(); i++) {

                                                                            Sales sales = (Sales) listSales.get(i);

                                                                            Vector temp = DbSalesDetail.list(0, 0, "sales_id=" + sales.getOID(), "");
                                                                            totalDiscount = 0;
                                                                            totallaba = 0;
                                                                            totalhpp = 0;
                                                                            if (temp != null && temp.size() > 0) {
                                                                                for (int xx = 0; xx < temp.size(); xx++) {
                                                                                    SalesDetail sd = (SalesDetail) temp.get(xx);
                                                                                    ItemMaster im = new ItemMaster();
                                                                                    try {
                                                                                        im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                    ItemGroup ig = new ItemGroup();
                                                                                    try {
                                                                                        ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                    //totalAmount = totalAmount + sd.getTotal() + sd.getDiscountAmount();
                                                                                    totalhpp = totalhpp + (sd.getCogs() * sd.getQty());
                                                                                    totallaba = totallaba + (sd.getTotal() - (sd.getCogs() * sd.getQty()));
                                                                                    // if (temp.size() == 1) {
                                                                                    totalDiscount = totalDiscount + sd.getDiscountAmount();
                                                                                    totalVat = totalVat + sales.getVatAmount();
                                                                                    grandTotal = grandTotal + sd.getTotal() + sd.getDiscountAmount();
                                                                                    // }

                                                                                    %>
                                                                                    <tr> 
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> align="center">
                                                                                            <%
                                                                                                    if (xx == 0) {
                                                                                            %>
                                                                                            <%=no%>
                                                                                            <%
                                                                                                        no++;
                                                                                                    }
                                                                                            %>
                                                                                            </td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"><font size="1"><%=(xx == 0) ? JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") : ""%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"><font size="1"><%=(xx == 0) ? sales.getNumber() : ""%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="17%" nowrap><font size="1"><%=im.getName()%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="15%"><font size="1"><%=ig.getName()%></font></td>
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="3%"> 
                                                                                            <div align="right"><font size="1"><%=sd.getQty()%></font></div>
                                                                                        </td>
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                            <div align="right"><font size="1"> 
                                                                                                <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() + sd.getDiscountAmount(), "#,###")%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%=(temp.size() == 1) ? JSPFormater.formatNumber(sd.getDiscountAmount(), "#,###") : ""%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getVatAmount(), "#,###") : ""%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="8%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%=(temp.size() == 1) ? JSPFormater.formatNumber(sd.getTotal() + sales.getVatAmount(), "#,###") : ""%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###")%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="8%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() - (sd.getCogs() * sd.getQty()), "#,###")%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="2%">
                                                                                            <%if (xx == 0) {%> 
                                                                                            <div align="center"><font size="1"> 
                                                                                                <input type="checkbox" name="sale_<%=sales.getOID()%>" value="1">
                                                                                            </font></div>
                                                                                            <%}%>	
                                                                                        </td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%if (temp.size() > 1) {

                                                                                                    totalDiscount = totalDiscount + sales.getDiscountAmount();
                                                                                                    totalVat = totalVat + sales.getVatAmount();
                                                                                    %>
                                                                                    <tr> 
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2">&nbsp;</td>
                                                                                        <td height="2" class="tablecell1"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount() + sales.getDiscountAmount() + totalDiscount, "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalDiscount, "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount() + sales.getVatAmount(), "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1">
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalhpp, "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1">
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totallaba, "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1">&nbsp;</td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <tr> 
                                                                                        <td colspan="13" height="2"></td>
                                                                                    </tr>
                                                                                    <%}
                                                                            grandDiscountAmount = grandDiscountAmount + totalDiscount;
                                                                            //grandTotal =  grandTotal + sales.getAmount() + totalDiscount;
                                                                            grandTotalHpp = grandTotalHpp + totalhpp;
                                                                            grandTotalLaba = grandTotalLaba + totallaba;



                                                                        }
                                                                    }%>
                                                                                    <tr> 
                                                                                        <td colspan="13" height="5"></td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td width="2%" height="19">&nbsp;</td>
                                                                                        <td width="6%" height="19">&nbsp;</td>
                                                                                        <td width="6%" height="19">&nbsp;</td>
                                                                                        <td width="17%" height="19">&nbsp;</td>
                                                                                        <td width="15%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="center"><font color="#FFFFFF" size="1"><b>T O T A L</b></font></div>
                                                                                        </td>
                                                                                        <td width="3%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="center"><font size="1"><b><font color="#FFFFFF"><%=totalQty%></font></b></font></div>
                                                                                        </td>
                                                                                        <td width="7%" height="19" bgcolor="#3366CC"><font size="1"></font></td>
                                                                                        <td width="7%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal, "#,###")%></font></b></font></div>
                                                                                        </td>
                                                                                        <td width="7%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandDiscountAmount, "#,###")%></font></b></font></div>
                                                                                        </td>
                                                                                        <td width="7%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalVat, "#,###")%></font></b></font></div>
                                                                                        </td>
                                                                                        <td width="8%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal - grandDiscountAmount, "#,###")%></font></b></font></div>
                                                                                        </td>
                                                                                        <td width="7%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalHpp, "#,###")%></font></b></font></div>
                                                                                        </td>
                                                                                        <td width="8%" height="19" bgcolor="#3366CC"> 
                                                                                            <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalLaba, "#,###")%></font></b></font></div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td width="2%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="17%">&nbsp;</td>
                                                                                        <td width="15%">&nbsp;</td>
                                                                                        <td width="3%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="8%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="8%">&nbsp;</td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td class="boxed1"><a href="javascript:cmdPostJournal()"><img src="../images/post_journal.gif" width="92" height="22" border="0"></a></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%
                                                                } else {

                                                                    if (iJSPCommand == JSPCommand.SUBMIT) {
                                                            %>
                                                            <tr align="left" valign="top"> 
                                                                <td height="8" align="left" colspan="3" class="page">  
                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                        <tr> 
                                                                            <td class="tablecell1" >&nbsp;No data that needs to be posted</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>                
                                                            <%
                    }
                }
            } catch (Exception exc) {
            }%>
                                                            <tr align="left" valign="top"> 
                                                                <td height="8" align="left" colspan="3" class="command"> 
                                                                    <span class="command"> 
                                                                </span> </td>
                                                            </tr>
                                                            <tr align="left" valign="top"> 
                                                                <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr> 
                                                                            <td width="97%">&nbsp;</td>
                                                                        </tr>                                                                        
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="top"> 
                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                                    </td>
                                                </tr>
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
