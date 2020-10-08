
<%-- 
    Document   : reportbudgetsupliersummary
    Created on : Mar 16, 2015, 11:55:31 AM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_BUDGET_REPORT_SUMMARY);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_BUDGET_REPORT_SUMMARY, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_BUDGET_REPORT_SUMMARY, AppMenu.PRIV_PRINT);            
%>            
<%
            session.removeValue("DATE_TRANS_DATE");
            int iCommand = JSPRequestValue.requestCommand(request);
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            int pkp = JSPRequestValue.requestInt(request, "pkp");
            int nonpkp = JSPRequestValue.requestInt(request, "nonpkp");
            long vendorId = JSPRequestValue.requestLong(request, "vendor");
            int paymentType = JSPRequestValue.requestInt(request, "payment_type");
            Date dateFrom = JSPFormater.formatDate(JSPRequestValue.requestString(request, "date_from"), "dd/MM/yyyy");
            Date dateTo = JSPFormater.formatDate(JSPRequestValue.requestString(request, "date_to"), "dd/MM/yyyy");
            long historyPrint = JSPRequestValue.requestLong(request, "history_print");
            Vector dateTrans = new Vector();
            
            int non = JSPRequestValue.requestInt(request, "type_non");
            int konsinyasi = JSPRequestValue.requestInt(request, "type_konsinyasi");            
            int komisi = JSPRequestValue.requestInt(request, "type_komisi");        

            SessReportBudgetSuplier dtTrans1 = new SessReportBudgetSuplier();
            SessReportBudgetSuplier dtTrans2 = new SessReportBudgetSuplier();
            dtTrans1.setTransDate(dateFrom);
            dtTrans2.setTransDate(dateTo);
            dateTrans.add(dtTrans1);
            dateTrans.add(dtTrans2);

            session.removeValue("PRINT_REPORT_BUDGET");

            session.putValue("DATE_TRANS_DATE", dateTrans);
            if (iCommand == JSPCommand.NONE) {
                ignore = 1;
                nonpkp = 1;
                pkp = 1;
                dateFrom = new Date();
                dateTo = new Date();
                non = 1;
                konsinyasi = 1;
                komisi = 1;
            }

            Vector list = new Vector();
            Hashtable print = new Hashtable();
            if (iCommand == JSPCommand.GET) {
                try {
                    Vector tmplist = (Vector) session.getValue("REPORT_BUDGET");
                    if (tmplist != null && tmplist.size() > 0) {
                        for (int t = 0; t < tmplist.size(); t++) {
                            SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
                            srbs = (SessReportBudgetSuplier) tmplist.get(t);
                            int select = JSPRequestValue.requestInt(request, "select" + srbs.getBankpoPaymentId());
                            if (select == 1) {
                                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                                bgt.setBankpoPaymentId(srbs.getBankpoPaymentId());
                                bgt.setVendorId(srbs.getVendorId());
                                bgt.setSuplier(srbs.getSuplier());
                                bgt.setDivisi(srbs.getDivisi());
                                bgt.setNoTT(srbs.getNoTT());
                                bgt.setValue(srbs.getValue());
                                bgt.setTransDate(srbs.getTransDate());
                                bgt.setCounter(srbs.getCounter());
                                bgt.setContact(srbs.getContact());
                                bgt.setBankId(srbs.getBankId());
                                bgt.setNoRek(srbs.getNoRek());
                                list.add(bgt);
                            }
                        }
                    }
                } catch (Exception e) {
                }
            }

            Vector list2 = new Vector();
            if (iCommand == JSPCommand.LIST) {
                session.removeValue("REPORT_BUDGET");
                list = SessReportAnggaran.getBudgetSuplierSummary(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER,paymentType,non,konsinyasi,komisi);                                                
                session.putValue("REPORT_BUDGET", list);
            }
            
            Vector history = new Vector();
            try{
                if (iCommand == JSPCommand.LIST || iCommand == JSPCommand.GET || iCommand == JSPCommand.REFRESH) {
                    history = DbReportBudget.getHistoryReport(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp,non,konsinyasi,komisi);
                }
            }catch(Exception e){}            
            
            Hashtable vendorIdx = new Hashtable();
            if (iCommand == JSPCommand.LIST || iCommand == JSPCommand.GET) {
                if(historyPrint == 0){
                    list2 = SessReportAnggaran.getBudgetSuplier(vendorId, dateFrom, dateTo, ignore, pkp, nonpkp, DbVendor.VENDOR_TYPE_SUPPLIER,non,konsinyasi,komisi);
                }else{
                    vendorIdx = DbReportBudget.listNumber(historyPrint);
                }
            }
            
            String v = "";
            int numberx = 1;
            
            for (int i = 0; i < list2.size(); i++) {
                SessReportBudgetSuplier srbs = (SessReportBudgetSuplier) list2.get(i);
                if (v.equalsIgnoreCase("") || v.compareToIgnoreCase(srbs.getSuplier()) != 0) {
                    vendorIdx.put(""+srbs.getVendorId(),""+ numberx);
                    numberx++;                                                                   
                }
                v = srbs.getSuplier();
            }


            String[] langNav = {"Report", "Budget Report Suplier"};
            if (lang == LANG_ID) {                
                String[] navID = {"Laporan", "Laporan Budget Suplier"};
                langNav = navID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function setChecked(val){
                 <%
            for (int k = 0; k < list.size(); k++) {
                SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
                srbs = (SessReportBudgetSuplier) list.get(k);
                %>
                    document.form1.select<%=srbs.getBankpoPaymentId()%>.checked=val.checked;
                <%
            }%>
        }
        
        function cmdPrintJournal(){	                       
            window.open("<%=printroot%>.report.RptBudgetSuplierSumPDF?vendorId=<%=vendorId%>&dateFrom=<%=dateFrom%>&dateTo=<%=dateTo%>&ignore=<%=ignore%>&pkp=<%=pkp%>&nonpkp=<%=nonpkp%>&payment_type=<%=paymentType%>&non=<%=non%>&konsinyasi=<%=konsinyasi%>&komisi=<%=komisi%>&user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>&history_print=<%=historyPrint%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdPrintJournalXLS(){	                       
                window.open("<%=printroot%>.report.RptBudgetSuplierSumXLS?vendorId=<%=vendorId%>&dateFrom=<%=dateFrom%>&dateTo=<%=dateTo%>&ignore=<%=ignore%>&pkp=<%=pkp%>&nonpkp=<%=nonpkp%>&payment_type=<%=paymentType%>&non=<%=non%>&konsinyasi=<%=konsinyasi%>&komisi=<%=komisi%>&user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>&history_print=<%=historyPrint%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){                                
                    document.form1.command.value="<%=JSPCommand.LIST%>";
                    document.form1.action="reportbudgetsupliersummary.jsp";
                    document.form1.submit();
                }
                
                function  cmdReload(){
                    document.form1.command.value="<%=JSPCommand.REFRESH %>";
                    document.form1.action="reportbudgetsupliersummary.jsp";
                    document.form1.submit();
                }    
                    
                
                function cmdGenerate(){                                
                    document.form1.command.value="<%=JSPCommand.GET%>";
                    document.form1.action="reportbudgetsupliersummary.jsp";
                    document.form1.submit();
                }
                
                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
                }
                //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <%@ include file="../calendar/calendarframe.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + " (Summary) </span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form id="form1" name="form1" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="valxx">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table  border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="120" class="tablecell1">&nbsp;&nbsp;Suplier</td>
                                                                                <td > 
                                                                                <%
            Vector result = new Vector(1, 1);
            result = DbVendor.list(0, 0, DbVendor.colNames[DbVendor.COL_TYPE] + " = " + DbVendor.VENDOR_TYPE_SUPPLIER, DbVendor.colNames[DbVendor.COL_NAME]);

                                                                                %>
                                                                                <select name="vendor">
                                                                                    <%if (result != null && result.size() > 0) {%>
                                                                                    <option value = "0" <%if (vendorId == 0) {%> selected <%}%> >ALL..</option>
                                                                                    <%
    for (int ix = 0; ix < result.size(); ix++) {
        Vendor vendor = (Vendor) result.get(ix);
                                                                                    %>                                                                            
                                                                                    <option value = "<%=vendor.getOID()%>" <%if (vendor.getOID() == vendorId) {%> selected <%}%> ><%=vendor.getName()%></option>
                                                                                    <%}%>                                                                            
                                                                                    <%}%>
                                                                                </select>    
                                                                            </tr>            
                                                                            <tr> 
                                                                                <td class="tablecell">&nbsp;&nbsp;Trans. Date</td>
                                                                                <td >
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <input name="date_from" value="<%=JSPFormater.formatDate((dateFrom == null) ? new Date() : dateFrom, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                            </td>
                                                                                            <td>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.date_from);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                            </td> 
                                                                                            <td class="fontarial">&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                                                                            <td>
                                                                                                <input name="date_to" value="<%=JSPFormater.formatDate((dateTo == null) ? new Date() : dateTo, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                            </td>
                                                                                            <td>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.date_to);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                            </td> 
                                                                                            <td><input type="checkbox" name = "ignore" value = "1" <%if (ignore == 1) {%>checked<%}%>></td> 
                                                                                            <td class="fontarial">&nbsp;Ignore</td> 
                                                                                        </tr>    
                                                                                    </table>     
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;Status Pajak</td>
                                                                                <td align="left">
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td><input type="checkbox" name = "nonpkp" value = "1" <%if (nonpkp == 1) {%>checked<%}%>></td> 
                                                                                            <td>Non Pkp</td>
                                                                                            <td>&nbsp;&nbsp;<input type="checkbox" name = "pkp" value = "1" <%if (pkp == 1) {%>checked<%}%>></td> 
                                                                                            <td>&nbsp;Pkp</td>
                                                                                        </tr>    
                                                                                    </table>     
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="tablecell" style=padding:3px;>Status Pajak</td>
                                                                                <td align="left">
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td><input type="checkbox" name = "type_non" value = "1" <%if (non == 1) {%>checked<%}%>></td> 
                                                                                            <td class="fontarial">Non</td>
                                                                                            <td>&nbsp;&nbsp;<input type="checkbox" name = "type_konsinyasi" value = "1" <%if (konsinyasi == 1) {%>checked<%}%>></td> 
                                                                                            <td class="fontarial">&nbsp;Konsinyasi</td>
                                                                                            <td>&nbsp;&nbsp;<input type="checkbox" name = "type_komisi" value = "1" <%if (komisi == 1) {%>checked<%}%>></td> 
                                                                                            <td class="fontarial">&nbsp;Komisi</td>
                                                                                        </tr>    
                                                                                    </table>     
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="tablecell">&nbsp;&nbsp;History Print</td>
                                                                                <td>
                                                                                     <select name="history_print" class="fontarial">
                                                                                        <option value="0" <%if (historyPrint == 0) {%> selected<%}%> >< Default ></option>
                                                                                        <%
                                                                                        if(history != null && history.size() > 0 ){
                                                                                            for(int z = 0; z < history.size() ; z++){
                                                                                                ReportBudget rb = (ReportBudget)history.get(z);
                                                                                                String key = rb.getFullName()+" - Printed :"+JSPFormater.formatDate(rb.getCreateDate(), "dd/MM/yyyy HH:mm:ss")+" ("+rb.getIgnore()+" Data)";
                                                                                                
                                                                                            
                                                                                        %>
                                                                                            <option value="<%=rb.getOID()%>" <%if (historyPrint == rb.getOID()) {%> selected<%}%> ><%=key%></option>
                                                                                        <%} }%>
                                                                                    </select>
                                                                                    <a href="javascript:cmdReload()" ><i>Re-Load</i></a> 
                                                                                </td>
                                                                            </tr> 
                                                                            <tr> 
                                                                                <td class="tablecell">&nbsp;&nbsp;Type Pembayaran</td>
                                                                                <td>
                                                                                     <select name="payment_type" class="fontarial">
                                                                                        <option value="-1" <%if (paymentType == -1) {%> selected<%}%> >< All Type ></option>                                                                                                    
                                                                                        <%for (int x = 0; x < DbVendor.valuePayment.length; x++) {%>
                                                                                        <option value="<%=DbVendor.valuePayment[x]%>" <%if (paymentType == Integer.parseInt(DbVendor.valuePayment[x])) {%> selected<%}%> ><%=DbVendor.keyPayment[x]%></option>                                                                                                    
                                                                                        <%}%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr> 
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <table width="700"  border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr height="2">
                                                                                            <td colspan="2" background="../images/line.gif" valign="top"><img src="../images/line.gif"></td>
                                                                                        </tr>    
                                                                                    </table>    
                                                                                </td>
                                                                            </tr>                                                                                
                                                                            <tr>
                                                                                <td colspan="2"> 
                                                                                    <table border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td ><a href="javascript:cmdSearch()"><img src="../images/search2.jpg" width="22" height="22" border="0"></a></td>
                                                                                            <td ><a href="javascript:cmdSearch()">Get Report</a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">&nbsp;</td> 
                                                                            </tr> 
                                                                            <%if (list != null && list.size() > 0) {%>
                                                                            <tr> 
                                                                                <td colspan="2">
                                                                                    <table width="1000" cellpadding="0" cellspacing="1">                                                                                        
                                                                                        <tr height="25">
                                                                                            <td class="tablehdr" width="25">NO</td>
                                                                                            <td class="tablehdr">NAME OF SUPLIER</td>
                                                                                            <td class="tablehdr" width="23%">BRAND OF SUPPLIER</td>
                                                                                            <td class="tablehdr" width="5%">REF</td>
                                                                                            <td class="tablehdr" width="15%">BANK</td>
                                                                                            <td class="tablehdr" width="15%">NO ACCOUNT</td>
                                                                                            <td class="tablehdr" width="12%">PAYMENT</td>
                                                                                            <td class="tablehdr" width="10%">Message For</td>
                                                                                            <td class="tablehdr" width="30"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%
    double totAmount = 0;
    int number = 1;
    for (int i = 0; i < list.size(); i++) {
        SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();
        srbs = (SessReportBudgetSuplier) list.get(i);

        int select = JSPRequestValue.requestInt(request, "select" + srbs.getBankpoPaymentId());
        if (iCommand == JSPCommand.LIST) {
            select = 1;
        }

        if (select == 1) {
            print.put("" + srbs.getBankpoPaymentId(), "" + srbs.getBankpoPaymentId());
        }

        totAmount = totAmount + srbs.getValue();
        Bank b = new Bank();
        try {
            b = DbBank.fetchExc(srbs.getBankId());
        } catch (Exception e) {
        }

        String noRek = "";
        String contact = "";
        if (srbs.getNoRek() != null) {
            noRek = srbs.getNoRek();
        }
        
        if(srbs.getContact() != null){
            contact = srbs.getContact();
        }
        
        int idx = 0;
        try{
            idx = Integer.parseInt(String.valueOf(vendorIdx.get(""+srbs.getVendorId())));
        }catch(Exception e){}
                                                                                        %>
                                                                                        <tr height="20">
                                                                                            <td class="tablecell" align="center">
                                                                                                <%=number%>
                                                                                                <%number = number + 1;%>
                                                                                            </td>
                                                                                            <td class="tablecell" align="left">&nbsp;&nbsp;<%=contact%></td>
                                                                                            <td class="tablecell" align="left"><%=srbs.getSuplier() %></td>
                                                                                            <td class="tablecell" align="center"><%=idx %></td>
                                                                                            <td class="tablecell" align="left"><%=b.getName() %></td>
                                                                                            <td  class="tablecell" align="center"><%=noRek%></td>
                                                                                            <td  class="tablecell" align="right"><%=JSPFormater.formatNumber(srbs.getValue(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                            <td  class="tablecell" align="right"></td>
                                                                                            <td  class="tablecell" align="center"><input type="checkbox" name="select<%=srbs.getBankpoPaymentId()%>" <%if (select == 1) {%> checked<%}%> value="1"></td>
                                                                                        </tr>                                                                                                                                                                                
                                                                                        <%
    }
                                                                                        %>
                                                                                        <tr >                                                                                            
                                                                                            <td colspan="8" background="../images/line.gif" valign="top"><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                        <tr height="25">
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell" align="center"><B>GRAND TOTAL</B></td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                            <td colspan="2" valign="top" class="tablecell" align="right"><B><%=JSPFormater.formatNumber(totAmount, "#,###.##")%></B>&nbsp;&nbsp;</td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td> 
                                                                            </tr>   
                                                                            <%
    session.putValue("PRINT_REPORT_BUDGET", print);
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td width="100"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                                                            <td width="150"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printx','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printx" border="0"></a></td>
                                                                                            <td><a href="javascript:cmdGenerate()"><img src="../images/search2.jpg" width="22" height="22" border="0"></a></td>
                                                                                            <td><a href="javascript:cmdGenerate()">&nbsp;Generate</a></td>
                                                                                        </tr>    
                                                                                    </table>
                                                                                </td>    
                                                                            </tr>    
                                                                            <%
            }
                                                                            %>
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                                                                                           
                                                            </table>
                                                        </form>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>

