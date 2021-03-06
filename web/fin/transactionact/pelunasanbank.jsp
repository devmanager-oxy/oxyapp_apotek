
<%-- 
    Document   : pelunasanbank
    Created on : Jun 23, 2011, 3:03:59 PM
    Author     : Roy Andika
--%>

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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_DELETE);
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
            
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "journal_number";

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();

            if (JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_START_DATE]).length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_START_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_END_DATE]).length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_END_DATE]), "dd/MM/yyyy");
            }

            if (JSPRequestValue.requestString(request, JspBankArchive.colNames[JspBankArchive.JSP_TRANSACTION_DATE]).length() > 0){
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
            bankArchive.setSearchFor("paymentbaseonpo");
            msgString = cmdBankArchive.getMessage();

            if (iCommand == JSPCommand.NONE) {
                bankArchive.setIgnoreInputDate(1);
                bankArchive.setIgnoreTransactionDate(1);
            }

            if (bankArchive.getIgnoreTransactionDate() == 0) {//trans_date
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
                    System.out.println("[exception] " + e.toString());
                }
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (bankArchive.getIgnoreInputDate() == 0){
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(bankArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(bankArchive.getEndDate(), "yyyy-MM-dd") + "'";
            }
            
           if(whereClause != null && whereClause.length() > 0){
                
                whereClause = whereClause + " AND "+DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]+"='"+DbBankpoPayment.STATUS_POSTED+"'";
                
            }else{
                
                whereClause = DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]+"='"+DbBankpoPayment.STATUS_POSTED+"'";
                
            }                        

            int vectSize = 0;

            vectSize = DbBankpoPayment.getCount(whereClause);

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdBankArchive.actionList(iCommand, start, vectSize, recordToGet);
            }

            listBankArchive = DbBankpoPayment.list(start, recordToGet, whereClause, orderClause);

            /*** LANG ***/
            String[] langCT = {"Search for", "Journal Number", "Period", "Input Date", "to", "Transaction Date", "Ignore", //0-6
                "Bank Deposit", "Cash Payment", "Non PO Based Payment", //7-9
                "Journal Number", "Deposit to Account", "Amount IDR", "Transaction Date", "Memo", //10-14
                "Journal Number", "Payment from Account", "Payment Method", "Cheque/Transfer Number", "Payment IDR", "Transaction Date", "Journal Status", "Memo", //15-22
                "Journal Number", "Payment from Account", "Payment Method", "Bank Reference", "Amount IDR", "Transaction Date", "Vendor", "Memo", "Activity", //23-31
                "Please click on the search button to find your data", "List is empty", "Process" //32-34
            };

            String[] langNav = {"Bank", "Cash Payment", "Date"};

            if (lang == LANG_ID){
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Setoran Bank", "Pembelian Tunai", "Pelunasan Non Pembelian", //7-9s
                    "Nomor Jurnal", "Setoran ke Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //10-14
                    "Nomor Jurnal", "Pelunasan dari Perkiraan", "Cara Pelunasan", "Referensi Bank", "Jumlah IDR", "Tanggal Transaksi", "Status Jurnal", "Catatan", //15-22
                    "Nomor Jurnal", "Pelunasan dari Perkiraan", "Cara Pelunasan", "Referensi Bank", "Jumlah IDR", "Tanggal Transaksi", "Pemasok", "Catatan", "Kegiatan", //23-31
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data", "Proses"}; //32-34
                langCT = langID;

                String[] navID = {"Bank", "Pembelian Tunai", "Tanggal"};
                langNav = navID;
                
            }
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
            <%if (!priv && !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdResetStart(){
                document.frmbankarchive.start.value="0";	
            }
            
            function cmdSearch(){
                document.frmbankarchive.start.value="0";	
                document.frmbankarchive.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmbankarchive.prev_command.value="<%=prevCommand%>";
                document.frmbankarchive.action="pelunasanbank.jsp";
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
            
            function cmdEditnonpoPayment(oidBanknonpoPayment){
                document.frmbankarchive.hidden_bankarchive.value=oidBanknonpoPayment;
                document.frmbankarchive.action="banknonpopaymentdetailprint.jsp";
                document.frmbankarchive.submit();
            }
            
            function cmdListFirst(){
                document.frmbankarchive.command.value="<%=JSPCommand.FIRST%>";
                document.frmbankarchive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmbankarchive.action="pelunasanbank.jsp";
                document.frmbankarchive.submit();
            }
            
            function cmdListPrev(){
                document.frmbankarchive.command.value="<%=JSPCommand.PREV%>";
                document.frmbankarchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmbankarchive.action="pelunasanbank.jsp";
                document.frmbankarchive.submit();
            }
            
            function cmdListNext(){
                document.frmbankarchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmbankarchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmbankarchive.action="pelunasanbank.jsp";
                document.frmbankarchive.submit();
            }
            
            function cmdListLast(){
                document.frmbankarchive.command.value="<%=JSPCommand.LAST%>";
                document.frmbankarchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmbankarchive.action="pelunasanbank.jsp";
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
            String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
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
                                                                                                        <td width="13%">&nbsp;</td>
                                                                                                        <td width="26%">&nbsp;</td>
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="51%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="13%"><%=langCT[1]%></td>
                                                                                                        <td width="26%"><input type="text" name="<%=jspBankArchive.colNames[jspBankArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= bankArchive.getJournalNumber() %>">   
                                                                                                        </td>
                                                                                                        <td width="10%"><%=langCT[3]%></td>
                                                                                                        <td width="51%">
                                                                                                        <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getStartDate() == null ? new Date() : bankArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> <%=langCT[4]%>
                                                                                                        
                                                                                                        <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getEndDate() == null ? new Date() : bankArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        
                                                                                                        <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (bankArchive.getIgnoreInputDate() == 1) {%>checked<%}%>>
                                                                                                               <%=langCT[6]%> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="13%"><%=langCT[2]%></td>
                                                                                                        <td width="26%"><%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", "NAME");
            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);
            String sel_p = "" + bankArchive.getPeriodeId();
            if (p != null && p.size() > 0) {

                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                    p_value.add(period.getName().trim());
                    p_key.add("" + period.getOID());
                }
            }
                                                                                                            %>
                                                                                                            <%= JSPCombo.draw(jspBankArchive.colNames[JspBankArchive.JSP_PERIODE_ID], "", sel_p, p_key, p_value, "", "formElemen") %>  
                                                                                                        </td>
                                                                                                        <td width="10%"><%=langCT[5]%></td>
                                                                                                        <td width="51%">
                                                                                                        <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getTransactionDate() == null ? new Date() : bankArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>                                                                                                        
                                                                                                        
                                                                                                        <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (bankArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>>
                                                                                                               <%=langCT[6]%> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="13%">&nbsp;</td>
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="5"></td>
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
                                                                            <tr> 
                                                                                <td><b><font size="2"><%=langCT[8]%></font></b> 
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <%

            if (listBankArchive != null && listBankArchive.size() > 0) {

                if (!bankArchive.getSearchFor().equals("")) {

                    if (bankArchive.getSearchFor().equals("paymentbaseonpo")) {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="11%" class="tablehdr"><%=langCT[15]%></td>
                                                                                            <td height="26" width="21%" class="tablehdr"><%=langCT[16]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[17]%></td>
                                                                                            <td width="14%" class="tablehdr"><%=langCT[18]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[19]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[20]%></td>
                                                                                            <td width="7%" class="tablehdr"><%=langCT[21]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[22]%></td>
                                                                                            <td width="7%" class="tablehdr"><%=langCT[34]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                    if (listBankArchive != null && listBankArchive.size() > 0) {
                                                                                                        for (int i = 0; i < listBankArchive.size(); i++) {

                                                                                                            BankpoPayment bp = (BankpoPayment) listBankArchive.get(i);

                                                                                                            Coa coa = new Coa();
                                                                                                            try {
                                                                                                                coa = DbCoa.fetchExc(bp.getCoaId());
                                                                                                            } catch (Exception e){
                                                                                                                System.out.println("[exception] "+e.toString());
                                                                                                            }

                                                                                                            Vendor vx = new Vendor();
                                                                                                            
                                                                                                            try {
                                                                                                                vx = DbVendor.fetchExc(bp.getVendorId());
                                                                                                            } catch (Exception e) {
                                                                                                                System.out.println("[exception] "+e.toString());
                                                                                                            }

                                                                                                            PaymentMethod pm = new PaymentMethod();
                                                                                                            
                                                                                                            try {
                                                                                                                pm = DbPaymentMethod.fetchExc(bp.getPaymentMethodId());
                                                                                                            } catch (Exception e) {
                                                                                                                System.out.println("[exception] "+e.toString());
                                                                                                            }
                                                                                                            
                                                                                                            if (i % 2 != 0) {

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" width="11%" nowrap><%=bp.getJournalNumber()%></td>
                                                                                            <td class="tablecell" width="21%" nowrap><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell" align="center" width="10%" nowrap> 
                                                                                                <div align="left"><%=pm.getDescription()%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="14%" nowrap><%=bp.getRefNumber()%></td>
                                                                                            <td class="tablecell" width="10%" nowrap> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="10%" nowrap> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="7%" nowrap> 
                                                                                                <div align="center"><%=bp.getStatus()%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="10%"><%=getSubstring1(bp.getMemo())%></td>
                                                                                            <td class="tablecell" width="7%"><div align="center"><a href="<%=approot%>/transactionact/cash_receive_detail.jsp?menu_idx=2&hidden_pettycash_payment_id=<%=bp.getOID()%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ok','','../images/ok2.gif',1)"><img src="../images/ok.gif" name="ok" width="49" height="22" border="0"></a></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
                                                                                        %>                        
                                                                                        <tr> 
                                                                                            <td class="tablecell1" width="11%" nowrap><%=bp.getJournalNumber()%></td>
                                                                                            <td class="tablecell1" width="21%" nowrap><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell1" align="center" width="10%" nowrap> 
                                                                                                <div align="left"><%=pm.getDescription()%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="14%" nowrap><%=bp.getRefNumber()%></td>
                                                                                            <td class="tablecell1" width="10%" nowrap> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="10%" nowrap> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="7%" nowrap> 
                                                                                                <div align="center"><%=bp.getStatus()%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="10%"><%=getSubstring1(bp.getMemo())%></td>
                                                                                            <td class="tablecell1" width="7%"><div align="center"><a href="<%=approot%>/transactionact/pelunasanbankproses.jsp?menu_idx=2&hidden_bank_po_payment_id=<%=bp.getOID()%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ok','','../images/ok2.gif',1)"><img src="../images/ok.gif" name="ok" width="49" height="22" border="0"></a></div></td>
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
                                                                                <td align="left" colspan="7" class="boxed1" width="99%"> 
                                                                                    <table width="100%">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" align="left" colspan="7" class="tablehdr" width="99%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="25" align="left" colspan="7" class="tablecell" width="99%"> 
                                                                                                <%if (iCommand == JSPCommand.NONE) {%>
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
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (iCommand == JSPCommand.NONE) {%>
                                                                cmdSearch();
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