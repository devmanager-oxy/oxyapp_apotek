
<%-- 
    Document   : jurnalsales
    Created on : Jun 5, 2014, 12:52:52 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.fms.transaction.DbGl" %>
<%@ page import = "com.project.fms.transaction.Gl" %>
<%@ page import = "com.project.fms.transaction.DbGlDetail" %>
<%@ page import = "com.project.fms.transaction.GlDetail" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_PROCESS_JOURNAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_PROCESS_JOURNAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_PROCESS_JOURNAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_ACCOUNTING, AppMenu.M2_SAL_PROCESS_JOURNAL, AppMenu.PRIV_ADD);
            
%>
<!-- Jsp Block -->
<%

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long cashCashierId = JSPRequestValue.requestLong(request, "shift_name");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long periodId = JSPRequestValue.requestLong(request, "period");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            long deffCurrIDR = 0;
            int stockable = 0;
            try {
                deffCurrIDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
            } catch (Exception e) {
            }

            try {
                stockable = Integer.parseInt(DbSystemProperty.getValueByName("STOCKABLE_DEFAULT"));
            } catch (Exception e) {
            }

            if (tanggal == null) {
                tanggal = new Date();
            }

            Vector locations = DbSegmentDetail.listLocation(user.getOID());
            if (locationId == 0 && locations != null && locations.size() > 0) {
                Location l = (Location) locations.get(0);
                locationId = l.getOID();
            }

            Vector vShift = DbSales.getShift(locationId, tanggal, 1);
            boolean matching = false;
            if (vShift != null && vShift.size() > 0) {
                long tmpCashCashierId = 0;
                for (int i = 0; i < vShift.size(); i++) {
                    Shift shift = (Shift) vShift.get(i);
                    if (i == 0) {
                        tmpCashCashierId = shift.getOID();
                    }
                    if (shift.getOID() == cashCashierId) {
                        matching = true;
                    }
                }
                if (cashCashierId == 0 || matching == false) {
                    cashCashierId = tmpCashCashierId;
                }
            }

            Vector list = new Vector();
            boolean isPosted = false;
            boolean isCoaComplete = true;
            Vector ccCredits = new Vector();
            Vector ccDebits = new Vector();
            Vector ccCashBack = new Vector();
            Vector ccTransfer = new Vector();

            Vector currencys = DbCurrency.list(0, 0, "", DbCurrency.colNames[DbCurrency.COL_CURRENCY_ID]);
            double totalCash[];
            totalCash = new double[currencys.size()];

            int typeReport = SessReportClosing.getTypeReport(locationId);

            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {
                list = DbSales.getDataClosing(tanggal, locationId, cashCashierId);
            }

            if (iJSPCommand == JSPCommand.POST) {
                try{
                    SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(0);
                    Sales s = DbSales.fetchExc(salesClosing.getSalesId());
                    
                    if(s.getPostedStatus() == 0){
                        
                        long oid = SessPostSales.postJournal(list, user.getOID(), periodId, sysCompany, locationId, currencys, tanggal, cashCashierId, stockable);                                              
                        if(oid != 0){
                            SessBankPayment.prosesReconCard(tanggal, locationId, cashCashierId, user);                                                            
                        }
                        list = DbSales.getDataClosing(tanggal, locationId, cashCashierId);
                        
                        
                    }
                }catch(Exception e){}
                
                
            }
            Location l = new Location();
            try {
                if (locationId != 0) {
                    l = DbLocation.fetchExc(locationId);
                }
            } catch (Exception e) {
            }
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
            
            function cmdPostJournal(){
                document.all.closecmd.style.display="none";
                document.all.closemsg.style.display="";
                document.frmsales.command.value="<%=JSPCommand.POST%>";
                <%if (typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_JOURNAL || typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_SHIFT) {%>
                document.frmsales.action="jurnalsales_single.jsp?menu_idx=<%=menuIdx%>";
                <%} else {%>
                document.frmsales.action="jurnalsales.jsp?menu_idx=<%=menuIdx%>";
                <%}%>
                document.frmsales.submit();
            }     
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                <%if (typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_JOURNAL || typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_SHIFT) {%>
                document.frmsales.action="jurnalsales_single.jsp?menu_idx=<%=menuIdx%>";
                <%} else {%>
                document.frmsales.action="jurnalsales.jsp?menu_idx=<%=menuIdx%>";
                <%}%>
                document.frmsales.submit();
            }
            
            function cmdchange(){
                document.frmsales.command.value="<%=JSPCommand.ASSIGN%>";
                <%if (typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_JOURNAL || typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_SHIFT) {%>
                document.frmsales.action="jurnalsales_single.jsp?menu_idx=<%=menuIdx%>";
                <%} else {%>
                document.frmsales.action="jurnalsales.jsp?menu_idx=<%=menuIdx%>";
                <%}%>                
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Accounting 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Process Journal <br>
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
                                                                                                                                            <td colspan="2">
                                                                                                                                                <table border="0" cellpadding="1" cellspacing="1">                                                                                                                                        
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="5" height="10"></td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td width="80" bgcolor="#D3EDF5" class="fontarial" style="color:#63605C">&nbsp;Date</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td width="300">
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>    
                                                                                                                                                        </td>
                                                                                                                                                        <td width="7"></td>
                                                                                                                                                        <td width="80" bgcolor="#D3EDF5" class="fontarial" style="color:#63605C">&nbsp;Period</td>
                                                                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                                                                        <td>
                                                                                                                                                            <%
            Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "' ", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
                                                                                                                                                            %>   
                                                                                                                                                            &nbsp;&nbsp;<select name="period" class="fontarial">
                                                                                                                                                                <option value="<%=0%>" <%if (0 == periodId) {%>selected<%}%>>- Default Period -</option>
                                                                                                                                                                <%
            if (false && periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);
                                                                                                                                                                %>
                                                                                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == periodId) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                                                                <%}%><%}%>
                                                                                                                                                            </select>                                                                                                        
                                                                                                                                                        </td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td bgcolor="#D3EDF5" class="fontarial" style="color:#63605C">&nbsp;Location</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td colspan="4">
                                                                                                                                                            <%

                                                                                                                                                            %>
                                                                                                                                                            <select name="src_location_id" class="fontarial">                                                                                                                                                                            
                                                                                                                                                                <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location us = (Location) locations.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option onClick="javascript:cmdchange()" value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                                                                <%}
            }%>
                                                                                                                                                            </select>           
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td bgcolor="#D3EDF5" class="fontarial" style="color:#63605C">&nbsp;Shift</td>
                                                                                                                                                        <td class="fontarial">:</td>
                                                                                                                                                        <td colspan="4" class="fontarial">
                                                                                                                                                            <%if (vShift == null || vShift.size() <= 0) {%>
                                                                                                                                                            <i>No shift available</i>                                                                                                                                                            
                                                                                                                                                            <%} else {%>
                                                                                                                                                            <select name="shift_name" class="fontarial">                                                                                                                                                               
                                                                                                                                                                <%if (vShift != null && vShift.size() > 0) {
        for (int i = 0; i < vShift.size(); i++) {
            Shift shift = (Shift) vShift.get(i);
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=shift.getOID()%>" <%if (shift.getOID() == cashCashierId) {%>selected<%}%>><%=shift.getName()%></option>
                                                                                                                                                                <%}
    }%>
                                                                                                                                                                
                                                                                                                                                                <%}%>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>      
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td valign="middle" colspan="4"> 
                                                                                                                                                <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="10">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td colspan="3">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {
                int length = 70 * (currencys.size());
                int lengthTable = 1200 + length;

                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4">
                                                                                                                                                <table width="<%=lengthTable%>" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                    <%
                                                                                                                                            int rowspan = 1;
                                                                                                                                            int colspan = 1;

                                                                                                                                            if (list != null && list.size() > 0) {

                                                                                                                                                if (currencys != null && currencys.size() > 0) {
                                                                                                                                                    rowspan = 2;
                                                                                                                                                    colspan = currencys.size();
                                                                                                                                                }


                                                                                                                                                    %>
                                                                                                                                                    <tr height="28">
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="20" class="tablearialhdr"><font size="1">NO</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="80" class="tablearialhdr"><font size="1">NUMBER</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="80" class="tablearialhdr"><font size="1">DATE</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="90" class="tablearialhdr"><font size="1">MEMBER</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">AMOUNT</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">DISCOUNT</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">KWITANSI</font></td>                                                                                                                                                        
                                                                                                                                                        <td align="center" colspan="<%=colspan%>" class="tablearialhdr"><font size="1">CASH</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="75" class="tablearialhdr"><font size="1">CREDIT CARD</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">DEBIT CARD</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">CASH BACK</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">TRANSFER</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">CREDIT (BON)</font></td>                                                                                                                                                        
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" width="70" class="tablearialhdr"><font size="1">RETUR</font></td>
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" class="tablearialhdr"><font size="1">MERCHANT</font></td>  
                                                                                                                                                        <td align="center" rowspan="<%=rowspan%>" class="tablearialhdr"><font size="1">STATUS</font></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%if (colspan > 0) {%>
                                                                                                                                                    <tr>
                                                                                                                                                        <%
    for (int t = 0; t < colspan; t++) {
        Currency c = (Currency) currencys.get(t);
                                                                                                                                                        %>
                                                                                                                                                        <td align="center" width="45" class="tablearialhdr"><font size="1"><%=c.getCurrencyCode()%></font></td>
                                                                                                                                                        <%}%>
                                                                                                                                                    </tr>    
                                                                                                                                                    <%

                                                                                                                                                        }

                                                                                                                                                        // sub total
                                                                                                                                                        double subCash = 0;
                                                                                                                                                        double subCard = 0;
                                                                                                                                                        double subDebit = 0;
                                                                                                                                                        double subCashBack = 0;
                                                                                                                                                        double subTransfer = 0;
                                                                                                                                                        double subBon = 0;
                                                                                                                                                        double subDiscount = 0;
                                                                                                                                                        double subRetur = 0;
                                                                                                                                                        double subAmount = 0;
                                                                                                                                                        double subKwitansi = 0;
                                                                                                                                                        long oidBiaya = 0;

                                                                                                                                                        for (int k = 0; k < list.size(); k++) {

                                                                                                                                                            SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(k);

                                                                                                                                                            subCash = subCash + salesClosing.getCash();
                                                                                                                                                            subCard = subCard + salesClosing.getCCard();
                                                                                                                                                            subDebit = subDebit + salesClosing.getDCard();
                                                                                                                                                            subCashBack = subCashBack + salesClosing.getCashBack();
                                                                                                                                                            subTransfer = subTransfer + salesClosing.getTransfer();
                                                                                                                                                            subBon = subBon + salesClosing.getBon();
                                                                                                                                                            subDiscount = subDiscount + salesClosing.getDiscount();
                                                                                                                                                            subRetur = subRetur + salesClosing.getRetur();
                                                                                                                                                            subAmount = subAmount + salesClosing.getAmount();
                                                                                                                                                            subKwitansi = subKwitansi + (salesClosing.getAmount() - salesClosing.getDiscount());

                                                                                                                                                            String strmerchant = salesClosing.getMerchantName();
                                                                                                                                                            if (salesClosing.getMerchant2Name().length() > 0) {
                                                                                                                                                                if (strmerchant.length() > 0) {
                                                                                                                                                                    strmerchant = strmerchant + ", ";
                                                                                                                                                                }
                                                                                                                                                                strmerchant = strmerchant + salesClosing.getMerchant2Name();
                                                                                                                                                            }

                                                                                                                                                            if (salesClosing.getMerchant3Name().length() > 0) {
                                                                                                                                                                if (strmerchant.length() > 0) {
                                                                                                                                                                    strmerchant = strmerchant + ", ";
                                                                                                                                                                }
                                                                                                                                                                strmerchant = strmerchant + salesClosing.getMerchant3Name();
                                                                                                                                                            }

                                                                                                                                                            long currId = 0;
                                                                                                                                                            if (salesClosing.getCash() != 0) {
                                                                                                                                                                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_CASH;
                                                                                                                                                                Vector pays = DbPayment.list(0, 1, wherePay, null);

                                                                                                                                                                for (int p = 0; p < pays.size(); p++) {
                                                                                                                                                                    Payment pay = (Payment) pays.get(p);
                                                                                                                                                                    if (pay.getCurrency_id() == 0) {
                                                                                                                                                                        currId = deffCurrIDR;
                                                                                                                                                                    } else {
                                                                                                                                                                        currId = pay.getCurrency_id();
                                                                                                                                                                    }
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            if (salesClosing.getCCard() != 0) {
                                                                                                                                                                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_CREDIT_CARD;
                                                                                                                                                                Vector pays = DbPayment.list(0, 1, wherePay, null);
                                                                                                                                                                if (pays != null && pays.size() > 0) {
                                                                                                                                                                    Payment p = (Payment) pays.get(0);
                                                                                                                                                                    Vector tmpCC = new Vector();
                                                                                                                                                                    tmpCC.add("" + p.getOID());
                                                                                                                                                                    tmpCC.add("" + p.getMerchantId());
                                                                                                                                                                    tmpCC.add("" + salesClosing.getCCard());
                                                                                                                                                                    ccCredits.add(tmpCC);
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            if (salesClosing.getDCard() != 0) {
                                                                                                                                                                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_DEBIT_CARD;
                                                                                                                                                                Vector pays = DbPayment.list(0, 1, wherePay, null);
                                                                                                                                                                if (pays != null && pays.size() > 0) {
                                                                                                                                                                    Payment p = (Payment) pays.get(0);
                                                                                                                                                                    Vector tmpCC = new Vector();
                                                                                                                                                                    tmpCC.add("" + p.getOID());
                                                                                                                                                                    tmpCC.add("" + p.getMerchantId());
                                                                                                                                                                    tmpCC.add("" + salesClosing.getDCard());
                                                                                                                                                                    ccDebits.add(tmpCC);
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            if (salesClosing.getTransfer() != 0) {
                                                                                                                                                                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_TRANSFER;
                                                                                                                                                                Vector pays = DbPayment.list(0, 1, wherePay, null);
                                                                                                                                                                if (pays != null && pays.size() > 0) {
                                                                                                                                                                    Payment p = (Payment) pays.get(0);
                                                                                                                                                                    Vector tmpTrf = new Vector();
                                                                                                                                                                    tmpTrf.add("" + p.getOID());
                                                                                                                                                                    tmpTrf.add("" + p.getBankId());
                                                                                                                                                                    tmpTrf.add("" + salesClosing.getTransfer());
                                                                                                                                                                    ccTransfer.add(tmpTrf);
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            if (salesClosing.getCashBack() != 0) {
                                                                                                                                                                String wherePay = DbPayment.colNames[DbPayment.COL_SALES_ID] + " = " + salesClosing.getSalesId() + " and " + DbPayment.colNames[DbPayment.COL_PAY_TYPE] + " = " + DbPayment.PAY_TYPE_CASH_BACK;
                                                                                                                                                                Vector pays = DbPayment.list(0, 1, wherePay, null);
                                                                                                                                                                if (pays != null && pays.size() > 0) {
                                                                                                                                                                    Payment p = (Payment) pays.get(0);
                                                                                                                                                                    Vector tmpCashBack = new Vector();
                                                                                                                                                                    tmpCashBack.add("" + p.getOID());
                                                                                                                                                                    tmpCashBack.add("" + p.getMerchantId());
                                                                                                                                                                    tmpCashBack.add("" + salesClosing.getCashBack());
                                                                                                                                                                    ccCashBack.add(tmpCashBack);
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            String style = "";
                                                                                                                                                            if (k % 2 == 0) {
                                                                                                                                                                style = "tablearialcell";
                                                                                                                                                            } else {
                                                                                                                                                                style = "tablearialcell1";
                                                                                                                                                            }
                                                                                                                                                    %>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td align="center" class="<%=style%>"><%=(k + 1)%></td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;"><%=salesClosing.getInvoiceNumber()%></td>                                                                                        
                                                                                                                                                        <td align="center" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatDate(salesClosing.getTglJam(), "yyyy-MM-dd")%></td>
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;"><%=salesClosing.getMember()%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber((salesClosing.getAmount() - salesClosing.getDiscount()), "###,###.##")%></td>                                                                                                                                                                                                                                                                                                    
                                                                                                                                                        <%for (int ir = 0; ir < currencys.size(); ir++) {
                                                                                                                                                                                                                                                                                                                    Currency cs = (Currency) currencys.get(ir);
                                                                                                                                                                                                                                                                                                                    if (cs.getOID() == currId) {
                                                                                                                                                                                                                                                                                                                        totalCash[ir] = totalCash[ir] + salesClosing.getCash();
                                                                                                                                                        %>                                                                                                                                                        
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getCash(), "###,###.##")%></td>
                                                                                                                                                        <%} else {
                                                                                                                                                            totalCash[ir] = totalCash[ir] + 0;
                                                                                                                                                        %>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(0, "###,###.##")%></td>
                                                                                                                                                        <%}
                                                                                                                                                                                                                                                                                                                }%>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getDCard(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getCashBack(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getTransfer(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getBon(), "###,###.##")%></td>                                                                                                                                            
                                                                                                                                                        <td align="right" class="<%=style%>" style="padding:3px;"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "###,###.##")%></td>                                                                                                                                            
                                                                                                                                                        <td align="left" class="<%=style%>" style="padding:3px;"><%=strmerchant%></td>
                                                                                                                                                        <%
                                                                                                                                                                                                                                                                                                                if (salesClosing.getPosted() == 1) {
                                                                                                                                                                                                                                                                                                                    isPosted = true;
                                                                                                                                                        %>
                                                                                                                                                        <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                                                                                        <%} else {%>    
                                                                                                                                                        <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">-</font></td>
                                                                                                                                                        <%}%>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>  
                                                                                                                                                    <input type="hidden" name="hidden_cash" value="<%=subCash%>">
                                                                                                                                                    <input type="hidden" name="hidden_credit" value="<%=subBon%>">
                                                                                                                                                    <tr height="22">                                                                                       
                                                                                                                                                        <td bgcolor="#F5C46D" class="fontarial" colspan="4" align="center"><b>GRAND TOTAL</b></td>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subAmount, "###,###.##")%></b></td>   
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subDiscount, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subKwitansi, "###,###.##")%></b></td>
                                                                                                                                                        <%for (int ir = 0; ir < currencys.size(); ir++) {%>                                                                                                                                                        
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(totalCash[ir], "###,###.##")%></b></td>
                                                                                                                                                        <%}%>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subCard, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subDebit, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subCashBack, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subTransfer, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subBon, "###,###.##")%></b></td>                                                                                                                                                        
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" style="padding:3px;"><b><%=JSPFormater.formatNumber(subRetur, "###,###.##")%></b></td>                                                                                                                                                                                                                                                
                                                                                                                                                        <td align="right" bgcolor="#F5C46D" class="fontarial" colspan="2">&nbsp;</td> 
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="19" height="25"></td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <%
                                                                                                                                                        double totDebit = 0;
                                                                                                                                                        double totCredit = 0;
                                                                                                                                                        if (isPosted == false) {                                                                                                                                                            
                                                                                                                                                            Vector mappings = SessPostSales.getMappingCOGS(tanggal, locationId, cashCashierId, stockable, sysCompany.getUseBkp());
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="10" height="15">
                                                                                                                                                            <table border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td width="25" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>No</b></td>
                                                                                                                                                                    <td width="500" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Akun Perkiraan</b></td>
                                                                                                                                                                    <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Debet</b></td>
                                                                                                                                                                    <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Credit</b></td>
                                                                                                                                                                </tr>    
                                                                                                                                                                <%
                                                                                                                                                        int nomor = 1;
                                                                                                                                                        String bg1 = "#EFFEDE";
                                                                                                                                                        String bg2 = "#E0FCC2";
                                                                                                                                                        for (int ir = 0; ir < currencys.size(); ir++) {
                                                                                                                                                            Currency cr = (Currency) currencys.get(ir);
                                                                                                                                                            double cashx = 0;
                                                                                                                                                            try {
                                                                                                                                                                cashx = totalCash[ir];
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }
                                                                                                                                                            if (cashx != 0) {
                                                                                                                                                                Coa cIr = new Coa();
                                                                                                                                                                try {
                                                                                                                                                                    cIr = DbCoa.fetchExc(cr.getCoaId());
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                double debt = 0;
                                                                                                                                                                double crd = 0;
                                                                                                                                                                if (cashx > 0) {
                                                                                                                                                                    debt = cashx;
                                                                                                                                                                    crd = 0;
                                                                                                                                                                } else {
                                                                                                                                                                    debt = 0;
                                                                                                                                                                    crd = cashx * -1;
                                                                                                                                                                }
                                                                                                                                                                totDebit = totDebit + debt;
                                                                                                                                                                totCredit = totCredit + crd;
                                                                                                                                                                if (cIr.getOID() == 0) {
                                                                                                                                                                    isCoaComplete = false;
                                                                                                                                                                }
                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }
                                                                                                                                                                %>                                                                                                                                                                
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=cIr.getCode()%> - <%=cIr.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(debt, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(crd, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                                <%
                                                                                                                                                                nomor++;
                                                                                                                                                            }
                                                                                                                                                        }

                                                                                                                                                        if (subBon != 0) {

                                                                                                                                                            Coa coaPiutang = new Coa();
                                                                                                                                                            try {
                                                                                                                                                                coaPiutang = DbCoa.fetchExc(l.getCoaArId());
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }

                                                                                                                                                            if (coaPiutang.getOID() == 0) {
                                                                                                                                                                isCoaComplete = false;
                                                                                                                                                            }

                                                                                                                                                            String bg = "";
                                                                                                                                                            if (nomor % 2 == 0) {
                                                                                                                                                                bg = bg1;
                                                                                                                                                            } else {
                                                                                                                                                                bg = bg2;
                                                                                                                                                            }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaPiutang.getCode()%> - <%=coaPiutang.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(subBon, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                                <%
                                                                                                                                                            totDebit = totDebit + subBon;
                                                                                                                                                            nomor++;
                                                                                                                                                        }

                                                                                                                                                        if (ccCredits != null && ccCredits.size() > 0) {
                                                                                                                                                            for (int t = 0; t < ccCredits.size(); t++) {
                                                                                                                                                                Vector vCredit = (Vector) ccCredits.get(t);
                                                                                                                                                                long coaId = 0;
                                                                                                                                                                Coa coa = new Coa();
                                                                                                                                                                Merchant m = new Merchant();
                                                                                                                                                                double amountExp = 0;
                                                                                                                                                                double amount = 0;
                                                                                                                                                                double amountFinal = amount;
                                                                                                                                                                try {
                                                                                                                                                                    amount = Double.parseDouble("" + vCredit.get(2));
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }

                                                                                                                                                                try {
                                                                                                                                                                    coaId = Long.parseLong("" + vCredit.get(1));
                                                                                                                                                                    if (coaId != 0) {
                                                                                                                                                                        m = DbMerchant.fetchExc(coaId);
                                                                                                                                                                        coa = DbCoa.fetchExc(m.getCoaId());
                                                                                                                                                                    }

                                                                                                                                                                    if (m.getOID() != 0) {
                                                                                                                                                                        if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                                                                                                                                                            amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount - amountExp;
                                                                                                                                                                        } else {
                                                                                                                                                                            amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount + amountExp;
                                                                                                                                                                        }
                                                                                                                                                                    }
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                totDebit = totDebit + amountFinal;
                                                                                                                                                                if (coa.getOID() == 0) {
                                                                                                                                                                    isCoaComplete = false;
                                                                                                                                                                } else {
                                                                                                                                                                    oidBiaya = coa.getOID();
                                                                                                                                                                }

                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coa.getCode()%> - <%=coa.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountFinal, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr> 
                                                                                                                                                                
                                                                                                                                                                <%
                                                                                                                                                                    nomor++;
                                                                                                                                                                    if (amountExp != 0) {
                                                                                                                                                                        Coa coaExp = new Coa();
                                                                                                                                                                        try {
                                                                                                                                                                            coaExp = DbCoa.fetchExc(m.getCoaExpenseId());
                                                                                                                                                                        } catch (Exception e) {
                                                                                                                                                                        }
                                                                                                                                                                        if (coaExp.getOID() == 0) {
                                                                                                                                                                            isCoaComplete = false;
                                                                                                                                                                        }
                                                                                                                                                                        totDebit = totDebit + amountExp;
                                                                                                                                                                        if (nomor % 2 == 0) {
                                                                                                                                                                            bg = bg1;
                                                                                                                                                                        } else {
                                                                                                                                                                            bg = bg2;
                                                                                                                                                                        }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaExp.getCode()%> - <%=coaExp.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountExp, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                
                                                                                                                                                                <%
                                                                                                                                                                    nomor++;
                                                                                                                                                                }

                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                        if (ccDebits != null && ccDebits.size() > 0) {
                                                                                                                                                            for (int t = 0; t < ccDebits.size(); t++) {
                                                                                                                                                                Vector vDebit = (Vector) ccDebits.get(t);
                                                                                                                                                                long coaId = 0;
                                                                                                                                                                Coa coa = new Coa();
                                                                                                                                                                Merchant m = new Merchant();
                                                                                                                                                                double amountExp = 0;
                                                                                                                                                                double amount = 0;
                                                                                                                                                                double amountFinal = amount;
                                                                                                                                                                try {
                                                                                                                                                                    amount = Double.parseDouble("" + vDebit.get(2));
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                try {
                                                                                                                                                                    coaId = Long.parseLong("" + vDebit.get(1));
                                                                                                                                                                    if (coaId != 0) {
                                                                                                                                                                        m = DbMerchant.fetchExc(coaId);
                                                                                                                                                                        coa = DbCoa.fetchExc(m.getCoaId());
                                                                                                                                                                    }

                                                                                                                                                                    if (m.getOID() != 0) {
                                                                                                                                                                        if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                                                                                                                                                            amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount - amountExp;
                                                                                                                                                                        } else {
                                                                                                                                                                            amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount + amountExp;
                                                                                                                                                                        }
                                                                                                                                                                    }
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                if (coa.getOID() == 0) {
                                                                                                                                                                    isCoaComplete = false;
                                                                                                                                                                } else {
                                                                                                                                                                    oidBiaya = coa.getOID();
                                                                                                                                                                }
                                                                                                                                                                totDebit = totDebit + amountFinal;
                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coa.getCode()%> - <%=coa.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountFinal, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                                <%
                                                                                                                                                                nomor++;
                                                                                                                                                                if (amountExp != 0) {
                                                                                                                                                                    Coa coaExp = new Coa();
                                                                                                                                                                    try {
                                                                                                                                                                        coaExp = DbCoa.fetchExc(m.getCoaExpenseId());
                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                    }
                                                                                                                                                                    if (coaExp.getOID() == 0) {
                                                                                                                                                                        isCoaComplete = false;
                                                                                                                                                                    }
                                                                                                                                                                    totDebit = totDebit + amountExp;
                                                                                                                                                                    if (nomor % 2 == 0) {
                                                                                                                                                                        bg = bg1;
                                                                                                                                                                    } else {
                                                                                                                                                                        bg = bg2;
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaExp.getCode()%> - <%=coaExp.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountExp, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                
                                                                                                                                                                <%
                                                                                                                                                                    nomor++;
                                                                                                                                                                }

                                                                                                                                                            }
                                                                                                                                                        }

                                                                                                                                                        if (ccTransfer != null && ccTransfer.size() > 0) {
                                                                                                                                                            for (int t = 0; t < ccTransfer.size(); t++) {
                                                                                                                                                                Vector vTransfer = (Vector) ccTransfer.get(t);
                                                                                                                                                                long coaId = 0;
                                                                                                                                                                Coa coa = new Coa();
                                                                                                                                                                Bank b = new Bank();
                                                                                                                                                                double amountExp = 0;
                                                                                                                                                                double amount = 0;
                                                                                                                                                                double amountFinal = amount;
                                                                                                                                                                try {
                                                                                                                                                                    amount = Double.parseDouble("" + vTransfer.get(2));
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                try {
                                                                                                                                                                    coaId = Long.parseLong("" + vTransfer.get(1));
                                                                                                                                                                    if (coaId != 0) {
                                                                                                                                                                        b = DbBank.fetchExc(coaId);
                                                                                                                                                                        coa = DbCoa.fetchExc(b.getCoaARId());
                                                                                                                                                                    }

                                                                                                                                                                    //if (b.getOID() != 0) {
                                                                                                                                                                    //    if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                                                                                                                                                    //        amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount ;//- amountExp;
                                                                                                                                                                   //     } else {
                                                                                                                                                                   //         amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                   //         amountFinal = amount + amountExp;
                                                                                                                                                                   //     }
                                                                                                                                                                    //}
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                if (coa.getOID() == 0) {
                                                                                                                                                                    isCoaComplete = false;
                                                                                                                                                                } else {
                                                                                                                                                                    oidBiaya = coa.getOID();
                                                                                                                                                                }
                                                                                                                                                                totDebit = totDebit + amountFinal;
                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coa.getCode()%> - <%=coa.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountFinal, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>


                                                                                                                                                                <%
                                                                                                                                                                    nomor++;


                                                                                                                                                            }
                                                                                                                                                        }

                                                                                                                                                        
                                                                                                                                                        if (ccCashBack != null && ccCashBack.size() > 0) {
                                                                                                                                                            for (int t = 0; t < ccCashBack.size(); t++) {
                                                                                                                                                                Vector vCashBack = (Vector) ccCashBack.get(t);
                                                                                                                                                                long coaId = 0;
                                                                                                                                                                Coa coa = new Coa();
                                                                                                                                                                Merchant m = new Merchant();
                                                                                                                                                                double amountExp = 0;
                                                                                                                                                                double amount = 0;
                                                                                                                                                                double amountFinal = amount;
                                                                                                                                                                try {
                                                                                                                                                                    amount = Double.parseDouble("" + vCashBack.get(2));
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                try {
                                                                                                                                                                    coaId = Long.parseLong("" + vCashBack.get(1));
                                                                                                                                                                    if (coaId != 0) {
                                                                                                                                                                        m = DbMerchant.fetchExc(coaId);
                                                                                                                                                                        coa = DbCoa.fetchExc(m.getCoaId());
                                                                                                                                                                    }

                                                                                                                                                                    if (m.getOID() != 0) {
                                                                                                                                                                        if (m.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                                                                                                                                                                            amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount;
                                                                                                                                                                        } else {
                                                                                                                                                                            amountExp = (m.getPersenExpense() / 100) * amount;
                                                                                                                                                                            amountFinal = amount + amountExp;
                                                                                                                                                                        }
                                                                                                                                                                    }
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                                if (coa.getOID() == 0) {
                                                                                                                                                                    isCoaComplete = false;
                                                                                                                                                                }
                                                                                                                                                                totDebit = totDebit + amountFinal;
                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }

                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coa.getCode()%> - <%=coa.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountFinal, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                                <%
                                                                                                                                                                nomor++;
                                                                                                                                                                if (amountExp != 0) {
                                                                                                                                                                    Coa coaExp = new Coa();
                                                                                                                                                                    try {
                                                                                                                                                                        coaExp = DbCoa.fetchExc(m.getCoaExpenseId());
                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                    }
                                                                                                                                                                    if (coaExp.getOID() == 0) {
                                                                                                                                                                        isCoaComplete = false;
                                                                                                                                                                    }
                                                                                                                                                                    totDebit = totDebit + amountExp;
                                                                                                                                                                    if (nomor % 2 == 0) {
                                                                                                                                                                        bg = bg1;
                                                                                                                                                                    } else {
                                                                                                                                                                        bg = bg2;
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaExp.getCode()%> - <%=coaExp.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountExp, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                
                                                                                                                                                                <%
                                                                                                                                                                    nomor++;
                                                                                                                                                                }

                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                        if (mappings != null && mappings.size() > 0) {
                                                                                                                                                            double ppn = 0;
                                                                                                                                                            String accPpn = "";
                                                                                                                                                            for (int t = 0; t < mappings.size(); t++) {
                                                                                                                                                                
                                                                                                                                                                MappingCogs map = (MappingCogs) mappings.get(t);

                                                                                                                                                                String accInv = "";
                                                                                                                                                                String accCogs = "";
                                                                                                                                                                String accSales = "";
                                                                                                                                                                String coaInv = "";
                                                                                                                                                                String coaCogs = "";
                                                                                                                                                                String coaPenjualan = "";
                                                                                                                                                                Coa c = new Coa();
                                                                                                                                                                Coa ccogs = new Coa();
                                                                                                                                                                Coa csales = new Coa();

                                                                                                                                                                double amountCogs = 0;
                                                                                                                                                                double amountRev = 0;

                                                                                                                                                                try {
                                                                                                                                                                    amountCogs = map.getAmount();
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }

                                                                                                                                                                try {
                                                                                                                                                                    amountRev = map.getAmountRev();
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }

                                                                                                                                                                ppn = ppn + map.getAmountPpn();

                                                                                                                                                                if (amountCogs != 0) {
                                                                                                                                                                    try {
                                                                                                                                                                        if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                                                                                                                                                            accInv = map.getAccGroInv();
                                                                                                                                                                        } else {
                                                                                                                                                                            accInv = map.getAccInv();
                                                                                                                                                                        }
                                                                                                                                                                        c = DbCoa.getCoaByCode(accInv.trim());
                                                                                                                                                                        coaInv = c.getCode() + " - " + c.getName();
                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                    }

                                                                                                                                                                    try {
                                                                                                                                                                        if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                                                                                                                                                            accCogs = map.getAccGroCogs();
                                                                                                                                                                        } else {
                                                                                                                                                                            accCogs = map.getAccCogs();
                                                                                                                                                                        }
                                                                                                                                                                        ccogs = DbCoa.getCoaByCode(accCogs.trim());
                                                                                                                                                                        coaCogs = ccogs.getCode() + " - " + ccogs.getName();
                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                    }
                                                                                                                                                                    if (c.getOID() == 0 || ccogs.getOID() == 0) {
                                                                                                                                                                        isCoaComplete = false;
                                                                                                                                                                    }
                                                                                                                                                                }

                                                                                                                                                                if (amountRev != 0) {
                                                                                                                                                                    try {
                                                                                                                                                                        if (l.getTypeGrosir() == DbLocation.TYPE_GROSIR) {
                                                                                                                                                                            accSales = map.getAccGroSales();
                                                                                                                                                                        } else {
                                                                                                                                                                            accSales = map.getAccSales();
                                                                                                                                                                        }
                                                                                                                                                                        csales = DbCoa.getCoaByCode(accSales.trim());
                                                                                                                                                                        coaPenjualan = csales.getCode() + " - " + csales.getName();
                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                    }
                                                                                                                                                                    if (csales.getOID() == 0) {
                                                                                                                                                                        isCoaComplete = false;
                                                                                                                                                                    }
                                                                                                                                                                }

                                                                                                                                                                totDebit = totDebit + amountCogs;
                                                                                                                                                                totCredit = totCredit + amountRev;
                                                                                                                                                                totCredit = totCredit + amountCogs;

                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }

                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaPenjualan%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountRev, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                                <%
                                                                                                                                                                nomor++;
                                                                                                                                                                if (amountCogs != 0) {
                                                                                                                                                                    if (nomor % 2 == 0) {
                                                                                                                                                                        bg = bg1;
                                                                                                                                                                    } else {
                                                                                                                                                                        bg = bg2;
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaInv%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountCogs, "###,###.##")  %></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <%
                                                                                                                                                                    nomor++;
                                                                                                                                                                    if (nomor % 2 == 0) {
                                                                                                                                                                        bg = bg1;
                                                                                                                                                                    } else {
                                                                                                                                                                        bg = bg2;
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=coaCogs%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(amountCogs, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>                                                                                                                                                                    
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                                <%
                                                                                                                                                                    nomor++;
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            if (ppn != 0) {
                                                                                                                                                                try {
                                                                                                                                                                    Coa cPpn = DbCoa.getCoaByCode(accPpn.trim());
                                                                                                                                                                    nomor++;
                                                                                                                                                                    String bg = "";
                                                                                                                                                                    if (nomor % 2 == 0) {
                                                                                                                                                                        bg = bg1;
                                                                                                                                                                    } else {
                                                                                                                                                                        bg = bg2;
                                                                                                                                                                    }
                                                                                                                                                                    totCredit = totCredit + ppn;
                                                                                                                                                                    if (cPpn.getOID() == 0) {
                                                                                                                                                                        isCoaComplete = false;
                                                                                                                                                                    }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=cPpn.getCode() + " - " + cPpn.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(ppn, "###,###.##")  %></td>                                                                                                                                                                    
                                                                                                                                                                </tr> 
                                                                                                                                                                
                                                                                                                                                                <%
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                        }

                                                                                                                                                        double balance = totCredit - totDebit;
                                                                                                                                                        String strAmount = JSPFormater.formatNumber(balance, "###,###.##");
                                                                                                                                                        if (strAmount.compareToIgnoreCase("0.00") != 0 && strAmount.compareToIgnoreCase("-0.00") != 0 && oidBiaya != 0 && balance > -1 && balance < 1) {
                                                                                                                                                            try {
                                                                                                                                                                Coa penyesuaian = DbCoa.fetchExc(oidBiaya);
                                                                                                                                                                totDebit = totDebit + balance;
                                                                                                                                                                String bg = "";
                                                                                                                                                                if (nomor % 2 == 0) {
                                                                                                                                                                    bg = bg1;
                                                                                                                                                                } else {
                                                                                                                                                                    bg = bg2;
                                                                                                                                                                }
                                                                                                                                                                %>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=nomor%></td>
                                                                                                                                                                    <td bgcolor="<%=bg%>" style="padding:3px;"><%=penyesuaian.getCode()%> - <%=penyesuaian.getName()%></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(balance, "###,###.##")  %></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##")  %></td>
                                                                                                                                                                </tr>                                                                                                                                                                
                                                                                                                                                                <%
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }
                                                                                                                                                        }%>
                                                                                                                                                                <tr height="20">
                                                                                                                                                                    <td colspan="2" class="fontarial" bgcolor="#cccccc" style="padding:3px;" align="center"><b>Total</b></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="#cccccc" style="padding:3px;"><b><%=JSPFormater.formatNumber(totDebit, "###,###.##")  %></b></td>
                                                                                                                                                                    <td align="right" class="fontarial" bgcolor="#cccccc" style="padding:3px;"><b><%=JSPFormater.formatNumber(totCredit, "###,###.##")  %></b></td>                                                                                                                                                                    
                                                                                                                                                                </tr>                                                                                                                                                                 
                                                                                                                                                            </table>                                                                                                                                                            
                                                                                                                                                        </td>
                                                                                                                                                    </tr>  
                                                                                                                                                    <%
                                                                                                                                                    } else {

                                                                                                                                                        Vector docs = SessPostSales.listSystemDocNumber(locationId, cashCashierId, tanggal);
                                                                                                                                                        if (docs != null && docs.size() > 0) {
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="19" height="50">&nbsp;</td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="19">
                                                                                                                                                            <table width="900" border="0" cellspacing="0" cellpadding="0"> 
                                                                                                                                                                <%
                                                                                                                                                            for (int t = 0; t < docs.size(); t++) {
                                                                                                                                                                long systemDocId = Long.parseLong("" + docs.get(t));
                                                                                                                                                                try {
                                                                                                                                                                    SystemDocNumber sdn = DbSystemDocNumber.fetchExc(systemDocId);
                                                                                                                                                                    Vector gls = DbGl.list(0, 0, DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + sdn.getDocNumber() + "'", null);
                                                                                                                                                                    if (gls != null && gls.size() > 0) {
                                                                                                                                                                        Gl gl = (Gl) gls.get(0);
                                                                                                                                                                        Vector details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");
                                                                                                                                                                        User ux = new User();
                                                                                                                                                                                                                                                                                                                            try {
                                                                                                                                                                                                                                                                                                                                ux = DbUser.fetch(gl.getPostedById());
                                                                                                                                                                                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                %>
                                                                                                                                                                <tr>
                                                                                                                                                                    <td>
                                                                                                                                                                        <table width="900" border="0" cellspacing="1" cellpadding="0"> 
                                                                                                                                                                            <tr> 
                                                                                                                                                                                <td width="100" class="fontarial" bgcolor="#EFFEDE" height="17" style="padding:3px;" nowrap><b>Status</b></td>      
                                                                                                                                                                                <td width="300" class="fontarial" height="17" nowrap style="padding:3px;"><b> : Posted</b></td> 
                                                                                                                                                                                <td width="100" class="fontarial" bgcolor="#EFFEDE" height="17" style="padding:3px;" nowrap><b>Number</b></td>      
                                                                                                                                                                                <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=gl.getJournalNumber()%></b></td> 
                                                                                                                                                                            </tr>
                                                                                                                                                                            <tr> 
                                                                                                                                                                                <td class="fontarial" bgcolor="#EFFEDE" style="padding:3px;" height="17" nowrap><b>Transaction Date</b></td>      
                                                                                                                                                                                <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></b></td> 
                                                                                                                                                                                <td class="fontarial" bgcolor="#EFFEDE" style="padding:3px;" height="17" nowrap><b>Create Date</b></td>      
                                                                                                                                                                                <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%></b></td>                                                                                                                                                                                 
                                                                                                                                                                            </tr>                                                                                                                                                                 
                                                                                                                                                                            <tr> 
                                                                                                                                                                                <td class="fontarial" bgcolor="#EFFEDE" style="padding:3px;" height="17" nowrap><b>Posted By</b></td>      
                                                                                                                                                                                <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=ux.getFullName()%></b></td> 
                                                                                                                                                                            </tr> 
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>  
                                                                                                                                                                <%if (details != null && details.size() > 0) {%>
                                                                                                                                                                <tr>    
                                                                                                                                                                    <td colspan="5">
                                                                                                                                                                        <table width="900" border="0" cellspacing="1" cellpadding="0" >
                                                                                                                                                                            <tr height="20">
                                                                                                                                                                                <td width="25" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>No</b></td>
                                                                                                                                                                                <td align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Akun Perkiraan</b></td>
                                                                                                                                                                                <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Debet</b></td>
                                                                                                                                                                                <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Credit</b></td>
                                                                                                                                                                                <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Memo</b></td>
                                                                                                                                                                                <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Segment</b></td>
                                                                                                                                                                            </tr> 
                                                                                                                                                                            <%

    double totalDebit = 0;
    double totalCredit = 0;
    for (int d = 0; d < details.size(); d++) {

        GlDetail gld = (GlDetail) details.get(d);
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gld.getCoaId());
        } catch (Exception e) {
        }

        SegmentDetail sd = new SegmentDetail();
        try {
            if (gld.getSegment1Id() != 0) {
                sd = DbSegmentDetail.fetchExc(gld.getSegment1Id());
            }
        } catch (Exception e) {
        }

        totalDebit = totalDebit + gld.getDebet();
        totalCredit = totalCredit + gld.getCredit();
        String bg1 = "#EFFEDE";
        String bg2 = "#E0FCC2";
        String bg = "";
        if (d % 2 == 0) {
            bg = bg1;
        } else {
            bg = bg2;
        }
                                                                                                                                                                            %>                                                                                                                                                                            
                                                                                                                                                                            <tr height="25"> 
                                                                                                                                                                                <td class="fontarial" bgcolor="<%=bg%>" align="center"><%=(d + 1)%></td>                                                                                                                                                                                
                                                                                                                                                                                <td class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                                                                                                                <td class="fontarial" bgcolor="<%=bg%>" align="right" style="padding:3px;"><%=(gld.getDebet() == 0) ? "" : JSPFormater.formatNumber(gld.getDebet(), "###,###.##")%></td>
                                                                                                                                                                                <td class="fontarial" bgcolor="<%=bg%>" align="right" style="padding:3px;"><%=(gld.getCredit() == 0) ? "" : JSPFormater.formatNumber(gld.getCredit(), "###,###.##")%></td>
                                                                                                                                                                                <td class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=gld.getMemo()%></td>
                                                                                                                                                                                <td class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=sd.getName()%></td>                                                                                                                                                                               
                                                                                                                                                                            </tr>   
                                                                                                                                                                            
                                                                                                                                                                            <%
    }


                                                                                                                                                                            %>
                                                                                                                                                                            <tr height="25"> 
                                                                                                                                                                                <td class="fontarial" bgcolor="#cccccc" align="center" colspan="2" nowrap>Grand Total</td>
                                                                                                                                                                                <td class="fontarial" bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalDebit, "###,###.##")%></td>
                                                                                                                                                                                <td class="fontarial" bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalCredit, "###,###.##")%></td>
                                                                                                                                                                                <td bgcolor="#cccccc" colspan="2">&nbsp;</td>                                                                                                                                                                                
                                                                                                                                                                            </tr>  
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>
                                                                                                                                                                <%}

                                                                                                                                                                    }
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                            }
                                                                                                                                                                %>  
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
                                                                                                                                                            }%>
                                                                                                                                                         <tr>
                                                                                                                                                        <td colspan="19">
                                                                                                                                                            <table  cellpadding="0" cellspacing="5" align="left" class="success">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td width="20"><img src="../images/success.gif" width="20" ></td>
                                                                                                                                                                    <td width="50" class="fontarial"><b>Posted</b></td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>   
                                                                                                                                                            
                                                                                                                                                        <%}


                                                                                                                                                    %>
                                                                                                                                                    <tr >
                                                                                                                                                        <td height="15" colspan="4"></td>                                                                                                                                                
                                                                                                                                                    </tr> 
                                                                                                                                                    <%if ((JSPFormater.formatNumber(totDebit, "###,###.##").compareTo(JSPFormater.formatNumber(totCredit, "###,###.##")) == 0) && isPosted == false && isCoaComplete == true) {%>
                                                                                                                                                    <%if (privAdd || privUpdate) {%>
                                                                                                                                                    <tr id="closecmd">
                                                                                                                                                        <td height="15" colspan="4">                                                                                                                                                
                                                                                                                                                            <a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a>                                                                                                                                                                                                                               
                                                                                                                                                        </td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <%}%>
                                                                                                                                                    <tr id="closemsg" align="left" valign="top"> 
                                                                                                                                                        <td height="22" valign="middle" colspan="10"> 
                                                                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td> <font color="#006600">Posting sales in progress, please wait .... </font> </td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td height="1">&nbsp; </td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr> 
                                                                                                                                                                    <td> <img src="../images/progress_bar.gif" border="0"> 
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <tr >
                                                                                                                                                        <td height="15" colspan="4"></td>                                                                                                                                                
                                                                                                                                                    </tr> 
                                                                                                                                                    <% if (iJSPCommand == JSPCommand.SUBMIT) {%>                                                                                                                                        
                                                                                                                                                    <tr >
                                                                                                                                                        <td height="15" colspan="4" class="fontarial"><i>Data proses jurnal not found...</i></td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <%} else if (iJSPCommand == JSPCommand.POST) {%>
                                                                                                                                                    <tr >
                                                                                                                                                        <td height="15" colspan="4" class="fontarial"><i>Proses journal done ..</i></td>
                                                                                                                                                    </tr>     
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <tr >
                                                                                                                                                        <td height="15" colspan="4" class="fontarial"><i>Klick search button to searching the data...</i></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <%}%>                                                                                                                                        
                                                                                                                                                    <%}%>
                                                                                                                                                    <tr >
                                                                                                                                                        <td height="50" colspan="4"></td>                                                                                                                                                
                                                                                                                                                    </tr> 
                                                                                                                                                </table>
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
                                                                                                            <script language="JavaScript">
                                                                                                                document.all.closecmd.style.display="";
                                                                                                                document.all.closemsg.style.display="none";
                                                                                                            </script>    
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

