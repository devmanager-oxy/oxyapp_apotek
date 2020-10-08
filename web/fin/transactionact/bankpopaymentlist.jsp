
<%-- 
    Document   : bankpopaymentlist
    Created on : Nov 15, 2012, 9:00:53 PM
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
<%@ page import = "com.project.fms.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_DELETE);
%>

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
                "Petty Cash Payment", "Journal Number", "Payment from Account", "Amount IDR", "Date", "Memo", "Activity", //14-20
                "Petty Cash Replenishment", "Journal Number", "Replenishment for Account", "From Account", "Amount", "Transaction Date", "Memo", //21-27
                "Please click on the search button to find your data", "List is empty", "Post Status", "Process", "Paid", "Balance", "Vendor", "Show Data" //28-34
            };

            String[] langNav = {"Acc. Payable", "Invoice Payment", "Date", "Cash Receipt", "Payment Petty Cash", "Replenishment Petty Cash", "Searching Parameter"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Penerimaan Tunai", "Nomor Jurnal", "Perkiraan Penerimaan", "Diterima dari", "Hutang IDR", "Tanggal Transaksi", "Catatan", //7-13
                    "Pelunasan Kas Tunai", "Nomor Jurnal", "Pelunasan dari Perkiraan", "Jumlah IDR", "Tanggal", "Catatan", "Kegiatan", //14-20
                    "Pengisian Kembali Kas Kecil", "Nomor Jurnal", "Pengisian Kembali untuk Perkiraan", "Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //21-27
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data", "Post Status", "Proses", "Terbayar", "Balance", "Suplier", "Tampil Data" //28-35
                };
                langCT = langID;

                String[] navID = {"Hutang", "Pembayaran Invoice", "Tanggal", "Penerimaan Tunai", "Pelunasan Kas Tunai", "Pengisian Kembali Kas Kecil", "Parameter Pencarian"};
                langNav = navID;
            }

            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpopayment_id");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");
            String jurnalNumber = JSPRequestValue.requestString(request, "jurnal_number");
            int showVal = JSPRequestValue.requestInt(request, "show_val");
            String strStartDate = JSPRequestValue.requestString(request, "start_date");
            String strEndDate = JSPRequestValue.requestString(request, "end_date");
            String strTransactionDate = JSPRequestValue.requestString(request, "transaction_date");
            int ignoreInputDate = JSPRequestValue.requestInt(request, "ignore_input_date");
            int ignoreTransDate = JSPRequestValue.requestInt(request, "ignore_trans_date");
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            String srcGroup = JSPRequestValue.requestString(request, "src_group");
            

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();
            Vector listBankpoPayment = new Vector(1, 1);
            JSPLine ctrLine = new JSPLine();
            int vectSize = 0;
            int recordToGet = 0;

            if (iCommand != JSPCommand.LOAD) {

                session.removeValue("LIST_BANK_PAYMENT_DETAIL");


                if (strStartDate.length() > 0) {
                    startDate = JSPFormater.formatDate(strStartDate, "dd/MM/yyyy");
                }

                if (strEndDate.length() > 0) {
                    endDate = JSPFormater.formatDate(strEndDate, "dd/MM/yyyy");
                }

                if (strTransactionDate.length() > 0) {
                    transDate = JSPFormater.formatDate(strTransactionDate, "dd/MM/yyyy");
                }

                if (iCommand == JSPCommand.NONE) {
                    showVal = 20;
                    periodeId = 0;
                }

                recordToGet = showVal;
                CmdBankpoPayment cmdBankpoPayment = new CmdBankpoPayment(request);

                if (iCommand == JSPCommand.NONE || iCommand == JSPCommand.BACK) {
                    ignoreTransDate = 1;
                    ignoreInputDate = 1;
                }

                vectSize = SessBankPayment.getCountBankpoList(srcVendorId, jurnalNumber, ignoreInputDate, startDate, endDate, periodeId, ignoreTransDate, transDate,srcGroup);

                if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                        (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                    start = cmdBankpoPayment.actionList(iCommand, start, vectSize, recordToGet);
                }

                listBankpoPayment = SessBankPayment.getBankpoList(start, recordToGet, srcVendorId, jurnalNumber, ignoreInputDate, startDate, endDate, periodeId, ignoreTransDate, transDate,srcGroup);
                session.putValue("LIST_BANK_PAYMENT_DETAIL", listBankpoPayment);
            } else {
                Vector tmpBankpoPayment = (Vector) session.getValue("LIST_BANK_PAYMENT_DETAIL");
                if (tmpBankpoPayment != null && tmpBankpoPayment.size() > 0) {
                    for (int i = 0; i < tmpBankpoPayment.size(); i++) {
                        BankpoPayment bpp = (BankpoPayment) tmpBankpoPayment.get(i);
                        int select = JSPRequestValue.requestInt(request, "pilih" + bpp.getOID());
                        if (select == 1) {
                            listBankpoPayment.add(bpp);
                        }
                    }
                }
                session.removeValue("LIST_BANK_PAYMENT_DETAIL");
                session.putValue("LIST_BANK_PAYMENT_DETAIL", listBankpoPayment);

            }
