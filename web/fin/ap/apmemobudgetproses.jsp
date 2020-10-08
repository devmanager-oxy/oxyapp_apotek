
<%-- 
    Document   : apmemobudgetproses
    Created on : Mar 23, 2016, 11:24:07 AM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../printing/printingvariables.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!

    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {

        int level = 0;
        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    String str = "";
                    if (!isPostableOnly) {
                        level = coax.getLevel() + minus;
                        switch (level) {
                            case 0:
                                break;
                            case 1:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 2:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }
                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";
                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(minus, coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidBudgetRequest = JSPRequestValue.requestLong(request, "hidden_budget_request_id");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            BudgetRequest budgetRequest = new BudgetRequest();
            Vector listDetail = new Vector();
            try {
                budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                if (budgetRequest.getOID() != 0) {
                    listDetail = DbBudgetRequestDetail.list(0, 0, DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + " = " + budgetRequest.getOID(), DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_DATE]);
                }
            } catch (Exception e) {
            }

            CmdReceiveBudget cmdReceiveMemo = new CmdReceiveBudget(request);
            cmdReceiveMemo.setBudgetRequestId(budgetRequest.getOID());
            JSPLine ctrLine = new JSPLine();
            if (iJSPCommand == JSPCommand.SAVE) {

            }
            int iErrCodeMain = cmdReceiveMemo.action(iJSPCommand, oidReceive);
            /* end switch*/
            JspReceiveMemo jspReceiveMemo = cmdReceiveMemo.getForm();
            Receive receive = cmdReceiveMemo.getReceiveMemo();
            String msgString = cmdReceiveMemo.getMessage();

            if (iErrCodeMain == 0 && iJSPCommand == JSPCommand.SAVE) {
                if (receive.getOID() != 0) {
                    SessMemorial.saveAllDetailBudget(budgetRequest, receive, listDetail, user.getOID()); 
                }
            }
 
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_OTHER_REVENUE_AP + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");


            /*** LANG ***/
            String[] langCT = {"Payment Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Expense Account", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully", //10 - 11
                "Searching", "Customer", "Department", "Non postable department, please select another department", "Payment to", "Credit in", "Period", "Segment", "Segment", //12-20
                "Budget Number","Vendor"};

            String[] langNav = {"Cash Transaction", "Cash Payment", "Date", "Required", "Searching", "Disbushment Editor", "Payment Type"};

            if (lang == LANG_ID) {
                String[] langID = {"Account Pembayaran", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Untuk Biaya", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses", //10 - 11
                    "Pencarian", "Konsumen", "Departemen", "Bukan department dengan level terendah, Harap memilih department yang levelnya postable", "Dibayarkan kepada", "Kredit", "Periode", "Segmen", "Segmen", //12-20
                    "Nomor Budget","Suplier"};


                langCT = langID;

                String[] navID = {"Transaksi Tunai", "Pembayaran Tunai", "Tanggal", "Harus diisi", "Pencarian", "Editor Pengakuan Biaya", "Tipe Pembayaran"};
                langNav = navID;
            }


            Vector sgDetails = DbSegmentDetail.list(0, 0, "", DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);
            SegmentDetail sDetail = new SegmentDetail();
            try {
                sDetail = DbSegmentDetail.fetchExc(budgetRequest.getSegment1Id());
            } catch (Exception e) {
            }
            Vector listVendor = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);
            long currencyId = 0;
            try {
                currencyId = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
            } catch (Exception e) {
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />    
        <script type="text/javascript" src="<%=approot%>/main/jquery.min.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.searchabledropdown.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $("select").searchable();
            });
            
            $(document).ready(function() {
                $("#value").html($("#searchabledropdown :selected").text() + " (VALUE: " + $("#searchabledropdown").val() + ")");
                $("select").change(function(){
                    $("#value").html(this.options[this.selectedIndex].text + " (VALUE: " + this.value + ")");
                });
            });
        </script>    
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdClickIt(obj){
                obj.select();           
            }            
            
            function cmdSave(){
                document.frmarapmemo.command.value="<%=JSPCommand.SAVE%>";    
                document.frmarapmemo.action="apmemobudgetproses.jsp";
                document.frmarapmemo.submit();
            }
            
            function removeChar(number){                
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);
                    
                    if(!isNaN(xx)){
                        result = result + xx;
                    }else{
                    if(xx==',' || xx=='.'){
                        result = result + xx;
                    }
                }
            }
            
            return result;
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
        //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/newdoc2.gif','../images/deletedoc2.gif')">
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmarapmemo" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                            
                                                            <input type="hidden" name="hidden_budget_request_id" value="<%=oidBudgetRequest%>">
                                                            <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">                                                            
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_INVOICE_NUMBER]%>" value="-">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_PURCHASE_ID]%>" value="0">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TYPE_AP]%>" value="<%=DbReceive.TYPE_AP_YES%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_INCLUDE_TAX]%>" value="<%=DbReceive.INCLUDE_TAX_NO%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_PAYMENT_TYPE]%>" value="<%=I_Project.PAYMENT_TYPE_CASH%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                    
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="100%"> 
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td > 
                                                                                                            <table border="0" cellspacing="2" cellpadding="1">                                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td width="100" nowrap class="tablecell1" style="padding:3px;"><%=langCT[4]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td width="450" class="fontarial"> 
                                                                                                                        <%

    Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

    String strNumber = "";
    Periode open = new Periode();
    if (receive.getPeriodId() != 0) {
        try {
            open = DbPeriode.fetchExc(receive.getPeriodId());
        } catch (Exception e) {
        }
    } else {
        if (periods != null && periods.size() > 0) {
            open = (Periode) periods.get(0);
        }
    }

    int counterJournal = DbSystemDocNumber.getNextCounterApMemo(open.getOID());
    strNumber = DbSystemDocNumber.getNextNumberApMemo(counterJournal, open.getOID());

    if (receive.getOID() != 0 || oidReceive != 0) {
        strNumber = receive.getNumber();
    }
                                                                                                                        %>
                                                                                                                        <b><%=strNumber%></b>                                                                                 
                                                                                                                    </td>
                                                                                                                    <td width="110" ></td>
                                                                                                                    <td width="1" class="fontarial"></td>
                                                                                                                    <td ></td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td nowrap class="tablecell1" style="padding:3px;"><%=langCT[21]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>                                                                                                                    
                                                                                                                    <td class="fontarial"><%=budgetRequest.getJournalNumber()%></td>
                                                                                                                    <td nowrap class="tablecell1" style="padding:3px;">
                                                                                                                        <%if (periods.size() > 1) {%>
                                                                                                                        <%=langCT[18]%>
                                                                                                                        <%} else {%>
                                                                                                                        &nbsp;
                                                                                                                        <%}%>
                                                                                                                        
                                                                                                                    </td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <%if (open.getStatus().equals("Closed") || receive.getOID() != 0) {%>
                                                                                                                        <%=open.getName()%>
                                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>" value="<%=open.getOID()%>">
                                                                                                                        <%} else {%>
                                                                                                                        <%if (periods.size() > 1) {%>
                                                                                                                        <select name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>">
                                                                                                                            <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                                                                                            %>
                                                                                                                            <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == receive.getPeriodId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                            <%}%>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%} else {%>
                                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>" value="<%=open.getOID()%>">
                                                                                                                        <%}
    }%>                                                                                                                                                                                                                                                 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td nowrap class="tablecell1" style="padding:3px;"><%=langCT[0]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_COA_ID]%>">
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accLinks.size(); i++) {
                    AccLink accLink = (AccLink) accLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                    }

                    if (receive.getCoaId() == 0 && i == 0) {
                        receive.setCoaId(accLink.getCoaId());
                    }
                                                                                                                            %>
                                                                                                                            <option <%if (receive.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, receive.getCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option>select..</option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%= jspReceiveMemo.getErrorMsg(jspReceiveMemo.JSP_COA_ID) %>
                                                                                                                    </td>
                                                                                                                    <td nowrap class="tablecell1" style="padding:3px;"><%=langCT[5]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>
                                                                                                                                <td><%=jspReceiveMemo.getErrorMsg(JspReceiveMemo.JSP_DATE)%></td>
                                                                                                                            </tr>    
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" style="padding:3px;"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <input type="text" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(DbBudgetRequestDetail.getSum(DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + " = " + budgetRequest.getOID()), "#,###.##")%>"  class="readonly" readOnly size="15">
                                                                                                                        <input type="hidden" name = "<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_CURRENCY_ID]%>" value = "<%=currencyId%>"> 
                                                                                                                        <%= jspReceiveMemo.getErrorMsg(jspReceiveMemo.JSP_TOTAL_AMOUNT) %>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" style="padding:3px;"><%=langCT[20]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                          <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_LOCATION_ID]%>" class="fontarial">
                                                                                                                            <%
            Vector locations;
            locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_CODE]);
            
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);                    
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (receive.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>                                                                                                                    
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>                                                                                                                    
                                                                                                                    <td class="tablecell1" style="padding:3px;"><%=langCT[22]%></td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td colspan="3" valign="top"> 
                                                                                                                        <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_VENDOR_ID]%>">
                                                                                                                            <option value="0">- select suplier -</option>
                                                                                                                            <%if (listVendor != null && listVendor.size() > 0) {
                for (int i = 0; i < listVendor.size(); i++) {
                    Vendor v = (Vendor) listVendor.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=v.getOID()%>" <%if (receive.getVendorId() == v.getOID()) {%> selected<%}%> ><%=v.getName()%> - <%=v.getCode()%></option>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                            
                                                                                                                        </select>
                                                                                                                        <%=jspReceiveMemo.getErrorMsg(JspReceiveMemo.JSP_VENDOR_ID)%>
                                                                                                                    </td>
                                                                                                                    <td height="16" colspan="3"></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td height="16" valign="top" class="fontarial">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="23">
                                                                                                                            <tr>
                                                                                                                                <td class="tablecell1" style="padding:3px;"><%=langCT[2]%></td>
                                                                                                                            </tr>    
                                                                                                                        </table>    
                                                                                                                    </td>
                                                                                                                    <td width="1" class="fontarial">:</td>
                                                                                                                    <td rowspan="2" valign="top"> 
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr> 
                                                                                                                                <td><textarea name="<%=jspReceiveMemo.colNames[JspReceiveMemo.JSP_NOTE]%>" cols="40" rows="3"><%=receive.getNote()%></textarea></td>
                                                                                                                                <td valign="top">&nbsp;</td>
                                                                                                                                <td><%= jspReceiveMemo.getErrorMsg(jspReceiveMemo.JSP_NOTE) %></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td height="16" colspan="3"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                                
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="5">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="5" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%" class="page"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr height="24"> 
                                                                                                                    <td class="tablearialhdr" width="25%" height="20"><%=langCT[20]%></td>
                                                                                                                    <td class="tablearialhdr" width="25%" height="20"><%=langCT[7]%></td>                                                                                                                                            
                                                                                                                    <td class="tablearialhdr" width="17%" height="20"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                                                                            
                                                                                                                    <td class="tablearialhdr" ><%=langCT[8]%></td>
                                                                                                                </tr>
                                                                                                                <%
    if (listDetail != null && listDetail.size() > 0) {
        for (int i = 0; i < listDetail.size(); i++) {

            BudgetRequestDetail brd = (BudgetRequestDetail) listDetail.get(i);

            Coa c = new Coa();
            try {
                c = DbCoa.fetchExc(brd.getCoaId());
            } catch (Exception e) {
            }

            String cssString = "tablecell";
            if (i % 2 != 0) {
                cssString = "tablecell1";
            }


                                                                                                                %>
                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td class="<%=cssString%>" style="padding:3px;"><%=sDetail.getName()%></td>
                                                                                                                    <td class="<%=cssString%>" style="padding:3px;"><%=c.getCode()%> - <%=c.getName()%></td>                                                                                                                                            
                                                                                                                    <td class="<%=cssString%>" style="padding:3px;"> 
                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(brd.getRequest(), "#,###.##")%></div>
                                                                                                                    </td>                                                                                                                                            
                                                                                                                    <td class="<%=cssString%>" style="padding:3px;"><%=brd.getMemo()%></td>
                                                                                                                </tr>
                                                                                                                <%
        }
    }
                                                                                                                %>                                                           
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="5">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr>
                                                                                            <td colspan="5">
                                                                                                <table border="0">
                                                                                                    <tr>
                                                                                                        <%if (receive.getOID() == 0) {%>
                                                                                                        <td width="100"><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/save2.gif',1)"><img src="../images/save.gif" name="savedoc21" height="22" border="0" ></a></td>
                                                                                                        <td>&nbsp;</td>
                                                                                                        <%}%>
                                                                                                        <td width="80"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0" ></a></td>                                                                                                                                
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="5">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if(iJSPCommand == JSPCommand.SAVE && iErrCodeMain==0){ %>
                                                                                        <tr>
                                                                                            <td colspan="5">
                                                                                                <table  cellpadding="0" cellspacing="5" align="right" class="success">
                                                                                                    <tr>
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" ></td>
                                                                                                        <td width="50" class="fontarial"><b>Saved</b></td>
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
                                                            <%} catch (Exception e) {
                out.println(e.toString());
            }%>
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
                            <td height="25" colspan="2"> <!-- #BeginEditable "footer" --> 
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