
<%-- 
    Document   : jurnalpaymentcredit
    Created on : Jun 26, 2012, 4:19:21 PM
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
<%@ page import = "com.project.fms.ar.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
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
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            
            if(iJSPCommand == JSPCommand.NONE){
                ignore = 0;
            }

            String whereClause = "";

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if(ignore == 0){
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " cr." + DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME] + " >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and cr." + DbCreditPayment.colNames[DbCreditPayment.COL_PAY_DATETIME] + " <= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 23:59:59'";
            }

            if (locationId != 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " sl." + DbSales.colNames[DbSales.COL_LOCATION_ID] + " = " + locationId;
            }

            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " cr." + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " = " + DbCreditPayment.TYPE_NOT_POSTED;

            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " sl." + DbSales.colNames[DbSales.COL_SALES_TYPE] + " = " + DbSales.TYPE_NON_CONSIGMENT;

            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " sl." + DbSales.colNames[DbSales.COL_TYPE] + " = " + DbSales.TYPE_CREDIT;
            
            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " sl." + DbSales.colNames[DbSales.COL_STATUS] + " = 1 ";            

            Vector listSales = DbSales.getListCreditPayment(whereClause);

            if (iJSPCommand == JSPCommand.POST && periodId != 0) {
                Vector temp = new Vector();
                if (listSales != null && listSales.size() > 0) {
                    for (int i = 0; i < listSales.size(); i++) {
                        
                        SalesPaymentCredit sales = (SalesPaymentCredit) listSales.get(i);
                        int xxx = JSPRequestValue.requestInt(request, "sale_" + sales.getCreditPaymentId());
                        
                        if (xxx == 1) {
                            temp.add(sales);
                        }
                    }
                    if (temp != null && temp.size() > 0) {
                        DbSales.postPaymentCredit(temp,user.getOID(), periodId);
                    }
                }
                listSales = DbSales.getListCreditPayment(whereClause);
            }
