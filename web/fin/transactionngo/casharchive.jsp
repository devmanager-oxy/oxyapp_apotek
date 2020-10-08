
<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
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
<%@ page import = "com.project.fms.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CAR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CAR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CAR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CAR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CAR, AppMenu.PRIV_DELETE);
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
            /*** LANG ***/
            String[] langCT = {"Search for", "Journal Number", "Period", "Input Date", "to", "Transaction Date", "Ignore", //0-6
                "Cash Receipt", "Journal Number", "Receipt to Account", "Receipt from", "Amount IDR", "Transaction Date", "Memo", //7-13
                "Petty Cash Payment", "Journal Number", "Payment from Account", "Amount IDR", "Transaction Date", "Memo", "Activity", //14-20
                "Petty Cash Replenishment", "Journal Number", "Replenishment for Account", "From Account", "Amount IDR", "Transaction Date", "Memo", //21-27
                "Please click on the search button to find your data", "List is empty", "Post Status", "Print", "Advance Receive", "Advance", "Debet", "Credit", "Cash Payment" //28-36
            };

            String[] langNav = {"Cash Transaction", "Archives", "Date", "Cash Receipt", "Payment Petty Cash", "Replenishment Petty Cash", "Advance Receive", "Advance", "payment", "Disbushment"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Penerimaan Tunai", "Nomor Jurnal", "Perkiraan Penerimaan", "Diterima dari", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //7-13
                    "Pembayaran Tunai", "Nomor Jurnal", "Pelunasan dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", "Kegiatan", //14-20
                    "Pengisian Kembali Kas Kecil", "Nomor Jurnal", "Pengisian Kembali untuk Perkiraan", "Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //21-27
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data", "Post Status", "Print", "Penerimaan Kasbon", "Kasbon", "Debet", "Credit" //28-35
                };
                langCT = langID;

                String[] navID = {"Transaksi Tunai", "Arsip", "Tanggal", "Penerimaan Tunai", "Pembayaran Tunai", "Pengisian Kembali Kas Kecil", "Penerimaan Kasbon", "Kasbon", "Pembayaran Tunai", "Pengakuan Biaya", "Pembayaran Tunai"};//0-9
                langNav = navID;
            }

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

