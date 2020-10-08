
<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BA, AppMenu.PRIV_DELETE);
            boolean privDepsView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD, AppMenu.PRIV_VIEW);
            boolean privPoView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO, AppMenu.PRIV_VIEW);
            boolean privNonPoView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN, AppMenu.PRIV_VIEW);
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
            long oidBankArchive = JSPRequestValue.requestLong(request, "hidden_bankarchive");
            String invoiceSrc = JSPRequestValue.requestString(request, "invoice_src");

            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "journal_prefix,journal_number";

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();

            if (JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_START_DATE]).length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_START_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_END_DATE]).length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_END_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_TRANSACTION_DATE]).length() > 0) {
                transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_TRANSACTION_DATE]), "dd/MM/yyyy");
            }

            CmdBankArchive cmdBankArchive = new CmdBankArchive(request);
            JSPLine jspLine = new JSPLine();
            Vector listBankArchive = new Vector(1, 1);
            BankArchive bankArchive = new BankArchive();
            JspBankArchive jspBankArchive = new JspBankArchive(request, bankArchive);

            iErrCode = cmdBankArchive.action(iCommand, oidBankArchive);

            jspBankArchive.requestEntityObject(bankArchive);
            bankArchive = jspBankArchive.getEntityObject();
            bankArchive.setStartDate(startDate);
            bankArchive.setEndDate(endDate);
            bankArchive.setTransactionDate(transDate);
            msgString = cmdBankArchive.getMessage();

            if (iCommand == JSPCommand.NONE) {
                bankArchive.setIgnoreInputDate(1);
                bankArchive.setIgnoreTransactionDate(1);
            }

            if (bankArchive.getIgnoreTransactionDate() == 0) {
                whereClause = "trans_date = '" + JSPFormater.formatDate(bankArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
            }
            if (!bankArchive.getJournalNumber().equals("")) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "journal_number like '%" + bankArchive.getJournalNumber() + "%'";
            }
            if (bankArchive.getPeriodeId() != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(bankArchive.getPeriodeId());
                } catch (Exception e) {
                }
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }
            if (bankArchive.getIgnoreInputDate() == 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(bankArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(bankArchive.getEndDate(), "yyyy-MM-dd") + "'";
            }

            int vectSize = 0;

            if (iCommand != JSPCommand.REFRESH) {
                if (bankArchive.getSearchFor().equals("bankdeposit")) {
                    vectSize = DbBankDeposit.getCount(whereClause);
                } else if (bankArchive.getSearchFor().equals("paymentbaseonpo")) {
                    vectSize = DbBankpoPayment.getCountArchive(orderClause, bankArchive.getIgnoreTransactionDate(), bankArchive.getIgnoreInputDate(), bankArchive.getStartDate(), bankArchive.getEndDate(), bankArchive.getTransactionDate(), bankArchive.getJournalNumber(), bankArchive.getPeriodeId(), invoiceSrc);
                } else if (bankArchive.getSearchFor().equals("paymentnonpo")) {
                    vectSize = DbBanknonpoPayment.getCount(whereClause);
                } else if (bankArchive.getSearchFor().equals("bankpaymentpo")) {
                    if (whereClause.length() > 0) {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PEMBAYARAN_BANK;
                    vectSize = DbBankpoPayment.getCount(whereClause);
                }

                if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                        (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                    start = cmdBankArchive.actionList(iCommand, start, vectSize, recordToGet);
                }
// get record to display
                if (bankArchive.getSearchFor().equals("bankdeposit")) {
                    listBankArchive = DbBankDeposit.list(start, recordToGet, whereClause, orderClause);
                } else if (bankArchive.getSearchFor().equals("paymentbaseonpo")) {
                    listBankArchive = DbBankpoPayment.getArchive(start, recordToGet, orderClause, bankArchive.getIgnoreTransactionDate(), bankArchive.getIgnoreInputDate(), bankArchive.getStartDate(), bankArchive.getEndDate(), bankArchive.getTransactionDate(), bankArchive.getJournalNumber(), bankArchive.getPeriodeId(), invoiceSrc);
                } else if (bankArchive.getSearchFor().equals("paymentnonpo")) {
                    listBankArchive = DbBanknonpoPayment.list(start, recordToGet, whereClause, orderClause);
                } else if (bankArchive.getSearchFor().equals("bankpaymentpo")) {
                    listBankArchive = DbBankpoPayment.list(start, recordToGet, whereClause, orderClause);
                }
            }

            /*** LANG ***/
            String[] langCT = {"Search for", "Journal Number", "Period", "Input Date", "to", "Transaction Date", "Ignore", //0-6
                "Bank Deposit", "PO Based Payment", "Non PO Based Payment", //7-9
                "Journal Number", "Deposit to Account", "Amount IDR", "Transaction Date", "Memo", //10-14
                "Journal Number", "Payment from Account", "Payment Method", "Cheque/Transfer Number", "Payment IDR", "Transaction Date", "Journal Status", "Memo", //15-22
                "Journal Number", "Payment from Account", "Payment Method", "Bank Reference", "Amount IDR", "Transaction Date", "Vendor", "Memo", "Activity", //23-31
                "Please click on the search button to find your data", "List is empty", "Print" //32-33
            };

            String[] langNav = {"Bank Transaction", "Archives", "Date", "Searching Parameter", "Segment"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Setoran Bank", "Payment Selection (Pengakuan Biaya)", "Pembayaran Bank (non PO)", //7-9
                    "Nomor Jurnal", "Setoran ke Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //10-14
                    "Nomor Jurnal", "Pelunasan dari Perkiraan", "Pelunasan", "Ref. Bank", "Jumlah IDR", "Tanggal Transaksi", "Status Jurnal", "Catatan", //15-22
                    "Nomor Jurnal", "Pelunasan dari Perkiraan", "Pelunasan", "Ref. Bank", "Jumlah IDR", "Tanggal Transaksi", "Pemasok", "Catatan", "Kegiatan", //23-31
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data", "Print"}; //32-34
                langCT = langID;

                String[] navID = {"Transaksi Bank", "Arsip", "Tanggal", "Parameter Pencarian", "Segmen"};
                langNav = navID;
            }

            Vector segments = DbSegment.list(0, 0, "", "count");
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
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
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(oidBankpoPayment){	                       
                window.open("<%=printroot%>.report.RptApMemoPDF?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id="+oidBankpoPayment+"&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdPrintJournalx(oidBankpoPayment){	                       
                    window.open("<%=printroot%>.report.RptPoPayment?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id="+oidBankpoPayment+"&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdResetStart(){
                        document.frmbankarchive.start.value="0";	
                    }
                    
                    function cmdReload(){
                        document.frmbankarchive.start.value="0";	
                        document.frmbankarchive.command.value="<%=JSPCommand.REFRESH%>";
                        document.frmbankarchive.prev_command.value="<%=prevCommand%>";
                        document.frmbankarchive.action="bankarchive.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdSearch(){
                        document.frmbankarchive.start.value="0";	
                        document.frmbankarchive.command.value="<%=JSPCommand.SUBMIT%>";
                        document.frmbankarchive.prev_command.value="<%=prevCommand%>";
                        document.frmbankarchive.action="bankarchive.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdEditDeposit(oidBankDeposit){
                        document.frmbankarchive.hidden_bankarchive.value=oidBankDeposit;
                        document.frmbankarchive.action="bankdepositprint.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdEditpoPayment(oidBankpoPayment){
                        document.frmbankarchive.hidden_bankarchive.value=oidBankpoPayment;
                        document.frmbankarchive.action="bankpopaymentprint.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdEditPayment(oidBankpoPayment){
                        document.frmbankarchive.hidden_bankarchive.value=oidBankpoPayment;
                        document.frmbankarchive.action="bankpaymentprint.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdEditnonpoPayment(oidBanknonpoPayment){
                        document.frmbankarchive.hidden_bankarchive.value=oidBanknonpoPayment;
                        document.frmbankarchive.action="banknonpopaymentdetailprint.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdListFirst(){
                        document.frmbankarchive.command.value="<%=JSPCommand.FIRST%>";
                        document.frmbankarchive.prev_command.value="<%=JSPCommand.FIRST%>";
                        document.frmbankarchive.action="bankarchive.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdListPrev(){
                        document.frmbankarchive.command.value="<%=JSPCommand.PREV%>";
                        document.frmbankarchive.prev_command.value="<%=JSPCommand.PREV%>";
                        document.frmbankarchive.action="bankarchive.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdListNext(){
                        document.frmbankarchive.command.value="<%=JSPCommand.NEXT%>";
                        document.frmbankarchive.prev_command.value="<%=JSPCommand.NEXT%>";
                        document.frmbankarchive.action="bankarchive.jsp";
                        document.frmbankarchive.submit();
                    }
                    
                    function cmdListLast(){
                        document.frmbankarchive.command.value="<%=JSPCommand.LAST%>";
                        document.frmbankarchive.prev_command.value="<%=JSPCommand.LAST%>";
                        document.frmbankarchive.action="bankarchive.jsp";
                        document.frmbankarchive.submit();
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
                                            <!-- #BeginEditable "menu" -->
                                   <%@ include file="../main/menu.jsp"%>
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
                                                        <form name="frmbankarchive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_bankarchive" value="<%=oidBankArchive%>">
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
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="800">                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" >                                                                                                            
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="1" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td width="10">&nbsp;</td>
                                                                                                                    <td width="10%">&nbsp;</td>
                                                                                                                    <td width="32%">&nbsp;</td>
                                                                                                                    <td width="13%">&nbsp;</td>
                                                                                                                    <td >&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td colspan="3"><b><i><%=langNav[3]%></i></b></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td height="3"></td>
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td ><%=langCT[0]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=jspBankArchive.colNames[jspBankArchive.JSP_SEARCH_FOR] %>" >                                                                                                                            
                                                                                                                            <option value="bankdeposit" <%if (bankArchive.getSearchFor().equals("bankdeposit")) {%> selected <%}%>><%=langCT[7]%></option>                                                                                                                            
                                                                                                                            <option value="paymentnonpo" <%if (bankArchive.getSearchFor().equals("paymentnonpo")) {%> selected <%}%>><%=langCT[9]%></option>                                                                                                                            
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td ><%=langCT[3]%></td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getStartDate() == null ? new Date() : bankArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td>   
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> &nbsp;&nbsp;<%=langCT[4]%>&nbsp;&nbsp;                                                                                                        
                                                                                                                                </td>
                                                                                                                                <td>   
                                                                                                                                    <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getEndDate() == null ? new Date() : bankArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td><input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (bankArchive.getIgnoreInputDate() == 1) {%>checked<%}%>></td>
                                                                                                                                <td><%=langCT[6]%></td>
                                                                                                                                <td>   
                                                                                                                            </tr>
                                                                                                                        </table>   
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td ><%=langCT[1]%></td>
                                                                                                                    <td > 
                                                                                                                        <input type="text" name="<%=jspBankArchive.colNames[jspBankArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= bankArchive.getJournalNumber() %>">
                                                                                                                    </td>
                                                                                                                    <td ><%=langCT[5]%></td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getTransactionDate() == null ? new Date() : bankArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                                </td>
                                                                                                                                <td>    
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                                </td>
                                                                                                                                <td>    
                                                                                                                                <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (bankArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>>
                                                                                                                                       </td>
                                                                                                                                <td>    
                                                                                                                                    <%=langCT[6]%>
                                                                                                                                </td>
                                                                                                                                <td>    
                                                                                                                            </tr>    
                                                                                                                        </table>    
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td ><%=langCT[2]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=jspBankArchive.colNames[JspBankArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                            <option value="0" <%if (bankArchive.getPeriodeId() == 0) {%> selected <%}%> >All periode..</option>
                                                                                                                            <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");
            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=period.getOID()%>" <%if (bankArchive.getPeriodeId() == period.getOID()) {%> selected <%}%> ><%=period.getName().trim()%></option>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                        </select>      
                                                                                                                    </td>
                                                                                                                    <%if (bankArchive.getSearchFor().equals("paymentbaseonpo")) {%>
                                                                                                                    <td>Invoice Number</td>
                                                                                                                    <td><input type="text" name="invoice_src" value="<%=invoiceSrc%>" size="25"></td>
                                                                                                                    <%} else {%>
                                                                                                                    <td colspan="2">&nbsp;</td>
                                                                                                                    <%}%>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5">&nbsp;</td>
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
                                                                                <td><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <%if (listBankArchive != null && listBankArchive.size() > 0) {%>
                                                                            <%if (bankArchive.getSearchFor().equals("bankdeposit") && privDepsView) {%>
                                                                            <tr> 
                                                                                <td><b><font face="arial"><i><%=langCT[7]%></i></font></b></td>
                                                                            </tr>
                                                                            <%} else if (bankArchive.getSearchFor().equals("paymentbaseonpo") && privPoView) {%>
                                                                            <tr> 
                                                                                <td><b><font face="arial"><i><%=langCT[8]%></i></font></b></td>
                                                                            </tr>
                                                                            <%} else if (bankArchive.getSearchFor().equals("bankpaymentpo") && privPoView) {%>
                                                                            <tr> 
                                                                                <td><b><font face="arial"><i>Payment PO</i></font></b></td>
                                                                            </tr>
                                                                            <%} else if (bankArchive.getSearchFor().equals("paymentnonpo") && privNonPoView) {
                                                                            %>
                                                                            <tr> 
                                                                                <td><b><font face="arial"><i><%=langCT[9]%></i></font></b></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <%
            if (listBankArchive != null && listBankArchive.size() > 0) {

                if (!bankArchive.getSearchFor().equals("")) {
                    if (bankArchive.getSearchFor().equals("bankdeposit") && privDepsView) {


                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="1050" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="25"> 
                                                                                            <td width="12%" class="tablehdr"><font size="1"><%=langCT[10]%></font></td>
                                                                                            <td width="20%" class="tablehdr"><font size="1"><%=langCT[11]%></font></td>
                                                                                            <td width="15%" class="tablehdr"><font size="1"><%=langNav[4]%></font></td>
                                                                                            <td width="15%" class="tablehdr"><font size="1"><%=langCT[12]%></font></td>
                                                                                            <td width="10%" class="tablehdr"><font size="1"><%=langCT[13]%></font></td>
                                                                                            <td width="6%" class="tablehdr"><font size="1">Status</font></td>
                                                                                            <td class="tablehdr"><font size="1"><%=langCT[14]%></font></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listBankArchive != null && listBankArchive.size() > 0) {
                                                                                            for (int i = 0; i < listBankArchive.size(); i++) {
                                                                                                BankDeposit bd = (BankDeposit) listBankArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(bd.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }

                                                                                                String nameSeg = "&nbsp;";

                                                                                                if (segments != null && segments.size() > 0) {
                                                                                                    for (int is = 0; is < segments.size(); is++) {
                                                                                                        Segment objSeg = (Segment) segments.get(is);
                                                                                                        if (is != 0) {
                                                                                                            nameSeg = nameSeg + " | ";
                                                                                                        }
                                                                                                        nameSeg = nameSeg + objSeg.getName();
                                                                                                        switch (is + 1) {
                                                                                                            case 1:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment1Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            case 2:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment2Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 3:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment3Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 4:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment4Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 5:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment5Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 6:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment6Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 7:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment7Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 8:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment8Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 9:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment9Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 10:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment10Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 11:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment11Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 12:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment12Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 13:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment13Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 14:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment14Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 15:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bd.getSegment15Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                                break;
                                                                                                        }
                                                                                                    }
                                                                                                }

                                                                                                if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="tablecell" align="center"><font size="1"><a href="javascript:cmdEditDeposit('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></font></td>
                                                                                            <td class="tablecell"><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>
                                                                                            <td class="tablecell1"><font size="1"><%=nameSeg%></font></td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bd.getTransDate())%></font></div>
                                                                                            </td>
                                                                                            <%if (bd.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="#D5E649" align="center"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="#E6AD49" align="center"><font size="1">-</font></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell"><font size="1"><%=getSubstring(bd.getMemo())%></font></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                                    } else {
                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="tablecell1" align="center"><font size="1"><a href="javascript:cmdEditDeposit('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></font></td>
                                                                                            <td class="tablecell1"><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>
                                                                                            <td class="tablecell1"><font size="1"><%=nameSeg%></font></td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bd.getTransDate())%></font></div>
                                                                                            </td>
                                                                                            <%if (bd.getPostedStatus() == 1) {%>
                                                                                            <td bgcolor="#D5E649" align="center"><font size="1">POSTED</font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="#E6AD49" align="center"><font size="1">-</font></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"><font size="1"><%=getSubstring(bd.getMemo())%></font></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                                }
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
                                                                                    } else if (bankArchive.getSearchFor().equals("paymentbaseonpo") && privPoView) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="1050" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="11%" class="tablehdr"><font size="1"><%=langCT[15]%></font></td>
                                                                                            <td height="26" width="21%" class="tablehdr"><font size="1"><%=langCT[16]%></font></td>
                                                                                            <td width="8%" class="tablehdr"><font size="1">Segmen</font></td>
                                                                                            <td width="10%" class="tablehdr"><font size="1"><%=langCT[20]%></font></td>                                                                                            
                                                                                            <td width="10%" class="tablehdr"><font size="1"><%=langCT[19]%></font></td>
                                                                                            <td width="10%" class="tablehdr"><font size="1">Deduction IDR</font></td>  
                                                                                            <td width="7%" class="tablehdr"><font size="1"><%=langCT[21]%></font></td>
                                                                                            <td width="37%" class="tablehdr"><font size="1"><%=langCT[22]%></font></td>
                                                                                            <td width="13%" class="tablehdr"><font size="1"><%=langCT[34]%></font></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listBankArchive != null && listBankArchive.size() > 0) {
                                                                                            for (int i = 0; i < listBankArchive.size(); i++) {

                                                                                                BankpoPayment bp = (BankpoPayment) listBankArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(bp.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }

                                                                                                Vector value = DbBankpoPaymentDetail.getAmount(bp.getOID());

                                                                                                double purchase = 0;
                                                                                                double deduction = 0;
                                                                                                try {
                                                                                                    purchase = Double.parseDouble("" + value.get(0));
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                try {
                                                                                                    deduction = Double.parseDouble("" + value.get(1));
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                
                                                                                                String nameSeg = "&nbsp;";

                                                                                                if (segments != null && segments.size() > 0) {
                                                                                                    for (int is = 0; is < segments.size(); is++) {
                                                                                                        Segment objSeg = (Segment) segments.get(is);
                                                                                                        if (is != 0) {
                                                                                                            nameSeg = nameSeg + " | ";
                                                                                                        }
                                                                                                        nameSeg = nameSeg + objSeg.getName();
                                                                                                        switch (is + 1) {
                                                                                                            case 1:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment1Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            case 2:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment2Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 3:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment3Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 4:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment4Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 5:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment5Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 6:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment6Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 7:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment7Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 8:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment8Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 9:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment9Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 10:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment10Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 11:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment11Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 12:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment12Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 13:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment13Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 14:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment14Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 15:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment15Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                                break;
                                                                                                        }
                                                                                                    }
                                                                                                }

                                                                                                if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" nowrap align="center"><font size="1"><a href="javascript:cmdEditpoPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></font></td>
                                                                                            <td class="tablecell" nowrap><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td> 
                                                                                            <td class="tablecell" nowrap><font size="1"><%=nameSeg%></font></td> 
                                                                                            <td class="tablecell" nowrap> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(purchase, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(deduction, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <%if(bp.getStatus().equals("Not Posted")){ %>
                                                                                            <td bgcolor="#D5E649" nowrap> 
                                                                                                <div align="center"><font size="1">-</font></div>
                                                                                            </td>
                                                                                            <%}else if(bp.getStatus().equals("Posted")){%>
                                                                                            <td bgcolor="#E6AD49" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}else{%>
                                                                                            <td bgcolor="#D5645B" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" ><font size="1"><%=getSubstring1(bp.getMemo())%></font></td>
                                                                                            <td class="tablecell" align="center">
                                                                                                <a href="javascript:cmdPrintJournal('<%=bp.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" nowrap align="center"><font size="1"><a href="javascript:cmdEditpoPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></font></td>
                                                                                            <td class="tablecell1" nowrap><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td> 
                                                                                            <td class="tablecell1" nowrap><font size="1"><%=nameSeg%></td> 
                                                                                            <td class="tablecell1"  nowrap> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(purchase, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(deduction, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <%if(bp.getStatus().equals("Not Posted")){ %>
                                                                                            <td bgcolor="#D5E649" nowrap> 
                                                                                                <div align="center"><font size="1">-</font></div>
                                                                                            </td>
                                                                                            <%}else if(bp.getStatus().equals("Posted")){%>
                                                                                            <td bgcolor="#E6AD49" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}else{%>
                                                                                            <td bgcolor="#D5645B" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1" ><font size="1"><%=getSubstring1(bp.getMemo())%></font></td>
                                                                                            <td class="tablecell1" align="center">
                                                                                                <a href="javascript:cmdPrintJournal('<%=bp.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                }
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
                                                                                    } else if (bankArchive.getSearchFor().equals("bankpaymentpo") && privPoView) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="11%" class="tablehdr"><font size="1"><%=langCT[15]%></font></td>
                                                                                            <td height="26" width="21%" class="tablehdr"><font size="1"><%=langCT[16]%></font></td>
                                                                                            <td width="8%" class="tablehdr"><font size="1">Segmen</font></td>
                                                                                            <td width="10%" class="tablehdr"><font size="1"><%=langCT[20]%></font></td>                                                                                            
                                                                                            <td width="10%" class="tablehdr"><font size="1"><%=langCT[19]%></font></td>
                                                                                            <td width="10%" class="tablehdr"><font size="1">Deduction IDR</font></td>                                                                                            
                                                                                            <td width="7%" class="tablehdr"><font size="1"><%=langCT[21]%></font></td>
                                                                                            <td width="37%" class="tablehdr"><font size="1"><%=langCT[22]%></font></td>
                                                                                            <td width="13%" class="tablehdr"><font size="1"><%=langCT[34]%></font></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listBankArchive != null && listBankArchive.size() > 0) {
                                                                                            for (int i = 0; i < listBankArchive.size(); i++) {

                                                                                                BankpoPayment bp = (BankpoPayment) listBankArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(bp.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }

                                                                                                Vector value = DbBankpoPaymentDetail.getAmount(bp.getOID());

                                                                                                double purchase = 0;
                                                                                                double deduction = 0;
                                                                                                try {
                                                                                                    purchase = Double.parseDouble("" + value.get(0));
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                try {
                                                                                                    deduction = Double.parseDouble("" + value.get(1));
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                
                                                                                                String nameSeg = "&nbsp;";

                                                                                                if (segments != null && segments.size() > 0) {
                                                                                                    for (int is = 0; is < segments.size(); is++) {
                                                                                                        Segment objSeg = (Segment) segments.get(is);
                                                                                                        if (is != 0) {
                                                                                                            nameSeg = nameSeg + " | ";
                                                                                                        }
                                                                                                        nameSeg = nameSeg + objSeg.getName();
                                                                                                        switch (is + 1) {
                                                                                                            case 1:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment1Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            case 2:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment2Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 3:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment3Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 4:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment4Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 5:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment5Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 6:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment6Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 7:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment7Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 8:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment8Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 9:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment9Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 10:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment10Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 11:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment11Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 12:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment12Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 13:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment13Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 14:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment14Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 15:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment15Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                                break;
                                                                                                        }
                                                                                                    }
                                                                                                }

                                                                                                if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" nowrap align="center"><font size="1"> <a href="javascript:cmdEditPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></font></td>
                                                                                            <td class="tablecell" nowrap><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>                                                                                            
                                                                                            <td class="tablecell" nowrap><font size="1"><%=nameSeg%></font></td>
                                                                                            <td class="tablecell" nowrap> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(purchase, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(deduction, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <%if(bp.getStatus().equals("Not Posted")){ %>
                                                                                            <td bgcolor="#D5E649" nowrap> 
                                                                                                <div align="center"><font size="1">-</font></div>
                                                                                            </td>
                                                                                            <%}else if(bp.getStatus().equals("Posted")){%>
                                                                                            <td bgcolor="#E6AD49" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}else{%>
                                                                                            <td bgcolor="#D5645B" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" ><font size="1"><%=getSubstring1(bp.getMemo())%></font></td>
                                                                                            <td class="tablecell" align="center">
                                                                                                <a href="javascript:cmdPrintJournalx('<%=bp.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" nowrap align="center"><font size="1"><a href="javascript:cmdEditPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></font></td>
                                                                                            <td class="tablecell1" nowrap><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>                                                                                                                                                                                   
                                                                                            <td class="tablecell1" nowrap><font size="1"><%=nameSeg%></font></td>      
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(purchase, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" nowrap> 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(deduction, "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <%if(bp.getStatus().equals("Not Posted")){ %>
                                                                                            <td bgcolor="#D5E649" nowrap> 
                                                                                                <div align="center"><font size="1">-</font></div>
                                                                                            </td>
                                                                                            <%}else if(bp.getStatus().equals("Posted")){%>
                                                                                            <td bgcolor="#E6AD49" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}else{%>
                                                                                            <td bgcolor="#D5645B" nowrap> 
                                                                                                <div align="center"><font size="1"><%=bp.getStatus()%></font></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1" ><font size="1"><%=getSubstring1(bp.getMemo())%></font></td>
                                                                                            <td class="tablecell1" align="center">
                                                                                                <a href="javascript:cmdPrintJournalx('<%=bp.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                }
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
                                                                                    } else if (bankArchive.getSearchFor().equals("paymentnonpo") && privNonPoView) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="1050" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="10%" class="tablehdr" ><font size="1"><%=langCT[23]%></font></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><font size="1"><%=langCT[24]%></font></td>
                                                                                            <td width="15%" class="tablehdr"><font size="1">Segmen</font></td>                                                                                            
                                                                                            <td width="10%" class="tablehdr"><font size="1"><%=langCT[27]%></font></td>
                                                                                            <td width="15%" class="tablehdr"><font size="1"><%=langCT[28]%></font></td>                                                                                            
                                                                                            <td class="tablehdr"><font size="1"><%=langCT[30]%></font></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listBankArchive != null && listBankArchive.size() > 0) {
                                                                                            for (int i = 0; i < listBankArchive.size(); i++) {
                                                                                                BanknonpoPayment bp = (BanknonpoPayment) listBankArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(bp.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }

                                                                                                PaymentMethod pm = new PaymentMethod();
                                                                                                try {
                                                                                                    pm = DbPaymentMethod.fetchExc(bp.getPaymentMethodId());
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                
                                                                                                String nameSeg = "&nbsp;";

                                                                                                if (segments != null && segments.size() > 0) {
                                                                                                    for (int is = 0; is < segments.size(); is++) {
                                                                                                        Segment objSeg = (Segment) segments.get(is);
                                                                                                        if (is != 0) {
                                                                                                            nameSeg = nameSeg + " | ";
                                                                                                        }
                                                                                                        nameSeg = nameSeg + objSeg.getName();
                                                                                                        switch (is + 1) {
                                                                                                            case 1:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment1Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            case 2:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment2Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 3:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment3Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 4:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment4Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 5:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment5Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 6:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment6Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 7:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment7Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 8:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment8Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 9:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment9Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 10:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment10Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 11:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment11Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 12:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment12Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 13:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment13Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 14:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment14Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            case 15:
                                                                                                                try {
                                                                                                                    SegmentDetail sdet = DbSegmentDetail.fetchExc(bp.getSegment15Id());
                                                                                                                    nameSeg = nameSeg + " : " + sdet.getName();
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                                break;
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                
                                                                                                
                                                                                                if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" align="center"><font size="1"><%=bp.getJournalNumber()%></font></td>
                                                                                            <td class="tablecell" ><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>
                                                                                            <td class="tablecell" nowrap><font size="1"><%=nameSeg%></font></td>                                                                                                                                                                                
                                                                                            <td class="tablecell" > 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bp.getTransDate())%></font></div>
                                                                                            </td>                                                                                            
                                                                                            <td class="tablecell" ><font size="1"><%=getSubstring1(bp.getMemo())%></font></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" align="center"><%=bp.getJournalNumber()%></font></td>
                                                                                            <td class="tablecell1" ><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>  
                                                                                            <td class="tablecell1" nowrap><font size="1"><%=nameSeg%></font></td>                                                                                            
                                                                                            <td class="tablecell1" > 
                                                                                                <div align="right"><font size="1"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></font></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" > 
                                                                                                <div align="center"><font size="1"><%=JSPFormater.formatDate(bp.getTransDate())%></font></div>
                                                                                            </td>                                                                                            
                                                                                            <td class="tablecell1" ><font size="1"><%=getSubstring1(bp.getMemo())%></font></td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                                }
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
                                                                                }
                                                                            } else {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td align="left" colspan="7" class="page" width="99%"> 
                                                                                    <table width="100%">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td align="left" colspan="7" class="tablecell" width="99%"> 
                                                                                                <%if (iCommand == JSPCommand.NONE || iCommand == JSPCommand.REFRESH ) {%>
                                                                                                <%=langCT[32]%> 
                                                                                                <%} else {%>                                                                                                
                                                                                                <%=langCT[33]%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
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
