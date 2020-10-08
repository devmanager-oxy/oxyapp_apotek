
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
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checksl.jsp" %>
<%@ include file="../../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privAdd = true;
            boolean privUpdate = true;
%>
<!-- Jsp Block -->
<%

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            String[] b = request.getParameterValues("segment1_id");
            long cashCashierId = JSPRequestValue.requestLong(request, "shift_name");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");

            if (session.getValue("REPORT_SALES_CLOSING") != null) {
                session.removeValue("REPORT_SALES_CLOSING");
            }

            if (session.getValue("REPORT_SALES_CLOSING2") != null) {
                session.removeValue("REPORT_SALES_CLOSING2");
            }

            if (session.getValue("REPORT_PARAMETER") != null) {
                session.removeValue("REPORT_PARAMETER");
            }

            if (tanggal == null) {
                tanggal = new Date();
            }

            Vector list = new Vector();

            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST){
                list = DbSales.getDataClosingVoucher(tanggal, locationId, cashCashierId);

                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(tanggal);

                session.putValue("REPORT_SALES_CLOSING", list);
                session.putValue("REPORT_PARAMETER", rp);
            }

            String exceptTable = DbSystemProperty.getValueByName("VOUCHER_VALUE");
            StringTokenizer strTok = new StringTokenizer(exceptTable, ",");

            Vector temp = new Vector();

            while (strTok.hasMoreTokens()) {
                temp.add((String) strTok.nextToken().trim());
            }
            double[] totQtyV = new double[temp.size()];

