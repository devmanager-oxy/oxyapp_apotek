
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail) listx.get(i);
                result = result + crd.getAmount();
            }
        }
        return result;
    }

    public BankpoPaymentDetail getBankpoPaymentDetail(Receive ii, Vector bankpoPaymentDetail) {
        BankpoPaymentDetail bpd = new BankpoPaymentDetail();
        try {
            if (bankpoPaymentDetail != null && bankpoPaymentDetail.size() > 0) {
                for (int i = 0; i < bankpoPaymentDetail.size(); i++) {
                    BankpoPaymentDetail x = (BankpoPaymentDetail) bankpoPaymentDetail.get(i);
                    if (x.getInvoiceId() == ii.getOID()) {
                        return x;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("\nerror : " + e.toString() + "\n");
        }
        return bpd;
    }

    public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly) {

        System.out.println("in recursif : " + coa.getOID());

        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {

            System.out.println("not postable ...");

            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");

            System.out.println(coas);

            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {

                    Coa coax = (Coa) coas.get(i);
                    String str = "";

                    if (!isPostableOnly) {
                        switch (coax.getLevel()) {
                            case 1:
                                break;
                            case 2:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }

                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";

                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(coax, oid, isPostableOnly);
                    }
                }
            }
        }

        return result;
    }
%>
<%
            String[] langCT = {"Receipt to Account", "Customer", "Payment Method", "Cheque/Transfer Number", "Memo", "Journal Number", "Trans. Date", "Amount", "Period"}; //0 - 8
            String[] langNav = {"Bank Transaction", "PO Payment", "Date", "Invoice", "Vendor", "Currency", "Location", "Balance",
                "Rate", "Payment", "Payment by Invoice", "Description", "DO Number", "Currency"
            };

            if (lang == LANG_ID) {
                String[] langID = {"Perkiraan", "Sarana", "Cara Pelunasan", "Cek/nomor Transfer", "Memo", "Nomor Jurnal", "Tgl. Transfer", "Jumlah", "Periode"}; //0 - 8
                langCT = langID;
                String[] navID = {"Transaksi Bank", "Order Pembelian", "Tanggal", "Tagihan", "Pemasok", "Mata uang", "Lokasi", "Balance",
                    "Rate", "Pembayaran", "Pembayaran Dg.", "Keterangan", "Nomor DO", "Mata Uang Inv"
                };
                langNav = navID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int start = JSPRequestValue.requestInt(request, "start");
            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_id");
            
            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("RECEIVE_DETAIL");
                oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankarchive");
            }

            int iErrCode = JSPMessage.NONE;
            String errMsg = "";
            String whereClause = "status = 'CHECKED'";

            JSPLine ctrLine = new JSPLine();
            iErrCode = ctrlBankpoPayment.action(iJSPCommand, oidBankpoPayment);
            errMsg = ctrlBankpoPayment.getMessage();

            JspBankpoPayment jspBankpoPayment = ctrlBankpoPayment.getForm();
            BankpoPayment bankpoPayment = ctrlBankpoPayment.getBankpoPayment();

            if (oidBankpoPayment == 0) {
                oidBankpoPayment = bankpoPayment.getOID();
            }

            if (oidBankpoPayment != 0) {
                try {
                    bankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);
                } catch (Exception e) {
                }
            }

            Vector vBankpoPaymentDetail = new Vector();

            if (bankpoPayment.getOID() != 0) {
                String wherepo = DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " = " + bankpoPayment.getOID();
                vBankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, wherepo, null);
            }

            Vector invoices = new Vector();
            /*variable declaration*/
            int recordToGet = 10;
            /*count list All BankpoPayment*/
            int vectSize = DbBankpoPayment.getCount(whereClause);
            String msgStringMain = ctrlBankpoPayment.getMessage();
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankpoPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
%>
<%
            Vector vBPD = new Vector();
            
            if (vBankpoPaymentDetail != null && vBankpoPaymentDetail.size() > 0 && iJSPCommand != JSPCommand.LOAD){                
                
                for (int i = 0; i < vBankpoPaymentDetail.size(); i++) {                    
                    BankpoPaymentDetail bd = (BankpoPaymentDetail)vBankpoPaymentDetail.get(i);                    
                    Receive pi = new Receive();                    
                    try{
                        pi = DbReceive.fetchExc(bd.getInvoiceId());
                    }catch(Exception e){}
                    
                        double payment = JSPRequestValue.requestDouble(request, "payment_amount_" + pi.getOID());
                        double invPayment = JSPRequestValue.requestDouble(request, "inv_curr_amount_" + pi.getOID());
                        String memo = JSPRequestValue.requestString(request, "memo_" + pi.getOID());
                        double excrate = JSPRequestValue.requestDouble(request, "exc_rate_" + pi.getOID());
                        long locId = JSPRequestValue.requestLong(request, "lokasi_" + pi.getOID());

                        long segment1_id = 0;

                        if(locId != 0){
                            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + locId;
                            Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);

                            if (segmentDt != null && segmentDt.size() > 0) {
                                SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                                segment1_id = sd.getOID();
                            }
                        }
                        
                        bd.setBankpoPaymentId(bankpoPayment.getOID());
                        bd.setMemo(memo);
                        bd.setInvoiceId(pi.getOID());
                        bd.setCurrencyId(pi.getCurrencyId());
                        bd.setBookedRate(excrate);
                        bd.setPaymentByInvCurrencyAmount(invPayment);
                        bd.setPaymentAmount(payment);
                        bd.setSegment1Id(segment1_id);
                        vBPD.add(bd);
                    
                }
                vBankpoPaymentDetail = new Vector();
                vBankpoPaymentDetail = vBPD;
            }

            if (iJSPCommand == JSPCommand.SAVE && bankpoPayment.getOID() != 0 && iErrCode == 0) {
                DbBankpoPaymentDetail.insertItems(bankpoPayment.getOID(), vBankpoPaymentDetail);
            }
            if (bankpoPayment.getOID() != 0 && iJSPCommand == JSPCommand.SUBMIT) {
                Vector vBPDx = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");
                DbReceive.checkForClosed(bankpoPayment.getOID(), vBPDx);
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            ExchangeRate eRate = DbExchangeRate.getStandardRate();
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
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
    <script language="JavaScript">        
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
        var usrDigitGroup = "<%=sUserDigitGroup%>";
        var usrDecSymbol = "<%=sUserDecimalSymbol%>";
        
        function cmdSave(){
            document.frmbankpopayment.command.value="<%=JSPCommand.SAVE%>";
            document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankpopayment.action="bankpopaymentedit.jsp";
            document.frmbankpopayment.submit();
        }
        
        function getAmount(oid){
            
         <%if (vBankpoPaymentDetail != null && vBankpoPaymentDetail.size() > 0) {

                for (int i = 0; i < vBankpoPaymentDetail.size(); i++) {

                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) vBankpoPaymentDetail.get(i);
                    Receive invoice = new Receive();
                    try {
                        invoice = DbReceive.fetchExc(bpd.getInvoiceId());
                    } catch (Exception e) {
                    }
         %>		
             if(oid=='<%=invoice.getOID()%>'){
                 
                 var currpayment = document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value;
                 currpayment = cleanNumberFloat(currpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
                 
                 
                 var totAp = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
                 totAp = cleanNumberFloat(totAp, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                 
                 if(parseFloat(totAp)<parseFloat(currpayment)){
                     alert("Payment amount is over the account payable,\nSystem will edit the data");
                     currpayment = totAp;
                 }				
                 
                 document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = formatFloat(''+currpayment, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                 
                 var hcurrpayment = document.frmbankpopayment.h_inv_curr_amount_<%=invoice.getOID()%>.value;
                 hcurrpayment = cleanNumberFloat(hcurrpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                 
                 var exc = document.frmbankpopayment.exc_rate_<%=invoice.getOID()%>.value;
                 exc = cleanNumberFloat(exc, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
                 
                 var payment = parseFloat(currpayment) * parseFloat(exc);					
                 document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value = formatFloat(''+payment, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
                 
                 var hpayment = parseFloat(hcurrpayment) * parseFloat(exc);					
                 
                 var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
                 total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                 
                 document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                 document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                 
                 document.frmbankpopayment.h_inv_curr_amount_<%=invoice.getOID()%>.value = currpayment;
             }
         <%}
            }%>
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
    <script type="text/javascript">
        <!--
        function MM_swapImgRestore() { //v3.0
            var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
        }
        function MM_preloadImages() { //v3.0
            var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }
        
        function MM_findObj(n, d) { //v4.01
            var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
            if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
            for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
            if(!x && d.getElementById) x=d.getElementById(n); return x;
        }
        
        function MM_swapImage() { //v3.0
            var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
        }
        //-->
    </script>
    <!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/savedoc2.gif','../images/post_journal2.gif','../images/print2.gif','../images/back2.gif','../images/close2.gif')">
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
                    <form name="frmbankpopayment" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_bankpo_payment_id" value="<%=oidBankpoPayment%>">                    
                    <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">                    
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_CURRENCY_ID]%>" value="<%=sysCompany.getBookingCurrencyId()%>">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                            <td height="8" valign="top" colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                    <tr align="left"> 
                                        <td height="21" valign="middle" width="12%">&nbsp;</td><td height="21" valign="middle" width="28%">&nbsp;</td><td height="21" valign="middle" width="13%">&nbsp;</td>
                                        <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_OPERATOR_ID) %>&nbsp;</div>
                                        </td>
                                    </tr>
                                    <tr align="left"> 
                                        <td height="21" valign="middle" width="12%"><%=langCT[5]%></td>
                                        <td height="21" valign="middle" width="28%"> 
                                            <%
            Vector periods = new Vector();

            Periode preClosedPeriod = new Periode();
            Periode openPeriod = new Periode();

            preClosedPeriod = DbPeriode.getPreClosedPeriod();
            openPeriod = DbPeriode.getOpenPeriod();

            if (preClosedPeriod.getOID() != 0) {
                periods.add(preClosedPeriod);
            }

            if (openPeriod.getOID() != 0) {
                periods.add(openPeriod);
            }

            String strNumber = "";

            Periode open = new Periode();

            if (bankpoPayment.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(bankpoPayment.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (preClosedPeriod.getOID() != 0) {
                    open = DbPeriode.getPreClosedPeriod();
                } else {
                    open = DbPeriode.getOpenPeriod();
                }
            }

            int counterJournal = DbSystemDocNumber.getNextCounterBkk(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberBkk(counterJournal, open.getOID());

            if (bankpoPayment.getOID() != 0 || oidBankpoPayment != 0) {
                strNumber = bankpoPayment.getJournalNumber();
            }
                                            %>                                
                                            <%=strNumber%>        
                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_NUMBER] %>"  >
                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_COUNTER] %>" >
                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_PREFIX] %>" > 
                                        </td>
                                        <td height="21" valign="middle" width="13%" nowrap>&nbsp;&nbsp;<b</td>
                                        <td height="21" colspan="2" width="47%" class="comment"> </td>
                                    </tr>
                                    <tr align="left"> 
                                        <td height="21" valign="middle" width="12%"><%=langCT[0]%></td>                                        
                                        <td height="21" valign="middle" width="28%">
                                            <b> 
                                                <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_COA_ID]%>">
                                                <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accLinks.size(); i++) {
                    AccLink acl = (AccLink) accLinks.get(i);
                    Coa coay = new Coa();
                    try {
                        coay = DbCoa.fetchExc(acl.getCoaId());
                    } catch (Exception e) {
                    }

                    if (bankpoPayment.getCoaId() == 0 && i == 0) {
                        bankpoPayment.setCoaId(acl.getCoaId());
                    }
                                                %>
                                            <option value="<%=acl.getCoaId()%>" <%if (acl.getCoaId() == bankpoPayment.getCoaId()) {%>selected<%}%>><b><%=coay.getCode() + " - " + coay.getName()%></b></option>
                                            <%=getAccountRecursif(coay, bankpoPayment.getCoaId(), isPostableOnly)%> 
                                            <%}
            }%>
                                            </select>
                                            </b><%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_COA_ID) %>          
                                        </td>
                                        <td height="21" valign="middle" width="13%">  
                                            <%if (preClosedPeriod.getOID() != 0) {%>
                                            <%=langCT[18]%>
                                            <%} else {%>
                                            &nbsp;
                                            <%}%>
                                        </td>
                                        <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                            <%if (preClosedPeriod.getOID() != 0) {%>
                                            <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PERIODE_ID]%>">
                                                <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                %>
                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == bankpoPayment.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                <%}%>
                                                <%}%>
                                            </select>
                                            <%} else {%>
                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PERIODE_ID]%>" value="<%=openPeriod.getOID()%>">
                                            <%}%>
                                        </td>
                                    </tr>                                    
                                    <tr align="left"> 
                                        <td height="21" valign="middle" width="12%"><%=langCT[2]%></td>
                                        <td height="21" valign="middle" width="28%"> 
                                            <%
            Vector vpm = DbPaymentMethod.list(0, 0, "", "");
                                            %>
                                            <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>">
                                                <%if (vpm != null && vpm.size() > 0) {
                for (int i = 0; i < vpm.size(); i++) {
                    PaymentMethod pm = (PaymentMethod) vpm.get(i);
                                                %>
                                                <option value="<%=pm.getOID()%>" <%if (pm.getOID() == bankpoPayment.getPaymentMethodId()) {%>selected<%}%>><%=pm.getDescription()%></option>
                                                <%}
            }%>
                                            </select>
                                        </td>
                                        <td height="21" valign="middle" width="13%">&nbsp;&nbsp;<%=langCT[6]%></td>
                                        <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                            <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getTransDate() == null) ? new Date() : bankpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                        <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_TRANS_DATE) %> </td>
                                    </tr>
                                    <tr align="left"> 
                                        <td height="21" valign="middle" width="12%" nowrap><%=langCT[3]%></td>
                                        <td height="21" valign="middle" width="28%"> 
                                            <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_REF_NUMBER] %>"  value="<%= bankpoPayment.getRefNumber() %>" class="formElemen">
                                        <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_REF_NUMBER) %> </td>
                                        <td height="21" valign="middle" width="13%">&nbsp;&nbsp;<%=langCT[7]%> 
                                        <%=baseCurrency.getCurrencyCode()%> </td>
                                        <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                            <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT] %>"  style="text-align:right" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" class="readonly" readonly size="25">
                                        <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_AMOUNT) %></td>
                                    </tr>
                                    <tr align="left"> 
                                    <td height="21" valign="top" width="12%"><%=langCT[4]%></td>
                                    <td height="21" valign="top" colspan="5"> 
                                        <textarea name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_MEMO] %>" class="formElemen" cols="55" rows="4"><%= bankpoPayment.getMemo() %></textarea>
                                    <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_MEMO) %> </td>
                                    <tr align="left"> 
                                    <td height="21" valign="top" width="12%">&nbsp;</td>
                                    <td height="21" valign="top" width="28%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" valign="top">&nbsp; 
                                    <tr align="left"> 
                                        <td height="21" valign="top" colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr > 
                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>                                                                
                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>                                                                
                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr> 
                                                                <td width="100%" class="page"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <%if (vBankpoPaymentDetail != null && vBankpoPaymentDetail.size() > 0) {%>
                                                                        <tr>
                                                                            <td class="tablehdr" width="8%" nowrap><font size="1"><%=langNav[10]%>/<br><%=langNav[12]%></font></td>
                                                                            <td class="tablehdr" width="8%" nowrap><font size="1"><%=langNav[4]%></font></td>
                                                                            <td class="tablehdr" width="5%" nowrap><font size="1"><%=langNav[5]%></font></td>
                                                                            <td class="tablehdr" width="9%"><font size="1"><%=langNav[6]%></font></td>
                                                                            <td class="tablehdr" width="9%"><font size="1"><%=langNav[7]%></font></td>
                                                                            <td class="tablehdr" width="4%" nowrap><font size="1"><%=langNav[8]%></font></td>
                                                                            <td class="tablehdr" width="9%"><font size="1"><%=langNav[7]%>&nbsp;<%=baseCurrency.getCurrencyCode()%></font></td>
                                                                            <td class="tablehdr" width="9%"><font size="1"><%=langNav[9]%>&nbsp;<%=baseCurrency.getCurrencyCode()%></font></td>
                                                                            <td class="tablehdr" width="15%"><font size="1"><%=langNav[10]%><br><%=langNav[13]%></font></td>
                                                                            <td class="tablehdr" width="33%"><font size="1"><%=langNav[11]%></font></td>
                                                                        </tr>
                                                                        <%
    for (int ix = 0; ix < vBankpoPaymentDetail.size(); ix++) {

        BankpoPaymentDetail bankpoPaymentDetail = (BankpoPaymentDetail) vBankpoPaymentDetail.get(ix);
        Receive receive = new Receive();

        try {
            receive = DbReceive.fetchExc(bankpoPaymentDetail.getInvoiceId());
        } catch (Exception e) {
        }

        Vendor vn = new Vendor();

        try {
            vn = DbVendor.fetchExc(receive.getVendorId());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        Currency cx = new Currency();
        try {
            cx = DbCurrency.fetchExc(receive.getCurrencyId());
        } catch (Exception e) {
        }

        Location locx = new Location();
        try {
            locx = DbLocation.fetchExc(receive.getLocationId());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        String sty = "";

        if (ix % 2 == 0) {
            sty = "tablecell";
        } else {
            sty = "tablecell";
        }

                                                                        %>
                                                                        <tr>
                                                                            <td class="<%=sty%>" nowrap><font size="1"><%=receive.getInvoiceNumber() + " / " + receive.getDoNumber()%></font></td>
                                                                            <td class="<%=sty%>" nowrap><font size="1"><%=vn.getName()%></font></td>
                                                                            <td class="<%=sty%>" nowrap><font size="1"><%=cx.getCurrencyCode()%></font></td>
                                                                            <td class="<%=sty%>" ><font size="1"><%=locx.getName()%></font></td>
                                                                            <td class="<%=sty%>" ><font size="1">
                                                                                    <%

                                                                            double maxCanPay = 0;
                                                                            double invBal = 0;

                                                                            BankpoPaymentDetail bpay = new BankpoPaymentDetail();
                                                                            try {
                                                                                bpay = DbBankpoPaymentDetail.fetchExc(bankpoPaymentDetail.getOID());
                                                                            } catch (Exception e) {
                                                                            }

                                                                            try {
                                                                                invBal = DbReceive.getInvoiceBalance(receive.getOID());
                                                                            } catch (Exception e) {
                                                                            }

                                                                            maxCanPay = bpay.getPaymentAmount() + invBal;

                                                                                    %>
                                                                                    <input type="text" name="inv_balance_<%=receive.getOID()%>" value="<%=JSPFormater.formatNumber(maxCanPay, "#,###.##")%>"   style="text-align:right" size="15" class="readonly" readOnly>
                                                                            </font></td>
                                                                            <td class="<%=sty%>" nowrap><font size="1">
                                                                                <%
                                                                            double exRateValue = 1;
                                                                            if (cx.getCurrencyCode().equals(IDRCODE)) {
                                                                                exRateValue = eRate.getValueIdr();
                                                                            } else if (cx.getCurrencyCode().equals(USDCODE)) {
                                                                                exRateValue = eRate.getValueUsd();
                                                                            } else {
                                                                                exRateValue = eRate.getValueEuro();
                                                                            }
                                                                                %>
                                                                                <input type="text" name="exc_rate_<%=receive.getOID()%>" value="<%=JSPFormater.formatNumber(exRateValue, "#,###.##")%>"   style="text-align:right" size="5" class="readonly" readOnly
                                                                                       
                                                                                   </font></td>
                                                                            <td class="<%=sty%>" ><font size="1">
                                                                                    
                                                                                    <%
                                                                            double balanceRp = 0;
                                                                            try {
                                                                                balanceRp = maxCanPay * exRateValue;
                                                                            } catch (Exception e) {
                                                                            }
                                                                                    %>
                                                                                    <input type="text" name="balance_idr_<%=receive.getOID()%>" value="<%=JSPFormater.formatNumber(balanceRp, "#,###.##")%>" style="text-align:right" size="15" class="readonly" readOnly>
                                                                            </font></td>
                                                                            <td class="<%=sty%>" ><font size="1">
                                                                                    <input type="hidden" name="h_payment_amount_<%=receive.getOID()%>" value="<%=bankpoPaymentDetail.getPaymentAmount()%>">
                                                                                    <input type="text" name="payment_amount_<%=receive.getOID()%>" value="<%=JSPFormater.formatNumber(bankpoPaymentDetail.getPaymentAmount(), "#,###.##")%>"   style="text-align:right" size="15" onClick="this.select()" class="readonly" readOnly>
                                                                                    
                                                                            </font></td>
                                                                            <td class="<%=sty%>" ><font size="1">
                                                                                    <input type="hidden" name="h_inv_curr_amount_<%=receive.getOID()%>" value="<%=bankpoPaymentDetail.getPaymentByInvCurrencyAmount()%>">
                                                                                    <%=cx.getCurrencyCode()%><input type="text" name="inv_curr_amount_<%=receive.getOID()%>" value="<%=JSPFormater.formatNumber(bankpoPaymentDetail.getPaymentByInvCurrencyAmount(), "#,###.##")%>"   style="text-align:right" size="15" onClick="this.select()"  onBlur="javascript:getAmount('<%=receive.getOID()%>')">
                                                                            </font></td>
                                                                            <td class="<%=sty%>" ><font size="1">
                                                                                    <input type="text" name="memo_<%=receive.getOID()%>" size="25" value="<%=bankpoPaymentDetail.getMemo()%>">
                                                                            </font></td>
                                                                        </tr>
                                                                        <%}%>
                                                                        <%}%>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr id="command_line"> 
                                        <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td width="69%">&nbsp;</td><td width="31%">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td width="69%"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr><td height="5"></td></tr>
                                                            <tr> 
                                                                <td width="43%">&nbsp;</td>
                                                            </tr>
                                                            <%
            if (bankpoPayment.getOID() == 0 || bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)) {
                if (iJSPCommand == JSPCommand.SAVE) {
                    if (iErrCode != 0) {
                                                            %>
                                                            <tr> 
                                                                <td height="5"> 
                                                                    <table border="0" cellpadding="2" cellspacing="0" class="warning" align="left" width="254">
                                                                        <tr> 
                                                                            <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                            <td width="167" nowrap>Error,incomplete data input</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%} else {%>
                                                            <tr> 
                                                                <td height="5"> 
                                                                    <table border="0" cellpadding="2" cellspacing="0" class="success" align="left" width="254">
                                                                        <tr> 
                                                                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td><td width="167" nowrap>Data has been saved</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%}%>
                                                            <tr> 
                                                                <td width="43%" height="4"></td>
                                                            </tr>
                                                            <%
                }
            }
            if (bankpoPayment.getOID() == 0 || bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)) {
                                                            %>
                                                            <tr> 
                                                                <td width="43%">
                                                                    <table border=0>
                                                                        <tr>
                                                                            <td><%if (privAdd || privUpdate) {%><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1111','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="print1111" border="0"></a><%}%></td>
                                                                            <td>&nbsp;</td>
                                                                            <td>
                                                                                <%
                                                            if (bankpoPayment.getOID() == 0 || bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)) {
                                                                if (iJSPCommand == JSPCommand.SAVE) {
                                                                    if (iErrCode == 0) {
                                                                        out.print("<a href=\"../freport/rpt_bankpopayment.jsp?bankpopayment_id=" + bankpoPayment.getOID() + "\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a>");
                                                                    }
                                                                }
                                                            }   
                                                                                %> 
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
                                                    <td width="31%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="5" class="boxed1">
                                                            <tr> 
                                                                <td width="36%"> 
                                                                    <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                </td>
                                                                <td width="64%"> 
                                                                    <div align="right"> 
                                                                        <input type="text" name="tot" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly" readOnly>
                                                                    </div>
                                                                </td>
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
                                    <%
            if (bankpoPayment.getOID() != 0 && bankpoPayment.getAmount() > 0 && iErrCode == 0 && bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)) {
                                    %>
                                    <tr> 
                                        <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td height="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <%if (false) {%>
                                    <tr> 
                                        <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                                    <td width="64%">&nbsp;</td>
                                                    <td width="28%"> 
                                                        <table border="0" cellpadding="5" cellspacing="0" class="info" width="233" align="right">
                                                            <tr> 
                                                                <td width="19"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                <td width="194" nowrap>Journal is ready to be posted</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <%}%>
                                    <%if (bankpoPayment.getOID() != 0 && iErrCode == 0 && bankpoPayment.getStatus().equals(I_Project.STATUS_POSTED)) {%>
                                    <tr> 
                                        <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td height="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr> 
                                        <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td width="3%">
                                                        <%
    out.print("<a href=\"../freport/rpt_bankpopayment.jsp?bankpopayment_id=" + bankpoPayment.getOID() + "\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
                                                        %>
                                                    </td>
                                                    <td width="3%">&nbsp;</td>
                                                    <td width="9%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
                                                    <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                    <td width="38%"> 
                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                            <tr> 
                                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                <td width="220">Journal has been posted successfully</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <%
            if (false) {
                                    %>    
                                    <tr id="emptymessage"> 
                                        <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr> 
                                                                <td height="2">&nbsp;</td>
                                                            </tr>
                                                            <tr> 
                                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td> 
                                                        <div align="right" class="msgnextaction"> 
                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right" width="317">
                                                                <tr> 
                                                                    <td width="2"><img src="../images/error.gif" width="20" height="20"></td>
                                                                    <td width="320" nowrap>Not enought 
                                                                    bank balance to do any transaction</td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <%}%>                                  
                                    <tr> 
                                        <td width="12%">&nbsp;</td><td width="28%">&nbsp;</td><td width="13%">&nbsp;</td><td width="47%">&nbsp;</td>
                                    </tr>
                                    <tr align="left" > 
                                        <td colspan="5" valign="top"> 
                                            <div align="left"></div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <script language="JavaScript">
                        cmdGetAmount();                        
                        cmdSetCheckBox();
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
        <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
        <!-- #EndEditable -->
    </td>
</tr>
</table>
</td>
</tr>
</table>
</body>
<!-- #EndTemplate --></html>