
<%-- 
    Document   : cardrelease
    Created on : Mar 4, 2015, 11:47:05 AM
    Author     : Roy
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
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            /*** LANG ***/
            String[] langCT = {"Search for", "Journal Number", "Vendor", "Release Date", "to", "Transaction Date", "Ignore", //0-6
                "Cash Receipt", "Journal Number", "Receipt to Account", "Receipt from", "Amount IDR", "Transaction Date", "Memo", //7-13
                "Petty Cash Payment", "Journal Number", "Payment from Account", "Amount IDR", "Transaction Date", "Memo", "Activity", //14-20
                "Petty Cash Replenishment", "Journal Number", "Replenishment for Account", "From Account", "Amount IDR", "Transaction Date", "Memo", //21-27
                "Please click on the search button to find your data", "List is empty", "Post Status", "Process" //28-30
            };

            String[] langNav = {"Bank Transaction", "Reconsile Credit Card", "Date", "Cash Receipt", "Payment Petty Cash", "Replenishment Petty Cash", "Searching Parameter", "Period", "BG Number", "Location"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Suplier", "Tanggal Pencairan", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Penerimaan Tunai", "Nomor Jurnal", "Perkiraan Penerimaan", "Diterima dari", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //7-13
                    "Pelunasan Kas Tunai", "Nomor Jurnal", "Pelunasan dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", "Kegiatan", //14-20
                    "Pengisian Kembali Kas Kecil", "Nomor Jurnal", "Pengisian Kembali untuk Perkiraan", "Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //21-27
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data", "Post Status", "Proses" //28-30
                };
                langCT = langID;

                String[] navID = {"Transaksi Bank", "Reconsile Kartu Credit", "Tanggal", "Penerimaan Tunai", "Pelunasan Kas Tunai", "Pengisian Kembali Kas Kecil", "Parameter Pencarian", "Periode", "Nomor BG", "Lokasi"};
                langNav = navID;
            }

            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpopayment_id");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");
            String jurnalNumber = JSPRequestValue.requestString(request, "jurnal_number");
            String strStartDate = JSPRequestValue.requestString(request, "start_date");
            String strEndDate = JSPRequestValue.requestString(request, "end_date");
            String strTransactionDate = JSPRequestValue.requestString(request, "transaction_date");
            int ignoreInputDate = JSPRequestValue.requestInt(request, "ignore_input_date");
            int ignoreTransDate = JSPRequestValue.requestInt(request, "ignore_trans_date");
            long segment1Oid = JSPRequestValue.requestLong(request, "segment1");
            long bankId = JSPRequestValue.requestLong(request, "bank_id");
            int status = JSPRequestValue.requestInt(request, "status");
            long bankSelectId = JSPRequestValue.requestLong(request, "bank_select_id");
            int typeBank = JSPRequestValue.requestInt(request, "type_bank");

            long oidOffice = 0;
            try {
                oidOffice = Long.parseLong(DbSystemProperty.getValueByName("OID_SEGMENT_OFFICE"));
            } catch (Exception e) {
            }

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();

            Date selectDate = new Date();

            String strSelectDate = JSPRequestValue.requestString(request, "trans_date_select");
            if (strStartDate.length() > 0) {
                selectDate = JSPFormater.formatDate(strSelectDate, "dd/MM/yyyy");
            }

            if (strStartDate.length() > 0) {
                startDate = JSPFormater.formatDate(strStartDate, "dd/MM/yyyy");
            }

            if (strEndDate.length() > 0) {
                endDate = JSPFormater.formatDate(strEndDate, "dd/MM/yyyy");
            }

            if (strTransactionDate.length() > 0) {
                transDate = JSPFormater.formatDate(strTransactionDate, "dd/MM/yyyy");
            }

            int recordToGet = 0;
            String msgString = "";
            String whereClause = "";
            String orderClause = "";

            CmdBankPayment cmdBankPayment = new CmdBankPayment(request);
            JSPLine jspLine = new JSPLine();
            Vector listBankPayment = new Vector(1, 1);

            if (iCommand == JSPCommand.NONE || iCommand == JSPCommand.BACK) {
                ignoreTransDate = 1;
                ignoreInputDate = 1;
                typeBank = -1;
            }

            if (typeBank == -1) {
                whereClause = DbBankPayment.colNames[DbBankPayment.COL_TYPE] + " in (" + DbBankPayment.TYPE_CARD_CREDIT + "," + DbBankPayment.TYPE_CARD_DEBIT + ") ";
            } else {
                whereClause = DbBankPayment.colNames[DbBankPayment.COL_TYPE] + " = " + typeBank;
            }

            msgString = cmdBankPayment.getMessage();
            int vectSize = 0;

            if (iCommand != JSPCommand.NONE) {

                if (segment1Oid != 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_SEGMENT1_ID] + " = '" + segment1Oid + "'";
                }


                if (ignoreTransDate == 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_TRANSACTION_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
                }

                if (bankId != 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_BANK_ID] + " = '" + bankId + "' ";
                }

                if (status != -1) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_STATUS] + " = '" + status + "' ";
                }

                if (jurnalNumber.length() > 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_JOURNAL_NUMBER] + " like '%" + jurnalNumber + "%' ";
                }

                if (periodeId != 0) {
                    Periode periode = new Periode();
                    try {
                        periode = DbPeriode.fetchExc(periodeId);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_TRANSACTION_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                }

                if (ignoreInputDate == 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + DbBankPayment.colNames[DbBankPayment.COL_DUE_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";
                }
            }

            if (iCommand != JSPCommand.NONE) {
                vectSize = DbBankPayment.getCount(whereClause);
            }

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdBankPayment.actionList(iCommand, start, vectSize, recordToGet);
            }

            if (iCommand != JSPCommand.NONE) {

                listBankPayment = DbBankPayment.list(start, recordToGet, whereClause, orderClause);
                if (iCommand == JSPCommand.POST) {
                    if (listBankPayment != null && listBankPayment.size() > 0) {

                        boolean glOk = false;
                        ExchangeRate er = DbExchangeRate.getStandardRate();

                        Periode p = new Periode();
                        try {
                            p = DbPeriode.getPeriodByTransDate(selectDate);
                        } catch (Exception e) {
                        }

                        long oid = 0;
                        long oidDoc = 0;


                        if (p.getOID() != 0 && p.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_CLOSED) != 0) {

                            //pengecekan coa, jangan sampai ada yang header bisa diposting
                            boolean cek = true;
                            if (bankSelectId == 0) {
                                for (int i = 0; i < listBankPayment.size(); i++) {
                                    BankPayment bp = (BankPayment) listBankPayment.get(i);
                                    int selected = JSPRequestValue.requestInt(request, "selected" + bp.getOID());
                                    long coaPaymentId = JSPRequestValue.requestLong(request, "coa_release" + bp.getOID());

                                    if (selected == 1) {
                                        try {
                                            Coa c = new Coa();
                                            try {
                                                c = DbCoa.fetchExc(coaPaymentId);
                                            } catch (Exception e) {
                                            }
                                            if (c.getOID() == 0 || c.getStatus().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                                                cek = false;
                                            }
                                        } catch (Exception e) {
                                            cek = false;
                                        }
                                    }
                                }

                            } else {
                                try {
                                    Coa c = new Coa();
                                    try {
                                        c = DbCoa.fetchExc(bankSelectId);
                                    } catch (Exception e) {
                                    }
                                    if (c.getOID() == 0 || c.getStatus().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                                        cek = false;
                                    }
                                } catch (Exception e) {
                                    cek = false;
                                }
                            }

                            if (cek == true) {
                                String journalNumber = "";
                                
                                for (int i = 0; i < listBankPayment.size(); i++) {
                                    BankPayment bp = (BankPayment) listBankPayment.get(i);
                                    int selected = JSPRequestValue.requestInt(request, "selected" + bp.getOID());

                                    if (selected == 1) {

                                        if (glOk == false) {

                                            BankPayment bpCek = new BankPayment();
                                            try {
                                                bpCek = DbBankPayment.fetchExc(bp.getOID());
                                            } catch (Exception e) {
                                            }

                                            if (bpCek.getStatus() != DbBankPayment.STATUS_PAID) {

                                                Date dt = new Date();
                                                int periodeTaken = 0;

                                                try {
                                                    periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                                                } catch (Exception e) {
                                                }

                                                if (periodeTaken == 0) {
                                                    dt = p.getStartDate();  // untuk mendapatkan periode yang aktif
                                                } else if (periodeTaken == 1) {
                                                    dt = p.getEndDate();  // untuk mendapatkan periode yang aktif}
                                                }

                                                long oidRp = 0;
                                                try {
                                                    oidRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                                } catch (Exception e) {
                                                }

                                                String formatDocCode = DbSystemDocNumber.getNumberPrefix(p.getOID(), DbSystemDocCode.TYPE_DOCUMENT_RECONCILE_CARD);
                                                int counter = DbSystemDocNumber.getNextCounter(p.getOID(), DbSystemDocCode.TYPE_DOCUMENT_RECONCILE_CARD);

                                                // proses untuk object ke general penanpungan code
                                                SystemDocNumber systemDocNumber = new SystemDocNumber();
                                                systemDocNumber.setCounter(counter);
                                                systemDocNumber.setDate(new Date());
                                                systemDocNumber.setPrefixNumber(formatDocCode);
                                                systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_RECONCILE_CARD]);
                                                systemDocNumber.setYear(dt.getYear() + 1900);

                                                journalNumber = DbSystemDocNumber.getNextNumber(counter, p.getOID(), DbSystemDocCode.TYPE_DOCUMENT_RECONCILE_CARD);
                                                systemDocNumber.setDocNumber(journalNumber);

                                                oid = DbGl.postJournalMain(p.getTableName(), oidRp, new Date(), counter, journalNumber, formatDocCode,
                                                        I_Project.JOURNAL_TYPE_PIUTANG_CARD,
                                                        "Pencairan Piutang kartu credit", user.getOID(),
                                                        "", 0, "", selectDate, p.getOID());
                                                
                                                if(oid != 0){
                                                    oidDoc = 0;
                                                    try {
                                                        oidDoc = DbSystemDocNumber.insertExc(systemDocNumber);
                                                    } catch (Exception E) {
                                                        System.out.println("[exception] " + E.toString());
                                                    }
                                                }
                                            }
                                            glOk = true;
                                        }


                                        long coaPaymentId = JSPRequestValue.requestLong(request, "coa_release" + bp.getOID());
                                        if (bankSelectId != 0) {
                                            coaPaymentId = bankSelectId;
                                        }

                                        Coa c = new Coa();
                                        try {
                                            c = DbCoa.fetchExc(coaPaymentId);
                                        } catch (Exception e) {
                                        }
                                        long oidHistory = 0;
                                        
                                        if(oid != 0){
                                            BankPaymentHistory bph = new BankPaymentHistory();
                                            bph.setBankPaymentId(bp.getOID());
                                            bph.setGlId(oid);
                                            bph.setJournalNumber(journalNumber);
                                            bph.setDate(new Date());
                                            bph.setType(0);                                        
                                            try{
                                                oidHistory = DbBankPaymentHistory.insertExc(bph);
                                            }catch(Exception e){}
                                        }

                                        if (oidHistory !=0 && c.getOID() != 0 && c.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE) && (p.getOID() != 0 && p.getStatus().compareToIgnoreCase("Closed") != 0)) {

                                            if (oid != 0) {
                                                if (oidOffice == 0) {
                                                    oidOffice = bp.getSegment1Id();
                                                }

                                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), c.getOID(), 0, bp.getAmount(),
                                                        bp.getAmount(), sysCompany.getBookingCurrencyId(), oid, "Pencairan piutang kartu credit", 0,
                                                        oidOffice, bp.getSegment2Id(), bp.getSegment3Id(), bp.getSegment4Id(),
                                                        0, 0, 0, 0,
                                                        0, 0, 0, 0,
                                                        0, 0, 0, 0);

                                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), bp.getCoaId(), bp.getAmount(), 0,
                                                        bp.getAmount(), sysCompany.getBookingCurrencyId(), oid, "Pencairan piutang kartu credit", 0,
                                                        bp.getSegment1Id(), bp.getSegment2Id(), bp.getSegment3Id(), bp.getSegment4Id(),
                                                        0, 0, 0, 0,
                                                        0, 0, 0, 0,
                                                        0, 0, 0, 0);

                                                bp.setStatus(DbBankPayment.STATUS_PAID);
                                                bp.setCoaPaymentId(c.getOID());
                                                bp.setPaymentDate(selectDate);
                                                bp.setSystemDocNumberId(oidDoc);
                                                try {
                                                    DbBankPayment.updateExc(bp);
                                                } catch (Exception e) {
                                                }
                                            }
                                        }
                                    }
                                }
                                if (oid != 0) {
                                    SessOptimizedJournal.optimizeJournalGl(p, oid, "Pencairan ", "Pencairan ", 1);                                    
                                }
                            }
                            listBankPayment = DbBankPayment.list(start, recordToGet, whereClause, orderClause);
                        }
                    }
                }
            }
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_DEBET + "'", "");
            Vector banks = DbBank.list(0, 0, "", DbBank.colNames[DbBank.COL_NAME]);
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
                document.frmbankpayment.start.value="0";	
            }
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listBankPayment.size(); k++) {
                BankPayment pp = (BankPayment) listBankPayment.get(k);
                %>
                    document.frmbankpayment.selected<%=pp.getOID()%>.checked=val.checked;
                   <%
            }%>
            setCalc();
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
    
    function setCalc(){            
        var t = 0;
                 <%
            for (int k = 0; k < listBankPayment.size(); k++) {
                BankPayment pp = (BankPayment) listBankPayment.get(k);
                %>
                    if(document.frmbankpayment.selected<%=pp.getOID()%>.checked==true){
                        var x = document.frmbankpayment.amount<%=pp.getOID()%>.value;                                       
                        x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);                     
                        t = parseFloat(t) + parseFloat(x);
                    }
                   <%
            }%>
            document.frmbankpayment.tot.value=formatFloat(t, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        }
        
        function cmdPost(){
            document.frmbankpayment.start.value="0";	
            document.frmbankpayment.command.value="<%=JSPCommand.POST%>";
            document.frmbankpayment.prev_command.value="<%=prevCommand%>";
            document.frmbankpayment.action="cardrelease.jsp";
            document.frmbankpayment.submit();
        }
        
        function cmdSearch(){
            document.frmbankpayment.start.value="0";	
            document.frmbankpayment.command.value="<%=JSPCommand.SEARCH%>";
            document.frmbankpayment.prev_command.value="<%=prevCommand%>";
            document.frmbankpayment.action="cardrelease.jsp";
            document.frmbankpayment.submit();
        }
        
        
        function cmdListFirst(){
            document.frmbankpayment.command.value="<%=JSPCommand.FIRST%>";
            document.frmbankpayment.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmbankpayment.action="cardrelease.jsp";
            document.frmbankpayment.submit();
        }
        
        function cmdListPrev(){
            document.frmbankpayment.command.value="<%=JSPCommand.PREV%>";
            document.frmbankpayment.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmbankpayment.action="cardrelease.jsp";
            document.frmbankpayment.submit();
        }
        
        function cmdListNext(){
            document.frmbankpayment.command.value="<%=JSPCommand.NEXT%>";
            document.frmbankpayment.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmbankpayment.action="cardrelease.jsp";
            document.frmbankpayment.submit();
        }
        
        function cmdListLast(){
            document.frmbankpayment.command.value="<%=JSPCommand.LAST%>";
            document.frmbankpayment.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmbankpayment.action="bankpayment_release.jsp";
            document.frmbankpayment.submit();
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
                                                        <form name="frmbankpayment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_bankpopayment_id" value="<%=oidBankpoPayment%>">
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
                                                                                                <table width="840" border="0" cellspacing="1" cellpadding="2">                                                                                                    
                                                                                                    <tr>
                                                                                                        <td colspan="4" height="5"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td colspan="3"><b><i><%=langNav[6]%> :</i></b></td>                                                                                                                    
                                                                                                    </tr>    
                                                                                                    <tr height="23">                                                                                                                    
                                                                                                        <td width="13%" class="tablecell1">&nbsp;&nbsp;<%=langCT[1]%></td>
                                                                                                        <td with="2" class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="jurnal_number"  value="<%=jurnalNumber%>" size="22"></td>
                                                                                                        <td width="15%" class="tablecell1">&nbsp;&nbsp;<%=langCT[3]%></td>
                                                                                                        <td width="350">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="start_date" value="<%=JSPFormater.formatDate((startDate == null ? new Date() : startDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpayment.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> &nbsp;&nbsp;<%=langCT[4]%>&nbsp;&nbsp;</td>
                                                                                                                    <td><input name="end_date" value="<%=JSPFormater.formatDate((endDate == null ? new Date() : endDate), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpayment.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td><input name="ignore_input_date" type="checkBox" class="formElemen"  value="1" <%if (ignoreInputDate == 1) {%>checked<%}%>></td>
                                                                                                                    <td><%=langCT[6]%></td>
                                                                                                                </tr>
                                                                                                            </table>      
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23">                                                                                                                    
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langNav[7]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <select name="periode_id" class=fontarial"">                                                                                                                
                                                                                                                <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

                                                                                                                %>
                                                                                                                <option value ="0" <%if (periodeId == 0) {%>selected<%}%>>- All Period -</option>
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
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="transaction_date" value="<%=JSPFormater.formatDate((transDate == null ? new Date() : transDate), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpayment.transaction_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                    <input name="ignore_trans_date" type="checkBox" class="formElemen"  value="1" <%if (ignoreTransDate == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td>
                                                                                                                        <%=langCT[6]%>
                                                                                                                    </td>    
                                                                                                                </tr>
                                                                                                            </table>  
                                                                                                        </td>
                                                                                                    </tr> 
                                                                                                    <%
            Vector segment1 = DbSegment.list(0, 1, DbSegment.colNames[DbSegment.COL_COUNT] + " = 1", null);
            Vector segmentDetail = new Vector();
            if (segment1 != null && segment1.size() > 0) {
                try {

                    Segment s = (Segment) segment1.get(0);
                    if (s.getOID() != 0) {
                        segmentDetail = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + s.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);
                    }
                } catch (Exception e) {
                }
            }
                                                                                                    %>
                                                                                                    <tr height="23">
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;Bank</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="bank_id" class=fontarial"">                                                                                                                
                                                                                                                <option value ="0" <%if (bankId == 0) {%>selected<%}%>>- All Bank -</option>                                                                                                                
                                                                                                                <%
            if (banks != null && banks.size() > 0) {
                for (int j = 0; j < banks.size(); j++) {
                    Bank b = (Bank) banks.get(j);
                                                                                                                %>
                                                                                                                <option value ="<%=b.getOID()%>" <%if (b.getOID() == bankId) {%>selected<%}%>><%=b.getName()%></option>                                                                                                                
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langNav[9]%></td>
                                                                                                        <td >
                                                                                                            <select name="segment1" class=fontarial""> 
                                                                                                                <option value="0" >- All Location -</option>
                                                                                                                <%
            if (segmentDetail != null && segmentDetail.size() > 0) {
                for (int i = 0; i < segmentDetail.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) segmentDetail.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=sd.getOID()%>" <%if (segment1Oid == sd.getOID()) {%> selected<%}%> ><%=sd.getName()%></option>
                                                                                                                <%
                }
            }
                                                                                                                %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23">
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;Status</td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="status" class=fontarial"">                                                                                                                
                                                                                                                <option value ="-1" <%if (status == -1) {%>selected<%}%>>- All Status -</option>                                                                                                                
                                                                                                                <option value ="<%=DbBankPayment.STATUS_NOT_PAID%>" <%if (status == DbBankPayment.STATUS_NOT_PAID) {%>selected<%}%>>Not Paid</option>                                                                                                                
                                                                                                                <option value ="<%=DbBankPayment.STATUS_PAID%>" <%if (status == DbBankPayment.STATUS_PAID) {%>selected<%}%>>Paid</option>                                                                                                                
                                                                                                            </select>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="tablecell1">&nbsp;&nbsp;Type</td>
                                                                                                        <td >
                                                                                                            <select name="type_bank" class=fontarial"">                                                                                                                
                                                                                                                <option value ="-1" <%if (typeBank == -1) {%>selected<%}%>>- All Status -</option>                                                                                                                
                                                                                                                <option value ="<%=DbBankPayment.TYPE_CARD_CREDIT%>" <%if (typeBank == DbBankPayment.TYPE_CARD_CREDIT) {%>selected<%}%>>Credit</option>                                                                                                                
                                                                                                                <option value ="<%=DbBankPayment.TYPE_CARD_DEBIT%>" <%if (typeBank == DbBankPayment.TYPE_CARD_DEBIT) {%>selected<%}%>>Debit</option>                                                                                                                
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="6">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                              
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
                                                                                <td height="6">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (listBankPayment != null && listBankPayment.size() > 0) {
                                                                            %>                                                                            
                                                                            <tr> 
                                                                                <td height="15"></td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                                <td height="24">
                                                                                    <table>
                                                                                        <%
                                                                                if (bankId != 0) {
                                                                                    try {
                                                                                        Bank b = DbBank.fetchExc(bankId);
                                                                                        Coa c = DbCoa.fetchExc(b.getCoaARId());
                                                                                        %>
                                                                                        <tr>
                                                                                            <td>Bank Account</td>
                                                                                            <td>:</td>
                                                                                            <td>
                                                                                                <select name="bank_select_id">
                                                                                                    <option value="<%=c.getOID()%>"><%=c.getCode()%> - <%=c.getName()%></option>
                                                                                                </select>    
                                                                                            </td>    
                                                                                        </tr>    
                                                                                        <% } catch (Exception e) {
                                                                                    }
                                                                                }%>
                                                                                        <tr>
                                                                                            <td>Date Transaction</td>
                                                                                            <td>:</td>
                                                                                            <td>
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="trans_date_select" value="<%=JSPFormater.formatDate((selectDate == null ? new Date() : selectDate), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpayment.trans_date_select);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        </td>                                                                                                                      
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>    
                                                                                        </tr> 
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="10"></td>
                                                                            </tr>
                                                                            
                                                                            
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="28"> 
                                                                                            <td width="15" class="tablehdr">No.</td>
                                                                                            <td width="12%" class="tablehdr"><%=langCT[15]%></td>
                                                                                            <td width="12%" class="tablehdr">Due Date</td>                                                                                                
                                                                                            <td width="25%" class="tablehdr">Segmen</td>   
                                                                                            <td class="tablehdr"><%=langCT[16]%></td>                                                                                                                                                                                                                                                                              
                                                                                            <td width="7%" class="tablehdr">Status</td>   
                                                                                            <td width="15" class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>                                                                                                                                                                                                                                                                               
                                                                                        </tr>
                                                                                        <%
                                                                                if (listBankPayment != null && listBankPayment.size() > 0) {

                                                                                    double total = 0;

                                                                                    for (int i = 0; i < listBankPayment.size(); i++) {

                                                                                        BankPayment pp = (BankPayment) listBankPayment.get(i);

                                                                                        Coa coa = new Coa();
                                                                                        try {
                                                                                            coa = DbCoa.fetchExc(pp.getCoaId());
                                                                                        } catch (Exception e) {
                                                                                            System.out.println("[exception] " + e.toString());
                                                                                        }

                                                                                        Vendor v = new Vendor();
                                                                                        try {
                                                                                            if (pp.getVendorId() != 0) {
                                                                                                v = DbVendor.fetchExc(pp.getVendorId());
                                                                                            }
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        String style = "tablecell1";


                                                                                        String segment = "";
                                                                                        if (pp.getSegment1Id() != 0) {
                                                                                            try {
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment + " | ";
                                                                                                }
                                                                                                SegmentDetail s = DbSegmentDetail.fetchExc(pp.getSegment1Id());
                                                                                                segment = segment + "" + s.getName();
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        }

                                                                                        if (pp.getSegment2Id() != 0) {
                                                                                            try {
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment + " | ";
                                                                                                }
                                                                                                SegmentDetail s = DbSegmentDetail.fetchExc(pp.getSegment2Id());
                                                                                                segment = segment + "" + s.getName();
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        }

                                                                                        if (pp.getSegment3Id() != 0) {
                                                                                            try {
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment + " | ";
                                                                                                }
                                                                                                SegmentDetail s = DbSegmentDetail.fetchExc(pp.getSegment3Id());
                                                                                                segment = segment + "" + s.getName();
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        }

                                                                                        if (pp.getSegment4Id() != 0) {
                                                                                            try {
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment + " | ";
                                                                                                }
                                                                                                SegmentDetail s = DbSegmentDetail.fetchExc(pp.getSegment4Id());
                                                                                                segment = segment + "" + s.getName();
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        }

                                                                                        if (pp.getSegment5Id() != 0) {
                                                                                            try {
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment + " | ";
                                                                                                }
                                                                                                SegmentDetail s = DbSegmentDetail.fetchExc(pp.getSegment5Id());
                                                                                                segment = segment + "" + s.getName();
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        }

                                                                                        if (pp.getSegment6Id() != 0) {
                                                                                            try {
                                                                                                if (segment.length() > 0) {
                                                                                                    segment = segment + " | ";
                                                                                                }
                                                                                                SegmentDetail s = DbSegmentDetail.fetchExc(pp.getSegment6Id());
                                                                                                segment = segment + "" + s.getName();
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        }

                                                                                        long coaPaymentId = JSPRequestValue.requestLong(request, "coa_release" + pp.getOID());
                                                                                        String strTransDate = JSPRequestValue.requestString(request, "trans_date" + pp.getOID());
                                                                                        Date transactionDate = new Date();
                                                                                        if (pp.getPaymentDate() == null) {
                                                                                            transactionDate = JSPFormater.formatDate(strTransDate, "dd/MM/yyyy");
                                                                                        } else {
                                                                                            transactionDate = pp.getPaymentDate();
                                                                                        }
                                                                                        if (coaPaymentId != 0) {
                                                                                            pp.setCoaPaymentId(coaPaymentId);
                                                                                        }

                                                                                        String bgNumber = "";
                                                                                        if (pp.getNumber() == null) {
                                                                                            bgNumber = "";
                                                                                        } else {
                                                                                            bgNumber = pp.getNumber();
                                                                                        }

                                                                                        total = total + pp.getAmount();

                                                                                        %>
                                                                                        <tr height="23"> 
                                                                                            <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                                                                            <td class="<%=style%>" align="center"><%=pp.getJournalNumber()%></td>
                                                                                            <%if (pp.getDueDate().before(new Date())) {%>
                                                                                            <td bgcolor="#D5645B"><div align="center"><%=JSPFormater.formatDate(pp.getDueDate(), "dd MMM yyyy")%></div></td>
                                                                                            <%} else {%>
                                                                                            <td class="<%=style%>"><div align="center"><%=JSPFormater.formatDate(pp.getDueDate(), "dd MMM yyyy")%></div></td>
                                                                                            <%}%>                                                                                                                                                                                        
                                                                                            <td class="<%=style%>"><%=segment%></td>
                                                                                            <td class="<%=style%>"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <%if (pp.getStatus() == DbBankPayment.STATUS_PAID) {%>
                                                                                            <td bgcolor="#D5645B"><div align="center"><font size="1">P A I D</font></div></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="#E6AD49"><div align="center"><font size="1">-</font></div></td>
                                                                                            <%}%>
                                                                                            <td class="<%=style%>">
                                                                                                <%if (pp.getStatus() != DbBankPayment.STATUS_PAID) {%>
                                                                                                <div align="center"><input type="checkbox" name="selected<%=pp.getOID()%>" value="1" onClick="setCalc()"></div>
                                                                                                <%}%>
                                                                                            </td>                                                                                     
                                                                                        </tr>
                                                                                        <tr height="23"> 
                                                                                            <td class="<%=style%>"></td>
                                                                                            <td colspan="5" class="<%=style%>">
                                                                                                <table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td width="300" align="center" class="tablecell"><i><b>Segmen</b></i></td>
                                                                                                        <td width="150" align="center" class="tablecell"><i><b>Paid Date</b></i></td>
                                                                                                        <td width="200" align="center" class="tablecell"><i><b>Amount</b></i></td>
                                                                                                        <td align="center" class="tablecell"><i><b>Perkiraan Bank</b></i></td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td align="left" class="tablecell"><i><%=segment%></i></td>
                                                                                                        <td align="center" class="tablecell">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="trans_date<%=pp.getOID()%>" value="<%=JSPFormater.formatDate((transactionDate == null ? new Date() : transactionDate), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpayment.trans_date<%=pp.getOID()%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                    </td>                                                                                                                      
                                                                                                                </tr>
                                                                                                            </table> 
                                                                                                        </td>
                                                                                                        <td class="tablecell"><i><div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div></i></td>
                                                                                                        <input type="hidden" name="amount<%=pp.getOID()%>" value="<%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%>">
                                                                                                        <td class="tablecell" align="right">
                                                                                                            <%if (pp.getStatus() != DbBankPayment.STATUS_PAID) {%>
                                                                                                            <select name="coa_release<%=pp.getOID()%>">
                                                                                                                <%if (accLinks != null && accLinks.size() > 0) {
        for (int x = 0; x < accLinks.size(); x++) {
            AccLink accLink = (AccLink) accLinks.get(x);
            Coa coax = new Coa();
            try {
                coax = DbCoa.fetchExc(accLink.getCoaId());
            } catch (Exception e) {
                System.out.println("[exception]" + e.toString());
            }
                                                                                                                %>
                                                                                                                <option <%if (pp.getCoaPaymentId() == coax.getOID()) {%>selected<%}%> value="<%=coax.getOID()%>"><%=coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                <%=getAccountRecursif(coax.getLevel() * -1, coax, pp.getCoaPaymentId(), isPostableOnly)%> 
                                                                                                                <%}
} else {%>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>                                                                                                            
                                                                                                            <%
} else {
    Coa coas = new Coa();
    try {
        coas = DbCoa.fetchExc(pp.getCoaPaymentId());
    } catch (Exception e) {
        System.out.println("[exception] " + e.toString());
    }
                                                                                                            %>
                                                                                                            <%=coas.getCode() + " - " + coas.getName()%>                                                                                                            
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%


                                                                                                    %>
                                                                                                </table>    
                                                                                            </td>
                                                                                            <td class="<%=style%>">&nbsp;</td>
                                                                                        </tr>  
                                                                                        
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                        <tr > 
                                                                                            <td colspan="4" align="center" class="fontarial"><b>T O T A L</b></td>
                                                                                            <td  align="left" class="fontarial" ><font size="2"><b><i><input type="text" name="tot" value="<%=JSPFormater.formatNumber(0.00, "###,###.##") %>" readOnly style="text-align:right"></i></b></font></td>
                                                                                            <td colspan="2">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr > 
                                                                                            <td ></td>
                                                                                            <td colspan="7" >
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                              
                                                                                                    <tr> 
                                                                                                        <td background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td></td>
                                                                                        </tr>
                                                                                        <%

                                                                                }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                &nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command">
                                                                                    <a href="javascript:cmdPost()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post2','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post2" border="0"></a>                                                                        
                                                                                </td>
                                                                            </tr>
                                                                            <%

                                                                            } else {
                                                                            %>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr> 
                                                                                            <td height="18"><i> 
                                                                                                    &nbsp;<%if (iCommand == JSPCommand.NONE) {%>
                                                                                                    <%=langCT[28]%> 
                                                                                                    <%} else {%>
                                                                                                    <%=langCT[29]%> 
                                                                                                <%}%> ..</i>
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
                                                        <script language="JavaScript">
                                                            setCalc();
                                                        </script>
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
