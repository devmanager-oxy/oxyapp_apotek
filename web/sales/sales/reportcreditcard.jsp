
<%-- 
    Document   : reportcreditcard
    Created on : Mar 1, 2015, 10:59:06 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "java.sql.ResultSet" %> 
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.fms.master.*" %>
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

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long bankId = JSPRequestValue.requestLong(request, "src_bank_id");

            if (session.getValue("REPORT_CARD") != null) {
                session.removeValue("REPORT_CARD");
            }

            if (session.getValue("REPORT_CARD_PARAMETER") != null) {
                session.removeValue("REPORT_CARD_PARAMETER");
            }

            if (tanggal == null) {
                tanggal = new Date();
            }

            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }

            Vector vpar = new Vector();
            vpar.add("" + locationId);
            vpar.add("" + JSPFormater.formatDate(tanggal, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(tanggalEnd, "dd/MM/yyyy"));
            vpar.add("" + user.getFullName());
            vpar.add("" + bankId);

            Vector report = new Vector();
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
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.ReportCardXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="reportcreditcard.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                            <span class="lvl2">Report Credit Card<br>
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
                                                                                                                                            <td width="80" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td width="2" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr size="23"> 
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Date</td>
                                                                                                                                            <td class="fontarial">:</td>
                                                                                                                                            <td colspan="2" > 
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                                                                        </td>
                                                                                                                                                        <td>&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr size="23">
                                                                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                                                            <td class="fontarial">:</td>
                                                                                                                                            <td colspan="2">
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>          
                                                                                                                                                <select name="src_location_id" class="fontarial" onChange="javascript:cmdchange()">                                                                                                                                                           
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
                                                                                                                                        <tr size="23">
                                                                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Bank</td>
                                                                                                                                            <td class="fontarial">:</td>
                                                                                                                                            <td colspan="2">
                                                                                                                                                <%
            Vector banks = DbBank.list(0, 0, "", DbBank.colNames[DbBank.COL_NAME]);
                                                                                                                                                %>          
                                                                                                                                                <select name="src_bank_id" class="fontarial">                                                                                                                                                           
                                                                                                                                                    <%if (banks != null && banks.size() > 0) {
                for (int i = 0; i < banks.size(); i++) {
                    Bank bank = (Bank) banks.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=bank.getOID()%>" <%if (bank.getOID() == bankId) {%>selected<%}%>><%=bank.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>           
                                                                                                                                            </td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr> 
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                            <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>                                                                  </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">&nbsp;</td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                Vector credits = SessReportClosing.getListCard(locationId, bankId, DbMerchant.TYPE_CREDIT_CARD);
                Vector debits = SessReportClosing.getListCard(locationId, bankId, DbMerchant.TYPE_DEBIT_CARD);
                if ((credits != null && credits.size() > 0) || (debits != null && debits.size() > 0)) {
                    double n = 80;
                    double length = 60 + (credits.size() * 6 * 80) + (debits.size() * 6 * 80) + 90;
                    double totalNett = 0;
                    double nilaic[] = new double[20];
                    double biayac[] = new double[20];
                    double nettc[] = new double[20];

                    double nilaid[] = new double[20];
                    double biayad[] = new double[20];
                    double nettd[] = new double[20];
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table width="<%=length%>" border="0" cellspacing="1" cellpadding="0">  
                                                                                                                                                    <tr height="26">                                                                                                 
                                                                                                                                                        <td width="60" class="tablearialhdr" rowspan="2">TANGGAL</td> 
                                                                                                                                                        <%
                                                                                                                                                if (credits != null && credits.size() > 0) {
                                                                                                                                                    for (int i = 0; i < credits.size(); i++) {
                                                                                                                                                        Merchant m = (Merchant) credits.get(i);
                                                                                                                                                        %>
                                                                                                                                                        <td class="tablearialhdr" colspan="6"><%=m.getDescription()%></td>                                                                                                                                                        
                                                                                                                                                        <%}
                                                                                                                                                }%>
                                                                                                                                                        <%
                                                                                                                                                if (debits != null && debits.size() > 0) {
                                                                                                                                                    for (int i = 0; i < debits.size(); i++) {
                                                                                                                                                        Merchant m = (Merchant) debits.get(i);
                                                                                                                                                        %>
                                                                                                                                                        <td class="tablearialhdr" colspan="6"><%=m.getDescription()%></td>                                                                                                                                                        
                                                                                                                                                        <%}
                                                                                                                                                }%>
                                                                                                                                                        <td width="90" class="tablearialhdr" rowspan="2">TOTAL NETT</td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr height="26">                                                                                                                                                                                                                                                         
                                                                                                                                                        <%
                                                                                                                                                if (credits != null && credits.size() > 0) {
                                                                                                                                                    for (int i = 0; i < credits.size(); i++) {
                                                                                                                                                        Merchant m = (Merchant) credits.get(i);
                                                                                                                                                        %>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">NILAI</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr"><%=JSPFormater.formatNumber(m.getPersenExpense(), "###.##")%> %</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">NETT</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">TRANSFER BANK</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">TANGGAL CAIR</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">SELISIH</td>                                                                                                                                                        
                                                                                                                                                        <%}
                                                                                                                                                }%>
                                                                                                                                                        <%
                                                                                                                                                if (debits != null && debits.size() > 0) {
                                                                                                                                                    for (int i = 0; i < debits.size(); i++) {
                                                                                                                                                        Merchant m = (Merchant) debits.get(i);
                                                                                                                                                        %>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">NILAI</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr"><%=JSPFormater.formatNumber(m.getPersenExpense(), "###.##")%> %</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">NETT</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">TRANSFER BANK</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">TANGGAL CAIR</td>
                                                                                                                                                        <td width="<%=n%>" class="tablearialhdr">SELISIH</td>
                                                                                                                                                        <%}
                                                                                                                                                }%>                      
                                                                                                                                                    </tr>      
                                                                                                                                                    <%
                                                                                                                                                try {

                                                                                                                                                    CONResultSet crs = null;

                                                                                                                                                    String where = DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + " 23:59:59' ";
                                                                                                                                                    if (locationId != 0) {
                                                                                                                                                        where = where + " and " + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + locationId;
                                                                                                                                                    }

                                                                                                                                                    String sql = "select date from pos_sales where " + where + " group by year(date),month(date),day(date) order by date";

                                                                                                                                                    String style = "";
                                                                                                                                                    int nomor = 1;

                                                                                                                                                    crs = CONHandler.execQueryResult(sql);
                                                                                                                                                    ResultSet rs = crs.getResultSet();

                                                                                                                                                    while (rs.next()) {
                                                                                                                                                        Vector tmpReport = new Vector();                                                                                                                                                        
                                                                                                                                                        Date tgl = rs.getDate("date");
                                                                                                                                                        tmpReport.add("" + JSPFormater.formatDate(tgl, "dd/MM/yyyy"));
                                                                                                                                                        if (nomor % 2 == 0) {
                                                                                                                                                            style = "tablearialcell";
                                                                                                                                                        } else {
                                                                                                                                                            style = "tablearialcell1";
                                                                                                                                                        }
                                                                                                                                                        double subNett = 0;

                                                                                                                                                    %>
                                                                                                                                                    <tr height="23">                                                                                                                                                        
                                                                                                                                                        <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(tgl, "dd-MMM")%></td>
                                                                                                                                                        <%
                                                                                                                                                            if (credits != null && credits.size() > 0) {
                                                                                                                                                                for (int i = 0; i < credits.size(); i++) {
                                                                                                                                                                    Merchant m = (Merchant) credits.get(i);
                                                                                                                                                                    double amount = SessReportClosing.getAmountCard(locationId, tgl, m.getOID());
                                                                                                                                                                    Date payDt = SessReportClosing.getDatePayment(locationId, tgl, m.getOID());
                                                                                                                                                                    double exp = (m.getPersenExpense() * amount / 100);
                                                                                                                                                                    double net = amount - exp;
                                                                                                                                                                    subNett = subNett + net;

                                                                                                                                                                    nilaic[i] = nilaic[i] + amount;
                                                                                                                                                                    biayac[i] = biayac[i] + exp;
                                                                                                                                                                    nettc[i] = nettc[i] + net;
                                                                                                                                                                    
                                                                                                                                                                    String strPayDt = "";
                                                                                                                                                                    if(payDt != null){
                                                                                                                                                                        strPayDt = JSPFormater.formatDate(payDt, "dd-MM-yyyy");
                                                                                                                                                                    }

                                                                                                                                                        %>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(amount, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(exp, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(net, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;">&nbsp;</td>
                                                                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><%=strPayDt%></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                        <%}
                                                                                                                                                            }%>
                                                                                                                                                        <%
                                                                                                                                                            if (debits != null && debits.size() > 0) {
                                                                                                                                                                for (int i = 0; i < debits.size(); i++) {
                                                                                                                                                                    Merchant m = (Merchant) debits.get(i);
                                                                                                                                                                    double amount = SessReportClosing.getAmountCard(locationId, tgl, m.getOID());
                                                                                                                                                                    Date payDt = SessReportClosing.getDatePayment(locationId, tgl, m.getOID());
                                                                                                                                                                    double exp = (m.getPersenExpense() * amount / 100);
                                                                                                                                                                    double net = amount - exp;
                                                                                                                                                                    subNett = subNett + net;

                                                                                                                                                                    nilaid[i] = nilaid[i] + amount;
                                                                                                                                                                    biayad[i] = biayad[i] + exp;
                                                                                                                                                                    nettd[i] = nettd[i] + net;
                                                                                                                                                                    
                                                                                                                                                                    String strPayDt = "";
                                                                                                                                                                    if(payDt != null){
                                                                                                                                                                        strPayDt = JSPFormater.formatDate(payDt, "dd-MM-yyyy");
                                                                                                                                                                    }
                                                                                                                                                        %>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(amount, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(exp, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(net, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;">&nbsp;</td>
                                                                                                                                                        <td class="<%=style%>" align="center" style="padding:3px;"><%=strPayDt%></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                        <%}
                                                                                                                                                            }
                                                                                                                                                            totalNett = totalNett + subNett;
                                                                                                                                                        %>
                                                                                                                                                        
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(subNett, "###,###.##") %></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%

                                                                                                                                                            nomor = nomor + 1;
                                                                                                                                                            report.add(tmpReport);
                                                                                                                                                        }

                                                                                                                                                        if (nomor != 1) {
                                                                                                                                                    %>    
                                                                                                                                                    <tr height="23">                                                                                                                                                        
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="center"><b>Total</b></td>
                                                                                                                                                        <%
                                                                                                                                                       if (credits != null && credits.size() > 0) {
                                                                                                                                                           for (int i = 0; i < credits.size(); i++) {
                                                                                                                                                               Merchant m = (Merchant) credits.get(i);
                                                                                                                                                        %>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(nilaic[i], "###,###.##") %></td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(biayac[i], "###,###.##") %></td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(nettc[i], "###,###.##") %></td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;">&nbsp;</td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;">&nbsp;</td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                        <%}
                                                                                                                                                       }%>
                                                                                                                                                        <%
                                                                                                                                                       if (debits != null && debits.size() > 0) {
                                                                                                                                                           for (int i = 0; i < debits.size(); i++) {
                                                                                                                                                               Merchant m = (Merchant) debits.get(i);
                                                                                                                                                        %>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(nilaid[i], "###,###.##") %></td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(biayad[i], "###,###.##") %></td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(nettd[i], "###,###.##") %></td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;">&nbsp;</td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;">&nbsp;</td>
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                        <%}
                                                                                                                                                       }
                                                                                                                                                        %>
                                                                                                                                                        
                                                                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalNett, "###,###.##") %></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                                    if (privPrint) {
                                                                                                                                                         session.putValue("REPORT_CARD",report);
                                                                                                                                                         session.putValue("REPORT_CARD_PARAMETER",vpar);
                                                                                                                                                    %>
                                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                                        <td height="22" valign="middle" colspan="7"> 
                                                                                                                                                            &nbsp;
                                                                                                                                                        </td>     
                                                                                                                                                    </tr>                                                                                                                                                      
                                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                                        <td height="22" valign="middle" colspan="7"> 
                                                                                                                                                            <a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                                        </td>     
                                                                                                                                                    </tr>  
                                                                                                                                                    <%}%>
                                                                                                                                                    
                                                                                                                                                    <%
                                                                                                                                                    }

                                                                                                                                                } catch (Exception e) {
                                                                                                                                                }
                                                                                                                                                    %>
                                                                                                                                                    
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                            } else {
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4" class="fontarial"><i>Data not found ...</i></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        } else {%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4" class="fontarial">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4" class="fontarial"><i>Click search button to searching the data .. </i></td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%}%>
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
