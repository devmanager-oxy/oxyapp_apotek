
<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_DELETE);

%>
<!-- Jsp Block -->
<%!
    public String getSubstring1(String s) {
        if (s.length() > 60) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 55) + "...</font></a>";
        }
        return s;
    }

    public String getSubstring(String s) {
        if (s.length() > 105) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 100) + "...</font></a>";
        }
        return s;
    }
%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCashArchive = JSPRequestValue.requestLong(request, "hidden_casharchive");

            boolean docWorkFlow = false;

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();

            if (JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]).length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]).length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]).length() > 0) {
                transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]), "dd/MM/yyyy");
            }

            int recordToGet = 0;
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "journal_prefix,journal_number";

            CmdCashArchive cmdCashArchive = new CmdCashArchive(request);
            JSPLine jspLine = new JSPLine();
            Vector listCashArchive = new Vector(1, 1);
            CashArchive cashArchive = new CashArchive();
            JspCashArchive jspCashArchive = new JspCashArchive(request, cashArchive);

            int ignoreInputDate = JSPRequestValue.requestInt(request, jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE]);
            int ignoreTransDate = JSPRequestValue.requestInt(request, jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE]);

            if (iCommand == JSPCommand.NONE || iCommand == JSPCommand.BACK) {
                ignoreTransDate = 1;
                ignoreInputDate = 1;
            }

            iErrCode = cmdCashArchive.action(iCommand, oidCashArchive);
            jspCashArchive.requestEntityObject(cashArchive);
            cashArchive = jspCashArchive.getEntityObject();
            cashArchive.setStartDate(startDate);
            cashArchive.setEndDate(endDate);
            cashArchive.setTransactionDate(transDate);

            if (cashArchive.getIgnoreTransactionDate() == 0) {
                whereClause = "trans_date = '" + JSPFormater.formatDate(cashArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
            }

            if (!cashArchive.getJournalNumber().equals("")) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "journal_number like '%" + cashArchive.getJournalNumber() + "%'";
            }

            if (cashArchive.getPeriodeId() != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(cashArchive.getPeriodeId());
                } catch (Exception e) {
                }

                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (cashArchive.getIgnoreInputDate() == 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(cashArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(cashArchive.getEndDate(), "yyyy-MM-dd") + "'";
            }

            if (whereClause != "") {
                whereClause = whereClause + " and ";
            }

            whereClause = whereClause + "posted_status=0";

            int vectSize = 0;

            whereClause = SessCashTransaction.getCondition(cashArchive.getSearchFor(), whereClause);
            vectSize = SessCashTransaction.getVectorSize(cashArchive.getSearchFor(), whereClause);
            start = 0;

            listCashArchive = SessCashTransaction.getListCashArchive(cashArchive.getSearchFor(), start, recordToGet, whereClause, orderClause);

            if (iCommand == JSPCommand.SAVE) {

                if (cashArchive.getSearchFor().equals("cashreceive")) {

                    if (listCashArchive != null && listCashArchive.size() > 0) {
                        for (int i = 0; i < listCashArchive.size(); i++) {
                            CashReceive cr = (CashReceive) listCashArchive.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + cr.getOID()) == 1) {
                                Vector listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, "cash_receive_id=" + cr.getOID(), "");
                                DbCashReceive.postJournal(cr, listCashReceiveDetail, user.getOID());
                            }
                        }
                    }

                    listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);

                } else if (cashArchive.getSearchFor().equals("paymentpettycash")) {

                    if (listCashArchive != null && listCashArchive.size() > 0) {
                        for (int i = 0; i < listCashArchive.size(); i++) {
                            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + pp.getOID()) == 1) {
                                Vector listPPDetail = DbPettycashPaymentDetail.list(0, 0, "pettycash_payment_id=" + pp.getOID(), "");
                                DbPettycashPayment.postJournal(pp, listPPDetail, user.getOID());
                            }
                        }
                    }
                    listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);

                } else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {

                    if (listCashArchive != null && listCashArchive.size() > 0) {
                        for (int i = 0; i < listCashArchive.size(); i++) {
                            PettycashReplenishment pp = (PettycashReplenishment) listCashArchive.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + pp.getOID()) == 1) {
                                DbPettycashReplenishment.postJournal(pp, user.getOID());
                            }
                        }
                    }

                    listCashArchive = DbPettycashReplenishment.list(start, recordToGet, whereClause, orderClause);

                } else if (cashArchive.getSearchFor().equals("advancereceive")) {
                    if (listCashArchive != null && listCashArchive.size() > 0) {
                        for (int i = 0; i < listCashArchive.size(); i++) {
                            CashReceive cr = (CashReceive) listCashArchive.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + cr.getOID()) == 1) {
                                Vector listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, "cash_receive_id=" + cr.getOID(), "");
                                DbCashReceive.postJournal(cr, listCashReceiveDetail, user.getOID());
                            }
                        }
                    }

                    listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);

                } else if (cashArchive.getSearchFor().equals("advance")) {

                    if (listCashArchive != null && listCashArchive.size() > 0) {
                        for (int i = 0; i < listCashArchive.size(); i++) {
                            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + pp.getOID()) == 1) {
                                Vector listPPDetail = DbPettycashPaymentDetail.list(0, 0, "pettycash_payment_id=" + pp.getOID(), "");
                                DbPettycashPayment.postJournal(pp, listPPDetail, user.getOID());
                            }
                        }
                    }

                    listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
                }
            }

            /*** LANG ***/
            String[] langCT = {"Search for", "Journal Number", "Period", "Input Date", "to", "Transaction Date", "Ignore", //0-6
                "Not Posted Cash Receipt", "Journal Number", "Receipt to Account", "Receipt from", "Amount IDR", "Transaction Date", "Memo", //7-13
                "Not Posted Petty Cash Payment", "Journal Number", "Payment from Account", "Amount IDR", "Transaction Date", "Memo", "Activity", //14-20
                "Not Posted Petty Cash Replenishment", "Journal Number", "Replenishment for Account", "From Account", "Amount IDR", "Transaction Date", "Memo", //21-27
                "Please click on the search button to find your data", "List of not posted document is empty", "Not Posted Advance Receive", "Not Posted Advance" //28-31
            };

            String[] langNav = {"Cash Transaction", "Archives", "Date", "Cash Receipt", "Payment Petty Cash", "Replenishment Petty Cash", "Post Journal", "Advance Refund", "Advance Released", "Searching Parameter",
                "Segment", "Account", "Amount", "Memo"
            };

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Penerimaan Tunai Belum Diposting", "Nomor Jurnal", "Perkiraan Penerimaan", "Diterima dari", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //7-13
                    "Pengakuan Biaya Balum Diposting", "Nomor Jurnal", "Pelunasan dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", "Kegiatan", //14-20
                    "Pengisian Kembali Kas Kecil Belum Diposting", "Nomor Jurnal", "Pengisian Kembali untuk Perkiraan", "Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //21-27
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data untuk di posting", "Pengembalian Sisa Kasbon Belum Diposting", "Kasbon Belum Diposting" //28-31
                };
                langCT = langID;

                String[] navID = {"Transaksi Tunai", "Arsip", "Tanggal", "Penerimaan Tunai", "Pengakuan Biaya", "Pengisian Kembali Kas Kecil", "Post Jurnal", "Pengembalian Sisa Kasbon", "Pemberian Kasbon", "Parameter Pencarian",
                    "Segmen", "Perkiraan", "Jumlah", "Keterangan"
                };
                langNav = navID;
            }

            int size = 0;
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" -->
    <title><%=systemTitle%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/default.css" rel="stylesheet" type="text/css" />
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <!--Begin Region JavaScript-->
    <script language="JavaScript">    
        
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function cmdResetStart(){
            document.frmcasharchive.start.value="0";	
        }
        
        function cmdSubmitCommand(){
            document.frmcasharchive.command.value="<%=JSPCommand.SAVE%>";
            document.frmcasharchive.prev_command.value="<%=prevCommand%>";
            document.frmcasharchive.action="casharchivepost.jsp";
            document.frmcasharchive.submit();
        }
        
        function cmdSearch(){
            document.frmcasharchive.start.value="0";	
            document.frmcasharchive.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmcasharchive.prev_command.value="<%=prevCommand%>";
            document.frmcasharchive.action="casharchivepost.jsp";
            document.frmcasharchive.submit();
        }
        
        function cmdEditReceipt(oidReceive){
            document.frmcasharchive.hidden_casharchive.value=oidReceive;
            document.frmcasharchive.action="cashreceivedetailprint.jsp";
            document.frmcasharchive.submit();
        }
        
        function cmdEditPayment(oidPayment){
            document.frmcasharchive.hidden_casharchive.value=oidPayment;
            document.frmcasharchive.action="pettycashpaymentdetailprint.jsp";
            document.frmcasharchive.submit();
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
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/savedoc2.gif','../images/post_journal2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<tr> 
<td valign="top"> 
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr> 
        <td height="96"> 
            <!-- #BeginEditable "header" -->
                         <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
        </td>
    </tr>
    <tr> 
        <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                <!--DWLayoutTable-->
                <tr> 
                    <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                        <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                        <!-- #EndEditable -->
                    </td>
                    <td width="100%" valign="top"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[6] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                <!-- #EndEditable --></td>
                            </tr>                                                
                            <tr> 
                                <td><!-- #BeginEditable "content" --> 
                                    <form name="frmcasharchive" method ="post" action="">
                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                    <input type="hidden" name="start" value="<%=start%>">
                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                    <input type="hidden" name="hidden_casharchive" value="<%=oidCashArchive%>">
                                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                            <td height="8"  colspan="3" class="container"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <!--DWLayoutTable-->
                                                    <tr align="left" valign="top"> 
                                                        <td width="100%" valign="top"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td colspan="4" valign="top"> 
                                                                        <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td colspan="4" valign="top"> 
                                                                        <table width="730" border="0" cellspacing="1" cellpadding="1">   
                                                                            <tr>                                                                                                                                            
                                                                                <td class="tablecell1" >                                                                                                            
                                                                                    <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="6" height="10"></td>
                                                                                        </tr>                                                                                                               
                                                                                        <tr>
                                                                                            <td width="5"></td>
                                                                                            <td width="13%"><%=langCT[0]%></td>
                                                                                            <td width="26%">                                                                                                                         
                                                                                                <select name="<%=jspCashArchive.colNames[jspCashArchive.JSP_SEARCH_FOR] %>">                                                                                                                
                                                                                                    <option value="cashreceive" <%if (cashArchive.getSearchFor().equals("cashreceive")) {%> selected <%}%>><%=langNav[3]%></option>                                                                                                                
                                                                                                    <option value="advancereceive" <%if (cashArchive.getSearchFor().equals("advancereceive")) {%> selected <%}%>><%=langNav[7]%></option>                                                                                                                
                                                                                                    <option value="paymentpettycash" <%if (cashArchive.getSearchFor().equals("paymentpettycash")) {%> selected <%}%>><%=langNav[4]%></option>                                                                                                                
                                                                                                    <option value="advance" <%if (cashArchive.getSearchFor().equals("advance")) {%> selected <%}%>><%=langNav[8]%></option>                                                                                                                
                                                                                                    <option value="paymentreplenishmentcash" <%if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {%> selected <%}%>><%=langNav[5]%></option>                                                                                                                
                                                                                                </select>
                                                                                            </td>
                                                                                            <td width="14%"><%=langCT[3]%></td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getStartDate() == null ? new Date() : cashArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        </td>
                                                                                                        <td>&nbsp;    
                                                                                                            <%=langCT[4]%>  
                                                                                                            &nbsp;
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getEndDate() == null ? new Date() : cashArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                        <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreInputDate == 1) {%>checked<%}%>>
                                                                                                               </td>
                                                                                                        <td>
                                                                                                            <%=langCT[6]%> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="5"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td ></td>
                                                                                            <td ><%=langCT[1]%></td>
                                                                                            <td > 
                                                                                                <input type="text" name="<%=jspCashArchive.colNames[jspCashArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= cashArchive.getJournalNumber() %>">
                                                                                            </td>
                                                                                            <td ><%=langCT[5]%></td>
                                                                                            <td > 
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getTransactionDate() == null ? new Date() : cashArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                        <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreTransDate == 1) {%>checked<%}%>><%=langCT[6]%>
                                                                                                               </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td ></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td ></td>
                                                                                            <td ><%=langCT[2]%></td>
                                                                                            <td > 
                                                                                                <select name="<%=jspCashArchive.colNames[JspCashArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                    <option value="0" <%if (cashArchive.getPeriodeId() == 0) {%> selected <%}%> >< all periode ></option>
                                                                                                    <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");
            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=period.getOID()%>" <%if (cashArchive.getPeriodeId() == period.getOID()) {%> selected <%}%> ><%=period.getName().trim()%></option>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td ></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="1">&nbsp;</td>
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
                                                    <tr> 
                                                        <td><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> </td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="15"></td>
                                                    </tr>
                                                    <%
            if (listCashArchive != null && listCashArchive.size() > 0) {

                if (!cashArchive.getSearchFor().equals("")) {
                    if (cashArchive.getSearchFor().equals("cashreceive")) {
                                                    %>
                                                    <tr> 
                                                        <td><b><i><%=langCT[7]%></i></b></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="3"></td>
                                                    </tr>
                                                    <tr> 
                                                        <td class="boxed1"> 
                                                            <table width="1050" border="0" cellspacing="1" cellpadding="1">
                                                            <tr height="26"> 
                                                                <td width="2%" class="tablearialhdr">&nbsp;</td>
                                                                <td width="13%" class="tablearialhdr"><%=langCT[8]%></td>
                                                                <td width="16%" class="tablearialhdr"><%=langCT[9]%></td>
                                                                <td width="14%" class="tablearialhdr"><%=langNav[10]%></td>
                                                                <td width="12%" class="tablearialhdr"><%=langCT[11]%></td>
                                                                <td width="13%" class="tablearialhdr"><%=langCT[12]%></td>
                                                                <td width="30%" class="tablearialhdr"><%=langCT[13]%></td>
                                                            </tr>
                                                            <%
                                                                vectSize = 0;
                                                                if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                    for (int i = 0; i < listCashArchive.size(); i++) {
                                                                        CashReceive bd = (CashReceive) listCashArchive.get(i);
                                                                        if (DbApprovalDoc.isPostingReady(bd.getOID()) || docWorkFlow == false) {

                                                                            vectSize = vectSize + 1;
                                                                            size = size + 1;
                                                                            Coa coa = new Coa();
                                                                            try {
                                                                                coa = DbCoa.fetchExc(bd.getCoaId());
                                                                            } catch (Exception e) {
                                                                            }
                                                            %>
                                                            <tr height="22"> 
                                                                <td class="tablearialcell1" width="3%">  
                                                                    <div align="center"> 
                                                                        <input type="checkbox" name="check_<%=bd.getOID()%>" value="1">
                                                                    </div>
                                                                </td>
                                                                <td class="tablearialcell1" width="13%" align="center"><%=bd.getJournalNumber()%></td>
                                                                <td class="tablearialcell1" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                <td class="tablearialcell1" width="14%">
                                                                    <div align="left"> 
                                                                        <%
                                                                        String segment1 = "";
                                                                        try {
                                                                            if (bd.getSegment1Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment1Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment2Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment2Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment3Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment3Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment4Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment4Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment5Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment5Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment6Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment6Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment7Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment7Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment8Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment8Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment9Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment9Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment10Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment10Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment11Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment11Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment12Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment12Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment13Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment13Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment14Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment14Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                            if (bd.getSegment15Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(bd.getSegment15Id());
                                                                                segment1 = segment1 + sd.getName() + " | ";
                                                                            }
                                                                        } catch (Exception e) {
                                                                        }

                                                                        if (segment1.length() > 0) {
                                                                            segment1 = segment1.substring(0, segment1.length() - 3);
                                                                        }
                                                                        %>
                                                                    <%=segment1%></div>
                                                                    
                                                                </td>
                                                                <td class="tablearialcell1" width="12%"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                                </td>
                                                                <td class="tablearialcell1" width="13%"> 
                                                                    <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                                                </td>
                                                                <td class="tablearialcell1"><%=getSubstring(bd.getMemo())%></td>
                                                            </tr>
                                                            <%
                                                                        Vector crd = new Vector();
                                                                        crd = DbCashReceiveDetail.list(0, 0, DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + " = " + bd.getOID(), null);
                                                                        if (crd != null && crd.size() > 0) {
                                                            %>
                                                            <tr height="20">
                                                            <td class="tablecell">&nbsp;</td>
                                                            <td class="tablecell1" colspan="5">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                    <tr height="20">
                                                                        <td class="tablearialcell" align="center" width="25%"><B><%=langNav[10]%></b></td>                                                                        
                                                                        <td class="tablearialcell" align="center" ><B><%=langNav[11]%></b></td>
                                                                        <td class="tablearialcell" align="center" width="15%"><B><%=langNav[12]%></b></td>
                                                                        <td class="tablearialcell" align="center" width="30%"><B><%=langNav[13]%></b></td>
                                                                    </tr>  
                                                                    <%
                                                                for (int t = 0; t < crd.size(); t++) {
                                                                    CashReceiveDetail cd = (CashReceiveDetail) crd.get(t);
                                                                    Coa c = new Coa();
                                                                    try {
                                                                        c = DbCoa.fetchExc(cd.getCoaId());
                                                                    } catch (Exception e) {
                                                                    }
                                                                    %>
                                                                    <tr height="20">
                                                                        <td class="tablecell" >
                                                                            <div align="left"> 
                                                                                <%
                                                                        String segment = "";
                                                                        try {
                                                                            if (cd.getSegment1Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment1Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment2Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment2Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment3Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment3Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment4Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment4Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment5Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment5Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment6Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment6Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment7Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment7Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment8Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment8Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment9Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment9Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment10Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment10Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment11Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment11Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment12Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment12Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment13Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment13Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment14Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment14Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                            if (cd.getSegment15Id() != 0) {
                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment15Id());
                                                                                segment = segment + sd.getName() + " | ";
                                                                            }
                                                                        } catch (Exception e) {
                                                                        }

                                                                        if (segment.length() > 0) {
                                                                            segment = segment.substring(0, segment.length() - 3);
                                                                        }
                                                                                %>
                                                                            <%=segment%></div>
                                                                        </td>                                                                        
                                                                        <td class="tablearialcell" ><%=c.getCode()%> - <%=c.getName()%></td>                                                                        
                                                                        <td class="tablearialcell" ><div align="right"><%=JSPFormater.formatNumber(cd.getAmount(), "#,###.##")%>&nbsp;&nbsp;&nbsp;</div></td>                                                                        
                                                                        <td class="tablearialcell" >&nbsp;<%=cd.getMemo() %></td>                                                                        
                                                                    </tr>
                                                                    <%}%>
                                                                </table>
                                                            </td>
                                                            <td class="tablecell">&nbsp;</td>
                                                        </td>  
                                                    </tr>    
                                                    <%}

                                                                        }
                                                                    }
                                                                }
                                                    %>
                                                </table>
                                            </td>
                                        </tr>
                                        <%} else if (cashArchive.getSearchFor().equals("advancereceive")) {%>
                                        <tr> 
                                            <td><font face="arial" size="2"><b><i><%=langCT[30]%></i></b></font></td>
                                        </tr>
                                        <tr> 
                                            <td height="3"></td>
                                        </tr>
                                        <tr> 
                                            <td class="boxed1"> 
                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                        <td width="2%" class="tablehdr">&nbsp;</td>
                                                        <td width="13%" class="tablehdr"><%=langCT[8]%></td>
                                                        <td height="26" width="16%" class="tablehdr"><%=langCT[9]%></td>
                                                        <td width="14%" class="tablehdr"><%=langCT[10]%></td>
                                                        <td width="12%" class="tablehdr"><%=langCT[11]%></td>
                                                        <td width="13%" class="tablehdr"><%=langCT[12]%></td>
                                                        <td width="30%" class="tablehdr"><%=langCT[13]%></td>
                                                    </tr>
                                                    <%
                                                                vectSize = 0;

                                                                if (listCashArchive != null && listCashArchive.size() > 0) {

                                                                    for (int i = 0; i < listCashArchive.size(); i++) {

                                                                        CashReceive bd = (CashReceive) listCashArchive.get(i);

                                                                        if (DbApprovalDoc.isPostingReady(bd.getOID()) || true) {

                                                                            vectSize = vectSize + 1;
                                                                            size = size + 1;
                                                                            Coa coa = new Coa();
                                                                            try {
                                                                                coa = DbCoa.fetchExc(bd.getCoaId());
                                                                            } catch (Exception e) {
                                                                            }

                                                                            Employee em = new Employee();
                                                                            try {
                                                                                em = DbEmployee.fetchExc(bd.getReceiveFromId());
                                                                            } catch (Exception e) {
                                                                            }

                                                                            if (i % 2 != 0) {

                                                    %>
                                                    <tr> 
                                                        <td class="tablecell" width="2%"> 
                                                            <div align="center"> 
                                                                <input type="checkbox" name="check_<%=bd.getOID()%>" value="1">
                                                            </div>
                                                        </td>
                                                        <td class="tablecell" width="13%"><%=bd.getJournalNumber()%></td>
                                                        <td class="tablecell" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                        <td class="tablecell" width="14%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                        <td class="tablecell" width="12%"> 
                                                            <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                        </td>
                                                        <td class="tablecell" width="13%"> 
                                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                                        </td>
                                                        <td class="tablecell" width="30%"><%=getSubstring(bd.getMemo())%></td>
                                                    </tr>
                                                    <%
                                                                } else {
                                                    %>
                                                    <tr> 
                                                        <td class="tablecell1" width="2%"> 
                                                            <div align="center"> 
                                                                <input type="checkbox" name="check_<%=bd.getOID()%>" value="1">
                                                            </div>
                                                        </td>
                                                        <td class="tablecell1" width="13%"><%=bd.getJournalNumber()%></td>
                                                        <td class="tablecell1" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                        <td class="tablecell1" width="14%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                        <td class="tablecell1" width="12%"> 
                                                            <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                        </td>
                                                        <td class="tablecell1" width="13%"> 
                                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                                        </td>
                                                        <td class="tablecell1" width="30%"><%=getSubstring(bd.getMemo())%></td>
                                                    </tr>
                                                    <%
                                                                            }
                                                                        }//end approval
                                                                    }
                                                                }
                                                    %>
                                                </table>
                                            </td>
                                        </tr>
                                        <%
                                                            } else if (cashArchive.getSearchFor().equals("paymentpettycash")) {
                                        %>
                                        <tr> 
                                            <td><b><i><%=langCT[14]%></i></b></td>
                                        </tr>
                                        <tr> 
                                            <td height="3"></td>
                                        </tr>
                                        <tr> 
                                            <td class="boxed1"> 
                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                <tr height="28"> 
                                                    <td width="2%"  class="tablearialhdr">&nbsp;</td>
                                                    <td width="10%" class="tablearialhdr"><%=langCT[15]%></td>
                                                    <td height="26" width="16%" class="tablearialhdr"><%=langCT[16]%></td>
                                                    <td height="26" width="10%" class="tablearialhdr">Segmen</td>
                                                    <td width="17%" class="tablearialhdr"><%=langCT[17]%></td>
                                                    <td width="11%" class="tablearialhdr"><%=langCT[18]%></td>
                                                    <td class="tablearialhdr"><%=langCT[19]%></td>                                                
                                                </tr>
                                                <%

                                                                vectSize = 0;

                                                                if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                    for (int i = 0; i < listCashArchive.size(); i++) {
                                                                        PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                        boolean isPostingReady = DbApprovalDoc.isPostingReady(pp.getOID());
                                                                        SegmentDetail sd = new SegmentDetail();
                                                                        try {
                                                                            sd = DbSegmentDetail.fetchExc(pp.getSegment1Id());
                                                                        } catch (Exception e) {
                                                                        }

                                                                        if (isPostingReady || true) {

                                                                            vectSize = vectSize + 1;
                                                                            size = size + 1;
                                                                            Coa coa = new Coa();
                                                                            try {
                                                                                coa = DbCoa.fetchExc(pp.getCoaId());
                                                                            } catch (Exception e) {
                                                                            }
                                                %>
                                                <tr> 
                                                    <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=pp.getOID()%>" value="1"></td>
                                                    <td class="tablecell1" align="center"><%=pp.getJournalNumber()%></td>
                                                    <td class="tablecell1" ><%=coa.getCode() + " - " + coa.getName()%></td>
                                                    <td class="tablecell1" > 
                                                        <div align="left"><%=sd.getName()%></div>
                                                    </td>
                                                    <td class="tablecell1" > 
                                                        <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                    </td>
                                                    <td class="tablecell1" > 
                                                        <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                                    </td>
                                                    <td class="tablecell1" ><%=getSubstring(pp.getMemo())%></td>                                                
                                                </tr>
                                                <%
                                                                                                                            Vector ppd = DbPettycashPaymentDetail.list(0, 0, DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + " = " + pp.getOID(), null);
                                                                                                                            if (ppd != null && ppd.size() > 0) {%>
                                                <tr height="20">
                                                <td class="tablecell">&nbsp;</td>
                                                <td class="tablecell1" colspan="5">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                        <tr height="22">
                                                            <td class="tablearialcell" align="center" width="25%"><B><%=langNav[10]%></b></td>                                                                        
                                                            <td class="tablearialcell" align="center" ><B><%=langNav[11]%></b></td>
                                                            <td class="tablearialcell" align="center" width="15%"><B><%=langNav[12]%></b></td>
                                                            <td class="tablearialcell" align="center" width="30%"><B><%=langNav[13]%></b></td>
                                                        </tr>  
                                                        <%
                                                    for (int t = 0; t < ppd.size(); t++) {
                                                        PettycashPaymentDetail cd = (PettycashPaymentDetail) ppd.get(t);
                                                        Coa c = new Coa();
                                                        try {
                                                            c = DbCoa.fetchExc(cd.getCoaId());
                                                        } catch (Exception e) {
                                                        }
                                                        %>
                                                        <tr height="22">
                                                            <td class="tablearialcell" >
                                                                <div align="left"> 
                                                                    <%
                                                            String segment = "";
                                                            try {
                                                                if (cd.getSegment1Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment1Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment2Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment2Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment3Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment3Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment4Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment4Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment5Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment5Id());
                                                                    segment = segment + sd.getName() + " | ";
                                                                }
                                                                if (cd.getSegment6Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment6Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment7Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment7Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment8Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment8Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment9Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment9Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment10Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment10Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment11Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment11Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment12Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment12Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment13Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment13Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment14Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment14Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                                if (cd.getSegment15Id() != 0) {
                                                                    SegmentDetail sdx = DbSegmentDetail.fetchExc(cd.getSegment15Id());
                                                                    segment = segment + sdx.getName() + " | ";
                                                                }
                                                            } catch (Exception e) {
                                                            }

                                                            if (segment.length() > 0) {
                                                                segment = segment.substring(0, segment.length() - 3);
                                                            }
                                                                    %>
                                                                <%=segment%></div>
                                                            </td>                                                                        
                                                            <td class="tablearialcell" ><%=c.getCode()%> - <%=c.getName()%></td>                                                                        
                                                            <td class="tablearialcell" ><div align="right"><%=JSPFormater.formatNumber(cd.getAmount(), "#,###.##")%>&nbsp;&nbsp;&nbsp;</div></td>                                                                        
                                                            <td class="tablearialcell" >&nbsp;<%=cd.getMemo() %></td>                                                                        
                                                        </tr>                                                                                                            
                                                        <%}%>                                                
                                                        <tr>
                                                            <td colspan="4" background="../images/line.gif"><img src="../images/line.gif"></td>
                                                        </tr>    
                                                    </table>
                                                </td>
                                                <td class="tablecell">&nbsp;</td>
                                            </td>  
                                        </tr>   
                                        <%
                                                                            }
                                                                        }//end posting ready
                                                                    }
                                                                }
                                        %>
                                    </table>
                                </td>
                            </tr>                                                                            
                            <%
                                                            } else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {
                            %>
                            <tr> 
                                <td><font size="2" face="arial"><%=langCT[21]%></font></td>
                            </tr>                                                                            
                            <tr> 
                                <td class="boxed1"> 
                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                            <td width="7%" class="tablehdr"><%=langCT[22]%></td>
                                            <td height="26" width="20%" class="tablehdr"><%=langCT[23]%></td>
                                            <td width="20%" class="tablehdr"><%=langCT[24]%></td>
                                            <td width="13%" class="tablehdr"><%=langCT[25]%></td>
                                            <td width="7%" class="tablehdr"><%=langCT[26]%></td>
                                            <td width="33%" class="tablehdr"><%=langCT[27]%>Z</td>
                                        </tr>
                                        <%
                                                                if (listCashArchive != null && listCashArchive.size() > 0) {

                                                                    for (int i = 0; i < listCashArchive.size(); i++) {

                                                                        PettycashReplenishment pr = (PettycashReplenishment) listCashArchive.get(i);

                                                                        Coa coa = new Coa();
                                                                        try {
                                                                            coa = DbCoa.fetchExc(pr.getReplaceCoaId());
                                                                        } catch (Exception e) {
                                                                        }

                                                                        size = size + 1;
                                                                        Coa coax = new Coa();

                                                                        try {
                                                                            coax = DbCoa.fetchExc(pr.getReplaceFromCoaId());
                                                                        } catch (Exception e) {
                                                                        }

                                                                        if (i % 2 != 0) {
                                        %>
                                        <tr> 
                                            <td class="tablecell"><%=pr.getJournalNumber()%></td>
                                            <td class="tablecell"><%=coa.getCode() + " - " + coa.getName()%></td>
                                            <td class="tablecell"><%=coax.getCode() + " - " + coax.getName()%></td>
                                            <td class="tablecell"> 
                                                <div align="right"><%=JSPFormater.formatNumber(pr.getReplaceAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell"> 
                                                <div align="center"><%=JSPFormater.formatDate(pr.getTransDate(), "dd-MMM-yyyy")%></div>
                                            </td>
                                            <td class="tablecell"><%=getSubstring1(pr.getMemo())%></td>
                                        </tr>
                                        <%
                                                } else {
                                        %>
                                        <tr> 
                                            <td class="tablecell1"><%=pr.getJournalNumber()%></td>
                                            <td class="tablecell1"><%=coa.getCode() + " - " + coa.getName()%></td>
                                            <td class="tablecell1"><%=coax.getCode() + " - " + coax.getName()%></td>
                                            <td class="tablecell1"> 
                                                <div align="right"><%=JSPFormater.formatNumber(pr.getReplaceAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                                <div align="center"><%=JSPFormater.formatDate(pr.getTransDate(), "dd-MMM-yyyy")%></div>
                                            </td>
                                            <td class="tablecell1"><%=getSubstring1(pr.getMemo())%></td>
                                        </tr>
                                        <%
                                                                        }
                                                                    }
                                                                }
                                        %>
                                    </table>
                                </td>
                            </tr>
                            
                            <%
                                                            }
                                                            if (cashArchive.getSearchFor().equals("cashadvance")) {
                            %>
                            <tr> 
                                <td><font face="arial" size="2"><%=langCT[30]%></font></td>
                            </tr>
                            <tr> 
                                <td height="3"></td>
                            </tr>
                            <tr> 
                                <td class="boxed1"> 
                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                            <td width="2%" class="tablehdr">&nbsp;</td>
                                            <td width="13%" class="tablehdr"><%=langCT[8]%></td>
                                            <td height="26" width="16%" class="tablehdr"><%=langCT[9]%></td>
                                            <td width="14%" class="tablehdr"><%=langCT[10]%></td>
                                            <td width="12%" class="tablehdr"><%=langCT[11]%></td>
                                            <td width="13%" class="tablehdr"><%=langCT[12]%></td>
                                            <td width="30%" class="tablehdr"><%=langCT[13]%></td>
                                        </tr>
                                        <%
                                if (listCashArchive != null && listCashArchive.size() > 0) {

                                    for (int i = 0; i < listCashArchive.size(); i++) {

                                        CashReceive bd = (CashReceive) listCashArchive.get(i);
                                        size = size + 1;
                                        Coa coa = new Coa();
                                        try {
                                            coa = DbCoa.fetchExc(bd.getCoaId());
                                        } catch (Exception e) {
                                        }

                                        Employee em = new Employee();

                                        try {
                                            em = DbEmployee.fetchExc(bd.getReceiveFromId());
                                        } catch (Exception e) {
                                        }

                                        if (i % 2 != 0) {

                                        %>
                                        <tr> 
                                            <td class="tablecell" width="2%"> 
                                                <div align="center"> 
                                                    <input type="checkbox" name="check_<%=bd.getOID()%>" value="1">
                                                </div>
                                            </td>
                                            <td class="tablecell" width="13%"><%=bd.getJournalNumber()%></td>
                                            <td class="tablecell" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                            <td class="tablecell" width="14%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                            <td class="tablecell" width="12%"> 
                                                <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="13%"> 
                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                            </td>
                                            <td class="tablecell" width="30%"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
                                                } else {
                                        %>
                                        <tr> 
                                            <td class="tablecell1" width="2%"> 
                                                <div align="center"> 
                                                    <input type="checkbox" name="check_<%=bd.getOID()%>" value="1">
                                                </div>
                                            </td>
                                            <td class="tablecell1" width="13%"><%=bd.getJournalNumber()%></td>
                                            <td class="tablecell1" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                            <td class="tablecell1" width="14%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                            <td class="tablecell1" width="12%"> 
                                                <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="13%"> 
                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                            </td>
                                            <td class="tablecell1" width="30%"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
                                        }
                                    }
                                }
                                        %>
                                    </table>
                                </td>
                            </tr>
                            
                            <%
                            } else if (cashArchive.getSearchFor().equals("advance")) {
                            %>
                            <tr> 
                                <td><font size="2" face="arial"><%=langCT[31]%></font></td>
                            </tr>
                            <tr> 
                                <td height="3"></td>
                            </tr>
                            <tr> 
                                <td class="boxed1"> 
                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                            <td width="2%" class="tablehdr">&nbsp;</td>
                                            <td width="14%" class="tablehdr"><%=langCT[15]%></td>
                                            <td height="26" width="16%" class="tablehdr"><%=langCT[16]%></td>
                                            <td width="17%" class="tablehdr"><%=langCT[17]%></td>
                                            <td width="11%" class="tablehdr"><%=langCT[18]%></td>
                                            <td width="31%" class="tablehdr"><%=langCT[19]%></td>
                                            <td width="9%" class="tablehdr"><%=langCT[20]%></td>
                                        </tr>
                                        <%

                                vectSize = 0;

                                if (listCashArchive != null && listCashArchive.size() > 0) {
                                    for (int i = 0; i < listCashArchive.size(); i++) {
                                        PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                        boolean isPostingReady = DbApprovalDoc.isPostingReady(pp.getOID());

                                        if (isPostingReady || true) {

                                            vectSize = vectSize + 1;
                                            size = size + 1;
                                            Coa coa = new Coa();
                                            try {
                                                coa = DbCoa.fetchExc(pp.getCoaId());
                                            } catch (Exception e) {
                                            }
                                            if (i % 2 != 0) {

                                        %>
                                        <tr> 
                                            <td class="tablecell" width="2%"> 
                                                <div align="center"> 
                                                    <input type="checkbox" name="check_<%=pp.getOID()%>" value="1">
                                                </div>
                                            </td>
                                            <td class="tablecell" width="14%"><%=pp.getJournalNumber()%></td>
                                            <td class="tablecell" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                            <td class="tablecell" width="17%"> 
                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="11%"> 
                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                            </td>
                                            <td class="tablecell" width="31%"><%=getSubstring(pp.getMemo())%></td>
                                            <td class="tablecell" width="9%"> 
                                                <div align="center"> 
                                                    <%if (pp.getActivityStatus().equals(I_Project.NA_POSTED_STATUS)) {%>
                                                    <img src="../images/yesx.gif" width="17" height="14"> 
                                                    <%} else {%>
                                                    - 
                                                    <%}%>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                                                            } else {
                                        %>
                                        <tr> 
                                            <td class="tablecell1" width="2%"> 
                                                <div align="center"> 
                                                    <input type="checkbox" name="check_<%=pp.getOID()%>" value="1">
                                                </div>
                                            </td>
                                            <td class="tablecell1" width="14%"><%=pp.getJournalNumber()%></td>
                                            <td class="tablecell1" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                            <td class="tablecell1" width="17%"> 
                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="11%"> 
                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                            </td>
                                            <td class="tablecell1" width="31%"><%=getSubstring(pp.getMemo())%></td>
                                            <td class="tablecell1" width="9%"> 
                                                <div align="center"> 
                                                    <%if (pp.getActivityStatus().equals(I_Project.NA_POSTED_STATUS)) {%>
                                                    <img src="../images/yesx.gif" width="17" height="14"> 
                                                    <%} else {%>
                                                    - 
                                                    <%}%>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        }//end is postingready
                                    }
                                }
                                        %>
                                    </table>
                                </td>
                            </tr>
                            
                            
                            <%
                                                            }
                                                        }
                                                    } else {
                            %>
                            <tr> 
                                <td class="boxed1"> 
                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">                                                                                       
                                        <tr> 
                                            <td colspan="8" height="25"><i> 
                                                    <%if (iCommand == JSPCommand.NONE) {%>
                                                    <%=langCT[28]%> 
                                                    <%} else {%>
                                                    <%=langCT[29]%> 
                                                <%}%></i>
                                            </td>
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
                <tr align="left" valign="top"> 
                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                </tr>                                                                
                <%if (size > 0) {%>
                <tr align="left" valign="top" > 
                    <td colspan="3" class="container">
                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a> 
                    </td>
                </tr>
                <%}%>
                <tr align="left" valign="top" > 
                    <td colspan="3" class="container">&nbsp;</td>
                </tr>                                                               
            </table>                                                           
            </form>
            <!-- #EndEditable -->
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
<tr> 
    <td height="25"> 
        <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
    </td>
</tr>
</table>
</td>
</tr>
</table>
</body>
<!-- #EndTemplate --></html>