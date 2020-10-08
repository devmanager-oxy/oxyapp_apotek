
<%-- 
    Document   : cashback
    Created on : May 16, 2015, 11:19:37 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>  
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>  
<%@ page import = "com.project.util.*" %>  
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.interfaces.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_CASH_BACK_TRANSACTION);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_CASH_BACK_TRANSACTION, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_CASH_BACK_TRANSACTION, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_CASH_BACK_TRANSACTION, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_CASH_BACK_TRANSACTION, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_CASH_BACK_TRANSACTION, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidMemberPoint = JSPRequestValue.requestLong(request, "hidden_member_point_id");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            int pointType = JSPRequestValue.requestInt(request, "point_type");
            int groupBy = JSPRequestValue.requestInt(request, "group_by");
            int orderBy = JSPRequestValue.requestInt(request, "order_by");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long totalSales = JSPRequestValue.requestLong(request, "src_total_sales");            

            if (session.getValue("REPORT_POINT_CASH_BACK_XLS") != null) {
                session.removeValue("REPORT_POINT_CASH_BACK_XLS");
            }

            if (session.getValue("REPORT_POINT_CASH_BACK_XLS_PARAMETER") != null) {
                session.removeValue("REPORT_POINT_CASH_BACK_XLS_PARAMETER");
            }

            if (iJSPCommand == JSPCommand.NONE) {
                pointType = 1;
                totalSales = 1;
            }

            String srcDate = JSPRequestValue.requestString(request, "src_start_date");
            String srcDateEnd = JSPRequestValue.requestString(request, "src_end_date");
            long oidPublic = 0;
            try{
                oidPublic = Long.parseLong(DbSystemProperty.getValueByName("OID_CUSTOMER_PUBLIC"));
            }catch(Exception e){}

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if (iJSPCommand != JSPCommand.NONE) {
                srcStartDate = JSPFormater.formatDate(srcDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcDateEnd, "dd/MM/yyyy");
            }

            Vector print = new Vector();

            Vector locations = new Vector();
            locations = DbLocation.listAll();
            Hashtable hash = new Hashtable();
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location l = (Location) locations.get(i);
                    hash.put("" + l.getOID(), l.getName());
                }
            }

            Vector vpar = new Vector();
            vpar.add("" + locationId);
            vpar.add("" + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy"));
            vpar.add("" + srcCode);
            vpar.add("" + srcName);
            vpar.add("" + user.getFullName());

            Vector report = new Vector();
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
                window.open("<%=printroot%>.report.RptCashBackXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmmemberpoint.hidden_member_point_id.value="0";
                    document.frmmemberpoint.command.value="<%=JSPCommand.POST%>";
                    document.frmmemberpoint.prev_command.value="<%=prevJSPCommand%>";
                    document.frmmemberpoint.action="cashback.jsp";
                    document.frmmemberpoint.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmemberpoint" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_member_point_id" value="<%=oidMemberPoint%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                    <tr valign="bottom"> 
                                                                                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report </font><font class="tit1">&raquo; 
                                                                                                        </font><span class="lvl2">Cash Back</span></b></td>
                                                                                                        <td width="40%" height="23"> 
                                                                                                            <%@ include file = "../main/userpreview.jsp" %>
                                                                                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr > 
                                                                                                        <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" >
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <%
            Vector vLoc = userLocations;
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="160" class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td width="300">
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
                                                                                                        <td width="130" class="tablearialcell">&nbsp;&nbsp;Sales Period</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td height="18"><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmemberpoint.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                    
                                                                                                                    <td height="18">&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                                                                                                    <td ><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmemberpoint.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>   
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Barcode</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="src_code" value="<%=srcCode%>" size="25" class="fontarial"></td>
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Member Name</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="src_name" value="<%=srcName%>" size="25" class="fontarial"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Sales Or Cash Back Out Not 0</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td ><input type="checkbox" name="src_total_sales" value="1" <%if(totalSales ==1){%> checked <%}%> >&nbsp; Only</td>
                                                                                                        <td colspan="3"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('src21','','../images/search2.gif',1)"><img src="../images/search.gif" name="src21" border="0"></a></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="25" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="1300" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="25" class="tablearialhdr">No</td>
                                                                                                        <td width="80" class="tablearialhdr">ID/Barcode</td>
                                                                                                        <td class="tablearialhdr">Name</td>
                                                                                                        <td class="tablearialhdr" width="80">Reg. Date</td>
                                                                                                        <td class="tablearialhdr" width="160">Location Reg.</td>
                                                                                                        <td width="80" class="tablearialhdr">Address</td>
                                                                                                        <td width="80" class="tablearialhdr">Telp</td>
                                                                                                        <td width="80" class="tablearialhdr">Email</td>
                                                                                                        <td width="80" class="tablearialhdr">Saldo Until<BR>(<%=JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy")%> )</td>
                                                                                                        <td width="80" class="tablearialhdr">Total Sales</td>
                                                                                                        <td width="80" class="tablearialhdr">Cash Back In</td>
                                                                                                        <td width="80" class="tablearialhdr">Cash Back Out</td>
                                                                                                        <td width="80" class="tablearialhdr">Saldo</td>
                                                                                                    </tr>
                                                                                                    <%
            if (iJSPCommand == JSPCommand.POST) {
                int no = 1;

                try {
                    CONResultSet dbrs = null;

                    String wherem = "";
                    String wheres = "";

                    if (locationId != 0) {
                        wherem = wherem + " and location_id = " + locationId;
                        wheres = wheres + " and ps.location_id = " + locationId;
                    }

                    String sql =
                            "select cx.customer_id as customer_id,c.code as code,c.kecamatan_id as kecamatan_id,c.name as name,c.address as address,c.hp as hp,c.email as email,c.reg_date as reg_date,saldo,penjualan,point_in,point_out from " +
                            "(select customer_id,sum(saldo) as saldo,sum(penjualan) as penjualan,sum(point_in) as point_in,sum(point_out)*-1 as point_out from (" +
                            "select customer_id,sum(point*in_out) as saldo,0 as penjualan,0 as point_in,0 as point_out from pos_member_point where type in (0,1,2,3,4) and date < '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and point != 0 group by customer_id union " +
                            
                            //" select ps.customer_id as customer_id,0 as saldo,sum((psd.qty * psd.selling_price)- psd.discount_amount) as penjualan,0 as point_in,0 as point_out from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                            //" where ps.type in (0,1) and ps.customer_id != "+oidPublic+" " + wheres + " and ps.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' group by ps.customer_id union " +                            
                            //" select ps.customer_id as customer_id,0 as saldo,sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as penjualan,0 as point_in,0 as point_out from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                            //" where ps.type in (2,3) and ps.customer_id != "+oidPublic+" " + wheres + " and ps.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' group by ps.customer_id union " +
                            
                            
                            " select customer_id as customer_id,0 as saldo,0 as penjualan,sum(in_out * point) as point_in,0 as point_out from pos_member_point where type = 3 and date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and in_out = 1 and point != 0 " + wherem + " group by customer_id union " +                            
                            //" select m.customer_id as customer_id,0 as saldo,0 as penjualan,sum(m.in_out * m.point) as point_in,0 as point_out from pos_member_point m inner join pos_sales ps on m.sales_id = ps.sales_id where m.type = 0 and m.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and m.point != 0 " + wheres + " group by m.customer_id union " +                            
                            " select m.customer_id as customer_id,0 as saldo,0 as penjualan,sum(m.in_out * m.point) as point_in,0 as point_out from pos_member_point m where m.type = 0 and m.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and m.point != 0 " + wherem + " group by m.customer_id union " +                            
                            
                            " select customer_id as customer_id,0 as saldo,0 as penjualan,0 as point_in,sum(in_out * point) as point_out from pos_member_point where type in (2,4) and date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and in_out = -1 and point != 0 " + wherem + " group by customer_id union " +
                            " select m.customer_id as customer_id,0 as saldo,0 as penjualan,0 as point_in,sum(m.in_out * m.point) as point_out from pos_member_point m where m.type = 1 and in_out = -1 and m.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' and m.point != 0 " + wheres + " group by m.customer_id ) as x group by customer_id ) as cx inner join customer c on cx.customer_id = c.customer_id where c.type in (" + DbCustomer.CUSTOMER_TYPE_REGULAR + "," + DbCustomer.CUSTOMER_TYPE_COMMON_AREA + ")";

                    if (srcCode != null && srcCode.length() > 0) {
                        sql = sql + " and c.code like '%" + srcCode.toLowerCase().trim() + "%'";
                    }

                    if (srcName != null && srcName.length() > 0) {
                        sql = sql + " and c.name like '%" + srcName.toLowerCase().trim() + "%'";
                    }

                    sql = sql + "order by saldo desc";

                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();

                    String style = "tablearialcell1";

                    double sumSaldo = 0;
                    double sumSales = 0;
                    double sumPoint = 0;
                    double sumCashBack = 0;
                    double sumEnding = 0;
                    
                    Hashtable hashPenjualan = InterfaceMember.getPenjualan(oidPublic, wheres, srcStartDate, srcEndDate); 

                    while (rs.next()) {
                        if (no % 2 == 0) {
                            style = "tablearialcell1";
                        } else {
                            style = "tablearialcell";
                        }
                        long customerId = rs.getLong("customer_id");
                        double penjualan = 0;
                        try{
                            penjualan = Double.parseDouble(String.valueOf(hashPenjualan.get(String.valueOf(customerId))));
                        }catch(Exception e){}
                        String name = rs.getString("name");
                        String code = rs.getString("code");
                        String address = rs.getString("address");
                        String hp = rs.getString("hp");
                        Date regDate = rs.getDate("reg_date");
                        String email = rs.getString("email");
                        double saldo = rs.getDouble("saldo");
                        //double penjualan = rs.getDouble("penjualan");
                        double pointIn = rs.getDouble("point_in");
                        double pointOut = rs.getDouble("point_out");
                        long kecId = rs.getLong("kecamatan_id");                        
                        
                        boolean kondisiOk = false;
                        
                        if(totalSales ==1){// jika yang dipilih hanya ada transaksi penjualan dan point keluar
                            if (penjualan != 0 || pointIn != 0 || pointOut != 0) {
                                kondisiOk = true;
                            }
                        }else{ // jika yang dipilih hanya semua transaksi
                            if (saldo != 0 || penjualan != 0 || pointIn != 0 || pointOut != 0) {
                                kondisiOk = true;
                            }
                        }

                        if (kondisiOk) {

                            sumSaldo = sumSaldo + saldo;
                            sumSales = sumSales + penjualan;
                            sumPoint = sumPoint + pointIn;
                            sumCashBack = sumCashBack + pointOut;

                            String strReg = "";
                            String locName = "";
                            if (regDate != null) {
                                try {
                                    strReg = JSPFormater.formatDate(regDate, "dd/MM/yyyy");
                                } catch (Exception e) {
                                }
                            }

                            if (kecId != 0) {
                                try {
                                    locName = "" + hash.get("" + kecId);
                                } catch (Exception e) {
                                }
                            }
                            
                            double ending = saldo + pointIn - pointOut;
                            sumEnding = sumEnding + ending; 
                            
                            Vector tmpReport = new Vector();
                            tmpReport.add(code);
                            tmpReport.add(name);
                            tmpReport.add(strReg);
                            tmpReport.add(locName);
                            tmpReport.add(address);
                            tmpReport.add("" + hp);
                            tmpReport.add("" + email);
                            tmpReport.add(JSPFormater.formatNumber(saldo, "###.##"));
                            tmpReport.add(JSPFormater.formatNumber(penjualan, "###.##"));
                            tmpReport.add(JSPFormater.formatNumber(pointIn, "###.##"));
                            tmpReport.add(JSPFormater.formatNumber(pointOut, "###.##"));
                            tmpReport.add(JSPFormater.formatNumber(ending, "###.##"));
                            report.add(tmpReport);
                                                                                                    %>    
                                                                                                    <tr> 
                                                                                                        <td class="<%=style%>" align="center"><font size="1"><%=no%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><font size="1"><%=code%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><font size="1"><%=name%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="center"><font size="1"><%=strReg%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><font size="1"><%=locName%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><font size="1"><%=address%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><font size="1"><%=hp%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px"><font size="1"><%=email%></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(saldo, "###,###.##") %></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(penjualan, "###,###.##") %></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(pointIn, "###,###.##") %></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(pointOut, "###,###.##") %></font></td>
                                                                                                        <td class="<%=style%>" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(ending, "###,###.##") %></font></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                                    no++;
                                                                                                                }
                                                                                                            }
                                                                                                            if (no > 1) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC" align="center" colspan="8">&nbsp;</td>                                                                                                        
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(sumSaldo, "###,###.##") %></font></td>
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(sumSales, "###,###.##") %></font></td>
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(sumPoint, "###,###.##") %></font></td>
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(sumCashBack, "###,###.##") %></font></td>
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC" style="padding:3px" align="right"><font size="1"><%=JSPFormater.formatNumber(sumEnding, "###,###.##") %></font></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                            }

                                                                                                        } catch (Exception e) {
                                                                                                        }


                                                                                                        if (no > 1) {

                                                                                                    %>                                                                                                    
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="5">&nbsp;</td>     
                                                                                                    </tr> 
                                                                                                    <%
                                                                                                    if (privPrint) {
                                                                                                        session.putValue("REPORT_POINT_CASH_BACK_XLS_PARAMETER", vpar);
                                                                                                        session.putValue("REPORT_POINT_CASH_BACK_XLS", report);
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="5">                                                                                                                                                 
                                                                                                            <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                        </td>     
                                                                                                    </tr> 
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="25" valign="middle" colspan="5">&nbsp;</td>     
                                                                                                    </tr> 
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                    <%} else {%>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="5" class="fontarial">                                                                                                                                                 
                                                                                                            <i>Click search button to searching the data</i>
                                                                                                        </td>     
                                                                                                    </tr> 
                                                                                                    <%}%>
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
                                                        </form>
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
