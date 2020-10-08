
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
            boolean priv = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP);
            boolean privView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_VIEW);
            boolean privUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_UPDATE);
            boolean privAdd = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_ADD);
            boolean privDelete = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRP, AppMenu.PRIV_DELETE);

            boolean privCR = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR);
            boolean privViewCR = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR, AppMenu.PRIV_VIEW);
            boolean privUpdateCR = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR, AppMenu.PRIV_UPDATE);

            boolean privPP = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP);
            boolean privViewPP = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_VIEW);
            boolean privUpdatePP = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_UPDATE);

            boolean privPR = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR);
            boolean privViewPR = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR, AppMenu.PRIV_VIEW);
            boolean privUpdatePR = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPR, AppMenu.PRIV_UPDATE);

            boolean privAR = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA);
            boolean privViewAR = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA, AppMenu.PRIV_VIEW);
            boolean privUpdateAR = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA, AppMenu.PRIV_UPDATE);

            boolean privA = true;//QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA);
            boolean privViewA = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_VIEW);
            boolean privUpdateA = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_UPDATE);

            boolean privPosting = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_UPDATE);

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

            //int recordToGet = 15;
            int recordToGet = 0;
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "journal_number";

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

            if (!cashArchive.getJournalNumber().equals("")){
                if (whereClause != ""){
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "journal_number like '%" + cashArchive.getJournalNumber() + "%'";
            }

            if (cashArchive.getPeriodeId() != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(cashArchive.getPeriodeId());
                } catch (Exception e){}

                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (cashArchive.getIgnoreInputDate() == 0){
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(cashArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(cashArchive.getEndDate(), "yyyy-MM-dd") + "'";
            }

            if (whereClause != ""){
                whereClause = whereClause + " and ";
            }
            
            whereClause = whereClause + "posted_status=0";

            int vectSize = 0;

            whereClause = SessCashTransaction.getCondition(cashArchive.getSearchFor(), whereClause);
            vectSize = SessCashTransaction.getVectorSize(cashArchive.getSearchFor(), whereClause);

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)){
                //start = cmdCashArchive.actionList(iCommand, start, vectSize, recordToGet);
                start = 0;
            }
            
            listCashArchive = SessCashTransaction.getListCashArchive(cashArchive.getSearchFor(), start, recordToGet, whereClause, orderClause);

            if (iCommand == JSPCommand.SAVE){

                if (cashArchive.getSearchFor().equals("cashreceive")){

                    if (listCashArchive != null && listCashArchive.size() > 0){
                        for (int i = 0; i < listCashArchive.size(); i++) {
                            CashReceive cr = (CashReceive) listCashArchive.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + cr.getOID()) == 1) {
                                Vector listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, "cash_receive_id=" + cr.getOID(), "");
                                DbCashReceive.postJournal(cr, listCashReceiveDetail, user.getOID());
                            }
                        }
                    }

                    listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);

                } else if (cashArchive.getSearchFor().equals("paymentpettycash")){

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

                } else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")){

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

                } else if (cashArchive.getSearchFor().equals("advance")){

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

            String[] langNav = {"Cash Transaction", "Archives", "Date", "Cash Receipt", "Payment Petty Cash", "Replenishment Petty Cash", "Post Journal", "Advance Refund", "Advance Released"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Penerimaan Tunai Belum Diposting", "Nomor Jurnal", "Perkiraan Penerimaan", "Diterima dari", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //7-13
                    "Pengakuan Biaya Balum Diposting", "Nomor Jurnal", "Pelunasan dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", "Kegiatan", //14-20
                    "Pengisian Kembali Kas Kecil Belum Diposting", "Nomor Jurnal", "Pengisian Kembali untuk Perkiraan", "Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //21-27
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data untuk di posting", "Pengembalian Sisa Kasbon Belum Diposting", "Kasbon Belum Diposting" //28-31
                };
                langCT = langID;

                String[] navID = {"Transaksi Tunai", "Arsip", "Tanggal", "Penerimaan Tunai", "Pengakuan Biaya", "Pengisian Kembali Kas Kecil", "Post Jurnal", "Pengembalian Sisa Kasbon", "Pemberian Kasbon"};
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
            
            function setChecked(val) {
            <%
            for (int i = 0; i < listCashArchive.size(); i++) {
                if (cashArchive.getSearchFor().equals("cashreceive")) {
                    CashReceive cr = (CashReceive) listCashArchive.get(i);
                    if (DbApprovalDoc.isPostingReady(cr.getOID())) out.println("document.frmcasharchive.check_"+cr.getOID()+".checked=val.checked");
                } else if (cashArchive.getSearchFor().equals("paymentpettycash")) {
                    PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);
                    if(DbApprovalDoc.isPostingReady(pp.getOID())) out.println("document.frmcasharchive.check_"+pp.getOID()+".checked=val.checked");
                } else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {
                    PettycashReplenishment pp = (PettycashReplenishment) listCashArchive.get(i);
                    if(DbApprovalDoc.isPostingReady(pp.getOID())) out.println("document.frmcasharchive.check_"+pp.getOID()+".checked=val.checked");
                } else if (cashArchive.getSearchFor().equals("advancereceive")) {
                    CashReceive cr = (CashReceive) listCashArchive.get(i);
                    if (DbApprovalDoc.isPostingReady(cr.getOID())) out.println("document.frmcasharchive.check_"+cr.getOID()+".checked=val.checked");
                } else if (cashArchive.getSearchFor().equals("advance")) {
                    PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);
                    if(DbApprovalDoc.isPostingReady(pp.getOID())) out.println("document.frmcasharchive.check_"+pp.getOID()+".checked=val.checked");
                }
            }
            %>
            }
            
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
            
            function cmdEditReplenishment(oidReplenishment){
                document.frmcasharchive.hidden_casharchive.value=oidReplenishment;
                document.frmcasharchive.action="pettycashreplenishmentconfirmprint.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListFirst(){
                document.frmcasharchive.command.value="<%=JSPCommand.FIRST%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcasharchive.action="casharchivepost.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListPrev(){
                document.frmcasharchive.command.value="<%=JSPCommand.PREV%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcasharchive.action="casharchivepost.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListNext(){
                document.frmcasharchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcasharchive.action="casharchivepost.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListLast(){
                document.frmcasharchive.command.value="<%=JSPCommand.LAST%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcasharchive.action="casharchivepost.jsp";
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
                                                                                <td width="100%" height="127" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                   
                                                                                                    <tr> 
                                                                                                        <td width="13%"><%=langCT[0]%></td>
                                                                                                        <td width="26%"> 
                                                                                                            <%

                                                                                                            %>
                                                                                                            <select name="<%=jspCashArchive.colNames[jspCashArchive.JSP_SEARCH_FOR] %>">
                                                                                                                <%if (privUpdate) {//privViewCR) {%>
                                                                                                                <option value="cashreceive" <%if (cashArchive.getSearchFor().equals("cashreceive")) {%> selected <%}%>><%=langNav[3]%></option>
                                                                                                                <%}%>
                                                                                                                <%if (privUpdate) {//privViewAR) {%>
                                                                                                                <option value="advancereceive" <%if (cashArchive.getSearchFor().equals("advancereceive")) {%> selected <%}%>><%=langNav[7]%></option>
                                                                                                                <%}%>
                                                                                                                <%if (privUpdate) {//privViewPP) {%>
                                                                                                                <option value="paymentpettycash" <%if (cashArchive.getSearchFor().equals("paymentpettycash")) {%> selected <%}%>><%=langNav[4]%></option>
                                                                                                                <%}%>
                                                                                                                <%if (privUpdate) {//privViewA) {%>                                                                                                    
                                                                                                                <option value="advance" <%if (cashArchive.getSearchFor().equals("advance")) {%> selected <%}%>><%=langNav[8]%></option>
                                                                                                                <%}%>                                                                                                   
                                                                                                                <%if (privUpdate) {//privViewPR) {%>
                                                                                                                <option value="paymentreplenishmentcash" <%if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {%> selected <%}%>><%=langNav[5]%></option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="10%"><%=langCT[3]%></td>
                                                                                                        <td width="51%">
                                                                                                        <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getStartDate() == null ? new Date() : cashArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> <%=langCT[4]%>  
                                                                                                        <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getEndDate() == null ? new Date() : cashArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreInputDate == 1) {%>checked<%}%>>
                                                                                                               <%=langCT[6]%> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="13%"><%=langCT[1]%></td>
                                                                                                        <td width="26%"> 
                                                                                                            <input type="text" name="<%=jspCashArchive.colNames[jspCashArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= cashArchive.getJournalNumber() %>">
                                                                                                        </td>
                                                                                                        <td width="10%"><%=langCT[5]%></td>
                                                                                                        <td width="51%"> 
                                                                                                        <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getTransactionDate() == null ? new Date() : cashArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreTransDate == 1) {%>checked<%}%>><%=langCT[6]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="13%"><%=langCT[2]%></td>
                                                                                                        <td colspan="3"> 
                                                                                                            <select name="<%=jspCashArchive.colNames[JspCashArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                <option value="0" <%if (cashArchive.getPeriodeId() == 0) {%> selected <%}%> >All periode..</option>
                                                                                                                <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");

            Vector p_value = new Vector(1, 1); Vector p_key = new Vector(1, 1);
            String sel_p = "" + cashArchive.getPeriodeId();
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
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="1">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            if (listCashArchive != null && listCashArchive.size() > 0) {

                if (!cashArchive.getSearchFor().equals("")) {

                    if (cashArchive.getSearchFor().equals("cashreceive")) {// && privViewCR){
%>
                                                                            <tr> 
                                                                                <td><font face="arial" size="2"><%=langCT[7]%></font></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[8]%></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><%=langCT[9]%></td>
                                                                                            <td width="14%" class="tablehdr"><%=langCT[10]%></td>
                                                                                            <td width="12%" class="tablehdr"><%=langCT[11]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[12]%></td>
                                                                                            <td width="30%" class="tablehdr"><%=langCT[13]%></td>
                                                                                            <td width="2%" class="tablehdr">Posting<input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%

                                                                                        vectSize = 0;

                                                                                        if (listCashArchive != null && listCashArchive.size() > 0){

                                                                                            for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                                
                                                                                                CashReceive bd = (CashReceive) listCashArchive.get(i);

                                                                                                if (DbApprovalDoc.isPostingReady(bd.getOID())){

                                                                                                    vectSize = vectSize + 1;
                                                                                                    size = size + 1;
                                                                                                    Coa coa = new Coa();
                                                                                                    try {
                                                                                                        coa = DbCoa.fetchExc(bd.getCoaId());
                                                                                                    } catch (Exception e){}

                                                                                                    Employee em = new Employee();
                                                                                                    try {
                                                                                                        em = DbEmployee.fetchExc(bd.getReceiveFromId());
                                                                                                    } catch (Exception e){}
                                                                                                    
                                                                                                    if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
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
                                                                                            <td class="tablecell" width="2%"><div align="center"><input type="checkbox" name="check_<%=bd.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                                 } else {
                                                                                        %>
                                                                                        <tr> 
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
                                                                                            <td class="tablecell1" width="2%"><div align="center"><input type="checkbox" name="check_<%=bd.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                    }
                                                                                                }//if appdoc
                                                                                            }
                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if(false){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            
                                                                            <%} else if (cashArchive.getSearchFor().equals("advancereceive")) {// && privViewCR){%>
                                                                            
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
                                                                                            <td width="13%" class="tablehdr"><%=langCT[8]%></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><%=langCT[9]%></td>
                                                                                            <td width="14%" class="tablehdr"><%=langCT[10]%></td>
                                                                                            <td width="12%" class="tablehdr"><%=langCT[11]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[12]%></td>
                                                                                            <td width="30%" class="tablehdr"><%=langCT[13]%></td>
                                                                                            <td width="2%" class="tablehdr">Posting<input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        vectSize = 0;

                                                                                        if (listCashArchive != null && listCashArchive.size() > 0) {

                                                                                            for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                                
                                                                                                CashReceive bd = (CashReceive) listCashArchive.get(i);

                                                                                                if (DbApprovalDoc.isPostingReady(bd.getOID())) {

                                                                                                    vectSize = vectSize + 1;
                                                                                                    size = size + 1;
                                                                                                    Coa coa = new Coa();
                                                                                                    try {
                                                                                                        coa = DbCoa.fetchExc(bd.getCoaId());
                                                                                                    } catch (Exception e) {}

                                                                                                    Employee em = new Employee();
                                                                                                    try {
                                                                                                        em = DbEmployee.fetchExc(bd.getReceiveFromId());
                                                                                                    } catch (Exception e) {}
                                                                                                    
                                                                                                    if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" width="13%"><%=bd.getJournalNumber()%></td>
                                                                                            <td class="tablecell" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell" width="14%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                                                            <td class="tablecell" width="12%"><div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div></td>
                                                                                            <td class="tablecell" width="13%"><div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div></td>
                                                                                            <td class="tablecell" width="30%"><%=getSubstring(bd.getMemo())%></td>
                                                                                            <td class="tablecell" width="2%"><div align="center"><input type="checkbox" name="check_<%=bd.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                    } else {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" width="13%"><%=bd.getJournalNumber()%></td>
                                                                                            <td class="tablecell1" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell1" width="14%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                                                            <td class="tablecell1" width="12%"><div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div></td>
                                                                                            <td class="tablecell1" width="13%"><div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div></td>
                                                                                            <td class="tablecell1" width="30%"><%=getSubstring(bd.getMemo())%></td>
                                                                                            <td class="tablecell1" width="2%"><div align="center"><input type="checkbox" name="check_<%=bd.getOID()%>" value="1"></div></td>
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
                                                                            <%if(false){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            
                                                                            <%
                                                                                    } else if (cashArchive.getSearchFor().equals("paymentpettycash")){// && privViewPP) {
%>
                                                                            <tr> 
                                                                                <td><font size="2" face="arial"><%=langCT[14]%></font></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr>
                                                                                            <td width="14%" class="tablehdr"><%=langCT[15]%></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><%=langCT[16]%></td>
                                                                                            <td width="17%" class="tablehdr"><%=langCT[17]%></td>
                                                                                            <td width="11%" class="tablehdr"><%=langCT[18]%></td>
                                                                                            <td width="31%" class="tablehdr"><%=langCT[19]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langCT[20]%></td>
                                                                                            <td width="2%" class="tablehdr">Posting<input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%

                                                                                        vectSize = 0;

                                                                                        if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                            for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                                PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                                                boolean isPostingReady = DbApprovalDoc.isPostingReady(pp.getOID());

                                                                                                if (isPostingReady) {

                                                                                                    vectSize = vectSize + 1;
                                                                                                    size = size + 1;
                                                                                                    Coa coa = new Coa();
                                                                                                    try {
                                                                                                        coa = DbCoa.fetchExc(pp.getCoaId());
                                                                                                    } catch (Exception e) {}

                                                                                                    if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" width="14%"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
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
                                                                                            <td class="tablecell" width="2%"><div align="center"><input type="checkbox" name="check_<%=pp.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" width="14%"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
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
                                                                                            <td class="tablecell1" width="2%"><div align="center"><input type="checkbox" name="check_<%=pp.getOID()%>" value="1"></div></td>
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
                                                                            <%if(false){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
                                                                                    } else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")){ //&& privViewPR) {
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
                                                                                                } catch (Exception e) {}
                                                                                                
                                                                                                size = size + 1;
                                                                                                Coa coax = new Coa();
                                                                                                
                                                                                                try {
                                                                                                    coax = DbCoa.fetchExc(pr.getReplaceFromCoaId());
                                                                                                } catch (Exception e) {}

                                                                                                if (i % 2 != 0) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><a href="javascript:cmdEditReplenishment('<%=pr.getOID()%>')"><%=pr.getJournalNumber()%></a></td>
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
                                                                                            <td class="tablecell1"><a href="javascript:cmdEditReplenishment('<%=pr.getOID()%>')"><%=pr.getJournalNumber()%></a></td>
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
                                                                            <%if(false){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
                                                                                    }if (cashArchive.getSearchFor().equals("cashadvance")){ // && privViewAR) {
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
                                                                                            <td width="13%" class="tablehdr"><%=langCT[8]%></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><%=langCT[9]%></td>
                                                                                            <td width="14%" class="tablehdr"><%=langCT[10]%></td>
                                                                                            <td width="12%" class="tablehdr"><%=langCT[11]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[12]%></td>
                                                                                            <td width="30%" class="tablehdr"><%=langCT[13]%></td>
                                                                                            <td width="2%" class="tablehdr">Posting<input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                    if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                        
                                                                                        for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                            
                                                                                            CashReceive bd = (CashReceive) listCashArchive.get(i);
                                                                                            size = size + 1;
                                                                                            Coa coa = new Coa();
                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(bd.getCoaId());
                                                                                            } catch (Exception e) {}

                                                                                            Employee em = new Employee();
                                                                                            
                                                                                            try {
                                                                                                em = DbEmployee.fetchExc(bd.getReceiveFromId());
                                                                                            } catch (Exception e) {}
                                                                                            
                                                                                            if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
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
                                                                                            <td class="tablecell" width="2%"><div align="center"><input type="checkbox" name="check_<%=bd.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>
                                                                                        <tr> 
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
                                                                                            <td class="tablecell1" width="2%"> <div align="center"><input type="checkbox" name="check_<%=bd.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if(false){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                    int cmd = 0;
                                                                                    if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                        cmd = iCommand;
                                                                                    } else {
                                                                                        if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                            cmd = JSPCommand.FIRST;
                                                                                        } else {
                                                                                            cmd = prevCommand;
                                                                                        }
                                                                                    }
                                                                                    jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                    jspLine.initDefault();

                                                                                    jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                    jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                    jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                    jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                    jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                    jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                    jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                    jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
                                                                                } else if (cashArchive.getSearchFor().equals("advance")){// && privViewA) {
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
                                                                                            <td width="14%" class="tablehdr"><%=langCT[15]%></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><%=langCT[16]%></td>
                                                                                            <td width="17%" class="tablehdr"><%=langCT[17]%></td>
                                                                                            <td width="11%" class="tablehdr"><%=langCT[18]%></td>
                                                                                            <td width="31%" class="tablehdr"><%=langCT[19]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langCT[20]%></td>
                                                                                            <td width="2%" class="tablehdr">Posting<input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%

                                                                                    vectSize = 0;

                                                                                    if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                        for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                                            boolean isPostingReady = DbApprovalDoc.isPostingReady(pp.getOID());

                                                                                            if (isPostingReady) {

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
                                                                                            <td class="tablecell" width="14%"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
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
                                                                                            <td class="tablecell" width="2%"><div align="center"><input type="checkbox" name="check_<%=pp.getOID()%>" value="1"></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" width="14%"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
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
                                                                                            <td class="tablecell1" width="2%"><div align="center"><input type="checkbox" name="check_<%=pp.getOID()%>" value="1"></div></td>
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
                                                                            
                                                                            <%if(false){%>                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                    int cmd = 0;
                                                                                    if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                        cmd = iCommand;
                                                                                    } else {
                                                                                        if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                            cmd = JSPCommand.FIRST;
                                                                                        } else {
                                                                                            cmd = prevCommand;
                                                                                        }
                                                                                    }
                                                                                    jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                    jspLine.initDefault();

                                                                                    jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                    jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                    jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                    jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                    jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                    jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                    jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                    jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
                                                                                    }
                                                                                }
                                                                            } else {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="8" class="tablehdr" height="21">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" colspan="8" height="25"> 
                                                                                                <%if (iCommand == JSPCommand.NONE) {%>
                                                                                                <%=langCT[28]%> 
                                                                                                <%} else {%>
                                                                                                <%=langCT[29]%> 
                                                                                                <%}%>
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
                                                                <%//if (listCashArchive != null && listCashArchive.size() > 0) {%>
                                                                <%if (size > 0) {%>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="container">                                                                        
                                                                        <%/*if((cashArchive.getSearchFor().equals("cashreceive") &&  privUpdateCR) || 
(cashArchive.getSearchFor().equals("advancereceive")) ||
(cashArchive.getSearchFor().equals("paymentpettycash") && privUpdatePP) ||
(cashArchive.getSearchFor().equals("paymentreplenishmentcash") && privViewPR) || 
(cashArchive.getSearchFor().equals("cashadvance") && privViewAR) ||
(cashArchive.getSearchFor().equals("advance") && privViewA)){ */%>                                                                        
                                                                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a> 
                                                                        <%//}%>                
                                                                    </td>
                                                                </tr>
                                                                <%}%>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="container">&nbsp;</td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="container">&nbsp;</td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="container">&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (iCommand == JSPCommand.NONE) {%>
                                                                //cmdSearch();	
                                                                <%}%>
                                                            </script>
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