%>          
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../../css/csssl.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/js/jquery.min.js"></script>
        <link href="<%=approot%>/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/js/bootstrap.min.js"></script>
        <link href="<%=approot%>/js/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
        <script src="<%=approot%>/js/bootstrap-multiselect.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(function () {
                $('#lstSegment').multiselect({
                    includeSelectAllOption: true
                });
                $('#btnSelected').click(function () {
                    var selected = $("#lstSegment option:selected");
                    var message = "";
                    selected.each(function () {

                    });
                    alert(message);
                });
            });
        </script>

        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>

            function cmdPrintJournalXls(){
                window.open("<%=printroot%>.report.RptClosingSalesXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }

                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="rptSalesVoucher.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                }

                function cmdchange(){
                    document.frmsales.command.value="<%=JSPCommand.ASSIGN%>";
                    document.frmsales.action="rptSalesVoucher.jsp?menu_idx=<%=menuIdx%>";
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
            <%@ include file="../../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr>
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif">
                                            <!-- #BeginEditable "menu" -->
                  <%@ include file="../../main/menusl.jsp"%>
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
                                                                                                                                            <span class="lvl2">Closing Sales Report<br>
                                                                                                                                </span></font></b></td>
                                                                                                                                <td width="40%" height="23">
                                                                                                                                    <%@ include file = "../../main/userpreview.jsp" %>
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
                                                                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="500">
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablecell1" >
                                                                                                                                                            <table width="100%" style="border:1px solid #ABA8A8" cellpadding="0" cellspacing="1">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td colspan="4" height="10"></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td width="10"></td>
                                                                                                                                                                    <td width="50" class="fontarial">Date</td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td width="7"></td>
                                                                                                                                                                    <td width="50" class="fontarial"></td>
                                                                                                                                                                    <td></td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td></td>
                                                                                                                                                                    <td class="fontarial">Location</td>
                                                                                                                                                                    <td colspan="3">

                                                                                                                                                                        <%
            Vector vLoc = userLocations;
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_location_id" class="fontarial" onChange="javascript:cmdchange()">
                                                                                                                                                                           <%
                                                                                                                                                        if (vLoc != null && vLoc.size() > 0) {
                                                                                                                                                            for (int i = 0; i < vLoc.size(); i++) {
                                                                                                                                                                Location sd = (Location) vLoc.get(i);
                                                                                                                                                                boolean selected = false;
                                                                                                                                                                if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                                                                                                                                                                    selected = true;
                                                                                                                                                                } else {
                                                                                                                                                                    if (b != null) {
                                                                                                                                                                        for (int x = 0; x < b.length; x++) {
                                                                                                                                                                            if (sd.getOID() == Long.parseLong(b[x].trim())) {
                                                                                                                                                                                selected = true;
                                                                                                                                                                                break;
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                     }
                                                                                                                                                                }
                                                                                                                                                            %>

                                                                                                                                                            <option  value="<%=sd.getOID()%>" <%if (selected) {%> selected<%}%>><%=sd.getName()%></option>
                                                                                                                                                            <% }
                                                                                                                                                             }%>
            }%>
                                                                                                                                                                        </select>
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr height="22">
                                                                                                                                                                    <td></td>
                                                                                                                                                                    <td class="fontarial">Shift</td>
                                                                                                                                                                    <td colspan="3">
                                                                                                                                                                        <%
            Vector vShift = DbSales.getShift(locationId, tanggal);
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="shift_name" class="fontarial">
                                                                                                                                                                            <option value="0">ALL SHIFT</option>
                                                                                                                                                                            <%if (vShift != null && vShift.size() > 0) {
                for (int i = 0; i < vShift.size(); i++) {
                    Shift shift = (Shift) vShift.get(i);
                    String name = SessClosingSummary.getUserShift(locationId, tanggal, shift.getOID());
                                                                                                                                                                            %>
                                                                                                                                                                            <option value="<%=shift.getOID()%>" <%if (shift.getOID() == cashCashierId) {%>selected<%}%>><%=shift.getName()%> ( <%=name%> )</option>
                                                                                                                                                                            <%}
            }%>
                                                                                                                                                                        </select>
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>
                                                                                                                                                                <tr height="10">
                                                                                                                                                                    <td colspan="6"></td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td width="10%" height="10">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td colspan="3">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="4" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4">
                                                                                                                                                <table width="1220" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                    <%if (list != null && list.size() > 0) {%>
                                                                                                                                                    <tr height="28">
                                                                                                                                                        <td align="center" width="20" rowspan="2" class="tablearialhdr"><font size="1">NO.</font></td>
                                                                                                                                                        <td align="center" width="80" rowspan="2" class="tablearialhdr"><font size="1">NUMBER</font></td>
                                                                                                                                                        <td align="center" width="80" rowspan="2" class="tablearialhdr"><font size="1">DATE</font></td>
                                                                                                                                                        <td align="center" width="120" rowspan="2" class="tablearialhdr"><font size="1">MEMBER</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialhdr"><font size="1">AMOUNT</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialhdr"><font size="1">DISCOUNT</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialhdr"><font size="1">TOTAL</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialYellow"><font size="1">CASH</font></td>
                                                                                                                                                        
                                                                                                                                                        <td align="center" width="75" rowspan="2" class="tablearialYellow"><font size="1">CREDIT CARD</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialYellow"><font size="1">DEBIT CARD</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialYellow"><font size="1">CASH BACK</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialYellow"><font size="1">CREDIT (BON)</font></td>
                                                                                                                                                        <td align="center" width="70" rowspan="2" class="tablearialYellow"><font size="1">RETUR</font></td>
                                                                                                                                                        <td align="center" rowspan="2" class="tablearialYellow"><font size="1">MERCHANT</font></td>
                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                    </tr>
                                                                                                                                                    
                                                                                                                                                    <%
    // sub total
    double subCash = 0;
    double subCard = 0;
    double subDebit = 0;
    double subCashBack = 0;
    double subBon = 0;
    double subDiscount = 0;
    double subRetur = 0;
    double subAmount = 0;
    double subKwitansi = 0;
    double subBalance = 0;
    double subVoucher = 0;
    double subDifference = 0;

    for (int k = 0; k < list.size(); k++) {

        SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(k);

        subCash = subCash + salesClosing.getCash();
        subCard = subCard + salesClosing.getCCard();
        subDebit = subDebit + salesClosing.getDCard();
        subCashBack = subCashBack + salesClosing.getCashBack();
        subBon = subBon + salesClosing.getBon();
        subDiscount = subDiscount + salesClosing.getDiscount();
        subRetur = subRetur + salesClosing.getRetur();
        subAmount = subAmount + salesClosing.getAmount();
        subKwitansi = subKwitansi + (salesClosing.getAmount() - salesClosing.getDiscount());
        subDifference = subDifference + salesClosing.getDifference();

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
        double totVoucer=0;
        double cVoucher=0;
        
        
        double balance = (salesClosing.getAmount() - salesClosing.getDiscount()) - salesClosing.getCash() - salesClosing.getCCard() - salesClosing.getDCard() - salesClosing.getTransfer() - salesClosing.getBon();
        subBalance = subBalance + balance;

                                                                                                                                                    %>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td align="center" class="tablearialcell"><%=(k + 1)%></td>
                                                                                                                                                        <td align="center" class="tablearialcell" ><%=salesClosing.getInvoiceNumber()%></td>
                                                                                                                                                        <td align="center" class="tablearialcell"><%=JSPFormater.formatDate(salesClosing.getTglJam(),"yyyy-MM-dd")%></td>
                                                                                                                                                        <td align="left" class="tablearialcell"><%=salesClosing.getMember()%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><b><%=JSPFormater.formatNumber((salesClosing.getAmount() - salesClosing.getDiscount()), "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "###,###.##")%></td>
                                                                                                                                                        
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getDCard(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getCashBack(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getBon(), "###,###.##")%></td>
                                                                                                                                                        <td align="right" class="tablearialcell"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "###,###.##")%></td>
                                                                                                                                                        <td align="left" class="tablearialcell"><%=strmerchant%></td>
                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablearialcell1" colspan="4" align="center"><b>GRAND TOTAL</b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subAmount, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subDiscount, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subKwitansi, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subCash, "###,###.##")%></b></td>
                                                                                                                                                        
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subCard, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subDebit, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subCashBack, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subBon, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1"><b><%=JSPFormater.formatNumber(subRetur, "###,###.##")%></b></td>
                                                                                                                                                        <td align="right" class="tablearialcell1" colspan="1">&nbsp;</td>
                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="10" height="15"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr id="closecmd">
                                                                                                                                                        <td colspan="10" align="left">
                                                                                                                                                            <%if (privAdd || privUpdate) {%>
                                                                                                                                                            <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../../images/printxls2.gif',1)"><img src="../../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                                            <%}%>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4" class="fontarial"><i>Click search button to searching the data..</i></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top">
                                                                                                                                <td height="22" valign="middle" colspan="4">
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td class="boxed1"></td>
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
                                                                                                            <script language="JavaScript">
                                                                                                                document.all.closecmd.style.display="";
                                                                                                                document.all.closemsg.style.display="none";
                                                                                                            </script>
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
            <%@ include file="../../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate -->
</html>

