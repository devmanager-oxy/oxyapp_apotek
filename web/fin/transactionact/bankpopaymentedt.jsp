
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
            

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_id");
            long oidEdtBankpoPayment = JSPRequestValue.requestLong(request, "edt_bankpo_payment_id");
            String vndInvNumber = JSPRequestValue.requestString(request, "vndinvnumber");
            long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");
            int overDue = JSPRequestValue.requestInt(request, "overdue");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int overStatus = JSPRequestValue.requestInt(request, "src_overdue");
            String srcNumber = JSPRequestValue.requestString(request, "src_number");

            Date dueDate = new Date();
            if (JSPRequestValue.requestString(request, "duedate").length() > 0) {
                dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "duedate"), "dd/MM/yyyy");
            }

            if (iJSPCommand == JSPCommand.NONE && iJSPCommand != JSPCommand.REFRESH) {
                overDue = 1;
            }

            int iErrCode = JSPMessage.NONE;
            iErrCode = ctrlBankpoPayment.action(iJSPCommand, oidBankpoPayment);
            JspBankpoPayment jspBankpoPayment = ctrlBankpoPayment.getForm();
            BankpoPayment bankpoPayment = ctrlBankpoPayment.getBankpoPayment();

            try {
                if (oidEdtBankpoPayment != 0) {
                    bankpoPayment = DbBankpoPayment.fetchExc(oidEdtBankpoPayment);
                }
            } catch (Exception e) {
            }

            if (oidBankpoPayment == 0) {
                oidBankpoPayment = bankpoPayment.getOID();
            }

            Vector locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            String strLocation = "";
            if (locationId == 0) {
                if (locations != null && locations.size() > 0) {
                    for (int i = 0; i < locations.size(); i++) {
                        Location l = (Location) locations.get(i);
                        if (strLocation != null && strLocation.length() > 0) {
                            strLocation = strLocation + ",";
                        }
                        strLocation = strLocation + l.getOID();
                    }
                }
            } else {
                strLocation = "" + locationId;
            }

            InvoiceSrc invSrc = new InvoiceSrc();
            if (session.getValue("SRC_POPAY") != null) {
                invSrc = (InvoiceSrc) session.getValue("SRC_POPAY");
            } else {
                invSrc.setVendorId(oidVendor);
                invSrc.setPoNumber("");
                invSrc.setVndInvNumber(vndInvNumber);
                invSrc.setDueDate(dueDate);
                invSrc.setOverDue(overDue);
                invSrc.setStatusOverdue(overStatus);
                invSrc.setLocationId(strLocation);
                invSrc.setInvNumber(srcNumber);
            }

            //Vector invoices = new Vector();
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
                        long vendorxId = JSPRequestValue.requestLong(request, "vndd_" + bpd.getInvoiceId());

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
                        ii.setVendorId(vendorxId);
                        vBPD.add(ii);

                    }
                }
            }
            if (iJSPCommand == JSPCommand.SAVE && bankpoPayment.getOID() != 0 && iErrCode == 0) {
                DbBankpoPaymentDetail.insertItems(bankpoPayment.getOID(), vBPD);                
                vbankpoPayment = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment.getOID(), null);
                try {
                    if (bankpoPayment.getOID() != 0) {
                        bankpoPayment = DbBankpoPayment.fetchExc(bankpoPayment.getOID());
                    }
                } catch (Exception e) {
                }
            //invoices = QrInvoice.getOpenInvoiceByVendor(oidVendor, invSrc);
            }
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PAYMENT_SUSPENSE_ACCOUNT + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            
            
            String[] langCT = {"Receipt to Account", "Customer", "Payment Method", "Cheque/Transfer Number", "Memo", "Journal Number", "Trans. Date", "Amount", "Period"}; //0 - 8
            String[] langNav = {"Acc. Payable", "PO Payment", "Date", "Invoice", "Vendor", "Inv. Currency", "Location", "Balance", // 0- 7
                "Rate", "Payment", "Invoice Number", "Description", "DO Number", "Currency", "Doc. Number", "Search for Open Invoice", "Vendor Invoice Number", "Due Date", "ignore" // 8 -18
            };

            if (lang == LANG_ID) {
                String[] langID = {"Perkiraan", "Sarana", "Cara Pelunasan", "Cek/nomor Transfer", "Memo", "Nomor Jurnal", "Tanggal Transfer", "Jumlah", "Periode"}; //0 - 8
                langCT = langID;
                String[] navID = {"Hutang", "Order Pembelian", "Tanggal", "Tagihan", "Suplier", "Mata uang Inv.", "Lokasi", "Balance", // 0 -7
                    "Rate", "Pembayaran", "Nomor Invoice", "Keterangan", "Nomor DO", "Mata Uang Inv", "Doc. Number", "Pencarian Faktur yang Belum Terbayarkan", "Nomor Faktur Suplier", "Tanggal Pelunasan", "Abaikan" // 8 -18
                };
                langNav = navID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
    <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
    <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
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
            window.open("<%=printroot%>.report.RptBankpoPDF?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id=<%=oidBankpoPayment%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdPrintJournalXLS(){	                       
                window.open("<%=printroot%>.report.RptBankpoPaymentXLS?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id=<%=oidBankpoPayment%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                                                            <td > 
                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                    <tr>
                                                                        <td colspan="7" height="5"></td>
                                                                    </tr>     
                                                                    <tr height="24">
                                                                        <td class="tablecell1" width="100">&nbsp;<%=langCT[5]%></td>
                                                                        <td width="5">:</td>
                                                                        <td width="250" class="fontarial">
                                                                            <%
            Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            String strNumber = "";
            Periode open = new Periode();
            if (bankpoPayment.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(bankpoPayment.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (periods != null && periods.size() > 0) {
                    open = (Periode) periods.get(0);
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
                                                                        <td width="100">&nbsp;</td>
                                                                        <td width="2"></td>
                                                                        <td ></td>
                                                                    </tr>
                                                                    <tr height="24">
                                                                        <td class="tablecell1" width="90">&nbsp;<%=langCT[0]%></td>                                        
                                                                        <td class="fontarial">:</td>
                                                                        <td>
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
                                                                                <option value="<%=acl.getCoaId()%>" <%if (acl.getCoaId() == bankpoPayment.getCoaId()) {%>selected<%}%>><%=coay.getCode() + " - " + coay.getName()%></option>
                                                                                <%=getAccountRecursif(coay, bankpoPayment.getCoaId(), isPostableOnly)%> 
                                                                                <%}
            }%>
                                                                            </select>
                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_COA_ID) %>                                                                             
                                                                        </td>
                                                                        <%if (periods.size() > 1) {%>
                                                                        <td class="tablecell1">&nbsp;<%=langCT[8]%></td>
                                                                        <td class="fontarial">:</td>
                                                                        <%} else {%>
                                                                        <td></td>
                                                                        <td></td>
                                                                        <%}%>
                                                                        <td > 
                                                                            <%if (open.getStatus().equals("Closed") || bankpoPayment.getOID() != 0) {%>
                                                                            <%=open.getName()%>
                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                            <%} else {%>
                                                                            <%if (periods.size() > 1) {%>
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
                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                            <%}%>
                                                                            <%}%>
                                                                        </td>
                                                                        <td ></td>
                                                                    </tr>        
                                                                    <tr height="24">                                                                         
                                                                        <td class="tablecell1">&nbsp;<%=langCT[7]%>&nbsp;<%=baseCurrency.getCurrencyCode()%></td>
                                                                        <td class="fontarial">:</td>
                                                                        <td > 
                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_REF_NUMBER] %>"  value="<%= bankpoPayment.getRefNumber() %>" class="formElemen">
                                                                            <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT] %>"  style="text-align:right" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" class="readonly" readonly size="11">
                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_AMOUNT) %>
                                                                        </td>
                                                                        <td class="tablecell1">&nbsp;<%=langCT[6]%></td>
                                                                        <td class="fontarial">:</td>
                                                                        <td >
                                                                            <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getTransDate() == null) ? new Date() : bankpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_TRANS_DATE) %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr height="24">
                                                                        <td class="tablecell1">&nbsp;<%=langCT[4]%></td>
                                                                        <td class="fontarial">:</td>
                                                                        <td colspan="4"> 
                                                                            <textarea name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_MEMO] %>" class="formElemen" cols="25" rows="2"><%= bankpoPayment.getMemo() %></textarea>
                                                                        <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_MEMO) %> </td>
                                                                        <td ></td>
                                                                    </tr>  
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>                                                                                            
                                            </tr>   
                                            <%if (vbankpoPayment != null && vbankpoPayment.size() > 0) {%>
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                        <tr height="28">
                                                            <td class="tablehdr" width="20">&nbsp;</td>
                                                            <td class="tablehdr" width="120"><%=langNav[14]%></td>
                                                            <td class="tablehdr" width="180"><%=langNav[4]%></td>
                                                            <td class="tablehdr" width="150"><%=langNav[10]%></td>
                                                            <td class="tablehdr" width="200"><%=langNav[6]%></td>
                                                            <td class="tablehdr" ><%=langNav[11]%></td>
                                                        </tr>
                                                        <%
    if (vbankpoPayment != null && vbankpoPayment.size() > 0) {

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
                                                        %>
                                                        <tr height="22">
                                                            <td class="tablearialcell1" align="center">
                                                                <input type="checkbox" name="chkd_<%=invoice.getOID()%>" value="1" onClick="javascript:cmdCheckItd('<%=invoice.getOID()%>')" checked >                                                
                                                                <input type="hidden" name="vndd_<%=invoice.getOID()%>" value="<%=invoice.getVendorId()%>" >
                                                            </td>
                                                            <td class="tablearialcell1" align="left" style="padding:3px;"><%=invoice.getNumber()%></td>
                                                            <td class="tablearialcell1" align="left" style="padding:3px;"><%=vxxx.getName() %></td>
                                                            <td class="tablearialcell1" align="left" style="padding:3px;"><%=invoice.getInvoiceNumber()%></td>
                                                            <td class="tablearialcell1" align="left" style="padding:3px;">
                                                                <%=loc.getName()%>
                                                                <input type="hidden" name="lokasid_<%=invoice.getOID()%>" value ="<%=loc.getOID()%>">
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
                                                            <td class="tablearialcell1" align="left" style="padding:3px;"><input type="text" name="memod_<%=invoice.getOID()%>" size="55" value="<%=notes%>" readonly class="readOnly"></td>
                                                        </tr>   
                                                        <tr height="22">
                                                            <td class="tablecell"></td>
                                                            <td class="tablecell1" colspan="5">
                                                                <table border="0" cellpadding="0" cellspacing="1">
                                                                    <tr>
                                                                        <td class="tablearialcell" align="center" width="180"><B><%=langNav[7]%></b></td> 
                                                                        <td class="tablearialcell" align="center" width="180"><B><%=langNav[8]%></b></td> 
                                                                        <td class="tablearialcell" align="center" width="180"><B><%=langNav[7]%>&nbsp;<%=baseCurrency.getCurrencyCode()%></b></td> 
                                                                        <td class="tablearialcell" align="center" width="180"><B><%=langNav[9]%>&nbsp;<%=baseCurrency.getCurrencyCode()%></b></td> 
                                                                        <td class="tablearialcell" align="center" width="180"><B><%=langNav[9]%> <%=langNav[13]%></b></td> 
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="tablearialcell" align="center" width="180" style="padding:3px;" ><input type="text" name="inv_balanced_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(DbReceive.getInvoiceBalanceEdt(invoice.getOID(), bpd.getOID()), "#,###.##")%>" style="text-align:right" size="15" class="readonly" readOnly></td> 
                                                                        <%
                                                                double exRateValue = 1;
                                                                Currency c = new Currency();
                                                                if (invoice.getCurrencyId() != 0) {
                                                                    try {
                                                                        c = DbCurrency.fetchExc(invoice.getCurrencyId());
                                                                    } catch (Exception e) {
                                                                    }
                                                                }
                                                                        %>
                                                                        <td class="tablearialcell" align="center" width="180"><input type="text" name="exc_rated_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(exRateValue, "#,###.##")%>"   style="text-align:right" size="5" class="readonly" readOnly></td> 
                                                                        <td class="tablearialcell" align="center" width="180"><input type="text" name="balance_idrd_<%=invoice.getOID()%>" value=""   style="text-align:right" size="15" class="readonly" readOnly></td> 
                                                                        <td class="tablearialcell" align="center" width="180">
                                                                            <input type="hidden" name="h_payment_amountd_<%=invoice.getOID()%>" value="<%=bpd.getPaymentAmount()%>">
                                                                            <input type="text" name="payment_amountd_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(bpd.getPaymentAmount(), "#,###.##")%>"   style="text-align:right" size="15" onClick="this.select()" class="readonly" readOnly>
                                                                        </td> 
                                                                        <td class="tablearialcell" align="center" width="180">
                                                                            <input type="hidden" name="h_inv_curr_amountd_<%=invoice.getOID()%>" value="<%=bpd.getPaymentByInvCurrencyAmount()%>">
                                                                            <%=c.getCurrencyCode()%>                                                  
                                                                            <input type="text" name="inv_curr_amountd_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(bpd.getPaymentByInvCurrencyAmount(), "#,###.##")%>" onBlur="javascript:getAmountd('<%=invoice.getOID()%>')"  style="text-align:right" size="15" onClick="this.select()"  >
                                                                        </td> 
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%
        }
    }
                                                        %>
                                                        
                                                    </table>
                                                </td>
                                            </tr> 
                                            <%}%>
                                            <tr> 
                                                <td height="25">&nbsp;</td>
                                            </tr>  
                                            <%if (bankpoPayment.getPostedStatus() == 0) {%>
                                            <tr>
                                                <td height="18">
                                                    <table border="0" cellspacing="2" cellpadding="1">
                                                        <tr height="5"> 
                                                            <td width="120"></td>
                                                            <td width="2"></td>
                                                            <td width="350"></td>
                                                            <td width="80"></td>
                                                            <td width="2"></td>
                                                            <td ></td>
                                                        </tr>
                                                        <tr>                                                                                                                    
                                                            <td colspan="6" height="5" class="fontarial"><b><i><%=langNav[15]%> :</i></b></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" height="1"></td>
                                                        </tr>
                                                        <tr height="24">
                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langNav[14]%></td> 
                                                            <td class="fontarial">:</td> 
                                                            <td ><input type="text" name="src_number" value="<%=srcNumber%>" size="15"></td> 
                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langNav[4]%></td>
                                                            <td class="fontarial">:</td>       
                                                            <td > 
                                                                <%
    Vector vnds = DbVendor.list(0, 0, "", "" + DbVendor.colNames[DbVendor.COL_NAME]);
                                                                %>
                                                                <select name="hidden_vendor_id" class="fontarial">
                                                                    <option value="0">- All Suplier - </option>
                                                                    <%if (vnds != null && vnds.size() > 0) {
        for (int i = 0; i < vnds.size(); i++) {
            Vendor v = (Vendor) vnds.get(i);
                                                                    %>
                                                                    <option value="<%=v.getOID()%>" <%if (oidVendor == v.getOID()) {%>selected<%}%>><%=v.getName()%></option>
                                                                    <%}
    }%>
                                                                </select>
                                                            </td>            
                                                            
                                                        </tr>
                                                        <tr height="24">
                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langNav[10]%></td>
                                                            <td class="fontarial">:</td>       
                                                            <td ><input type="text" name="vndinvnumber" value="<%=vndInvNumber%>" size="15"></td>                                                                                                                    
                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langNav[6]%></td> 
                                                            <td class="fontarial">:</td> 
                                                            <td >
                                                                <select name="src_location_id" class="fontarial"> 
                                                                    <option value="0" <%if (locationId == 0) {%>selected<%}%>>- All Locations -</option>
                                                                    <%if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location us = (Location) locations.get(i);
                                                                    %>
                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                    <%}
    }%>
                                                                </select> 
                                                            </td> 
                                                        </tr>
                                                        <tr height="24">                                                                                                       
                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langNav[17]%></td>
                                                            <td class="fontarial">:</td>       
                                                            <td > 
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td><input name="duedate" value="<%=JSPFormater.formatDate(dueDate, "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.duedate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                            
                                                                        <td >&nbsp;&nbsp;<input type="checkbox" name="overdue" value="1" <%if (overDue == 1) {%>checked<%}%>></td>
                                                                        <td class="fontarial"><%=langNav[18]%></td>
                                                                    </tr>       
                                                                </table>
                                                            </td>
                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;Overdue</td> 
                                                            <td class="fontarial">:</td> 
                                                            <td >
                                                                <select name="src_overdue" class="fontarial">
                                                                    <option value = "0" <%if (overStatus == 0) {%> selected<%}%> >- All Status -</option>
                                                                    <option value = "1" <%if (overStatus == 1) {%> selected<%}%> >Overdue</option>
                                                                    <option value = "2" <%if (overStatus == 2) {%> selected<%}%> >Not Overdue</option>
                                                                </select>  
                                                            </td>
                                                        </tr> 
                                                        <tr> 
                                                            <td colspan="6" width="100%"><table width="800" border="0" cellspacing="0" cellpadding="0"><tr><td background="../images/line.gif"><img src="../images/line.gif"></td></tr></table></td>
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
                                    <td colspan="5" class="container"> 
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
                                    <td colspan="5" class="container"> 
                                        <table align="left" border="0" cellspacing="0" cellpadding="0">
                                            <tr id="closecmd">                                                 
                                                <%if (bankpoPayment.getPostedStatus() == 0) {%>
                                                <td width="70">
                                                    <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sv','','../images/save2.gif',1)"><img src="../images/save.gif" name="sv" border="0"></a>                                            
                                                </td>
                                                <td width="15">&nbsp;</td>
                                                <%}%>
                                                <td width="70">
                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/exportpdf2.png',1)"><img src="../images/exportpdf.png" name="print" height="21" border="0"></a>    
                                                </td>
                                                <td width="15">&nbsp;</td>
                                                <td width="100">
                                                    <a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" height="22" border="0"></a>    
                                                </td>
                                                <td width="15">&nbsp;</td>
                                                <td width="100"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
                                                <td width="10"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>                                                
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
                                <tr> 
                                    <td colspan="5" height="35">&nbsp;</td>
                                </tr> 
                            </table>
                        </td>
                    </tr>
                </table>
                <script language="JavaScript">
                    cmdGetAmount();
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