//untuk multi payment
            long uniqMultiPaymentId = OIDGenerator.generateOID();
            Vector group = SessBankPayment.vendorGroup();
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
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
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (iCommand == JSPCommand.REFRESH) {%>
            window.location="<%=approot%>/transactionact/bankpaymentmulty.jsp?menu_idx=5&hidden_uniq_multi_key_payment_id=<%=uniqMultiPaymentId%>";
            <%}%>
            
            <%if (iCommand == JSPCommand.LOAD) {%>
            window.location="<%=approot%>/transactionact/bankpaymentmulty.jsp?menu_idx=5&hidden_uniq_multi_key_payment_id=<%=uniqMultiPaymentId%>";
            <%}%>
            
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function setChecked(val){
                var totBalance = 0;                
                 <%
            for (int k = 0; k < listBankpoPayment.size(); k++) {
                BankpoPayment bp = (BankpoPayment) listBankpoPayment.get(k);
                %>
                    document.frmbankpopayment.pilih<%=bp.getOID()%>.checked=val.checked;
                    var balance =  document.frmbankpopayment.balance<%=bp.getOID()%>.value;
                    balance = cleanNumberFloat(balance, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    if(document.frmbankpopayment.pilih<%=bp.getOID()%>.checked==true){
                        totBalance = parseFloat(totBalance) + parseFloat(balance);
                    }
                    <%}%>
                    document.frmbankpopayment.total_payment.value = formatFloat(totBalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);  
                }
                
                function setSelection(){                    
                    var totBalance = 0;                
                 <%
            for (int k = 0; k < listBankpoPayment.size(); k++) {
                BankpoPayment bp = (BankpoPayment) listBankpoPayment.get(k);
                %>
                    if(document.frmbankpopayment.pilih<%=bp.getOID()%>.checked==true){
                        var balance =  document.frmbankpopayment.balance<%=bp.getOID()%>.value;
                        balance = cleanNumberFloat(balance, sysDecSymbol, usrDigitGroup, usrDecSymbol);    
                        totBalance = parseFloat(totBalance) + parseFloat(balance);
                    }    
                    <%}%>
                    document.frmbankpopayment.total_payment.value = formatFloat(totBalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);  
                }
                
                function cmdSearch(){
                    document.frmbankpopayment.start.value="0";	
                    document.frmbankpopayment.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmbankpopayment.prev_command.value="<%=prevCommand%>";
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
                }
                
                function cmdSinglePayment(){                                    
                    document.frmbankpopayment.start.value="0";	
                    document.frmbankpopayment.command.value="<%=JSPCommand.REFRESH %>";
                    document.frmbankpopayment.prev_command.value="<%=prevCommand%>";                    
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
                }
                
                function cmdPayment(){                                    
                    document.frmbankpopayment.start.value="0";	
                    document.frmbankpopayment.command.value="<%=JSPCommand.LOAD%>";
                    document.frmbankpopayment.prev_command.value="<%=prevCommand%>";                    
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
                }
                
                function cmdListFirst(){
                    document.frmbankpopayment.command.value="<%=JSPCommand.FIRST%>";
                    document.frmbankpopayment.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
                }
                
                function cmdListPrev(){
                    document.frmbankpopayment.command.value="<%=JSPCommand.PREV%>";
                    document.frmbankpopayment.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
                }
                
                function cmdListNext(){
                    document.frmbankpopayment.command.value="<%=JSPCommand.NEXT%>";
                    document.frmbankpopayment.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
                }
                
                function cmdListLast(){
                    document.frmbankpopayment.command.value="<%=JSPCommand.LAST%>";
                    document.frmbankpopayment.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmbankpopayment.action="bankpopaymentlist.jsp";
                    document.frmbankpopayment.submit();
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
                                                        <form name="frmbankpopayment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_bankpopayment_id" value="<%=oidBankpoPayment%>">
                                                            <input type="hidden" name="hidden_uniq_multi_key_payment_id" value="<%=uniqMultiPaymentId%>">
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
                                                                                                <table width="870" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td >                                                                                                            
                                                                                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                                <tr>
                                                                                                                    <td colspan="6" height="5"></td>
                                                                                                                </tr>    
                                                                                                                <tr>                                                                                                                    
                                                                                                                    <td colspan="6"><b><i><%=langNav[6]%></i></b></td>                                                                                                                    
                                                                                                                </tr>    
                                                                                                                <tr>                                                                                                                    
                                                                                                                    <td width="13%" class="tablecell1" >&nbsp;&nbsp;<%=langCT[1]%></td>
                                                                                                                    <td width="2" class="fontarial">:</td>
                                                                                                                    <td width="300"><input type="text" name="jurnal_number"  value="<%=jurnalNumber%>" size="22"></td>
                                                                                                                    <td width="15%" class="tablecell1">&nbsp;&nbsp;<%=langCT[3]%></td>
                                                                                                                    <td width="2" class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="start_date" value="<%=JSPFormater.formatDate((startDate == null ? new Date() : startDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td> 
                                                                                                                                <td class="fontarial">&nbsp;&nbsp;<%=langCT[4]%>&nbsp;&nbsp;</td>
                                                                                                                                <td><input name="end_date" value="<%=JSPFormater.formatDate((endDate == null ? new Date() : endDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td><input name="ignore_input_date" type="checkBox" class="formElemen"  value="1" <%if (ignoreInputDate == 1) {%>checked<%}%>></td>
                                                                                                                                <td class="fontarial"><%=langCT[6]%></td>
                                                                                                                            </tr>
                                                                                                                        </table>      
                                                                                                                    </td>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" >&nbsp;&nbsp;<%=langCT[2]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="periode_id" class="fontarial">                                                                                                                
                                                                                                                            <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

                                                                                                                            %>
                                                                                                                            <option value ="0" <%if (periodeId == 0) {%>selected<%}%>>select..</option>
                                                                                                                            <%
            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                                                                                                                            %>
                                                                                                                            <option value ="<%=period.getOID()%>" <%if (period.getOID() == periodeId) {%>selected<%}%> ><%=period.getName()%></option>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langCT[5]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="transaction_date" value="<%=JSPFormater.formatDate((transDate == null ? new Date() : transDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.transaction_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                <td><input name="ignore_trans_date" type="checkBox" class="formElemen"  value="1" <%if (ignoreTransDate == 1) {%>checked<%}%>></td>
                                                                                                                                <td class="fontarial"><%=langCT[6]%></td>    
                                                                                                                            </tr>
                                                                                                                        </table>  
                                                                                                                    </td>                                                                                                                    
                                                                                                                </tr>               
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" >&nbsp;&nbsp;<%=langCT[35]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="show_val" class="fontarial"> 
                                                                                                                            <option value ="20" <%if (showVal == 20) {%>selected<%}%>>20 Data</option>
                                                                                                                            <option value ="40" <%if (showVal == 40) {%>selected<%}%>>40 Data</option>
                                                                                                                            <option value ="60" <%if (showVal == 60) {%>selected<%}%>>60 Data</option>
                                                                                                                            <option value ="80" <%if (showVal == 80) {%>selected<%}%>>80 Data</option>
                                                                                                                            <option value ="100" <%if (showVal == 100) {%>selected<%}%>>100 Data</option>
                                                                                                                        </select>
                                                                                                                    </td>  
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langCT[34]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <select name="src_vendor_id" class="fontarial">
                                                                                                                            <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- All Vendor -</option>
                                                                                                                            <%
            Vector vendors = DbVendor.list(0, 0, "", "name");
            Hashtable vends = new Hashtable();
            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);
                    vends.put(String.valueOf(d.getOID()), String.valueOf(d.getName()));
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                 <tr>
                                                                                                                    <td >&nbsp;</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        
                                                                                                                    </td>  
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;Group</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <select name="src_group" class="fontarial">
                                                                                                                            <option value="0" <%if (srcGroup.equalsIgnoreCase("")) {%>selected<%}%>>- All Group -</option>
                                                                                                                            <%
            
            if (group != null && group.size() > 0) {
                for (int i = 0; i < group.size(); i++) {
                    String grp = String.valueOf(""+group.get(i));
                    
                                                                                                                            %>
                                                                                                                            <option value="<%=grp%>" <%if (srcGroup.equalsIgnoreCase(grp)) {%>selected<%}%>><%=grp%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
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
                                                                            <tr> 
                                                                                <td colspan="4" height="6">
                                                                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                               
                                                                                        <tr> 
                                                                                            <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    
                                                                                </td>
                                                                            </tr>                                                                                   
                                                                            <tr> 
                                                                                <td colspan="4"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>  
                                                                            <tr> 
                                                                                <td height="25">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (listBankpoPayment != null && listBankpoPayment.size() > 0) {
                                                                            %>                                                                            
                                                                            <tr> 
                                                                                <td height="6"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="1160" border="0" cellspacing="1" cellpadding="1">                                                                                        
                                                                                        <tr height="26"> 
                                                                                            <td width="20" class="tablehdr">No</td>
                                                                                            <td width="100" class="tablehdr"><%=langCT[15]%></td>
                                                                                            <td width="200" class="tablehdr"><%=langCT[34]%></td>                                                                                            
                                                                                            
                                                                                            <td width="90" class="tablehdr"><%=langCT[18]%></td>
                                                                                            <td width="80" class="tablehdr"><%=langCT[17]%></td> 
                                                                                            <td width="80" class="tablehdr">Terbayar IDR</td> 
                                                                                            <td width="80" class="tablehdr">Balance IDR</td> 
                                                                                            <td class="tablehdr"><%=langCT[19]%></td>                                                                                                                                                                                        
                                                                                            <td width="15" class="tablehdr">Single Pembayaran</td>
                                                                                            <td width="15" class="tablehdr">Multi Pembayaran <input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                if (listBankpoPayment != null && listBankpoPayment.size() > 0) {
                                                                                    double totalBalance = 0;
                                                                                    for (int i = 0; i < listBankpoPayment.size(); i++) {

                                                                                        BankpoPayment pp = (BankpoPayment) listBankpoPayment.get(i);

                                                                                        String style = "";

                                                                                        double payment = SessBankPayment.getPaymentBankPo(pp.getOID());
                                                                                        double paid = DbBankpoPaymentDetail.getTotalPayment(pp.getOID());

                                                                                        if (i % 2 != 0) {
                                                                                            style = "tablecell";
                                                                                        } else {
                                                                                            style = "tablecell1";
                                                                                        }

                                                                                        //untuk single payment
                                                                                        long uniqId = OIDGenerator.generateOID();
                                                                                        long uniqDetailId = OIDGenerator.generateOID();

                                                                                        String vendorName = "";
                                                                                        try {
                                                                                            if (pp.getVendorId() != 0) {
                                                                                                vendorName = SessBankPayment.getVendorName(pp.getVendorId());
                                                                                            }
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        totalBalance = totalBalance + (payment - paid);
                                                                                        %>
                                                                                        <tr height="22"> 
                                                                                            <td class="<%=style%>" align="center"><%=(start + i + 1)%>.</td>
                                                                                            <td class="<%=style%>" align="center"><%=pp.getJournalNumber()%></td>
                                                                                            <td class="<%=style%>" align="left"><%=vendorName%></td>                                                                                            
                                                                                            <td class="<%=style%>"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(), "dd MMM yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="<%=style%>" style="padding:3px"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(payment, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="<%=style%>" style="padding:3px"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(paid, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="<%=style%>" style="padding:3px"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber((payment - paid), "#,###.##")%></div>
                                                                                                <input type="hidden" name="balance<%=pp.getOID()%>" value="<%=JSPFormater.formatNumber((payment - paid), "#,###.##")%>">
                                                                                            </td>
                                                                                            <td class="<%=style%>" style="padding:3px"><%=getSubstring(pp.getMemo())%></td>                                                                                            
                                                                                            <td class="<%=style%>" align=center>
                                                                                                <i><div align="center"><a href="<%=approot%>/transactionact/bankpayment.jsp?menu_idx=5&hidden_bankpopayment_id=<%=pp.getOID()%>&hidden_uniq_id=<%=uniqId%>&hidden_uniq_detail_id=<%=uniqDetailId%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ok','','../images/ok2.gif',1)">Bayar</a></div></i>
                                                                                            </td>
                                                                                            <td class="<%=style%>" align="center"><input type="checkbox" name="pilih<%=pp.getOID()%>" onClick="setSelection()" value="1"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        %>                                                                                         
                                                                                        <tr height="22">
                                                                                            <td colspan="10">
                                                                                                <table width="100%">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <span class="command"> 
                                                                                                                <%
                                                                                            int cmd = 0;
                                                                                            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                                                                                                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                                cmd = iCommand;
                                                                                            } else {
                                                                                                if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                    cmd = JSPCommand.FIRST;
                                                                                                } else {
                                                                                                    cmd = prevCommand;
                                                                                                }
                                                                                            }

                                                                                            ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                            ctrLine.initDefault();
                                                                                                                %>
                                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> 
                                                                                                        </td>
                                                                                                        <td align="right"><input type="text" name="total_payment" size="15" value="<%=JSPFormater.formatNumber(0.00, "#,###.##")%>" style="text-align:right" class="readOnly" readonly></td>
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
                                                                            <tr> 
                                                                                <td colspan="7">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="7" class="fontarial">
                                                                                    <i>
                                                                                    <div align="left">                                                                                        
                                                                                        <a href="javascript:cmdPayment()">Pembayaran (By Selection)</a>
                                                                                    </div>
                                                                                    </i>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="7" height="30">&nbsp;</td>
                                                                            </tr>
                                                                            <%

                                                                            } else {
                                                                            %>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr> 
                                                                                            <td class="f" height="18"><i> 
                                                                                                    &nbsp;<%if (iCommand == JSPCommand.NONE) {%>
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
                                                            </table>
                                                        </form>
                                                        <!-- #EndEditable -->
                                                    </td>
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
