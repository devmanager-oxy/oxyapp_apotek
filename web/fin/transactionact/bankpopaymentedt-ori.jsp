
<%-- 
    Document   : bankpopaymentedt
    Created on : Jan 1, 2013, 9:12:13 AM
    Author     : Roy Andika
--%>

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
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_INVOICE, AppMenu.PRIV_DELETE);
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
        }
        return bpd;
    }

    public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly) {

        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");
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
            String[] langNav = {"Acc. Payable", "PO Payment", "Date", "Invoice", "Vendor", "Inv. Currency", "Location", "Balance", // 0- 7
                "Rate", "Payment", "Invoice Number", "Description", "DO Number", "Currency", "Vendor", "Search for Open Invoice", "Vendor Invoice Number", "Due Date", "ignore" // 8 -18
            };

            if (lang == LANG_ID) {
                String[] langID = {"Perkiraan", "Sarana", "Cara Pelunasan", "Cek/nomor Transfer", "Memo", "Nomor Jurnal", "Tgl. Transfer", "Jumlah", "Periode"}; //0 - 8
                langCT = langID;
                String[] navID = {"Hutang", "Order Pembelian", "Tanggal", "Tagihan", "Suplier", "Mata uang Inv.", "Lokasi", "Balance", // 0 -7
                    "Rate", "Pembayaran", "Nomor Invoice", "Keterangan", "Nomor DO", "Mata Uang Inv", "Suplier", "Pencarian Faktur yang Belum Terbayarkan", "Nomor Faktur Suplier", "Tanggal Pelunasan", "Abaikan" // 8 -18
                };
                langNav = navID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_id");
            long oidEdtBankpoPayment = JSPRequestValue.requestLong(request, "edt_bankpo_payment_id");            
            String vndInvNumber = JSPRequestValue.requestString(request, "vndinvnumber");
            long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");
            int overDue = JSPRequestValue.requestInt(request, "overdue");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            Date dueDate = new Date();
            if (JSPRequestValue.requestString(request, "duedate").length() > 0) {
                dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "duedate"), "dd/MM/yyyy");
            }

            if (iJSPCommand == JSPCommand.NONE && iJSPCommand != JSPCommand.REFRESH) {
                overDue = 1;
            }

            int iErrCode = JSPMessage.NONE;
            String errMsg = "";

            String whereClause = DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"' ";

            JSPLine ctrLine = new JSPLine();
            iErrCode = ctrlBankpoPayment.action(iJSPCommand, oidBankpoPayment);
            errMsg = ctrlBankpoPayment.getMessage();

            JspBankpoPayment jspBankpoPayment = ctrlBankpoPayment.getForm();
            BankpoPayment bankpoPayment = ctrlBankpoPayment.getBankpoPayment();

            try {
                bankpoPayment = DbBankpoPayment.fetchExc(oidEdtBankpoPayment);
            } catch (Exception e) {
            }

            if (oidBankpoPayment == 0) {
                oidBankpoPayment = bankpoPayment.getOID();
            }

            InvoiceSrc invSrc = new InvoiceSrc();
            if (session.getValue("SRC_POPAY") != null) {
                invSrc = (InvoiceSrc) session.getValue("SRC_POPAY");
            } else {
                invSrc.setVendorId(0);
                invSrc.setOverDue(1);
                invSrc.setDueDate(new Date());
                invSrc.setVndInvNumber("");
            }

            Vector invoices = new Vector();
            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int vectSize = DbBankpoPayment.getCount(whereClause);
            String msgStringMain = ctrlBankpoPayment.getMessage();
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankpoPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
%>
<%
            Vector vbankpoPayment = new Vector();

            if (bankpoPayment.getOID() != 0) {
                vbankpoPayment = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment.getOID(), null);
            }
            Vector vBPD = new Vector();

            if (vbankpoPayment != null && vbankpoPayment.size() > 0) {
                for (int i = 0; i < vbankpoPayment.size(); i++) {

                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) vbankpoPayment.get(i);
                    Receive pi = new Receive();
                    try {
                        pi = DbReceive.fetchExc(bpd.getInvoiceId());
                    } catch (Exception e) {
                    }

                    int chk = JSPRequestValue.requestInt(request, "chkd_" + bpd.getInvoiceId());

                    if (chk == 1) {
                        double payment = JSPRequestValue.requestDouble(request, "payment_amountd_" + bpd.getInvoiceId());
                        double invPayment = JSPRequestValue.requestDouble(request, "inv_curr_amountd_" + bpd.getInvoiceId());
                        String memo = JSPRequestValue.requestString(request, "memod_" + bpd.getInvoiceId());
                        double excrate = JSPRequestValue.requestDouble(request, "exc_rated_" + bpd.getInvoiceId());
                        long locId = JSPRequestValue.requestLong(request, "lokasid_" + bpd.getInvoiceId());
                        long vendorId = JSPRequestValue.requestLong(request, "vndd_" + bpd.getInvoiceId());

                        long segment1_id = 0;

                        if (locId != 0) {
                            String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + locId;
                            Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);

                            if (segmentDt != null && segmentDt.size() > 0) {
                                SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                                segment1_id = sd.getOID();
                            }
                        }

                        BankpoPaymentDetail ii = new BankpoPaymentDetail();
                        ii.setBankpoPaymentId(bankpoPayment.getOID());
                        ii.setMemo(memo);
                        ii.setInvoiceId(bpd.getInvoiceId());
                        ii.setCurrencyId(pi.getCurrencyId());
                        ii.setBookedRate(excrate);
                        ii.setPaymentByInvCurrencyAmount(invPayment);
                        ii.setPaymentAmount(payment);
                        ii.setSegment1Id(segment1_id);
                        ii.setVendorId(vendorId);
                        vBPD.add(ii);
                    }
                }
            }

            if (iJSPCommand == JSPCommand.SAVE && bankpoPayment.getOID() != 0 && iErrCode == 0) {
                DbBankpoPaymentDetail.insertItems(bankpoPayment.getOID(), vBPD);
                vbankpoPayment = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment.getOID(), null);
                invoices = QrInvoice.getOpenInvoiceByVendor(oidVendor, invSrc);
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PAYMENT_SUSPENSE_ACCOUNT + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
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
        
        function cmdSearch(){            
            document.frmbankpopayment.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmbankpopayment.action="bankpopaymentedtprocess.jsp";
            document.frmbankpopayment.submit();
        }    
        
        function cmdPrintJournal(){	                       
            window.open("<%=printroot%>.report.RptApMemoPDF?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id=<%=oidBankpoPayment%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdCheckItd(oid){
                
         <%if (vbankpoPayment != null && vbankpoPayment.size() > 0) {
                for (int i = 0; i < vbankpoPayment.size(); i++) {
                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) vbankpoPayment.get(i);
         %>		
             if(oid=='<%=bpd.getInvoiceId()%>'){                 
                 if(document.frmbankpopayment.chkd_<%=bpd.getInvoiceId()%>.checked){
                     
                     var bal = document.frmbankpopayment.inv_balanced_<%=bpd.getInvoiceId()%>.value;
                     var balidr = document.frmbankpopayment.balance_idrd_<%=bpd.getInvoiceId()%>.value;   
                     balidr = cleanNumberFloat(balidr, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                     
                     document.frmbankpopayment.inv_curr_amountd_<%=bpd.getInvoiceId()%>.value=bal;
                     document.frmbankpopayment.payment_amountd_<%=bpd.getInvoiceId()%>.value=balidr;					
                     document.frmbankpopayment.h_inv_curr_amountd_<%=bpd.getInvoiceId()%>.value=bal;
                     document.frmbankpopayment.h_payment_amountd_<%=bpd.getInvoiceId()%>.value=balidr;					
                     document.frmbankpopayment.inv_curr_amountd_<%=bpd.getInvoiceId()%>.disabled=false;
                     document.frmbankpopayment.payment_amountd_<%=bpd.getInvoiceId()%>.disabled=false;
                     
                     var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
                     total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                     balidr = cleanNumberFloat(balidr, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                     
                     document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) + parseFloat(balidr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                     document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) + parseFloat(balidr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                     
                 }else{				
                 var paymentIdr = document.frmbankpopayment.payment_amountd_<%=bpd.getInvoiceId()%>.value;					
                 paymentIdr = cleanNumberFloat(paymentIdr, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                 
                 document.frmbankpopayment.inv_curr_amountd_<%=bpd.getInvoiceId()%>.value="0.00";
                 document.frmbankpopayment.payment_amountd_<%=bpd.getInvoiceId()%>.value="0.00";					
                 document.frmbankpopayment.inv_curr_amountd_<%=bpd.getInvoiceId()%>.disabled=true;
                 document.frmbankpopayment.payment_amountd_<%=bpd.getInvoiceId()%>.disabled=true;					
                 document.frmbankpopayment.h_inv_curr_amountd_<%=bpd.getInvoiceId()%>.value="0.00";
                 document.frmbankpopayment.h_payment_amountd_<%=bpd.getInvoiceId()%>.value="0.00";					
                 
                 var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
                 total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
                 
                 document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) - parseFloat(paymentIdr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                 document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) - parseFloat(paymentIdr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
             }                 
         }
         <%}
            }%>
        }
        
        function getAmount(oid){
            
         <%if (invoices != null && invoices.size() > 0) {

                for (int i = 0; i < invoices.size(); i++) {
                    Vector v = (Vector) invoices.get(i);
                    Receive invoice = (Receive) v.get(1);
         %>		
             if(oid=='<%=invoice.getOID()%>'){
                 
                 var currpayment = document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value;
                 currpayment = cleanNumberFloat(currpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
                 
                 
                 var totAp = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
                 totAp = cleanNumberFloat(totAp, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                 
                 if( currpayment < 0){
                     if(parseFloat(totAp) > parseFloat(currpayment) || parseFloat(currpayment) > 0){
                         alert("Payment amount is over the account payable,\nSystem will edit the data");
                         currpayment = totAp;
                     }    
                 }else{    
                 if(parseFloat(totAp)<parseFloat(currpayment)){
                     alert("Payment amount is over the account payable,\nSystem will edit the data");
                     currpayment = totAp;
                 }					
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
        
        function getAmountd(oid){
            
         <%if (vbankpoPayment != null && vbankpoPayment.size() > 0) {
                for (int i = 0; i < vbankpoPayment.size(); i++) {
                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) vbankpoPayment.get(i);
                    Receive invoice = new Receive();
                    try {
                        invoice = DbReceive.fetchExc(bpd.getInvoiceId());
                    } catch (Exception e) {
                    }
         %>		
             if(oid=='<%=invoice.getOID()%>'){
                 
                 var currpayment = document.frmbankpopayment.inv_curr_amountd_<%=invoice.getOID()%>.value;
                 currpayment = cleanNumberFloat(currpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);                 
                 var totAp = document.frmbankpopayment.inv_balanced_<%=invoice.getOID()%>.value;
                 totAp = cleanNumberFloat(totAp, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                 
                 if( currpayment < 0){                     
                     if(parseFloat(totAp) > parseFloat(currpayment) || parseFloat(currpayment) > 0){
                         alert("Payment amount is over the account payable,\nSystem will edit the data");
                         currpayment = totAp;
                     }    
                     
                 }else{    
                 if(parseFloat(totAp)<parseFloat(currpayment)){
                     alert("Payment amount is over the account payable,\nSystem will edit the data");
                     currpayment = totAp;
                 }					
             }
             
             document.frmbankpopayment.inv_curr_amountd_<%=invoice.getOID()%>.value = formatFloat(''+currpayment, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);              
             var hcurrpayment = document.frmbankpopayment.h_inv_curr_amountd_<%=invoice.getOID()%>.value;
             hcurrpayment = cleanNumberFloat(hcurrpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);
             
             var exc = document.frmbankpopayment.exc_rated_<%=invoice.getOID()%>.value;
             exc = cleanNumberFloat(exc, sysDecSymbol, usrDigitGroup, usrDecSymbol);					             
             var payment = parseFloat(currpayment) * parseFloat(exc);		             
             document.frmbankpopayment.payment_amountd_<%=invoice.getOID()%>.value = formatFloat(''+payment, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
             
             var hpayment = parseFloat(hcurrpayment) * parseFloat(exc);					
             
             var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
             total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
             
             document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
             document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
             
             document.frmbankpopayment.h_inv_curr_amountd_<%=invoice.getOID()%>.value = currpayment;
             
         }
         <%}
            }%>
            
        }
        
        function cmdSetCheckBox(){            
         <%if (invoices != null && invoices.size() > 0) {
                for (int i = 0; i < invoices.size(); i++) {
                    Vector v = (Vector) invoices.get(i);
                    Receive invoice = (Receive) v.get(1);
         %>		
             if(!document.frmbankpopayment.chkd_<%=invoice.getOID()%>.checked){
                 document.frmbankpopayment.inv_curr_amountd_<%=invoice.getOID()%>.value="0.00";
                 document.frmbankpopayment.payment_amountd_<%=invoice.getOID()%>.value="0.00";					
                 document.frmbankpopayment.inv_curr_amountd_<%=invoice.getOID()%>.disabled=true;
                 document.frmbankpopayment.payment_amountd_<%=invoice.getOID()%>.disabled=true;
             }
             
         <%}
            }%>
        }
        
        function cmdGetAmount(){
         <%if (vbankpoPayment != null && vbankpoPayment.size() > 0) {
                for (int i = 0; i < vbankpoPayment.size(); i++) {
                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) vbankpoPayment.get(i);
         %>
             var balance = document.frmbankpopayment.inv_balanced_<%=bpd.getInvoiceId()%>.value;
             var erate = document.frmbankpopayment.exc_rated_<%=bpd.getInvoiceId()%>.value;
             
             balance = cleanNumberFloat(balance, sysDecSymbol, usrDigitGroup, usrDecSymbol);
             erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);			
             
             document.frmbankpopayment.balance_idrd_<%=bpd.getInvoiceId()%>.value = formatFloat(balance * erate, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);              
         <%}
            }%>
        }
        
        function removeChar(number){            
            var ix;
            var result = "";
            for(ix=0; ix<number.length; ix++){
                var xx = number.charAt(ix);                
                if(!isNaN(xx)){
                    result = result + xx;
                }
                else{
                    if(xx==',' || xx=='.'){
                        result = result + xx;
                    }
                }
            }            
            return result;
        }
        
        function cmdSave(){
            document.all.closecmd.style.display="none";
            document.all.closemsg.style.display="";
            document.frmbankpopayment.command.value="<%=JSPCommand.SAVE%>";
            document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankpopayment.action="bankpopaymentedt.jsp";
            document.frmbankpopayment.submit();
        }
        
        function cmdBack(){
            document.frmbankpopayment.command.value="<%=JSPCommand.NONE%>";
            document.frmbankpopayment.action="bankpopaymentsrc.jsp";
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
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_bankpo_payment_id" value="<%=oidBankpoPayment%>">                        
                    <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                    <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_VENDOR_ID]%>" value="<%=oidVendor%>">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_CURRENCY_ID]%>" value="<%=sysCompany.getBookingCurrencyId()%>">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                        <td height="8" valign="top" colspan="3" class="container"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr align="left"> 
                                <td colspan="5">
                                <table border="0" cellpadding="1" cellspacing="1" width="650">                                                                                                                                        
                                <tr>                                                                                                                                            
                                    <td class="tablecell1" > 
                                    <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                        <tr>
                                            <td colspan="7" height="5"></td>
                                        </tr>     
                                        <tr>
                                            <td width="5"></td>
                                            <td height="21" valign="middle" width="15%"><%=langCT[5]%></td>
                                            <td height="21" valign="middle" width="50%"> 
                                                <%
            Vector periods = new Vector();
            Periode preClosedPeriod = new Periode();
            Periode openPeriod = new Periode();

            Vector vPreClosed = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE]);

            openPeriod = DbPeriode.getOpenPeriod();

            if (vPreClosed != null && vPreClosed.size() > 0) {
                for (int i = 0; i < vPreClosed.size(); i++) {
                    Periode prClosed = (Periode) vPreClosed.get(i);
                    if (i == 0) {
                        preClosedPeriod = prClosed;
                    }
                    periods.add(prClosed);
                }
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

            int counterJournal = DbSystemDocNumber.getNextCounterTT(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberTT(counterJournal, open.getOID());

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
                                            <td height="21" colspan="2" class="comment"></td>
                                            <td width="5"></td>
                                        </tr>
                                        <tr align="left"> 
                                        <td ></td>
                                        <td height="21" valign="middle"><%=langCT[0]%></td>                                        
                                        <td height="21" valign="middle">
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
                                        <td height="21" valign="middle">  
                                            <%if (preClosedPeriod.getOID() != 0) {%>
                                            &nbsp;&nbsp;<%=langCT[8]%>
                                            <%} else {%>
                                            &nbsp;
                                            <%}%>
                                        </td>
                                        <td height="21" colspan="2" class="comment" valign="top"> 
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
                                        <td ></td>
                                    </tr>                                    
                                    <tr align="left"> 
                                        <td ></td>
                                        <td height="21" valign="middle" ><%=langCT[6]%></td>
                                        <td height="21" valign="middle" >
                                            <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getTransDate() == null) ? new Date() : bankpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_TRANS_DATE) %>
                                        </td>
                                        <td height="21" valign="middle"></td>
                                        <td height="21" colspan="2" class="comment" valign="top"></td> 
                                        <td ></td>
                                    </tr>
                                    <tr align="left"> 
                                        <td ></td>
                                        <td height="21" valign="middle" nowrap><%=langCT[7]%>&nbsp;<%=baseCurrency.getCurrencyCode()%></td>
                                        <td height="21" valign="middle" > 
                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_REF_NUMBER] %>"  value="<%= bankpoPayment.getRefNumber() %>" class="formElemen">
                                            <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT] %>"  style="text-align:right" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" class="readonly" readonly size="25">
                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_AMOUNT) %>
                                        </td>
                                        <td height="21" valign="middle" ></td>
                                        <td height="21" colspan="2" class="comment" valign="top"></td>
                                        <td ></td>
                                    </tr>
                                    <tr align="left">
                                        <td ></td>
                                        <td height="21" valign="top" ><%=langCT[4]%></td>
                                        <td height="21" valign="top" colspan="4"> 
                                            <textarea name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_MEMO] %>" class="formElemen" cols="50" rows="4"><%= bankpoPayment.getMemo() %></textarea>
                                        <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_MEMO) %> </td>
                                        <td ></td>
                                    </tr>  
                                    <tr>
                                        <td colspan="7" height="5"></td>
                                    </tr>  
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr> 
                <td>&nbsp; </td>
            </tr>    
            <%if (vbankpoPayment != null && vbankpoPayment.size() > 0) {%>
            <tr> 
                <td> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td width="100%" class="page"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                        <td class="tablehdr" width="2%"><font size="1"></font></td >
                                        <td class="tablehdr" width="8%" nowrap><font size="1"><%=langNav[10]%>/<br><%=langNav[12]%></font></td>
                                        <td class="tablehdr" width="8%" nowrap><font size="1"><%=langNav[4]%></font></td>
                                        <td class="tablehdr" width="7%" nowrap><font size="1"><%=langNav[5]%></font></td>
                                        <td class="tablehdr" width="9%"><font size="1"><%=langNav[6]%></font></td>
                                        <td class="tablehdr" width="9%"><font size="1"><%=langNav[7]%></font></td>
                                        <td class="tablehdr" width="4%" nowrap><font size="1"><%=langNav[8]%></font></td>
                                        <td class="tablehdr" width="9%"><font size="1"><%=langNav[7]%><%=baseCurrency.getCurrencyCode()%></font></td>
                                        <td class="tablehdr" width="9%"><font size="1"><%=langNav[9]%><%=baseCurrency.getCurrencyCode()%></font></td>
                                        <td class="tablehdr" width="11%"><font size="1"><%=langNav[10]%><br><%=langNav[13]%></font></td>
                                        <td class="tablehdr" width="33%"><font size="1"><%=langNav[11]%></font></td>
                                    </tr>
                                    <%if (vbankpoPayment != null && vbankpoPayment.size() > 0) {%>                                                            
                                    <%
    for (int it = 0; it < vbankpoPayment.size(); it++) {
        BankpoPaymentDetail bpd = (BankpoPaymentDetail) vbankpoPayment.get(it);
        Receive invoice = new Receive();
        try {
            invoice = DbReceive.fetchExc(bpd.getInvoiceId());
        } catch (Exception e) {
        }

        Vendor vxxx = new Vendor();
        try {
            vxxx = DbVendor.fetchExc(invoice.getVendorId());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        Location loc = new Location();
        try {
            loc = DbLocation.fetchExc(invoice.getLocationId());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        //Hashtable pendingOnePO = new Hashtable(); 
        try{
            //if(vxxx.getPendingOnePo() == DbVendor.TYPE_ONE_PENDING_PO){
            //    pendingOnePO =  DbReceive.getOnePendingPO(invSrc,invoice.getVendorId());  
            //}
        }catch(Exception e){}
                    
        String number = "";
                    if(invoice.getInvoiceNumber().length() > 0){
                        number = invoice.getInvoiceNumber();
                    }else{
                        number = invoice.getNumber();
                    }
                                    %>
                                    <tr> 
                                        <td class="tablecell" width="2%"> 
                                            <div align="center"> 
                                                <input type="checkbox" name="chkd_<%=invoice.getOID()%>" value="1" onClick="javascript:cmdCheckItd('<%=invoice.getOID()%>')" checked >                                                
                                                <input type="hidden" name="vndd_<%=invoice.getOID()%>" value="<%=invoice.getVendorId()%>" >
                                            </div>
                                        </td>
                                        <td class="tablecell" width="8%"> 
                                            <div align="left"><font size="1"><%=number + "/" + invoice.getDoNumber()%> </font></div>
                                        </td>
                                        <td width="8%" class="tablecell" nowrap><font size="1"><%=vxxx.getName()%></font></td>
                                        <td width="7%" class="tablecell"> 
                                            <div align="center"> <font size="1"> 
                                                    <%
                                        Currency c = new Currency();
                                        try {
                                            c = DbCurrency.fetchExc(invoice.getCurrencyId());
                                        } catch (Exception e) {
                                        }
                                                    %>
                                            <%=c.getCurrencyCode()%></font></div>
                                        </td>
                                        <td width="9%" class="tablecell"><font size="1"><%=loc.getName()%></font>
                                            <input type="hidden" name="lokasid_<%=invoice.getOID()%>" value ="<%=loc.getOID()%>">
                                        </td>
                                        <td width="9%" class="tablecell"> 
                                            <div align="center">
                                                <input type="text" name="inv_balanced_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(DbReceive.getInvoiceBalanceEdt(invoice.getOID(), bpd.getOID()), "#,###.##")%>" style="text-align:right" size="15" class="readonly" readOnly>                                                                                    
                                            </div>
                                        </td>
                                        <td width="4%" class="tablecell"> 
                                            <div align="center"> 
                                                <%
                                        double exRateValue = 1;
                                        if (c.getCurrencyCode().equals(IDRCODE)) {
                                            exRateValue = eRate.getValueIdr();
                                        } else if (c.getCurrencyCode().equals(USDCODE)) {
                                            exRateValue = eRate.getValueUsd();
                                        } else {
                                            exRateValue = eRate.getValueEuro();
                                        }
                                                %>
                                                <input type="text" name="exc_rated_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(exRateValue, "#,###.##")%>"   style="text-align:right" size="5" class="readonly" readOnly>
                                            </div>
                                        </td>
                                        <td width="9%" class="tablecell"> 
                                            <div align="center"> 
                                                <input type="text" name="balance_idrd_<%=invoice.getOID()%>" value=""   style="text-align:right" size="15" class="readonly" readOnly>
                                            </div>
                                        </td>
                                        <td width="9%" class="tablecell"> 
                                            <div align="center"> 
                                                <input type="hidden" name="h_payment_amountd_<%=invoice.getOID()%>" value="<%=bpd.getPaymentAmount()%>">
                                                <input type="text" name="payment_amountd_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(bpd.getPaymentAmount(), "#,###.##")%>"   style="text-align:right" size="15" onClick="this.select()" class="readonly" readOnly>
                                            </div>
                                        </td>
                                        <td width="11%" class="tablecell" nowrap> 
                                            <div align="center"> 
                                                <input type="hidden" name="h_inv_curr_amountd_<%=invoice.getOID()%>" value="<%=bpd.getPaymentByInvCurrencyAmount()%>">
                                                <%=c.getCurrencyCode()%>                                                  
                                                <input type="text" name="inv_curr_amountd_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(bpd.getPaymentByInvCurrencyAmount(), "#,###.##")%>" onBlur="javascript:getAmountd('<%=invoice.getOID()%>')"  style="text-align:right" size="15" onClick="this.select()"  >                                                 
                                            </div>
                                        </td>
                                        <%
                                        String notes = "";
                                        if (invoice.getTypeAp() == 1) {
                                            notes = invoice.getNote();
                                        } else {
                                            notes = invoice.getInvoiceNumber() + ", " + JSPFormater.formatDate(invoice.getDate(), "dd/MM/yyyy");
                                        }

                                        if (bpd.getMemo().length() > 0) {
                                            notes = bpd.getMemo();
                                        }
                                        %>    
                                        <td width="33%" class="tablecell"> 
                                            <div align="left"> 
                                                <input type="text" name="memod_<%=invoice.getOID()%>" size="25" value="<%=notes%>" >
                                            </div>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <%}%>
                                </table>
                            </td>
                        </tr>    
                    </table>        
                </td>                     
            </tr>
            <%}%>
            <tr> 
                <td height="25">&nbsp;</td>
            </tr>  
            <%if (bankpoPayment.getPostedStatus() == 0) {%>
            <tr>
                <td height="18"></td>
            </tr>
            <tr> 
                <td height="25">                                
                    <table border="0" cellpadding="1" cellspacing="1" width="400">
                        <tr>
                            <td class="tablecell1">
                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                    <tr>
                                        <td colspan="4" height="5"></td>
                                    </tr>   
                                    <tr>
                                        <td width="5"></td>
                                        <td colspan="2" height="5"><i><b><%=langNav[15]%></b></i></td>
                                        <td width="5"></td>
                                    </tr>  
                                    <tr>
                                        <td colspan="4" height="5"></td>
                                    </tr>  
                                    <tr>
                                        <td ></td>
                                        <td width="120"><%=langNav[14]%></td>
                                        <td>
                                            <%
    Vector vnds = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);
                                            %>
                                            <select name="hidden_vendor_id">
                                                <option value="0">< all ></option>
                                                <%if (vnds != null && vnds.size() > 0) {
        for (int i = 0; i < vnds.size(); i++) {
            Vendor v = (Vendor) vnds.get(i);
                                                %>
                                                <option value="<%=v.getOID()%>" <%if (oidVendor == v.getOID()) {%>selected<%}%>><%=v.getName()%></option>
                                                <%}
    }%>
                                            </select>&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td ></td>
                                    </tr>   
                                    <tr>
                                        <td ></td>
                                        <td><%=langNav[16]%></td>
                                        <td><input type="text" name="vndinvnumber" value="<%=vndInvNumber%>" size="25"></td>
                                        <td ></td>
                                    </tr>   
                                    <tr>
                                        <td ></td>
                                        <td><%=langNav[17]%></td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td><input name="duedate" value="<%=JSPFormater.formatDate(dueDate, "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.duedate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                            
                                                    <td >&nbsp;&nbsp;<input type="checkbox" name="overdue" value="1" <%if (overDue == 1) {%>checked<%}%>></td>
                                                    <td ><%=langNav[18]%></td>
                                                </tr>       
                                            </table> 
                                        </td>
                                        <td ></td>
                                    </tr>  
                                    <tr>
                                        <td colspan="2" height="15"></td>
                                    </tr>        
                                </table>
                            </td>
                        </tr>
                    </table>                                
                </td>
            </tr>                        
            <tr> 
                <td ><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('srch','','../images/search2.gif',1)"><img src="../images/search.gif" name="srch"  border="0"></a><td> 
            </tr>    
            <tr> 
                <td height="10"><td> 
            </tr>    
            <%} else {%>
            <tr> 
                <td height="25"> 
                    <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                        <tr> 
                            <td width="20"><img src="../images/success.gif"></td>
                            <td width="110"><B>Document Posted</B></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
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
                <td width="69%">&nbsp;</td>
                <td width="31%"> 
                    <table width="100%" border="0" cellspacing="1" cellpadding="5" class="boxed1">
                        <tr> 
                            <td width="36%" > 
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
<%if (bankpoPayment.getOID() != 0) {%>
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
            <tr id="closecmd"> 
                <td width="10">&nbsp;</td>
                <%if (bankpoPayment.getPostedStatus() == 0) {%>
                <td width="3%">
                    <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sv','','../images/save2.gif',1)"><img src="../images/save.gif" name="sv" border="0"></a>                                            
                </td>
                <td width="3%">&nbsp;</td>
                <%}%>
                <td width="3%">
                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>    
                </td>
                <td width="3%">&nbsp;</td>
                <td width="9%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
                <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                <td ></td>
            </tr>
            <tr id="closemsg" align="left" valign="top"> 
                <td height="22" valign="middle" colspan="7"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                      
                        <tr> 
                            <td>&nbsp;&nbsp;&nbsp;<font color="#006600">Save document in progress, please wait .... </font> </td>
                        </tr>
                        <tr> 
                            <td height="1">&nbsp;</td>
                        </tr>
                        <tr> 
                            <td>&nbsp;&nbsp;&nbsp;<img src="../images/progress_bar.gif" border="0"> 
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
</tr>
<%}%>                                   
</table>
</td>
</tr>
</table>
<script language="JavaScript">
    cmdGetAmount();                                 
    cmdSetCheckBox();
    </script>
<script language="JavaScript">
    document.all.closecmd.style.display="";
    document.all.closemsg.style.display="none";
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