// variable declaration
            int recordToGet = 15;
            String msgString = "";
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

            if (iCommand == JSPCommand.NONE) {
                cashArchive.setSearchFor("cashreceive");
                cashArchive.setIgnoreInputDate(1);
                cashArchive.setIgnoreTransactionDate(1);
            }

            cashArchive = jspCashArchive.getEntityObject();
            cashArchive.setStartDate(startDate);
            cashArchive.setEndDate(endDate);
            cashArchive.setTransactionDate(transDate);

            msgString = cmdCashArchive.getMessage();

            if (cashArchive.getIgnoreTransactionDate() == 0) {//trans_date
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

            int vectSize = 0;

            whereClause = SessCashTransaction.getWhereArchive(cashArchive.getSearchFor(), whereClause);

            vectSize = SessCashTransaction.getVectorArchive(cashArchive.getSearchFor(), whereClause);

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdCashArchive.actionList(iCommand, start, vectSize, recordToGet);
            }

            if (cashArchive.getSearchFor().equals("cashreceive")) {
                listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);
            } else if (cashArchive.getSearchFor().equals("paymentpettycash")) {
                listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
            } else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {
                listCashArchive = DbPettycashReplenishment.list(start, recordToGet, whereClause, orderClause);
            } else if (cashArchive.getSearchFor().equals("advancereceive")) {
                listCashArchive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);
            } else if (cashArchive.getSearchFor().equals("advance")) {
                listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
            } else if (cashArchive.getSearchFor().equals("payment")) {
                listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
            }
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';
            
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdResetStart(){
                document.frmcasharchive.start.value="0";	
            }
            
            function cmdSearch(){
                document.frmcasharchive.start.value="0";	
                document.frmcasharchive.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcasharchive.prev_command.value="<%=prevCommand%>";
                document.frmcasharchive.action="casharchive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdEditReceipt(oidReceive){
                document.frmcasharchive.hidden_casharchive.value=oidReceive;
                document.frmcasharchive.action="cashreceivedetailpreview.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdEditPayment(oidPayment){
                document.frmcasharchive.hidden_casharchive.value=oidPayment;
                document.frmcasharchive.action="pettycashpaymentdetailpreview.jsp";
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
                document.frmcasharchive.action="casharchive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListPrev(){
                document.frmcasharchive.command.value="<%=JSPCommand.PREV%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcasharchive.action="casharchive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListNext(){
                document.frmcasharchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcasharchive.action="casharchive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListLast(){
                document.frmcasharchive.command.value="<%=JSPCommand.LAST%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcasharchive.action="casharchive.jsp";
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
        <!--End Region JavaScript-->
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                                                                                                &nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="750">                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" > 
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">                                                                                                   
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="10"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td width="80" class="fontarial"><%=langCT[0]%></td>
                                                                                                                    <td width="160"> 
                                                                                                                        <%

                                                                                                                        %>
                                                                                                                        <select name="<%=jspCashArchive.colNames[jspCashArchive.JSP_SEARCH_FOR] %>">                                                                                                                
                                                                                                                            <option value="cashreceive" <%if (cashArchive.getSearchFor().equals("cashreceive")) {%> selected <%}%>><%=langNav[3]%></option>                                                                                                                
                                                                                                                            <option value="advancereceive" <%if (cashArchive.getSearchFor().equals("advancereceive")) {%> selected <%}%>><%=langNav[6]%></option>                                                                                                                
                                                                                                                            <option value="paymentpettycash" <%if (cashArchive.getSearchFor().equals("paymentpettycash")) {%> selected <%}%>><%=langNav[9]%></option>                                                                                                                
                                                                                                                            <option value="payment" <%if (cashArchive.getSearchFor().equals("payment")) {%> selected <%}%>><%=langNav[8]%></option>                                                                                                                
                                                                                                                            <option value="advance" <%if (cashArchive.getSearchFor().equals("advance")) {%> selected <%}%>><%=langNav[7]%></option>
                                                                                                                            
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="100"><%=langCT[3]%></td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getStartDate() == null ? new Date() : cashArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>
                                                                                                                                <td class="fontarial">
                                                                                                                                    &nbsp;&nbsp;<%=langCT[4]%>&nbsp;&nbsp;
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
                                                                                                                                <td class="fontarial">
                                                                                                                                    <%=langCT[6]%> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td ></td>
                                                                                                                    <td class="fontarial"><%=langCT[1]%></td>
                                                                                                                    <td > 
                                                                                                                        <input type="text" name="<%=jspCashArchive.colNames[jspCashArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= cashArchive.getJournalNumber() %>">
                                                                                                                    </td>
                                                                                                                    <td class="fontarial"><%=langCT[5]%></td>
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
                                                                                                                                <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreTransDate == 1) {%>checked<%}%>>
                                                                                                                                       </td>
                                                                                                                                <td class="fontarial">
                                                                                                                                &nbsp;<%=langCT[6]%></td> 
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td class="fontarial"><%=langCT[2]%></td>
                                                                                                                    <td colspan="3"> 
                                                                                                                        <select name="<%=jspCashArchive.colNames[JspCashArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                            <option value="0" <%if (cashArchive.getPeriodeId() == 0) {%> selected <%}%> >All periode..</option>
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
                                                                                                                </tr>                                                                                                              
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="15"> </td>
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
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (listCashArchive != null && listCashArchive.size() > 0) {

                if (cashArchive.getSearchFor().equals("cashreceive")) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="fontarial"><b><i><%=langCT[7]%></i></b></td>
                                                                            </tr>                                                                           
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="28"> 
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[8]%></td>
                                                                                            <td  class="tablearialhdr"><%=langCT[9]%></td>
                                                                                            <td width="13%" class="tablearialhdr"><%=langCT[10]%></td>
                                                                                            <td width="9%" class="tablearialhdr"><%=langCT[11]%></td>
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[12]%></td>
                                                                                            <td width="25%" class="tablearialhdr"><%=langCT[13]%></td>
                                                                                            <td width="7%" class="tablearialhdr"><%=langCT[30]%></td>                                                                                           
                                                                                        </tr>
                                                                                        <%

                                                                                    for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                        CashReceive bd = (CashReceive) listCashArchive.get(i);

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

                                                                                        String styleCss = "tablearialcell";
                                                                                        if (i % 2 != 0) {
                                                                                            styleCss = "tablearialcell1";
                                                                                        }

                                                                                        %>
                                                                                        <tr height="23"> 
                                                                                            <td class="<%=styleCss%>" align="center"><a href="javascript:cmdEditReceipt('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                                                                            <td class="<%=styleCss%>"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="<%=styleCss%>"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate(), "dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"><%=getSubstring(bd.getMemo())%></td>                                                                                                
                                                                                            <%if (bd.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">NOT POSTED</font></td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%

                                                                                    }

                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
                                                                            <%
                                                                                } else if (cashArchive.getSearchFor().equals("paymentpettycash")) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="fontarial"><b><i><%=langNav[9]%></i></b></td>
                                                                            </tr>                                                                           
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="28"> 
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[15]%></td>
                                                                                            <td width="19%" class="tablearialhdr"><%=langCT[16]%></td>                                                                                             
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[17]%></td>                                                                                            
                                                                                            <td width="13%" class="tablearialhdr"><%=langCT[18]%></td>
                                                                                            <td class="tablearialhdr"><%=langCT[19]%></td>                                                                                                                                                                                        
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[30]%></td>
                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                    if (listCashArchive != null && listCashArchive.size() > 0) {

                                                                                        for (int i = 0; i < listCashArchive.size(); i++) {

                                                                                            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                                            Coa coa = new Coa();
                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(pp.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }

                                                                                            String styleCss = "tablearialcell";
                                                                                            if (i % 2 != 0) {
                                                                                                styleCss = "tablearialcell1";
                                                                                            }

                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="<%=styleCss%>" align="center"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
                                                                                            <td class="<%=styleCss%>"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                                                            </td>                                                                                            
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(), "dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>" ><%=getSubstring(pp.getMemo())%></td>                                                                                            
                                                                                            <%if (pp.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">NOT POSTED</font></td>
                                                                                            <%}%>                                                                             
                                                                                        </tr>
                                                                                        <%
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
                                                                           
                                                                            <%
                                                                                } else if (cashArchive.getSearchFor().equals("advancereceive")) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="fontarial"><b><i><%=langCT[32]%></i></b></td>
                                                                            </tr>                                                                            
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="28"> 
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[8]%></td>
                                                                                            <td width="13%" class="tablearialhdr"><%=langCT[9]%></td>
                                                                                            <td width="9%" class="tablearialhdr"><%=langCT[10]%></td>
                                                                                            <td width="9%" class="tablearialhdr"><%=langCT[11]%></td>
                                                                                            <td width="20%" class="tablearialhdr"><%=langCT[12]%></td>
                                                                                            <td class="tablearialhdr"><%=langCT[13]%></td>
                                                                                            <td width="9%" class="tablearialhdr"><%=langCT[30]%></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                    if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                        for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                            CashReceive bd = (CashReceive) listCashArchive.get(i);

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
                                                                                            
                                                                                            String styleCss = "tablearialcell";
                                                                                            if (i % 2 != 0) {
                                                                                                styleCss = "tablearialcell1";
                                                                                            }

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=styleCss%>" align="center"><%=bd.getJournalNumber()%></td>
                                                                                            <td class="<%=styleCss%>"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="<%=styleCss%>"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate(),"dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"><%=getSubstring(bd.getMemo())%></td>
                                                                                            <%if (bd.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">NOT POSTED</font></td>
                                                                                            <%}%>                                                                                                
                                                                                        </tr>
                                                                                       <%
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
                                                                            
                                                                            <%
                                                                                } else if (cashArchive.getSearchFor().equals("advance")) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="fontarial"><b><i><%=langCT[33]%></i></b></td>
                                                                            </tr> 
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="28"> 
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[15]%></td>
                                                                                            <td width="20%" class="tablearialhdr"><%=langCT[16]%></td>
                                                                                            <td width="17%" class="tablearialhdr"><%=langCT[17]%></td>
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[18]%></td>
                                                                                            <td class="tablearialhdr"><%=langCT[19]%></td>                                                                                            
                                                                                            <td width="8%" class="tablearialhdr"><%=langCT[30]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                    if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                        for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                                            Coa coa = new Coa();

                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(pp.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }

                                                                                            String styleCss = "tablearialcell";
                                                                                            if (i % 2 != 0) {
                                                                                                styleCss = "tablearialcell1";
                                                                                            }

                                                                                        %>
                                                                                        <tr height="23"> 
                                                                                            <td class="<%=styleCss%>" align="center"><%=pp.getJournalNumber()%></td>
                                                                                            <td class="<%=styleCss%>"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(),"dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"><%=getSubstring(pp.getMemo())%></td>                                                                                            
                                                                                            <%if (pp.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">NOT POSTED</font></td>
                                                                                            <%}%>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
                                                                            <%
                                                                                } else if (cashArchive.getSearchFor().equals("payment")) {

                                                                            %>       
                                                                            
                                                                             <tr> 
                                                                                <td class="fontarial"><b><i><%=langNav[8]%></i></b></td>
                                                                            </tr> 
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="26"> 
                                                                                            <td width="10%" class="tablearialhdr"><%=langCT[15]%></td>
                                                                                            <td  width="16%" class="tablearialhdr"><%=langCT[16]%></td>
                                                                                            <td width="17%" class="tablearialhdr"><%=langCT[17]%></td>
                                                                                            <td width="12%" class="tablearialhdr"><%=langCT[18]%></td>
                                                                                            <td class="tablearialhdr"><%=langCT[19]%></td>                                                                                            
                                                                                            <td width="8%" class="tablearialhdr"><%=langCT[30]%></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                    if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                        for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                            PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                                            Coa coa = new Coa();

                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(pp.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }
                                                                                            
                                                                                            String styleCss = "tablearialcell";
                                                                                            if (i % 2 != 0) {
                                                                                                styleCss = "tablearialcell1";
                                                                                            }

                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="<%=styleCss%>" align="center"><%=pp.getJournalNumber()%></td>
                                                                                            <td class="<%=styleCss%>"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(),"dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=styleCss%>"><%=getSubstring(pp.getMemo())%></td>
                                                                                            
                                                                                            <%if (pp.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1">NOT POSTED</font></td>
                                                                                            <%}%>  
                                                                                            
                                                                                        </tr>
                                                                                       
                                                                                        <%
                                                                                            
                                                                                        }
                                                                                    }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
                                                                            
                                                                            <%
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
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
