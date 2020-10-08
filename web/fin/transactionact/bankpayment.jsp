
<%-- 
    Document   : bankpayment
    Created on : Nov 16, 2012, 11:40:16 AM
    Author     : Roy Andika
--%>

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
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.GiroTransaction" %>
<%@ page import = "com.project.ccs.postransaction.sales.DbGiroTransaction" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../printing/printingvariables.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_INVOICE_PAYMENT, AppMenu.PRIV_DELETE);
%>
<%!
    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                BankpoPaymentDetail crd = (BankpoPaymentDetail) listx.get(i);
                result = result + crd.getPaymentAmount();
            }
        }
        return result;
    }

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
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpopayment_id");
            long oidBankpoPaymentInduk = JSPRequestValue.requestLong(request, "hidden_bankpopayment_induk_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            long coaSuspense = JSPRequestValue.requestLong(request, "hidden_coa_suspense");
            long vendorId = JSPRequestValue.requestLong(request, "hidden_vendor_id");
            double amountHutang = JSPRequestValue.requestDouble(request, "hidden_amount_hutang");
            long oidBG = 0;
            long oidCheckPending = 0;
            try {
                oidBG = Long.parseLong(DbSystemProperty.getValueByName("OID_PAYMENT_BG"));
            } catch (Exception e) {}
            
            try {
                oidCheckPending = Long.parseLong(DbSystemProperty.getValueByName("OID_PAYMENT_CHECK_PENDING"));
            } catch (Exception e) {}
            
            //Pengecekan uniq key
            long uniqId = JSPRequestValue.requestLong(request, "hidden_uniq_id");
            long uniqDetailId = JSPRequestValue.requestLong(request, "hidden_uniq_detail_id");

            docChoice = 1;
            generalOID = oidBankpoPayment;

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("PPPAYMENT_DETAIL");
                recIdx = -1;                
                oidBankpoPaymentInduk = oidBankpoPayment;
            }              

            BankpoPayment objBankpoPayment = new BankpoPayment();
            int countx = DbBankpoPayment.getCount(DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_ID] + " = " + oidBankpoPayment + " and " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PEMBAYARAN_BANK);
            double payment = DbBankpoPaymentDetail.getTotalPayment(oidBankpoPayment);
            
            int countUniq = DbUniqKey.getCount(DbUniqKey.colNames[DbUniqKey.COL_UNIQ_ID]+" = "+uniqId);
            int countUniqDetail = DbUniqKeyDetail.getCount(DbUniqKeyDetail.colNames[DbUniqKeyDetail.COL_UNIQ_DETAIL_ID]+" = "+uniqDetailId);
            
            if (oidBankpoPayment != 0 && iJSPCommand == JSPCommand.SAVE && (countUniq <= 0 && countUniqDetail <= 0)) {
                long oidCoa = JSPRequestValue.requestLong(request, JspBankpoPayment.colNames[JspBankpoPayment.JSP_COA_ID]);
                Date transDt = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspBankpoPayment.colNames[JspBankpoPayment.JSP_TRANS_DATE]), "dd/MM/yyyy"); 
                long perId = JSPRequestValue.requestLong(request, JspBankpoPayment.colNames[JspBankpoPayment.JSP_PERIODE_ID]);
                long paymentMethod = JSPRequestValue.requestLong(request, JspBankpoPayment.colNames[JspBankpoPayment.JSP_PAYMENT_METHOD_ID]);

                boolean err = false;
                try {
                    Coa coa = DbCoa.fetchExc(oidCoa);
                    if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        err = true;
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                if (perId != 0) {

                    String wherex = "";
                    Periode preClosedPeriodx = DbPeriode.getPreClosedPeriod();

                    Periode perx = new Periode();
                    try {
                        perx = DbPeriode.fetchExc(perId);
                    } catch (Exception e) {
                    }

                    if (preClosedPeriodx.getOID() != 0) {
                        wherex = "'" + JSPFormater.formatDate(transDt, "yyyy-MM-dd") + "' between start_date and end_date " +
                                " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + perx.getOID();
                    } else {
                        wherex = "'" + JSPFormater.formatDate(transDt, "yyyy-MM-dd") + "' between start_date and end_date " +
                                " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                    }

                    Vector v = DbPeriode.list(0, 0, wherex, "");
                    if (v == null || v.size() == 0) {
                        err = true;
                    }
                }

                if (paymentMethod == 0) {
                    err = true;
                }

                objBankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);
                if (err == false) {                    
                    objBankpoPayment.setStatus(DbBankpoPayment.STATUS_PARTIALY_PAID);
                    try {
                        DbBankpoPayment.updateExc(objBankpoPayment);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    oidBankpoPayment = 0;
                }
            }

            BankpoPayment bankpoPayment = new BankpoPayment();
            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);
            JspBankpoPayment jspBankpoPayment = ctrlBankpoPayment.getForm();
            boolean isSave = false;
            String msgErr = "";
            String msgPayment = "";

            if (iJSPCommand == JSPCommand.SAVE) {
                
                if(countUniq <= 0 && countUniqDetail <= 0) {
                    isSave = true;
                    jspBankpoPayment.requestEntityObject(bankpoPayment);
                    try {
                        Coa coa = DbCoa.fetchExc(bankpoPayment.getCoaId());
                        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                            msgErr = "postable account required";
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    if (bankpoPayment.getPaymentMethodId() == 0) {
                        msgErr = "Payment method required";
                        msgPayment = "Payment method required";
                    }

                    if (bankpoPayment.getPeriodeId() != 0) {
                        String wherex = "";
                        Periode preClosedPeriodx = DbPeriode.getPreClosedPeriod();

                        if (preClosedPeriodx.getOID() != 0) {
                            wherex = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                                " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + bankpoPayment.getPeriodeId();
                        } else {
                            wherex = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                                " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                        }

                        Vector v = DbPeriode.list(0, 0, wherex, "");
                        if (v == null || v.size() == 0) {
                            msgErr = "transaction date out of open period range";
                        }
                    }

                    bankpoPayment.setOID(0);
                
                    if (countx == 0) {
                        bankpoPayment.setJournalNumber(objBankpoPayment.getJournalNumber() + "P");
                    } else {
                        bankpoPayment.setJournalNumber(objBankpoPayment.getJournalNumber() + "P" + (countx + 1));
                    }

                    bankpoPayment.setJournalPrefix(objBankpoPayment.getJournalPrefix());
                    bankpoPayment.setJournalCounter(objBankpoPayment.getJournalCounter());
                    bankpoPayment.setDate(objBankpoPayment.getDate());
                    bankpoPayment.setRefId(objBankpoPayment.getOID());
                    bankpoPayment.setCurrencyId(objBankpoPayment.getCurrencyId());
                    bankpoPayment.setVendorId(vendorId);

                    if (msgErr.length() <= 0) {
                        bankpoPayment.setStatus(DbBankpoPayment.STATUS_PAID);
                        bankpoPayment.setPostedStatus(1);
                        try {
                            oidBankpoPayment = DbBankpoPayment.insertExc(bankpoPayment);
                        } catch (Exception e) {
                            System.out.println("[exception] " + e.toString());
                        }
                    }
                }
            }

            if (iJSPCommand != JSPCommand.SAVE) {
                bankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);
                vendorId = bankpoPayment.getVendorId();
                amountHutang = bankpoPayment.getAmount();
            }

            long oidBankpopaymentDetail = JSPRequestValue.requestLong(request, "hidden_bankpopayment_detail_id");
            CmdBankpoPaymentDetail ctrlBankpoPaymentDetail = new CmdBankpoPaymentDetail(request);
            Vector listBankpoPaymentDetail = new Vector(1, 1);
            JspBankpoPaymentDetail jspBankpoPaymentDetaill = ctrlBankpoPaymentDetail.getForm();
            BankpoPaymentDetail bankpoPaymentDetail = ctrlBankpoPaymentDetail.getBankpoPaymentDetail();

            if (session.getValue("PPPAYMENT_DETAIL") != null) {
                listBankpoPaymentDetail = (Vector) session.getValue("PPPAYMENT_DETAIL");
            }

            if (iJSPCommand == JSPCommand.SAVE && (countUniq <= 0 && countUniqDetail <= 0)) {
                jspBankpoPaymentDetaill.requestEntityObject(bankpoPaymentDetail);
                if (bankpoPayment.getOID() != 0) {
                    try {
                        bankpoPaymentDetail.setBankpoPaymentId(bankpoPayment.getOID());
                        bankpoPaymentDetail.setBookedRate(1);
                        bankpoPaymentDetail.setCurrencyId(objBankpoPayment.getCurrencyId());
                        bankpoPaymentDetail.setPaymentByInvCurrencyAmount(bankpoPaymentDetail.getPaymentAmount());
                        DbBankpoPaymentDetail.insertExc(bankpoPaymentDetail);
                        listBankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, "" + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment.getOID(), "");

                        DbBankpoPaymentDetail.updateStatusPaymentPosted(objBankpoPayment.getOID());
                        DbBankpoPayment.postJournalPembayaran(bankpoPayment, listBankpoPaymentDetail, user.getOID());

                        //pengecekan status pembayaran
                        DbBankpoPaymentDetail.statusPembayaran(oidBankpoPaymentInduk);

                        if (bankpoPayment.getPaymentMethodId() == oidBG || bankpoPayment.getPaymentMethodId() == oidCheckPending) {

                            BankPayment bp = new BankPayment();
                            bp.setReferensiId(bankpoPayment.getOID());
                            bp.setAmount(bankpoPayment.getAmount());
                            if (bankpoPayment.getPaymentMethodId() == oidBG){
                                bp.setType(DbBankPayment.TYPE_BANK_PO);
                            }else if(bankpoPayment.getPaymentMethodId() == oidCheckPending){
                                bp.setType(DbBankPayment.TYPE_BANK_PO_CHECK);
                            }
                            
                            bp.setNumber(bankpoPayment.getRefNumber());
                            bp.setCreateDate(new Date());
                            bp.setCoaId(bankpoPayment.getCoaId());
                            bp.setCurrencyId(bankpoPayment.getCurrencyId());
                            bp.setDueDate(bankpoPayment.getDueDateBG());
                            bp.setStatus(DbBankPayment.STATUS_NOT_PAID);
                            bp.setCreateId(user.getOID());
                            bp.setSegment1Id(bankpoPayment.getSegment1Id());
                            bp.setSegment2Id(bankpoPayment.getSegment2Id());
                            bp.setSegment3Id(bankpoPayment.getSegment3Id());
                            bp.setSegment4Id(bankpoPayment.getSegment4Id());
                            bp.setSegment5Id(bankpoPayment.getSegment5Id());
                            bp.setSegment6Id(bankpoPayment.getSegment6Id());
                            bp.setSegment7Id(bankpoPayment.getSegment7Id());
                            bp.setSegment8Id(bankpoPayment.getSegment8Id());
                            bp.setSegment9Id(bankpoPayment.getSegment9Id());
                            bp.setSegment10Id(bankpoPayment.getSegment10Id());
                            bp.setSegment11Id(bankpoPayment.getSegment11Id());
                            bp.setSegment12Id(bankpoPayment.getSegment12Id());
                            bp.setSegment13Id(bankpoPayment.getSegment13Id());
                            bp.setSegment14Id(bankpoPayment.getSegment14Id());
                            bp.setSegment15Id(bankpoPayment.getSegment15Id());
                            bp.setTransactionDate(bankpoPayment.getTransDate());
                            bp.setVendorId(bankpoPayment.getVendorId());
                            bp.setJournalCounter(bankpoPayment.getJournalCounter());
                            bp.setJournalPrefix(bankpoPayment.getJournalPrefix());
                            if (bankpoPayment.getPaymentMethodId() == oidBG){
                                bp.setJournalNumber(bankpoPayment.getJournalNumber() + "-BG");
                            }else if(bankpoPayment.getPaymentMethodId() == oidCheckPending){
                                bp.setJournalNumber(bankpoPayment.getJournalNumber() + "-CHEQUE");
                            }

                            try {
                                DbBankPayment.insertExc(bp);
                            } catch (Exception e) {
                            }
                        }

                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    try{
                        UniqKey uniqKey = new UniqKey();
                        uniqKey.setType(DbUniqKey.TYPE_BANK_PO_PAYMENT);
                        uniqKey.setRefId(bankpoPayment.getOID());       
                        uniqKey.setUniqId(uniqId);                                    
                        long uniqIdx = DbUniqKey.insertExc(uniqKey);
                        if(uniqIdx != 0){
                            UniqKeyDetail ukd = new UniqKeyDetail();
                            ukd.setUniqKeyId(uniqIdx);
                            ukd.setUniqDetailId(uniqDetailId);
                            DbUniqKeyDetail.insertExc(ukd);
                        }
                    }catch(Exception e){}    
                }
                iJSPCommand = JSPCommand.ADD;
            }

            session.putValue("PPPAYMENT_DETAIL", listBankpoPaymentDetail);
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT + "'", "");

            String[] langCT = {"Receipt to Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Account - Description", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Invoice payment document has been saved successfully", "Search Journal Number", "Paid", "Period", "Payment", "Ref. Number", "Advance"}; //10-17

            String[] langNav = {"Acc. Payable", "Invoice Payment", "Date", "CASH PAYMENT EDITOR"};

            if (lang == LANG_ID) {
                String[] langID = {"Perkiraan", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Perkiraan", "Keterangan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran faktur sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Paid", "Periode", "Pembayaran", "Nomor Transfer / BG", "Kasbon"}; //10-17
                langCT = langID;

                String[] navID = {"Hutang", "Pembayaran Invoice", "Tanggal", "EDITOR PEMBAYARAN TUNAI"};
                langNav = navID;
            }

            Vector segments = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            
            double balance = amountHutang - payment;
            if (iJSPCommand == JSPCommand.NONE) {
                 bankpoPayment.setAmount(balance); 
            }
%>
<html>
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdCetak(param){	
                document.frmbankpopaymentdetail.command.value="<%=JSPCommand.LOAD%>";
                document.frmbankpopaymentdetail.command_print.value=param;
                document.frmbankpopaymentdetail.action="bankpayment.jsp";
                document.frmbankpopaymentdetail.submit();	
            }
            
            function cmdKasbon(){
                var numb = document.frmbankpopaymentdetail.referensi_number.value;
                window.open("<%=approot%>/<%=transactionFolder%>/kasbonpo.jsp?txt_jurnal=\'"+numb+"'&command=<%=JSPCommand.SEARCH%>&formName=frmgl&txt_Id=referensi_id&txt_Name=referensi_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }  
                
                
                var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                var usrDigitGroup = "<%=sUserDigitGroup%>";
                var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                
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
            
            function checkNumber(){            
                var st = document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value;		            
                result = removeChar(st);            
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
                if(parseFloat(result) > parseFloat(ab)){                
                    if(parseFloat(ab)<1){                    
                        result = "0";         
                        alert("No account balance available,\nCan not continue the transaction.");                    
                    }else{                    
                    result = ab;                
                    alert("Transaction amount over the account balance");
                }
            }        
            document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
        }
        
        function cmdSubmitCommand(){
            document.frmbankpopaymentdetail.command.value="<%=JSPCommand.SAVE%>";
            document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankpopaymentdetail.action="bankpayment.jsp";
            document.frmbankpopaymentdetail.submit();
        }
        
        function cmdBack(){
            document.frmbankpopaymentdetail.command.value="<%=JSPCommand.NONE%>";            
            document.frmbankpopaymentdetail.action="bankpopaymentlist.jsp";
            document.frmbankpopaymentdetail.submit();
        }
        
        function isBG(){                
            if(document.frmbankpopaymentdetail.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>.value == '<%=oidBG%>' ||  document.frmbankpopaymentdetail.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>.value == '<%=oidCheckPending%>'){
                document.all.inpBg.style.display="";
            }else{                    
            document.all.inpBg.style.display="none";
        }
    }
    
    function cmdUpdate(){       
        var x = document.frmbankpopaymentdetail.<%=JspBankpoPaymentDetail.colNames[JspBankpoPaymentDetail.JSP_PAYMENT_AMOUNT]%>.value;                                       
        x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);  
        document.frmbankpopaymentdetail.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT]%>.value= formatFloat(parseFloat(x), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        document.frmbankpopaymentdetail.<%=JspBankpoPaymentDetail.colNames[JspBankpoPaymentDetail.JSP_PAYMENT_AMOUNT]%>.value= formatFloat(parseFloat(x), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    
    function cmdPrintJournal(){	                       
        window.open("<%=printroot%>.report.RptPoPayment?user_id=<%=appSessUser.getUserOID()%>&bankpopayment_id=<%=oidBankpoPayment%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
        }
        
        //-------------- script form image -------------------
        
        function cmdDelPict(oidBankpopaymentDetail){
            document.frmimage.hidden_bankpopayment_detail_id.value=oidBankpopaymentDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="bankpayment.jsp";
            document.frmimage.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
                                                        <form name="frmbankpopaymentdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_bankpopayment_detail_id" value="<%=oidBankpopaymentDetail%>">
                                                            <input type="hidden" name="hidden_bankpopayment_id" value="<%=oidBankpoPayment%>">
                                                            <input type="hidden" name="<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_TYPE]%>" value="<%=DbBankpoPayment.TYPE_PEMBAYARAN_BANK%>">                                                            
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                                                            <input type="hidden" name="pcash_balance" value="">
                                                            <input type="hidden" name="hidden_vendor_id" value="<%=vendorId%>">
                                                            <input type="hidden" name="hidden_bankpopayment_induk_id" value="<%=oidBankpoPaymentInduk%>">                                                            
                                                            <input type="hidden" name="hidden_amount_hutang" value="<%=amountHutang%>">  
                                                            <input type="hidden" name="hidden_uniq_id" value="<%=uniqId%>">  
                                                            <input type="hidden" name="hidden_uniq_detail_id" value="<%=uniqDetailId%>">  
                                                            <input type="hidden" name="first_load" value="<%=1%>">
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4" height="10"></td>
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td colspan="4" height="10">
                                                                                                <table width="880" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td width="130" nowrap></td>                                                                                                                    
                                                                                                        <td width="5" nowrap></td>
                                                                                                        <td width="400" nowrap></td>
                                                                                                        <td width="130" nowrap></td>
                                                                                                        <td width="5" nowrap></td>
                                                                                                        <td nowrap></td>
                                                                                                    </tr>    
                                                                                                    <tr height="22">                                                                                                        
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[4]%></td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td class="fontarial">
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

    int counterJournal = DbSystemDocNumber.getNextCounterBkk(open.getOID());
    strNumber = DbSystemDocNumber.getNextNumberBkk(counterJournal, open.getOID()) + "P";
    
    if ((bankpoPayment.getOID() != 0 || oidBankpoPayment != 0) && isSave == false) {
        if (countx == 0) {
            strNumber = bankpoPayment.getJournalNumber() + "P";
        } else {
            strNumber = bankpoPayment.getJournalNumber() + "P" + (countx + 1);
        }
    } else {
        strNumber = bankpoPayment.getJournalNumber();
    }

                                                                                                            %> 
                                                                                                            <b><%=strNumber%></b> 
                                                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_NUMBER]%>">
                                                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_COUNTER]%>">
                                                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_PREFIX]%>">
                                                                                                        </td>
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;
                                                                                                            <%if (periods.size() > 1) {%>
                                                                                                            <%=langCT[14]%>
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >    
                                                                                                            <%if (periods.size() > 1) {%>
                                                                                                            <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PERIODE_ID]%>" class="fontarial">
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
                                                                                                        </td>                                                                                                       
                                                                                                    </tr>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[0]%></td>    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_COA_ID]%>">
                                                                                                                <%if (accLinks != null && accLinks.size() > 0) {
        for (int i = 0; i < accLinks.size(); i++) {
            AccLink accLink = (AccLink) accLinks.get(i);
            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(accLink.getCoaId());
            } catch (Exception e) {
                System.out.println("[exception]" + e.toString());
            }
                                                                                                                %>
                                                                                                                <option <%if (bankpoPayment.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                <%=getAccountRecursif(coa.getLevel() * -1, coa, bankpoPayment.getCoaId(), isPostableOnly)%> 
                                                                                                                <%}
} else {%>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_COA_ID) %> 
                                                                                                        </td>
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[5]%></td>    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td nowrap>
                                                                                                            <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getTransDate() == null) ? new Date() : bankpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_TRANS_DATE) %> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
    String ref_number = "";
    long kasbonId = 0;
                                                                                                    %>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly size="15"></td>                                                                                                        
                                                                                                        <%if (false) {%>
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[17]%></td>      
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">                                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input size="20" type="text" name="referensi_number" value="<%=ref_number%>" class="fontarial">
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <input type="hidden" name="kasbon_id" value="<%=kasbonId%>">
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;<a href="javascript:cmdKasbon()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>     
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[15]%></td>                                                                                                        
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <%
    Vector vpm = DbPaymentMethod.list(0, 0, "", "");
                                                                                                            %>
                                                                                                            <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>" onChange="javascript:isBG()">
                                                                                                                <option value="<%=0%>" <%if (0 == bankpoPayment.getPaymentMethodId()) {%>selected<%}%>>- Select Payment -</option>
                                                                                                                <%if (vpm != null && vpm.size() > 0) {
        for (int i = 0; i < vpm.size(); i++) {
            PaymentMethod pm = (PaymentMethod) vpm.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=pm.getOID()%>" <%if (pm.getOID() == bankpoPayment.getPaymentMethodId()) {%>selected<%}%>><%=pm.getDescription()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>    
                                                                                                            <font class="fontarial" color="FF0000"><i><%=msgPayment%></i></font>
                                                                                                        </td>
                                                                                                        <td ></td>     
                                                                                                        <td ></td>
                                                                                                        <td ></td>                                                                                                         
                                                                                                    </tr>
                                                                                                    <tr id="inpBg" height="22"> 
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;Due Date BG</td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_DUE_DATE_BG] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getDueDateBG() == null) ? new Date() : bankpoPayment.getDueDateBG(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_DUE_DATE_BG] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_DUE_DATE_BG) %> 
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell1" nowrap>&nbsp;&nbsp;<%=langCT[16]%></td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_REF_NUMBER] %>"  value="<%= bankpoPayment.getRefNumber() %>" class="formElemen">
                                                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_REF_NUMBER) %> 
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr class="tablecell1" height="22">
                                                                                                                    <td>&nbsp;&nbsp;<%=langCT[2]%></td>
                                                                                                                </tr>     
                                                                                                            </table>        
                                                                                                        </td>
                                                                                                        <td class="fontarial" valign="top">:</td>
                                                                                                        <td valign="top"> 
                                                                                                            <textarea name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_MEMO]%>" cols="40" rows="3"><%=bankpoPayment.getMemo()%></textarea>
                                                                                                        </td>
                                                                                                        <td colspan="3" valign="top">
                                                                                                            <%
    if (segments != null && segments.size() > 0) {
        for (int i = 0; i < segments.size(); i++) {
            Segment segment = (Segment) segments.get(i);

            String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + segment.getOID();

            switch (i + 1) {
                case 1:
                    //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                    //maka akan di tampikan sesuai dengan segment yang ditentukan
                    if (user.getSegment1Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment1Id();
                    }
                    break;
                case 2:
                    if (user.getSegment2Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment2Id();
                    }
                    break;
                case 3:
                    if (user.getSegment3Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment3Id();
                    }
                    break;
                case 4:
                    if (user.getSegment4Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment4Id();
                    }
                    break;
                case 5:
                    if (user.getSegment5Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment5Id();
                    }
                    break;
                case 6:
                    if (user.getSegment6Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment6Id();
                    }
                    break;
                case 7:
                    if (user.getSegment7Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment7Id();
                    }
                    break;
                case 8:
                    if (user.getSegment8Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment8Id();
                    }
                    break;
                case 9:
                    if (user.getSegment9Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment9Id();
                    }
                    break;
                case 10:
                    if (user.getSegment10Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment10Id();
                    }
                    break;
                case 11:
                    if (user.getSegment11Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment11Id();
                    }
                    break;
                case 12:
                    if (user.getSegment12Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment12Id();
                    }
                    break;
                case 13:
                    if (user.getSegment13Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment13Id();
                    }
                    break;
                case 14:
                    if (user.getSegment14Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment14Id();
                    }
                    break;
                case 15:
                    if (user.getSegment15Id() != 0) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment15Id();
                    }
                    break;
            }

            Vector sgDetails = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);

                                                                                                            %>
                                                                                                            <table border="0" cellpadding="0" cellspacing="1">      
                                                                                                                <%if (i == 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr> 
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" class="fontarial"><B><i>Segmen :</i></B></td>
                                                                                                                </tr>    
                                                                                                                <%}%>
                                                                                                                <tr height="23"> 
                                                                                                                    <td width="130" class="tablecell1">&nbsp;&nbsp;<%=segment.getName()%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                                            <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                        for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                            SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                            String selected = "";
                                                                                                                            switch (i + 1) {
                                                                                                                                case 1:
                                                                                                                                    if (bankpoPayment.getSegment1Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 2:
                                                                                                                                    if (bankpoPayment.getSegment2Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 3:
                                                                                                                                    if (bankpoPayment.getSegment3Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 4:
                                                                                                                                    if (bankpoPayment.getSegment4Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 5:
                                                                                                                                    if (bankpoPayment.getSegment5Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 6:
                                                                                                                                    if (bankpoPayment.getSegment6Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 7:
                                                                                                                                    if (bankpoPayment.getSegment7Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 8:
                                                                                                                                    if (bankpoPayment.getSegment8Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 9:
                                                                                                                                    if (bankpoPayment.getSegment9Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 10:
                                                                                                                                    if (bankpoPayment.getSegment10Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 11:
                                                                                                                                    if (bankpoPayment.getSegment11Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 12:
                                                                                                                                    if (bankpoPayment.getSegment12Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 13:
                                                                                                                                    if (bankpoPayment.getSegment13Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 14:
                                                                                                                                    if (bankpoPayment.getSegment14Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 15:
                                                                                                                                    if (bankpoPayment.getSegment5Id() == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                }
                                                                                                                            if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                selected = "";
                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                                                            <%}
                                                                                                                    }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr> 
                                                                                                            </table>
                                                                                                            <%
        }
    }
                                                                                                            %> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="5" colspan="6"></td>
                                                                                                    </tr>    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="1">                                                                                                                                                                                          
                                                                                                    <tr> 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="100%" class="page"> 
                                                                                                                                    <table width="1160" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="6">
                                                                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                                                                    <tr> 
                                                                                                                                                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="28"> 
                                                                                                                                            <td class="tablehdr" width="180" height="20">Segmen</td>
                                                                                                                                            <td class="tablehdr" width="220" height="20"><%=langCT[7]%></td>
                                                                                                                                            <td class="tablehdr" width="150" height="20">Hutang</td>
                                                                                                                                            <td class="tablehdr" width="150" height="20">Terbayar</td>
                                                                                                                                            <td class="tablehdr" width="150" height="20"><%=langCT[1]%> IDR</td>
                                                                                                                                            <td class="tablehdr" height="20"><%=langCT[8]%></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="28"> 
                                                                                                                                            <td class="tablecell">
                                                                                                                                                <%
    if (segments != null && segments.size() > 0) {
        for (int i = 0; i < segments.size(); i++) {
            Segment segment = (Segment) segments.get(i);

            String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + segment.getOID();

            switch (i + 1) {
                case 1:
                    //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                    //maka akan di tampikan sesuai dengan segment yang ditentukan
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment1Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment1Id();
                    }
                    break;
                case 2:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment2Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment2Id();
                    }
                    break;
                case 3:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment3Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment3Id();
                    }
                    break;
                case 4:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment3Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment3Id();
                    }
                    break;
                case 5:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment5Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment5Id();
                    }
                    break;
                case 6:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment6Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment6Id();
                    }
                    break;
                case 7:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment7Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment7Id();
                    }
                    break;
                case 8:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment8Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment8Id();
                    }
                    break;
                case 9:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment9Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment9Id();
                    }
                    break;
                case 10:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment10Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment10Id();
                    }
                    break;
                case 11:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment11Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment11Id();
                    }
                    break;
                case 12:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment12Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment12Id();
                    }
                    break;
                case 13:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment13Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment13Id();
                    }
                    break;
                case 14:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment14Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment14Id();
                    }
                    break;
                case 15:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPayment.getSegment15Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankpoPaymentDetail.getSegment15Id();
                    }
                    break;
            }

            Vector sgDetails = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);

                                                                                                                                                %>
                                                                                                                                                <table border="0" bgcolor="#F3F3F3">                                                                                                                                                    
                                                                                                                                                    <tr> 
                                                                                                                                                        <td style="padding:3px;" class="fontarial"><%=segment.getName()%></td>
                                                                                                                                                        <td > 
                                                                                                                                                            <select name="JSP_SEGMENT<%=i + 1%>_DETAIL_ID" class="fontarial">
                                                                                                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                                                            for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                                                SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                                                String selected = "";
                                                                                                                                                                switch (i + 1) {
                                                                                                                                                                    case 1:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment1Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }

                                                                                                                                                                        break;
                                                                                                                                                                    case 2:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment2Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 3:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment3Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 4:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment4Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 5:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 6:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment6Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 7:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment7Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 8:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment8Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 9:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment9Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 10:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment10Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 11:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment11Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 12:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment12Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 13:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment13Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 14:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment14Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                    case 15:
                                                                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                                                                            if (bankpoPayment.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        } else {
                                                                                                                                                                            if (bankpoPaymentDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                                selected = "selected";
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                        break;
                                                                                                                                                                }
                                                                                                                                                                %>
                                                                                                                                                                <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                                                                                                <%}
                                                                                                                                                        }%>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                </table>
                                                                                                                                                <%}
    }%>
                                                                                                                                            </td>    
                                                                                                                                            <td class="tablecell" style="padding:3px;">                                                                                                                                             
                                                                                                                                                <%

    if (iJSPCommand == JSPCommand.NONE) {
        coaSuspense = bankpoPayment.getCoaId();
    }

    Coa objCoaSuspense = new Coa();
    try {
        objCoaSuspense = DbCoa.fetchExc(coaSuspense);
    } catch (Exception e) {
    }
                                                                                                                                                %>   
                                                                                                                                                <input type="hidden" name="hidden_coa_suspense" value="<%=coaSuspense%>">
                                                                                                                                                <input type="hidden" name="<%=jspBankpoPaymentDetaill.colNames[jspBankpoPaymentDetaill.JSP_COA_ID]%>" value="<%=coaSuspense%>">
                                                                                                                                                <%=objCoaSuspense.getCode()%>&nbsp;-&nbsp; <%=objCoaSuspense.getName()%>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                            
                                                                                                                                            <td class="tablecell" style="padding:3px">
                                                                                                                                                <input type="text" size="20" name="total_hutang" value="<%=JSPFormater.formatNumber(amountHutang, "###,###.##")%>" style="text-align:right" readonly class="readOnly">
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell" style="padding:3px">
                                                                                                                                                <input type="text" size="20" name="total_hutang" value="<%=JSPFormater.formatNumber(payment, "###,###.##")%>" style="text-align:right" readonly class="readOnly">
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell" align="right" style="padding:3px">
                                                                                                                                                <input type="text" size="20" name="<%=jspBankpoPaymentDetaill.colNames[jspBankpoPaymentDetaill.JSP_PAYMENT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "###,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdate()">                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                            <%
    String notes = "";
    if (iJSPCommand == JSPCommand.NONE) {
        notes = bankpoPayment.getMemo();
    } else {
        notes = bankpoPaymentDetail.getMemo();
    }
                                                                                                                                            %>
                                                                                                                                            
                                                                                                                                            <input type="hidden" name="<%=jspBankpoPaymentDetaill.colNames[jspBankpoPaymentDetaill.JSP_MEMO]%>" value="<%=notes%>">
                                                                                                                                            <td class="tablecell" style="padding:3px"><%=notes%></td>
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
                                                                                                    <tr id="command_line"> 
                                                                                                        <td colspan="5"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="78%">&nbsp;</td>
                                                                                                                    <td width="22%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="78%">&nbsp; </td>
                                                                                                                    <td class="boxed1" width="22%"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td width="36%" class="fontarial"> 
                                                                                                                                    <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                                                                                </td>
                                                                                                                                <td width="64%" class="fontarial"> 
                                                                                                                                    <div align="right"><b>                                                                                                                                            
                                                                                                                                            <input type="hidden" name="total_detail" value="<%=bankpoPayment.getAmount()%>">
                                                                                                                                    <%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%></b></div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (msgErr.length() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                    <td width="170" nowrap><%=msgErr%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>                                                                                                   
                                                                                                    <%if (bankpoPayment.getStatus().compareTo(DbBankpoPayment.STATUS_PAID) == 0 && bankpoPayment.getOID() != 0) {%>
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
                                                                                                                    <td width="8%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/back2.gif',1)"><img src="../images/back.gif" name="post" height="22" border="0"></a></td>
                                                                                                                    <td width="68%"> 
                                                                                                                        <a href="javascript:cmdPrintJournal('<%=bankpoPayment.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                    </td>
                                                                                                                    <td width="24%"> 
                                                                                                                        <div align="right" class="msgnextaction"> 
                                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="info" width="170" align="right">
                                                                                                                                <tr> 
                                                                                                                                    <td width="8"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                                                                                    <td nowrap><%=langCT[11]%></td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if ((bankpoPayment.getOID() != 0 && bankpoPayment.getStatus().compareTo(DbBankpoPayment.STATUS_PAID) != 0) || (msgErr.length() > 0 && bankpoPayment.getStatus().compareTo(DbBankpoPayment.STATUS_PAID) != 0) && countUniq==0 && countUniqDetail==0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5"> 
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <%if (privUpdate || privAdd) {%>
                                                                                                                    <td width="120">
                                                                                                                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="new1" border="0"></a>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <td >
                                                                                                                        <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
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
                                                            </table>
                                                            <%} catch (Exception e) {
            //out.println(e.toString());
            }%>
                                                            <script language="JavaScript">
                                                                if(document.frmbankpopaymentdetail.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>.value == '<%=oidBG%>' ||  document.frmbankpopaymentdetail.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>.value == '<%=oidCheckPending%>'){
                                                                    document.all.inpBg.style.display="";
                                                                }else{                    
                                                                document.all.inpBg.style.display="none";
                                                            }
                                                            </script>
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
                            <td height="25"> <!-- #BeginEditable "footer" --> 
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
