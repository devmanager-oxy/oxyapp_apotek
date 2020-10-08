
<%-- 
    Document   : bankpaymentmulty
    Created on : Dec 1, 2015, 7:30:26 AM
    Author     : Roy
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
<%@ page import = "com.project.fms.session.*" %>
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
            long bankpoGroupId = JSPRequestValue.requestLong(request, "bankpo_group_id");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");
            long coaId = JSPRequestValue.requestLong(request, "coa_id");
            long uniqId = JSPRequestValue.requestLong(request, "hidden_uniq_multi_key_payment_id");
            
            long segment1Id = JSPRequestValue.requestLong(request, "JSP_SEGMENT1_ID");
            long segment2Id = JSPRequestValue.requestLong(request, "JSP_SEGMENT2_ID");
            long paymentMethodId = JSPRequestValue.requestLong(request, "payment_method_id");
            String strTransDate = JSPRequestValue.requestString(request, "trans_date");
            String strDueDateBg = JSPRequestValue.requestString(request, "due_date_bg");
            String refNumber = JSPRequestValue.requestString(request, "ref_number");
            String memo = JSPRequestValue.requestString(request, "memo");
            String keteranganMaterai = JSPRequestValue.requestString(request, "keterangan_materai");
            double totalMaterai = JSPRequestValue.requestDouble(request, "total_materai");

            if (iJSPCommand == JSPCommand.NONE) {
                keteranganMaterai = "Pendapatan Materai";
            }

            long oidBG = 0;
            long oidCheckPending = 0;
            try {
                oidBG = Long.parseLong(DbSystemProperty.getValueByName("OID_PAYMENT_BG"));
            } catch (Exception e) {}
            
            try {
                oidCheckPending = Long.parseLong(DbSystemProperty.getValueByName("OID_PAYMENT_CHECK_PENDING"));
            } catch (Exception e) {}

            long oidMateraiDebet = 0;
            long oidMateraiCredit = 0;


            try {
                oidMateraiDebet = Long.parseLong(DbSystemProperty.getValueByName("OID_MATERAI_DEBET"));
            } catch (Exception e) {
            }

            try {
                oidMateraiCredit = Long.parseLong(DbSystemProperty.getValueByName("OID_MATERAI_CREDIT"));
            } catch (Exception e) {
            }


            BankpoGroup bankpoGroup = new BankpoGroup();
            try {
                if (bankpoGroupId != 0) {
                    bankpoGroup = DbBankpoGroup.fetchExc(bankpoGroupId);
                }
            } catch (Exception e) {
            }

            Date transDate = new Date();
            Date dueDateBg = new Date();
            if (strTransDate != null && strTransDate.length() > 0) {
                transDate = JSPFormater.formatDate(strTransDate, "dd/MM/yyyy");
            }

            if (strDueDateBg != null && strDueDateBg.length() > 0) {
                dueDateBg = JSPFormater.formatDate(strDueDateBg, "dd/MM/yyyy");
            }

            Vector listBankpoPayment = new Vector();
            
            try {
                if (iJSPCommand == JSPCommand.NONE) {
                    Vector tmpBankpoPayment = (Vector) session.getValue("LIST_BANK_PAYMENT_DETAIL");
                    if (tmpBankpoPayment != null && tmpBankpoPayment.size() > 0) {
                        for (int i = 0; i < tmpBankpoPayment.size(); i++) {
                            BankpoPayment bpp = (BankpoPayment) tmpBankpoPayment.get(i);
                            if(i==0){
                                memo = "Pembayaran Suplier "+DbBankpoGroup.getVendor(bpp.getOID()) ;
                            }
                            listBankpoPayment.add(bpp);
                        }
                    }
                    session.putValue("LIST_BANK_PAYMENT_DETAIL", listBankpoPayment);
                } else {
                    listBankpoPayment = (Vector) session.getValue("LIST_BANK_PAYMENT_DETAIL");
                }
            } catch (Exception e) {
            }
            String codeMappingOS = "";
            try {
                codeMappingOS = DbSystemProperty.getValueByName("MAPPING_OUTSTANDING_BG");
            } catch (Exception e) {
            }
            
            StringTokenizer strTokenizer = new StringTokenizer(codeMappingOS, ",");
            Hashtable strMapping = new Hashtable();
            try {
                while (strTokenizer.hasMoreTokens()) {
                    String str = strTokenizer.nextToken();
                    StringTokenizer token = new StringTokenizer(str, "=");
                    if (token.hasMoreTokens()) {
                        String split1 = token.nextToken();
                        String split2 = token.nextToken();
                        strMapping.put(split1, split2);
                    }
                }
            } catch (Exception e) {
            }
            

            String msgErr = "";
            String msgSucces = "";

            int countUniq = DbBankpoGroup.getCount(DbBankpoGroup.colNames[DbBankpoGroup.COL_UNIQ_KEY_ID] + " = " + uniqId);

            if ((iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.REFRESH) && countUniq == 0 && oidMateraiCredit != 0 && oidMateraiDebet != 0) {
                if (bankpoGroup.getOID() == 0) {

                    if ((memo == null || memo.length() <= 0) && iJSPCommand == JSPCommand.SAVE){
                        msgErr = "Pengisian Catatan/Keterangan required ";
                    }

                    if (totalMaterai != 0 && iJSPCommand == JSPCommand.SAVE) {
                        if (keteranganMaterai == null || keteranganMaterai.length() <= 0) {
                            msgErr = "Keterangan Materai harus diisi ";
                        }
                    }

                    try {
                        Coa coa = DbCoa.fetchExc(coaId);
                        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE) && iJSPCommand == JSPCommand.SAVE) {
                            msgErr = "postable account/Perkiraan required ";
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                    if (paymentMethodId == 0 && iJSPCommand == JSPCommand.SAVE) {
                        msgErr = "Payment method /Pembayaran required ";
                    }
                    
                    if((paymentMethodId == oidCheckPending || paymentMethodId == oidBG) && iJSPCommand == JSPCommand.SAVE){
                        if(refNumber == null || refNumber.length() <=0){
                            msgErr = "Number required";
                        }
                    }
                    

                    if (periodeId != 0 && iJSPCommand == JSPCommand.SAVE) {
                        String wherex = "";
                        Periode preClosedPeriodx = DbPeriode.getPreClosedPeriod();

                        if (preClosedPeriodx.getOID() != 0) {
                            wherex = "'" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "' between start_date and end_date " +
                                    " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodeId;
                        } else {
                            wherex = "'" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "' between start_date and end_date " +
                                    " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                        }

                        Vector v = DbPeriode.list(0, 0, wherex, "");
                        if (v == null || v.size() == 0) {
                            msgErr = "transaction date out of open period range";
                        }

                        Periode p = DbPeriode.fetchExc(periodeId);
                        if (p.getStatus().equalsIgnoreCase("Closed")) {
                            msgErr = "Periode sudah closing";
                        }
                    } else {
                        msgErr = "Please select period";
                    }

                    if (msgErr.length() <= 0 && iJSPCommand == JSPCommand.SAVE) {
                        Date dt = new Date();

                        Periode opnPeriode = new Periode();
                        try {
                            opnPeriode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {
                        }

                        int periodeTaken = 0;
                        try {
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        } catch (Exception e) {
                        }

                        if (periodeTaken == 0) {
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        } else if (periodeTaken == 1) {
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                        }

                        Date dtx = (Date) dt.clone();
                        dtx.setDate(1);

                        String formatDocCode = "";
                        int counter = 0;
                        formatDocCode = DbSystemDocNumber.getNumberPrefix(opnPeriode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_GROUP);
                        counter = DbSystemDocNumber.getNextCounter(opnPeriode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_GROUP);

                        /* konsep baru */
                        bankpoGroup.setJournalCounter(counter);
                        bankpoGroup.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);

                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT_GROUP]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        formatDocCode = DbSystemDocNumber.getNextNumber(bankpoGroup.getJournalCounter(), opnPeriode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_GROUP);
                        systemDocNumber.setDocNumber(formatDocCode);

                        bankpoGroup.setJournalNumber(formatDocCode);
                        bankpoGroup.setUniqKeyId(uniqId);
                        bankpoGroup.setDate(new Date());
                        bankpoGroup.setTransDate(transDate);
                        bankpoGroup.setOperatorId(user.getOID());
                        bankpoGroup.setPaymentMethodId(paymentMethodId);
                        bankpoGroup.setPeriodeId(periodeId);
                        bankpoGroup.setSegment1Id(segment1Id);
                        bankpoGroup.setSegment2Id(segment2Id);
                        bankpoGroup.setCoaId(coaId);
                        bankpoGroup.setMemo(memo);
                        try {
                            long oid = DbBankpoGroup.insertExc(bankpoGroup);
                            bankpoGroupId = oid;
                            if (oid != 0) {
                                try {
                                    DbSystemDocNumber.insertExc(systemDocNumber);
                                } catch (Exception e) {
                                    System.out.println("[exception] " + e.toString());
                                }

                                if (listBankpoPayment != null && listBankpoPayment.size() > 0) {
                                    double totAmount = 0;
                                    long currencyId = 0;
                                    long vdId = 0;
                                    for (int i = 0; i < listBankpoPayment.size(); i++) {

                                        BankpoPayment tempBp = (BankpoPayment) listBankpoPayment.get(i);
                                        long selectVendorId = tempBp.getVendorId();
                                        if(selectVendorId != 0){
                                            vdId = selectVendorId;
                                        }
                                        BankpoPayment bp = new BankpoPayment();
                                        try {
                                            bp = DbBankpoPayment.fetchExc(tempBp.getOID());
                                        } catch (Exception e) {
                                        }
                                        double payment = JSPRequestValue.requestDouble(request, "total_hutang" + bp.getOID());
                                        totAmount = totAmount + payment;
                                        BankpoGroupDetail bgd = new BankpoGroupDetail();
                                        bgd.setBankpoGroupId(oid);
                                        bgd.setBankpoPaymentId(bp.getOID());
                                        bgd.setDate(new Date());
                                        bgd.setType(DbBankpoGroupDetail.TYPE_BANK_PO);
                                        bgd.setRefId(0);
                                        bgd.setVendorId(selectVendorId);
                                        bgd.setAmount(payment);                                        
                                        try {
                                            long oidDetail = DbBankpoGroupDetail.insertExc(bgd);

                                            if (oidDetail != 0) {
                                                BankpoPayment bankpoPayment = new BankpoPayment();
                                                int countx = DbBankpoPayment.getCount(DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_ID] + " = " + bp.getOID() + " and " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_PEMBAYARAN_BANK);
                                                if (countx == 0) {
                                                    bankpoPayment.setJournalNumber(bp.getJournalNumber() + "P");
                                                } else {
                                                    bankpoPayment.setJournalNumber(bp.getJournalNumber() + "P" + (countx + 1));
                                                }
                                                bankpoPayment.setJournalPrefix(bp.getJournalPrefix());
                                                bankpoPayment.setJournalCounter(bp.getJournalCounter());
                                                bankpoPayment.setPeriodeId(periodeId);
                                                bankpoPayment.setDate(new Date());
                                                bankpoPayment.setType(1);
                                                bankpoPayment.setAmount(payment);
                                                bankpoPayment.setTransDate(transDate);
                                                bankpoPayment.setRefId(bp.getOID());
                                                bankpoPayment.setCurrencyId(bp.getCurrencyId());
                                                currencyId = bp.getCurrencyId();
                                                bankpoPayment.setVendorId(selectVendorId);
                                                bankpoPayment.setCoaId(coaId);
                                                bankpoPayment.setMemo(memo);
                                                bankpoPayment.setOperatorId(user.getOID());
                                                bankpoPayment.setStatus(DbBankpoPayment.STATUS_PAID);
                                                bankpoPayment.setPostedStatus(1);
                                                bankpoPayment.setRefNumber(refNumber);
                                                bankpoPayment.setPostedById(user.getOID());
                                                bankpoPayment.setSegment1Id(segment1Id);
                                                bankpoPayment.setSegment2Id(segment2Id);
                                                bankpoPayment.setPaymentMethodId(paymentMethodId);
                                                try {
                                                    long oidBankpoPayment = DbBankpoPayment.insertExc(bankpoPayment);
                                                    SessBankPayment.updateRefBankpoDetail(oidDetail, oidBankpoPayment);
                                                    if (oidBankpoPayment != 0) {
                                                        try {
                                                            BankpoPaymentDetail bankpoPaymentDetail = new BankpoPaymentDetail();
                                                            bankpoPaymentDetail.setBankpoPaymentId(bankpoPayment.getOID());
                                                            bankpoPaymentDetail.setBookedRate(1);
                                                            bankpoPaymentDetail.setCurrencyId(bankpoPayment.getCurrencyId());
                                                            bankpoPaymentDetail.setPaymentAmount(payment);
                                                            bankpoPaymentDetail.setPaymentByInvCurrencyAmount(payment);
                                                            bankpoPaymentDetail.setSegment1Id(bp.getSegment1Id());
                                                            bankpoPaymentDetail.setSegment2Id(bp.getSegment2Id());
                                                            bankpoPaymentDetail.setMemo(memo);
                                                            bankpoPaymentDetail.setCoaId(bp.getCoaId());

                                                            DbBankpoPaymentDetail.insertExc(bankpoPaymentDetail);
                                                            DbBankpoPaymentDetail.updateStatusPaymentPosted(bp.getOID());
                                                            //pengecekan status pembayaran
                                                            DbBankpoPaymentDetail.statusPembayaran(bp.getOID());
                                                            
                                                        } catch (Exception e) {
                                                            System.out.println("[exception] " + e.toString());
                                                        }

                                                    }
                                                } catch (Exception e) {
                                                    System.out.println("[exception] " + e.toString());
                                                }

                                            }
                                        } catch (Exception e) {
                                        }
                                    }

                                    //pembuatan jurnal deduction
                                    if (totalMaterai != 0) {

                                        BankpoGroupDetail bgd = new BankpoGroupDetail();
                                        bgd.setBankpoGroupId(oid);
                                        bgd.setBankpoPaymentId(0);
                                        bgd.setDate(new Date());
                                        bgd.setType(DbBankpoGroupDetail.TYPE_GENERAL_LEDGER);
                                        bgd.setCoaId(oidMateraiCredit);
                                        bgd.setAmount(totalMaterai);
                                        bgd.setSegment1Id(segment1Id);
                                        bgd.setRefId(0);
                                        try {
                                            long oidDetail = DbBankpoGroupDetail.insertExc(bgd);
                                        } catch (Exception e) {
                                        }
                                    }
                                    
                                    DbBankpoGroup.postJournal(bankpoGroup,user.getOID(),oidMateraiDebet,keteranganMaterai);

                                    if (paymentMethodId == oidBG || paymentMethodId == oidCheckPending) {

                                        BankPayment bpay = new BankPayment();
                                        bpay.setReferensiId(oid);
                                        bpay.setAmount(totAmount-totalMaterai);
                                        if (paymentMethodId == oidBG){
                                            bpay.setType(DbBankPayment.TYPE_BANK_PO_GROUP);
                                        }else if(paymentMethodId == oidCheckPending){
                                            bpay.setType(DbBankPayment.TYPE_BANK_PO_CHECK);
                                        }
                                        
                                        bpay.setNumber(refNumber);
                                        bpay.setCreateDate(new Date());
                                        bpay.setCoaId(coaId);
                                        bpay.setCurrencyId(currencyId);
                                        bpay.setDueDate(dueDateBg);
                                        bpay.setStatus(DbBankPayment.STATUS_NOT_PAID);
                                        bpay.setCreateId(user.getOID());
                                        bpay.setSegment1Id(segment1Id);
                                        bpay.setSegment2Id(segment2Id);
                                        bpay.setSegment3Id(0);
                                        bpay.setSegment4Id(0);
                                        bpay.setSegment5Id(0);
                                        bpay.setSegment6Id(0);
                                        bpay.setSegment7Id(0);
                                        bpay.setSegment8Id(0);
                                        bpay.setSegment9Id(0);
                                        bpay.setSegment10Id(0);
                                        bpay.setSegment11Id(0);
                                        bpay.setSegment12Id(0);
                                        bpay.setSegment13Id(0);
                                        bpay.setSegment14Id(0);
                                        bpay.setSegment15Id(0);
                                        bpay.setTransactionDate(transDate);
                                        bpay.setVendorId(vdId);
                                        bpay.setJournalCounter(bankpoGroup.getJournalCounter());
                                        bpay.setJournalPrefix(bankpoGroup.getJournalPrefix());                                        
                                        if (paymentMethodId == oidBG){
                                            bpay.setJournalNumber(bankpoGroup.getJournalNumber() + "-BG");
                                        }else if(paymentMethodId == oidCheckPending){
                                            bpay.setJournalNumber(bankpoGroup.getJournalNumber() + "-CHEQUE");
                                        }
                                        
                                        long coaPaymentId = 0;
                                        try{
                                            coaPaymentId = Long.parseLong(String.valueOf(strMapping.get(String.valueOf(coaId))));                                                                                                        
                                        }catch(Exception e){coaPaymentId = 0;}
                                        bpay.setCoaPaymentId(coaPaymentId);
                                        
                                        try {
                                            DbBankPayment.insertExc(bpay);
                                            int type = 0;
                                            if(paymentMethodId == oidBG){
                                                type = DbBgMaster.TYPE_BG; 
                                            }else{
                                                type = DbBgMaster.TYPE_CHECK; 
                                            }
                                            DbBgMaster.updateRefIdByNumb(bpay.getNumber(),type,bankpoGroup.getOID(),dueDateBg,bpay.getAmount());
                                            
                                        } catch (Exception e) {
                                        }
                                    }

                                    msgSucces = "Data selesai di proses";
                                }
                            }
                        } catch (Exception e) {
                        }
                    }

                }
            }


            String[] langCT = {"Receipt to Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Account - Description", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Invoice payment document has been saved successfully", "Search Journal Number", "Paid", "Period", "Payment", "BG/Cheque Number", "Advance"}; //10-17

            String[] langNav = {"Acc. Payable", "Invoice Payment (Multipayment)", "Date", "CASH PAYMENT EDITOR"};

            if (lang == LANG_ID) {
                String[] langID = {"Perkiraan", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Perkiraan", "Keterangan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran faktur sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Paid", "Periode", "Pembayaran", "Nomor BG/Cheque", "Kasbon"}; //10-17
                langCT = langID;

                String[] navID = {"Hutang", "Pembayaran Invoice (Multipayment)", "Tanggal", "EDITOR PEMBAYARAN TUNAI"};
                langNav = navID;
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT + "'", "");
            Vector segments = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            
            
            
%>
<html>
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
            
            function cmdRefresh(){	
                document.frmbankpopaymentdetail.command.value="<%=JSPCommand.REFRESH%>";                
                document.frmbankpopaymentdetail.action="bankpaymentmulty.jsp";
                document.frmbankpopaymentdetail.submit();	
            }
            
            function cmdGetAmount(){ 
                <%
            if (listBankpoPayment != null && listBankpoPayment.size() > 0) {%>
                    var totalPaid = 0;
            <%
                for (int i = 0; i < listBankpoPayment.size(); i++) {
                    BankpoPayment bp = (BankpoPayment) listBankpoPayment.get(i);
            %>                
                var pay =  document.frmbankpopaymentdetail.total_hutang<%=bp.getOID()%>.value;
                pay = cleanNumberFloat(pay, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
                var a =  document.frmbankpopaymentdetail.amount<%=bp.getOID()%>.value;
                a = cleanNumberFloat(a, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
                if(parseFloat(pay) > parseFloat(a) || parseFloat(pay) < 0){
                    pay = parseFloat(a);
                }    
                
                totalPaid = parseFloat(totalPaid) + parseFloat(pay);             
                document.frmbankpopaymentdetail.total_hutang<%=bp.getOID()%>.value = formatFloat(parseFloat(pay), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);              
                <%}%>             
                var materai =  document.frmbankpopaymentdetail.total_materai.value;
                materai = cleanNumberFloat(materai, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                if(parseFloat(materai) < 0){
                    materai = parseFloat(0);
                }    
                document.frmbankpopaymentdetail.total_materai.value = formatFloat(parseFloat(materai), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);              
                document.frmbankpopaymentdetail.total_pembayaran.value = formatFloat((parseFloat(totalPaid)-parseFloat(materai)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                <%}%>
            }
            
            function isBG(){                 
                if(document.frmbankpopaymentdetail.payment_method_id.value == '<%=oidBG%>' || document.frmbankpopaymentdetail.payment_method_id.value == '<%=oidCheckPending%>'){
                    document.all.inpBg.style.display="";
                }else{                    
                document.all.inpBg.style.display="none";
            }
            
        }
        
        function cmdSubmitCommand(){
            document.frmbankpopaymentdetail.command.value="<%=JSPCommand.SAVE%>";
            document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankpopaymentdetail.action="bankpaymentmulty.jsp";
            document.frmbankpopaymentdetail.submit();
        }
        
        function cmdBack(){
            document.frmbankpopaymentdetail.command.value="<%=JSPCommand.NONE%>";            
            document.frmbankpopaymentdetail.action="bankpopaymentlist.jsp";
            document.frmbankpopaymentdetail.submit();
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
                                                            <input type="hidden" name="hidden_uniq_multi_key_payment_id" value="<%=uniqId%>">                                                              
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
                                                                                                        <td width="110" nowrap></td>                                                                                                                    
                                                                                                        <td width="5" nowrap></td>
                                                                                                        <td width="400" nowrap></td>
                                                                                                        <td width="110" nowrap></td>
                                                                                                        <td width="5" nowrap></td>
                                                                                                        <td nowrap></td>
                                                                                                    </tr>  
                                                                                                    <%
    Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

    Periode open = new Periode();
    if (periodeId != 0) {
        try {
            open = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {
        }
    } else {
        if (periods != null && periods.size() > 0) {
            open = (Periode) periods.get(0);
        }
    }

                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap><%=langCT[4]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td class="fontarial"> 
                                                                                                            <%

    String strNumber = "";
    int counterJournal = DbSystemDocNumber.getNextCounter(open.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_GROUP);
    strNumber = DbSystemDocNumber.getNextNumber(counterJournal, open.getOID(), DbSystemDocCode.TYPE_DOCUMENT_TT_GROUP);
    if (bankpoGroupId != 0) {
        strNumber = bankpoGroup.getJournalNumber();
    }



                                                                                                            %>
                                                                                                            <b><%=strNumber%></b> 
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_NUMBER]%>">
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_COUNTER]%>">
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_PREFIX]%>">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap><%=langCT[0]%></td>    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <select name="coa_id" class="fontarial" <%if(!(iJSPCommand == JSPCommand.SAVE && msgSucces.length() > 0)){%> onChange="javascript:cmdRefresh()" <%}%>>
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
                                                                                                                <option <%if (coaId == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                <%=getAccountRecursif(coa.getLevel() * -1, coa, coaId, isPostableOnly)%> 
                                                                                                                <%}
} else {%>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap> <%if (periods.size() > 1) {%>
                                                                                                            <%=langCT[14]%>
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                        <%}%></td>    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td nowrap>
                                                                                                            <%if (periods.size() > 1) {%>
                                                                                                            <select name="periode_id" class="fontarial">
                                                                                                                <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                                                                                %>
                                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == periodeId) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                            <%} else {%>
                                                                                                            <input type="hidden" name="periode_id" value="<%=open.getOID()%>">
                                                                                                            <%}%> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
    String ref_number = "";
    long kasbonId = 0;
                                                                                                    %>                                                                                                   
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap><%=langCT[15]%></td>                                                                                                        
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <%
    Vector vpm = DbPaymentMethod.list(0, 0, "", "");
                                                                                                            %>
                                                                                                            <select name="payment_method_id" <%if(!(iJSPCommand == JSPCommand.SAVE && msgSucces.length() > 0)){%> onChange="javascript:cmdRefresh()" <%}%> >
                                                                                                                <option value="<%=0%>" <%if (0 == paymentMethodId) {%>selected<%}%>>- Select Payment -</option>
                                                                                                                <%if (vpm != null && vpm.size() > 0) {
        for (int i = 0; i < vpm.size(); i++) {
            PaymentMethod pm = (PaymentMethod) vpm.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=pm.getOID()%>" <%if (pm.getOID() == paymentMethodId) {%>selected<%}%>><%=pm.getDescription()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>                                                                                                                
                                                                                                        </td>
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap><%=langCT[5]%></td>      
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <input name="trans_date" value="<%=JSPFormater.formatDate((transDate == null) ? new Date() : transDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopaymentdetail.trans_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>                                                                                                              
                                                                                                        </td>                                                                                                       
                                                                                                    </tr>
                                                                                                    <%if(paymentMethodId == oidCheckPending || paymentMethodId == oidBG){%>
                                                                                                    <tr id="inpBg" height="22"> 
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap>Due Date BG/Cheque</td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <input name="due_date_bg" value="<%=JSPFormater.formatDate((dueDateBg == null) ? new Date() : dueDateBg, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopaymentdetail.due_date_bg);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>                                                                                                             
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <% 
                                                                                                    String whBg = "";
                                                                                                    if(paymentMethodId == oidCheckPending){
                                                                                                        whBg = DbBgMaster.colNames[DbBgMaster.COL_TYPE]+" = "+DbBgMaster.TYPE_CHECK;
                                                                                                    }else{
                                                                                                        whBg = DbBgMaster.colNames[DbBgMaster.COL_TYPE]+" = "+DbBgMaster.TYPE_BG;
                                                                                                    }
                                                                                                    
                                                                                                    String strCoa = "0";
                                                                                                    try{
                                                                                                        strCoa = String.valueOf(strMapping.get(String.valueOf(coaId)));                                                                                                        
                                                                                                    }catch(Exception e){strCoa = "0";}
                                                                                                    whBg = whBg+" and "+DbBgMaster.colNames[DbBgMaster.COL_COA_ID]+" = "+strCoa;

                                                                                                    Vector vbgMaster = new Vector();
                                                                                                    if(iJSPCommand == JSPCommand.SAVE && msgSucces.length() > 0){
                                                                                                        vbgMaster = DbBgMaster.list(0, 0, DbBgMaster.colNames[DbBgMaster.COL_REF_ID]+" = "+bankpoGroup.getOID(),DbBgMaster.colNames[DbBgMaster.COL_NUMBER]);
                                                                                                    }else{
                                                                                                        vbgMaster = DbBgMaster.list(0, 0, whBg+" and "+DbBgMaster.colNames[DbBgMaster.COL_REF_ID]+" = 0",DbBgMaster.colNames[DbBgMaster.COL_NUMBER]);
                                                                                                    }
                                                                                                    %>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap><%=langCT[16]%></td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="ref_number" class="fontarial">
                                                                                                                <option value="" >- select number -</option>
                                                                                                                <%
                                                                                                                if(vbgMaster != null && vbgMaster.size() > 0){
                                                                                                                    for(int u=0; u < vbgMaster.size();u++){
                                                                                                                    BgMaster bgMaster = (BgMaster)vbgMaster.get(u);
                                                                                                                %>
                                                                                                                    <option value="<%=bgMaster.getNumber()%>" <%if(ref_number.equals(bgMaster.getNumber())){%> selected<%}%> ><%=bgMaster.getNumber()%></option>
                                                                                                                <%} }%>
                                                                                                            </select>                                                                                                                                                                                                                                                                                                                                       
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}else{%>
                                                                                                    <tr height="22">
                                                                                                        <td class="tablecell" style="padding:3px;" nowrap>Nomor Referensi</td>                                                                                                                    
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="ref_number"  value="<%= refNumber %>" class="formElemen">                                                                                                            
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>

                                                                                                    <%}%>
                                                                                                    <tr height="22"> 
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr class="tablecell" height="22">
                                                                                                                    <td style="padding:3px;"><%=langCT[2]%></td>
                                                                                                                </tr>     
                                                                                                            </table>        
                                                                                                        </td>
                                                                                                        <td class="fontarial" valign="top">:</td>
                                                                                                        <td valign="top"> 
                                                                                                            <textarea name="memo" cols="40" rows="3"><%=memo%></textarea>
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
                                                                                                                    <td width="100" class="tablecell" style="padding:3px;"><%=segment.getName()%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                                            <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                        for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                            SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                            String selected = "";
                                                                                                                            switch (i + 1) {
                                                                                                                                case 1:
                                                                                                                                    if (segment1Id == sd.getOID()) {
                                                                                                                                        selected = "selected";
                                                                                                                                    }
                                                                                                                                    break;
                                                                                                                                case 2:
                                                                                                                                    if (segment2Id == sd.getOID()) {
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
                                                                                                <table border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="23">
                                                                                                        <td class="tablehdr" width="23">No</td>
                                                                                                        <td class="tablehdr" width="100">Number</td>
                                                                                                        <td class="tablehdr" width="180">Segment</td>
                                                                                                        <td class="tablehdr" width="200">Perkiraan</td>
                                                                                                        <td class="tablehdr" width="120">Hutang</td>
                                                                                                        <td class="tablehdr" width="120">Terbayar</td>
                                                                                                        <td class="tablehdr" width="120">Jumlah IDR</td>
                                                                                                        <td class="tablehdr" width="250">Keterangan</td>                                                                                                        
                                                                                                    </tr>    
                                                                                                    <%
    if (listBankpoPayment != null && listBankpoPayment.size() > 0) {
        double totalPayment = 0;
        int pages = 0;
        for (int i = 0; i < listBankpoPayment.size(); i++) {
            BankpoPayment b = (BankpoPayment) listBankpoPayment.get(i);
            pages++;
            BankpoPayment bp = new BankpoPayment();
            try {
                bp = DbBankpoPayment.fetchExc(b.getOID());
            } catch (Exception ex) {
            }

            String style = "";
            if (i % 2 != 0) {
                style = "tablecell";
            } else {
                style = "tablecell1";
            }

            String segment = "";

            if (bp.getSegment1Id() != 0) {
                try {
                    SegmentDetail sd = DbSegmentDetail.fetchExc(bp.getSegment1Id());
                    segment = sd.getName();
                } catch (Exception e) {
                }
            }

            if (bp.getSegment2Id() != 0) {
                try {
                    SegmentDetail sd = DbSegmentDetail.fetchExc(bp.getSegment2Id());
                    if (segment != null && segment.length() > 0) {
                        segment = segment + "|";
                    }
                    segment = segment + sd.getName();
                } catch (Exception e) {
                }
            }

            Coa coaSelect = new Coa();
            try {
                coaSelect = DbCoa.fetchExc(bp.getCoaId());
            } catch (Exception e) {
            }

            double payment = SessBankPayment.getPaymentBankPo(bp.getOID());
            double paid = DbBankpoPaymentDetail.getTotalPayment(bp.getOID());

            double pembayaran = (payment - paid);
            if (iJSPCommand == JSPCommand.SAVE) {
                pembayaran = JSPRequestValue.requestDouble(request, "total_hutang" + bp.getOID());
            }
            totalPayment = totalPayment + pembayaran;
                                                                                                    %>                                                                    
                                                                                                    <tr height="23">
                                                                                                        <td class="<%=style%>" align="center"><%=(i + 1)%></td>
                                                                                                        <td class="<%=style%>" align="center"><%=bp.getJournalNumber() %></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=segment%></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=coaSelect.getCode()%>-<%=coaSelect.getName()%></td>
                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(payment, "###,###.##") %></td>
                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(paid, "###,###.##") %></td>
                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;">
                                                                                                            <input type="hidden" name="amount<%=bp.getOID()%>" value="<%=JSPFormater.formatNumber(((payment - paid)), "###,###.##")%>" > 
                                                                                                            <input type="text" size="15" name="total_hutang<%=bp.getOID()%>" value="<%=JSPFormater.formatNumber((pembayaran), "###,###.##")%>" style="text-align:right" onClick="this.select()" onBlur="javascript:cmdGetAmount()">
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=bp.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        }
                                                                                                    %>
                                                                                                    <tr height="23">
                                                                                                        <td colspan="5" class="fontarial"></td>
                                                                                                    </tr>
                                                                                                    <tr height="23">
                                                                                                        <td colspan="5" class="fontarial"><b><i>Deduction</i><b></td>
                                                                                                    </tr>
                                                                                                    <tr height="23">
                                                                                                        <td class="tablecell" align="center"><%=(pages + 1)%></td>
                                                                                                        <td class="tablecell" align="left" colspan="5">Pendapatan Materai</td>                                                                                                        
                                                                                                        <td class="tablecell" align="right" style="padding:3px;">
                                                                                                            <input type="text" size="15" name="total_materai" value="<%=JSPFormater.formatNumber(totalMaterai, "###,###.##")%>" style="text-align:right" onClick="this.select()" onBlur="javascript:cmdGetAmount()" >
                                                                                                        </td> 
                                                                                                        <td class="tablecell" >
                                                                                                            <input type="text" size="30" name="keterangan_materai" value="<%=keteranganMaterai%>" class="fontarial">
                                                                                                        </td> 
                                                                                                    </tr>
                                                                                                    <% 
                                                                                                    totalPayment = totalPayment - totalMaterai; 
                                                                                                    %>
                                                                                                    <tr height="23">
                                                                                                        <td align="center" colspan="5">&nbsp;</td>
                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="center"><b><i>Total Payment</i></b></td>                                                                                                        
                                                                                                        <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><input type="text" size="15" name="total_pembayaran" value="<%=JSPFormater.formatNumber(totalPayment, "###,###.##") %>" style="text-align:right" class="readOnly" readonly></td>                                                                                                        
                                                                                                        <td align="left" style="padding:3px;">&nbsp;</td>                                                        
                                                                                                    </tr>
                                                                                                    <%
    }

                                                                                                    %>
                                                                                                    <%if (countUniq > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="7">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                    <td class="fontarial" nowrap><i>Data sudah pernah tersimpan, klik back untuk kembali ke daftar hutang</i></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <%}%>
                                                                                                    
                                                                                                    
                                                                                                    <%if (iJSPCommand == JSPCommand.SAVE) {%>
                                                                                                    <%if (msgErr.length() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="7">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                                                                <tr>
                                                                                                                    <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                    <td class="fontarial" nowrap><i><%=msgErr%></i></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%> 
                                                                                                    <%if (msgSucces.length() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="7">
                                                                                                            <div align="left" class="msgnextaction"> 
                                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="info" width="170" align="left">
                                                                                                                    <tr> 
                                                                                                                        <td width="8"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                                                                        <td nowrap><%=msgSucces%></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td colspan="7"> 
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <%if (privUpdate || privAdd) {%>
                                                                                                                    <%if (msgSucces.length() <= 0 && countUniq == 0 && listBankpoPayment != null && listBankpoPayment.size() > 0) {%>
                                                                                                                    <td width="120">                                                                                                                        
                                                                                                                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="new1" border="0"></a>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                                    <td >
                                                                                                                        <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" border="0"></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="7" height="25">&nbsp;</td>
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