%>
<html>
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!masterPriv || !masterPrivView) {%>            
            <%}%>
            
            function cmdPostJournal(){
                document.frmsales.command.value="<%=JSPCommand.POST%>";
                document.frmsales.action="jurnalpaymentcredit.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsales.action="jurnalpaymentcredit.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function setMember(){
                window.open("<%=approot%>/crm/sewatanah/search_customer.jsp?formName=frmsewa_tanah_edit", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");           
            }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listSales.size(); k++) {
                SalesPaymentCredit osl = (SalesPaymentCredit) listSales.get(k);
                 %>
                     document.frmsales.sale_<%=osl.getCreditPaymentId()%>.checked=val.checked;
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Accounting 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Payment Credit<br>
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
                                                                                                                                            <td width="10%" height="14" nowrap>Payment Date</td>
                                                                                                                                            <td colspan="3" height="14"> 
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                                                                        </td> 
                                                                                                                                                        <td>&nbsp;<input type="checkbox" name="ignore" value="1" <%if(ignore==1){%> checked<%}%>></td>
                                                                                                                                                        <td>&nbsp;ignore</td>
                                                                                                                                                        <td width="100"></td>     
                                                                                                                                                        <td>Periode</td> 
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
                                                                                                                                                <table width="90%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td class="tablehdr" width="2%" rowspan="2">No</td>
                                                                                                                                                        <td class="tablehdr" width="6%" rowspan="2">Name</td>
                                                                                                                                                        <td class="tablehdr" width="6%" rowspan="2">Date</td>
                                                                                                                                                        <td class="tablehdr" width="6%" rowspan="2">Sales No.</td>
                                                                                                                                                        <td class="tablehdr" width="7%" rowspan="2">Amount</td>
                                                                                                                                                        <td class="tablehdr" width="7%" colspan="2">Payment</td>
                                                                                                                                                        <td class="tablehdr" width="6%" rowspan="2"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablehdr" width="7%">Payment Date</td>
                                                                                                                                                        <td class="tablehdr" width="7%">Amount</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                    int no = 1;

                                                                                                                                    if (listSales != null && listSales.size() > 0) {

                                                                                                                                        long salesId = 0;
                                                                                                                                        double tmpAmount = 0;

                                                                                                                                        for (int i = 0; i < listSales.size(); i++) {

                                                                                                                                            SalesPaymentCredit salesCredit = (SalesPaymentCredit) listSales.get(i);
                                                                                                                                            
                                                                                                                                            String where = DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]+" = "+salesCredit.getSalesId();
                                                                                                                                            Vector vARInv = DbARInvoice.list(0, 1, where, null);
                                                                                                                                            boolean isOk = true;

                                                                                                                                                    %>
                                                                                                                                                    <%if (salesId != salesCredit.getSalesId() && salesId != 0){%>
                                                                                                                                                    <tr >
                                                                                                                                                        <td class="tablecell" colspan="4" align="center"></td>
                                                                                                                                                        <td class="tablecell" align="center"></td>
                                                                                                                                                        <td class="tablecell" align="center"></td>
                                                                                                                                                        <td bgcolor="#5CC8D5" align="right"><%=JSPFormater.formatNumber(tmpAmount, "#,###")%>&nbsp;</td>
                                                                                                                                                        <td class="tablecell" ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr >
                                                                                                                                                        <td align="center" colspan="5"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                                                tmpAmount = 0;
                                                                                                                                                            }
                                                                                                                                                    %>   
                                                                                                                                                    <tr> 
                                                                                                                                                        <%
                                                                                                                                                            if (salesId != salesCredit.getSalesId()) {
                                                                                                                                                        %>
                                                                                                                                                        <td class="tablecell1" align="center"><%=no%></td>
                                                                                                                                                        <td class="tablecell1" ><%=salesCredit.getName()%></td>
                                                                                                                                                        <td class="tablecell1" align="center"><%=JSPFormater.formatDate(salesCredit.getDate(), "dd-MM-yyyy")%></td>
                                                                                                                                                        <%
                                                                                                                                                        if(salesCredit.getStatus() == 0){
                                                                                                                                                            isOk = false;
                                                                                                                                                        %>                                                                                                                                                        
                                                                                                                                                            <td bgcolor="FF0000" align="center"><%=salesCredit.getNumber()%></td>
                                                                                                                                                        <%} else if(vARInv == null || vARInv.size() <= 0){ 
                                                                                                                                                            isOk = false;
                                                                                                                                                        %>
                                                                                                                                                            <td bgcolor="F5D93C" align="center"><%=salesCredit.getNumber()%></td>
                                                                                                                                                        <%}else{%>
                                                                                                                                                            <td class="tablecell1" align="center"><%=salesCredit.getNumber()%></td>    
                                                                                                                                                        <%}%>    
                                                                                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(salesCredit.getAmount(), "#,###")%>&nbsp;</td>
                                                                                                                                                        <%
                                                                                                                                                            no++;
                                                                                                                                                        } else {
                                                                                                                                                        %>
                                                                                                                                                        <td class="tablecell" align="center">&nbsp;</td>
                                                                                                                                                        <td class="tablecell" >&nbsp;</td>
                                                                                                                                                        <td class="tablecell" align="center">&nbsp;</td>
                                                                                                                                                        <td class="tablecell" align="center">&nbsp;</td>
                                                                                                                                                        <td class="tablecell" align="right">&nbsp;</td>
                                                                                                                                                        <%
                                                                                                                                                            }
                                                                                                                                                            salesId = salesCredit.getSalesId();
                                                                                                                                                        %>
                                                                                                                                                        <td class="tablecell1" align="center"><%=JSPFormater.formatDate(salesCredit.getPaymentDateTime(), "dd-MM-yyyy")%></td>
                                                                                                                                                        <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(salesCredit.getAmountCredit(), "#,###")%>&nbsp;</td>
                                                                                                                                                        <td class="tablecell1" align="center">
                                                                                                                                                            <%if(isOk){%>
                                                                                                                                                            <input type="checkbox" name="sale_<%=salesCredit.getCreditPaymentId()%>" value="1"></td>
                                                                                                                                                            <%}%>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                                            tmpAmount = tmpAmount + salesCredit.getAmountCredit();
                                                                                                                                                        }%>
                                                                                                                                                    <tr height="5">
                                                                                                                                                        <td class="tablecell" colspan="4" align="center"></td>
                                                                                                                                                        <td class="tablecell" align="center"></td>
                                                                                                                                                        <td class="tablecell" align="center"></td>
                                                                                                                                                        <td bgcolor="#5CC8D5" align="right"><%=JSPFormater.formatNumber(tmpAmount, "#,###")%>&nbsp;</td>
                                                                                                                                                        <td class="tablecell" ></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="5">
                                                                                                                                                        <td align="center" colspan="5"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    
                                                                                                                                                    <%
                                                                                                                                        tmpAmount = 0;
                                                                                                                                    }%>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td colspan="13" height="5"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td colspan="13">&nbsp;</td>
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
                                                                                                                            <%if (iJSPCommand == JSPCommand.NONE) { %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" class="page">  
                                                                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablecell1" >&nbsp;Click search to show the data</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>   
                                                                                                                            <%}%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" class="command"> 
                                                                                                                                    <span class="command"> 
                                                                                                                                </span> </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="3" height="15"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="3">Information :</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="3" height="5"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="15"> 
                                                                                                                                            <td width="30" bgcolor="#FF0000">&nbsp;</td>
                                                                                                                                            <td width="10" align="center">:</td>
                                                                                                                                            <td >Data sales not yet posted</td>
                                                                                                                                        </tr>                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="3" height="5"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="15"> 
                                                                                                                                            <td bgcolor="#F5D93C">&nbsp;</td>
                                                                                                                                            <td align="center">:</td>
                                                                                                                                            <td >Invoice credit not exist</td>
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
