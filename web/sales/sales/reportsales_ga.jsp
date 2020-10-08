
<%-- 
    Document   : reportsales_ga
    Created on : Feb 24, 2015, 12:32:20 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "java.sql.ResultSet" %> 
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_GA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_SALES_REPORT), AppMenu.M2_SAL_REPORT_GA, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_SALES_REPORT), AppMenu.M2_SAL_REPORT_GA, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long indukCustomerId = JSPRequestValue.requestLong(request, "induk_customer_id");
            long customerId = JSPRequestValue.requestLong(request, "customer_id");
            String headerx = JSPRequestValue.requestString(request, "headerx");
            
            if (session.getValue("REPORT_SALES_GA") != null) {
                session.removeValue("REPORT_SALES_GA");
            }

            if (session.getValue("REPORT_SALES_GA_PARAMETER") != null) {
                session.removeValue("REPORT_SALES_GA_PARAMETER");
            }

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            Vector induks = DbIndukCustomer.list(0, 0, "", DbIndukCustomer.colNames[DbIndukCustomer.COL_NAME]);

            Vector customers = new Vector();
            String where = DbCustomer.colNames[DbCustomer.COL_TYPE] + " = '" + DbCustomer.CUSTOMER_TYPE_COMPANY + "' ";
            if (indukCustomerId != 0) {
                where = where + " and " + DbCustomer.colNames[DbCustomer.COL_INDUK_CUSTOMER_ID] + " = " + indukCustomerId;
            }
            customers = DbCustomer.list(0, 0, where, DbCustomer.colNames[DbCustomer.COL_NAME]);

            Vector vLoc = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_TYPE] + " = '" + DbLocation.TYPE_GENERAL_AFFAIR + "'", "name");
            if (locationId == 0) {
                try {
                    Location lx = (Location) vLoc.get(0);
                    locationId = lx.getOID();
                } catch (Exception e) {
                }
            }

            Vector uoms = new Vector();
            Hashtable hUom = new Hashtable();
            uoms = DbUom.list(0, 0, "", "");
            if (uoms != null && uoms.size() > 0) {
                for (int i = 0; i < uoms.size(); i++) {
                    Uom uom = (Uom) uoms.get(i);
                    hUom.put("" + uom.getOID(), uom.getUnit());
                }
            }
            
            Vector report = new Vector();
            Vector reportParameter = new Vector();
            reportParameter.add(headerx);
            reportParameter.add(""+indukCustomerId);
            reportParameter.add(""+customerId);
            reportParameter.add("" + JSPFormater.formatDate(invStartDate, "dd/MM/yyyy"));
            reportParameter.add("" + JSPFormater.formatDate(invEndDate, "dd/MM/yyyy"));
            
            session.putValue("REPORT_SALES_GA_PARAMETER",reportParameter);
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
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsales.action="reportsales_ga.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdReload(){
                document.frmsales.command.value="<%=JSPCommand.REFRESH%>";
                document.frmsales.action="reportsales_ga.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.ReportSalesGAXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Report General Affair<br>
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
                                                                                                                        <table border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="10"></td>
                                                                                                                            </tr>
                                                                                                                            <tr height="22"> 
                                                                                                                                <td width="100" class="tablearialcell" nowrap>&nbsp;&nbsp;Location</td>
                                                                                                                                <td class="fontarial" size="2">:</td>
                                                                                                                                <td > 
                                                                                                                                    <select name="src_location_id" class="fontarial">                                                                                                                                                    
                                                                                                                                        <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>  
                                                                                                                                <td width="100"></td>
                                                                                                                                <td width="100" class="tablearialcell" nowrap>&nbsp;&nbsp;Date Between</td>
                                                                                                                                <td class="fontarial" size="2">:</td>
                                                                                                                                <td>
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
                                                                                                                            <tr height="22"> 
                                                                                                                                <td class="tablearialcell" nowrap>&nbsp;&nbsp;Customer Group</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td colspan="5"> 
                                                                                                                                    <select name="induk_customer_id" class="fontarial" onchange="javascript:cmdReload()">
                                                                                                                                        <option value="0">- All Group -</option>
                                                                                                                                        <%
            if (induks != null && induks.size() > 0) {
                for (int i = 0; i < induks.size(); i++) {
                    IndukCustomer ic = (IndukCustomer) induks.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=ic.getOID()%>" <%if (indukCustomerId == ic.getOID()) {%> selected <%}%>><%=ic.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr height="22"> 
                                                                                                                                <td class="tablearialcell" nowrap>&nbsp;&nbsp;Customer</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td colspan="5"> 
                                                                                                                                    <select name="customer_id" class="fontarial" >
                                                                                                                                        <option value="0">- All Customer -</option>
                                                                                                                                        <%
            if (customers != null && customers.size() > 0) {
                for (int i = 0; i < customers.size(); i++) {
                    Customer c = (Customer) customers.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=c.getOID()%>" <%if (customerId == c.getOID()) {%> selected <%}%>><%=c.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr height="10"> 
                                                                                                                                <td colspan="7" ></td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="7" class="fontarial"><i><b>Header</b></i></td>
                                                                                                                            </tr>
                                                                                                                            <tr height="22"> 
                                                                                                                                <td class="tablearialcell" nowrap>&nbsp;&nbsp;No. Invoice</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td colspan="5"><input type="text" name="headerx" value="<%=headerx%>" size="25">  
                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="7" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3" height="15">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%try {%>
                                                                                                                <%if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                                                <tr>
                                                                                                                    <td class="container">
                                                                                                                        <table width="950" border="0" cellspacing="1" cellpadding="0">    
                                                                                                                            
                                                                                                                            <tr height="26">                                                                                                 
                                                                                                                                <td width="25" class="tablearialhdr">No</td>
                                                                                                                                <td width="100" class="tablearialhdr">SKU</td>                                                                                                                                
                                                                                                                                <td  class="tablearialhdr">NAMA BARANG</td>
                                                                                                                                <td width="70" class="tablearialhdr">SATUAN</td>
                                                                                                                                <td width="80" class="tablearialhdr">QTY</td>
                                                                                                                                <td width="120" class="tablearialhdr">HARGA</td>
                                                                                                                                <td width="120" class="tablearialhdr">JUMLAH</td>                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%

    CONResultSet crs = null;
    try {

        String wherex = "";

        if (indukCustomerId != 0) {
            wherex = wherex + " and c.induk_customer_id = " + indukCustomerId;
        }

        if (customerId != 0) {
            wherex = wherex + " and c.customer_id = " + customerId;
        }

        String sql = "select gname,ig_id as gid,gcode,mcode,name,satuan,sum(qty) as xqty,sum(jumlah) as xjumlah from ( " +
                " select g.item_group_id as ig_id,g.code as gcode,g.name as gname,m.item_master_id as item_id,m.code as mcode,m.name,m.uom_sales_id as satuan,sum(sd.qty) as qty,sum((sd.qty * sd.selling_price)-sd.discount_amount) as jumlah from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id inner join pos_item_group g on m.item_group_id = g.item_group_id inner join customer c on s.customer_id = c.customer_id where s.type in (0,1) and s.location_id = " + locationId + " and s.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and s.date <= '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59' " + wherex + " group by m.item_master_id union " +
                " select g.item_group_id as ig_id,g.code as gcode,g.name as gname,m.item_master_id as item_id,m.code,m.name as mcode,m.uom_sales_id as satuan,sum(sd.qty)*-1 as qty,sum((sd.qty * sd.selling_price)-sd.discount_amount)*-1 as jumlah from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id inner join pos_item_group g on m.item_group_id = g.item_group_id inner join customer c on s.customer_id = c.customer_id where s.type in (2,3) and s.location_id = " + locationId + " and s.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and s.date <= '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59' " + wherex + " group by m.item_master_id ) as x group by item_id order by gcode,mcode";

        crs = CONHandler.execQueryResult(sql);
        ResultSet rs = crs.getResultSet();
        String style = "";
        int nomor = 1;
        long tmpGid = 0;
        String grpName = "";

        double subTotal = 0;
        double grandTotal = 0;
        boolean data = false;

        while (rs.next()) {
            data = true;
            String groupCode = rs.getString("gcode");
            String itemCode = rs.getString("mcode");
            String name = rs.getString("name");
            String gname = rs.getString("gname");
            long gId = rs.getLong("gid");
            long initId = rs.getLong("satuan");
            String unit = "";
            double qty = rs.getDouble("xqty");
            double amount = rs.getDouble("xjumlah");
            double price = 0;
            
            if (qty == 0 && amount == 0) {
                price = 0;
            } else if (qty == 0) {
                price = 0;
            } else {
                price = amount / qty;
            }

            try {
                unit = String.valueOf(hUom.get("" + initId));
            } catch (Exception e) {
                unit = "";
            }

            Vector tmpReport = new Vector();
            tmpReport.add(""+gId);
            tmpReport.add(""+groupCode);
            tmpReport.add(""+itemCode);
            tmpReport.add(""+name);
            tmpReport.add(""+unit);
            tmpReport.add(""+qty);
            tmpReport.add(""+price);
            tmpReport.add(""+amount);
            tmpReport.add(""+gname);
            report.add(tmpReport);
            
            if (nomor % 2 == 0) {
                style = "tablearialcell";
            } else {
                style = "tablearialcell1";
            }%>
                                                                                                                            
                                                                                                                            <%if (tmpGid != 0 && tmpGid != gId) {%>
                                                                                                                            <tr height="22"  bgcolor="#cccccc">                                                                                                                                                                                                 
                                                                                                                                <td class="fontarial" colspan="3" align="center"><i>TOTAL PEMAKAIAN <%=grpName%></i></td>                                                                                                                                
                                                                                                                                <td class="fontarial" colspan="3"  align="left" style="padding:3px;">&nbsp;</td>                                                                                                                                                                                                                                                                
                                                                                                                                <td class="fontarial" align="right" style="padding:3px;"><i><%=JSPFormater.formatNumber(subTotal, "###,###.##")%></i></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                            subTotal = 0;
                                                                                                                                        }%>
                                                                                                                            <%
                                                                                                                                        if (tmpGid != gId) {
                                                                                                                                            grpName = gname;
                                                                                                                            %>
                                                                                                                            <tr height="22" bgcolor="#BFD8AF">                                                                                                                                                                                                 
                                                                                                                                <td class="fontarial" align="center"><i><%=groupCode%></i></td>                                                                                                                                
                                                                                                                                <td class="fontarial" colspan="6" align="left" style="padding:3px;"><i><%=gname%></i></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                            nomor = 1;
                                                                                                                                        }
                                                                                                                                        tmpGid = gId;
                                                                                                                            %>
                                                                                                                            <tr height="22">                                                                                                                                                                                                 
                                                                                                                                <td class="<%=style%>" align="center"><%=nomor%>.</td>
                                                                                                                                <%
                                                                                                                                        nomor++;
                                                                                                                                %>
                                                                                                                                <td class="<%=style%>" align="center"><%=itemCode%></td>
                                                                                                                                <td class="<%=style%>" style="padding:3px;"><%=name.toUpperCase()%></td>
                                                                                                                                <td class="<%=style%>" style="padding:3px;"><%=unit.toUpperCase()%></td>
                                                                                                                                <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(qty, "###,###.##")%></td>
                                                                                                                                <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(price, "###,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(amount, "###,###.##")%></td>                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                        subTotal = subTotal + amount;
                                                                                                                                        grandTotal = grandTotal + amount;
                                                                                                                                    }
        if(data){
            session.putValue("REPORT_SALES_GA",report);
        %>
                                                                                                                            <tr height="22"  bgcolor="#cccccc">                                                                                                                                                                                                 
                                                                                                                                <td class="fontarial" colspan="3" align="center"><i>TOTAL PEMAKAIAN <%=grpName%></i></td>                                                                                                                                
                                                                                                                                <td class="fontarial" colspan="3"  align="left" style="padding:3px;">&nbsp;</td>                                                                                                                                                                                                                                                                
                                                                                                                                <td class="fontarial" align="right" style="padding:3px;"><i><%=JSPFormater.formatNumber(subTotal, "###,###.##")%></i></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <% 
                                                                                                                            grandTotal = Math.round(grandTotal);
                                                                                                                            %>
                                                                                                                            <tr height="22"  bgcolor="#cccccc">                                                                                                                                                                                                 
                                                                                                                                <td class="fontarial" colspan="3" align="center"><b><i>GRAND TOTAL</i></b></td>                                                                                                                                
                                                                                                                                <td class="fontarial" colspan="3"  align="left" style="padding:3px;">&nbsp;</td>                                                                                                                                                                                                                                                                
                                                                                                                                <td class="fontarial" align="right" style="padding:3px;"><b><i><%=JSPFormater.formatNumber(grandTotal, "###,###.##")%></i></b></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%if(privPrint){%>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="6">&nbsp;</td>                                                                                                                                                                                                                                                                                        
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="6"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>                                                                                                                                                                                                                                                                                        
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="25" colspan="6">&nbsp;</td>                                                                                                                                                                                                                                                                                        
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                            }
                                                                                                                            }
    } catch (Exception e) {
    }
                                                                                                                            
                                                                                                                            %>
                                                                                                                            
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>  
                                                                                                                <%}%>
                                                                                                                <%} catch (Exception e) {
            }%>
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
