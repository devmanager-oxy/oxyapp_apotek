
<%-- 
    Document   : salesbonus
    Created on : Aug 21, 2015, 10:10:30 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_BONUS);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_BONUS, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_BONUS, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            double persen = 0;
            try {
                persen = Double.parseDouble(DbSystemProperty.getValueByName("PERSENTASE_BONUS_SALES"));
            } catch (Exception e) {
            }
            if (session.getValue("REPORT_SALES_BONUS") != null) {
                session.removeValue("REPORT_SALES_BONUS");
            }

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            Vector listUser = DbUser.listPartObj(0, 0, "", null);
            Hashtable hash = new Hashtable();
            if (listUser != null && listUser.size() > 0) {
                for (int i = 0; i < listUser.size(); i++) {
                    User ux = (User) listUser.get(i);
                    hash.put(String.valueOf(ux.getOID()), String.valueOf(ux.getFullName()));
                }
            }
            
            ReportParameter rp = new ReportParameter();
            rp.setDateFrom(invStartDate);
            rp.setDateTo(invEndDate);
            rp.setLocationId(locationId);
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
            
            function cmdPrintXLS(){	                       
                window.open("<%=printroot%>.report.ReportSalesBonusXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="salesbonus.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Sales Bonus<br>
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
                                                                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="400">                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td >                                                                                                                                                
                                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="4" height="10"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td colspan="3" height="14" class="fontarial"><i><b>Searching Parameter :</b></i></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td width="100" nowrap class="tablearialcell">&nbsp;&nbsp;Date Between</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td > 
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>
                                                                                                                                                                    <td class="fontarial">
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
                                                                                                                                                        <td width="5" height="14" nowrap></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                                                                        <td class="fontarial">:</td>
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
                                                                                                                                                        <td width="5" height="14" nowrap></td>
                                                                                                                                                    </tr>                                                                                                                                                                                                                                                                                                                                                                           
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                      
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>      
                                                                                                                            <tr>
                                                                                                                                <td colspan="4">
                                                                                                                                    <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">
                                                                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                                                                </td> 
                                                                                                                            </tr>    
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="20" valign="middle" colspan="4"></td> 
                                                                                                                            </tr>    
                                                                                                                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {

                String where = "";
                if (locationId != 0) {
                    where = DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + locationId;
                }

                Vector locations = DbLocation.list(0, 0, where, DbLocation.colNames[DbLocation.COL_NAME]);

                double grandSales = 0;
                double grandBonus = 0;

                if (locations != null && locations.size() > 0) {
                    for (int i = 0; i < locations.size(); i++) {
                        Location l = (Location) locations.get(i);
                        try {
                            CONResultSet crs = null;
                            where = " and ps." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + l.getOID();
                            String sql = "select locationid, user_id,name,sum(omset) as xomset,sum(hpp) as xhpp from ( " +
                                    " select ps.type,l.location_id as locationid, l.name as name, ps.marketing_id as user_id,sum((psd.qty * psd.selling_price)- psd.discount_amount) as omset ,sum( psd.qty * psd.cogs) as hpp  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_location l on ps.location_id = l.location_id " +
                                    " where ps.type in (0,1) " + where + " and ps.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00'  and ps.date <= '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59;59' group by ps.marketing_id union " +
                                    " select ps.type,l.location_id as locationid, l.name as name, ps.marketing_id as user_id,sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as omset ,sum( psd.qty * psd.cogs)*-1 as hpp  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_location l on ps.location_id = l.location_id " +
                                    " where ps.type in (2,3) " + where + " and ps.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00'  and ps.date <= '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59;59' group by ps.marketing_id ) as x group by user_id ";
                            crs = CONHandler.execQueryResult(sql);
                            ResultSet rs = crs.getResultSet();

                            Vector datas = new Vector();
                            double total = 0;
                            while (rs.next()) {
                                double amount = rs.getDouble("xomset");
                                long userId = rs.getLong("user_id");
                                total = total + amount;

                                Vector tmp = new Vector();
                                tmp.add(String.valueOf(userId));
                                tmp.add(String.valueOf(amount));
                                datas.add(tmp);
                            }

                            double totalBonus = 0;
                            if (l.getAmountTarget() < total) {
                                totalBonus = (persen * total) / 100;
                            }


                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="20" valign="middle" colspan="4">
                                                                                                                                    <table width="800" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="5">
                                                                                                                                                <table border="0" cellspacing="1" cellpadding="0">
                                                                                                                                                    <tr >
                                                                                                                                                        <td class="tablearialcell" style="padding:3px;" width="100">Location</td>
                                                                                                                                                        <td width="1">:</td>
                                                                                                                                                        <td class="fontarial"><%=l.getName()%></td>
                                                                                                                                                        <td class="tablearialcell" style="padding:3px;" width="100">Persentase Bonus</td>
                                                                                                                                                        <td width="1">:</td>
                                                                                                                                                        <td class="fontarial" width="50"><%=JSPFormater.formatNumber(persen, "###,###.##")%> %</td>
                                                                                                                                                    </tr>  
                                                                                                                                                    <tr >
                                                                                                                                                        <td class="tablearialcell" style="padding:3px;" width="100">Target Omset</td>
                                                                                                                                                        <td width="1">:</td>
                                                                                                                                                        <td class="fontarial" width="300"><%=JSPFormater.formatNumber(l.getAmountTarget(), "###,###.##")%></td>
                                                                                                                                                        <td class="tablearialcell" style="padding:3px;" width="100">Total Bonus</td>
                                                                                                                                                        <td width="1">:</td>
                                                                                                                                                        <td class="fontarial"><%=JSPFormater.formatNumber(totalBonus, "###,###.##")%></td>
                                                                                                                                                    </tr>       
                                                                                                                                                    <tr >
                                                                                                                                                        <td colspan="3" height="3"></td>
                                                                                                                                                    </tr>  
                                                                                                                                                </table>    
                                                                                                                                            </td>    
                                                                                                                                        </tr>    
                                                                                                                                        <tr>
                                                                                                                                            <td width="25" class="tablearialhdr">No</td>
                                                                                                                                            <td class="tablearialhdr">Cashier</td>
                                                                                                                                            <td width="130" class="tablearialhdr">Total Sales</td>
                                                                                                                                            <td width="130" class="tablearialhdr">Bonus (%)</td>
                                                                                                                                            <td width="130" class="tablearialhdr">Bonus (Value)</td>
                                                                                                                                        </tr>
                                                                                                                                        <%

                                                                                                                                            int no = 1;
                                                                                                                                            double subTotal = 0;
                                                                                                                                            double subPersen = 0;
                                                                                                                                            double subBonus = 0;
                                                                                                                                            for (int ix = 0; ix < datas.size(); ix++) {

                                                                                                                                                Vector tx = (Vector) datas.get(ix);
                                                                                                                                                double amount = Double.parseDouble(String.valueOf(tx.get(1)));
                                                                                                                                                String fullName = "";
                                                                                                                                                long userId = Long.parseLong(String.valueOf(tx.get(0)));
                                                                                                                                                try {
                                                                                                                                                    fullName = String.valueOf(hash.get(String.valueOf(userId)));
                                                                                                                                                } catch (Exception e) {
                                                                                                                                                    fullName = "";
                                                                                                                                                }
                                                                                                                                                if(fullName.equals("null")){
                                                                                                                                                    fullName = "";
                                                                                                                                                }

                                                                                                                                                String style = "";
                                                                                                                                                if (no % 2 == 0) {
                                                                                                                                                    style = "tablearialcell";
                                                                                                                                                } else {
                                                                                                                                                    style = "tablearialcell1";
                                                                                                                                                }

                                                                                                                                                double bonusPersonal = 0;
                                                                                                                                                double persenPersonal = 0;
                                                                                                                                                if (l.getAmountTarget() < total) {
                                                                                                                                                    persenPersonal = (amount * 100) / total;
                                                                                                                                                    bonusPersonal = (persenPersonal * totalBonus) / 100;
                                                                                                                                                    subPersen = subPersen + persenPersonal;
                                                                                                                                                    subBonus = subBonus + bonusPersonal;
                                                                                                                                                    grandBonus = grandBonus + bonusPersonal;
                                                                                                                                                }
                                                                                                                                                subTotal = subTotal + amount;
                                                                                                                                                grandSales = grandSales + amount;

                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td class="<%=style%>" align="center"><%=no%></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" > <%=fullName%></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(amount, "###,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(persenPersonal, "###,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(bonusPersonal, "###,###.##") %></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                                no++;
                                                                                                                                            }
                                                                                                                                            if (no > 1) {
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" align="center" colspan="2"><b>Total</b></td>                                                                                                                                            
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(subTotal, "###,###.##") %></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(subPersen, "###,###.##") %></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(subBonus, "###,###.##") %></b></td>
                                                                                                                                        </tr>                                                                                                                                      
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr >
                                                                                                                                            <td colspan="5" class="tablearialcell" style="padding:3px;"><font color="#FF0000"><i>&nbsp;Data not found</i></font></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <tr height="35">
                                                                                                                                            <td colspan="5"></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                        </tr> 
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>    
                                                                                                                            <%


                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                            %>
                                                                                                                            
                                                                                                                            <%}%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" > 
                                                                                                                                    <table width="800" border="0" cellspacing="1" cellpadding="0">                                                                                                                                        
                                                                                                                                        <tr height="25">
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" align="center" colspan="2"><b>Grand Total</b></td>                                                                                                                                            
                                                                                                                                            <td bgcolor="#cccccc" width="130" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(grandSales, "###,###.##") %></b></td>
                                                                                                                                            <td bgcolor="#cccccc" width="135" class="fontarial" style="padding:3px;" align="right"></td>
                                                                                                                                            <td bgcolor="#cccccc" width="135" class="fontarial" style="padding:3px;" align="right"><b><%=JSPFormater.formatNumber(grandBonus, "###,###.##") %></b></td>
                                                                                                                                        </tr> 
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                                if (privPrint) {
                                                                                                                                     session.putValue("REPORT_SALES_BONUS",rp);
                                                                                                                                    %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                                                                    &nbsp;
                                                                                                                                </td>     
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                                                                    <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr> 
                                                                                                                            <%}%>
                                                                                                                            <%} else {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" > 
                                                                                                                                    <i>Klik search button to seraching the data ....</i>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
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
