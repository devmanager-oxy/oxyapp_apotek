
<%-- 
    Document   : cashreceivedetail
    Created on : Mar 9, 2012, 9:42:08 AM
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
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../printing/printingvariables.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CR, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                CashReceiveDetail crd = (CashReceiveDetail) listx.get(i);
                result = result + crd.getAmount() - crd.getCreditAmount();
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
            String[] langCT = {"Receipt to Account", "Receipt From", "Amount", "Memo", "Journal Number", "Transaction Date", //0-5
                "Receipt From", "Currency", "Code", "Amount", "Booked Rate", "Amount", "Description", //6-12
                "Cash Received document is ready to be saved", "Cash Receive document has been saved successfully", "Searching", "Customer", "Search Advance", "Credit", "Credit Amount in", "Period", "Segment"}; //13-21
            String[] langNav = {"Cash Transaction", "Cash Receive", "Date", "SEARCHING", "Cash Receive Editor", "required"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Diterima Pada", "Diterima Dari", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Dari Perkiraan", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan",//6-12
                    "Dokumen Penerimaan Tunai siap untuk disimpan", "Dokumen Penerimaan Tunai sudah disimpan dengan sukses", "Pencarian", "Konsumen", "Cari Kasbon", "Credit", "Jumlah Credit", "Periode", "Segmen"}; //13-21
                langCT = langID;
                String[] navID = {"Transaksi Tunai", "Penerimaan Tunai", "Tanggal", "PENCARIAN", "Editor Penerimaan Tunai", "Data harus diisi"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidCashReceive = JSPRequestValue.requestLong(request, "hidden_cash_receive_id");
            long oidCashReceiveDetail = JSPRequestValue.requestLong(request, "hidden_cash_receive_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int reset_app = JSPRequestValue.requestInt(request, "reset_app");
            docChoice = 2;
            generalOID = oidCashReceive;

            String strApproval = DbSystemProperty.getValueByName("APPLY_DOC_WORKFLOW");

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("RECEIVE_DETAIL");
                oidCashReceive = 0;
                recIdx = -1;
            }


            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            boolean isLoad = false;
            long referensi_id = 0;

            if (iJSPCommand == JSPCommand.REFRESH) {
                session.removeValue("RECEIVE_DETAIL");
                oidCashReceive = JSPRequestValue.requestLong(request, "cash_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdCashReceive ctrlCashReceive = new CmdCashReceive(request);
            JSPLine ctrLine = new JSPLine();

            int iErrCodeRec = ctrlCashReceive.action(iJSPCommand, oidCashReceive);
            JspCashReceive jspCashReceive = ctrlCashReceive.getForm();
//int vectSize = 0;

            CashReceive cashReceive = ctrlCashReceive.getCashReceive();
            String msgStringRec = ctrlCashReceive.getMessage();
            if (oidCashReceive == 0) {
                oidCashReceive = cashReceive.getOID();
            }

            if (oidCashReceive != 0) {
                try {
                    cashReceive = DbCashReceive.fetchExc(oidCashReceive);
                } catch (Exception e) {
                }
            }

            String cstName = "";
            Customer cs = new Customer();
            try {
                cs = DbCustomer.fetchExc(cashReceive.getCustomerId());
                cstName = cs.getName();
            } catch (Exception e) {
            }

            if (reset_app == 1) {
                DbApprovalDoc.resetApproval(I_Project.TYPE_APPROVAL_BKM, cashReceive.getOID());
            }
%>
<%
            boolean load = false;
            if (iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }
            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }
            CmdCashReceiveDetail ctrlCashReceiveDetail = new CmdCashReceiveDetail(request);
            Vector listCashReceiveDetail = new Vector(1, 1);

            if (load) {
                listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + "=" + cashReceive.getOID(), null);
            }

            iErrCode = ctrlCashReceiveDetail.action(iJSPCommand, oidCashReceiveDetail);

            JspCashReceiveDetail jspCashReceiveDetail = ctrlCashReceiveDetail.getForm();
            CashReceiveDetail cashReceiveDetail = ctrlCashReceiveDetail.getCashReceiveDetail();
            msgString = ctrlCashReceiveDetail.getMessage();

            if (session.getValue("RECEIVE_DETAIL") != null) {
                listCashReceiveDetail = (Vector) session.getValue("RECEIVE_DETAIL");
            }

            boolean submit = false;
            if (iJSPCommand == JSPCommand.SUBMIT) {

                submit = true;
                if (iErrCode == 0 && iErrCodeRec == 0) {
                    if (recIdx == -1) {
                        listCashReceiveDetail.add(cashReceiveDetail);
                    } else {
                        CashReceiveDetail crd = (CashReceiveDetail) listCashReceiveDetail.get(recIdx);
                        cashReceiveDetail.setOID(crd.getOID());
                        listCashReceiveDetail.set(recIdx, cashReceiveDetail);
                    }
                }
            }

            if (iJSPCommand == JSPCommand.DELETE) {
                try {
                    try {
                        CashReceiveDetail crdd = (CashReceiveDetail) listCashReceiveDetail.get(recIdx);
                        DbCashReceiveDetail.deleteExc(crdd.getOID());
                    } catch (Exception e) {
                        System.out.println("[exception]" + e.toString());
                    }
                    listCashReceiveDetail.remove(recIdx);
                } catch (Exception e) {
                }
            }

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                if (cashReceive.getOID() != 0) {
                    DbCashReceiveDetail.saveAllDetail(cashReceive, listCashReceiveDetail);
                    listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, "cash_receive_id=" + cashReceive.getOID(), "");
                    isSave = true;
                }
            }

            session.putValue("RECEIVE_DETAIL", listCashReceiveDetail);
            Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_CASH_CREDIT, sysLocation.getOID());
            Vector currencies = DbCurrency.list(0, 0, "", "");
            //ExchangeRate eRate = DbExchangeRate.getStandardRate();

            double totalDetail = getTotalDetail(listCashReceiveDetail);
            cashReceive.setAmount(totalDetail);

            if (iJSPCommand == JSPCommand.RESET && iErrCodeRec == 0) {
                totalDetail = 0;
                cashReceive = new CashReceive();
                listCashReceiveDetail = new Vector();
                session.removeValue("RECEIVE_DETAIL");
            }

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeRec == 0 && recIdx == -1) {
                iJSPCommand = JSPCommand.ADD;
                cashReceiveDetail = new CashReceiveDetail();
            }
            double balance = 0;
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_CASH + "'", "");
            Vector segments = DbSegment.list(0, 0, "", "");
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript" src="<%=approot%>/main/jquery.min.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.searchabledropdown.js"></script>
        <link rel="stylesheet" href="<%=approot%>/js/reset.css">
        <script type="text/javascript" src="<%=approot%>/js/bootstrap.min2.js"></script>
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
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>        
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdCetak(param){	
                document.frmcashreceivedetail.command.value="<%=JSPCommand.LOAD%>";
                document.frmcashreceivedetail.command_print.value=param;
                document.frmcashreceivedetail.action="cashreceivedetail.jsp";
                document.frmcashreceivedetail.submit();	
            }
            
            function cmdPrintJournal(oidCashReceive){	                       
                window.open("<%=printroot%>.report.RptCashReceivePDF?user_id=<%=appSessUser.getUserOID()%>&cash_receive_id="+oidCashReceive+"&lang=<%=lang%>");
                }
                
                function cmdSearchJurnal(){
                    var numb = document.frmcashreceivedetail.jurnal_number.value;  
                    window.open("<%=approot%>/<%=transactionFolder%>/s_nomorjurnal.jsp?txt_jurnal=\'"+numb+"'&command=<%=JSPCommand.SEARCH%>", null, "height=400,width=700, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }
                    
                    function cmdSearchCustomer(){
                        var cstName = document.frmcashreceivedetail.cst_name.value;  
                        window.open("<%=approot%>/<%=transactionFolder%>/srckonsumen.jsp?cst_name=\'"+cstName+"'&command=<%=JSPCommand.SEARCH%>", null, "height=400,width=700, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                        }     
                        
                        
                        function cmdClickMe(){
                            var x = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;	
                            document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.select();
                        }
                        
                        function cmdClickMeCredit(){
                            var x = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value;	
                            document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.select();
                        }
                        
                        function cmdNewJournal(){	
                            document.frmcashreceivedetail.hidden_cash_receive_id.value="0";
                            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value="0";
                            document.frmcashreceivedetail.command.value="<%=JSPCommand.NONE%>";
                            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
                            document.frmcashreceivedetail.submit();	
                        }
                        
                        function cmdAdd(cashReceiveId){	
                            document.frmcashreceivedetail.hidden_cash_receive_id.value=cashReceiveId;
                            document.frmcashreceivedetail.select_idx.value="-1";
                            document.frmcashreceivedetail.command.value="<%=JSPCommand.ADD%>";
                            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
                            document.frmcashreceivedetail.submit();	
                        }
                        
                        var sysDecSymbol = "<%=sSystemDecimalSymbol%>"; var usrDigitGroup = "<%=sUserDigitGroup%>"; var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                        
                        function removeChar(number){                        
                            var ix; var result = "";
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
                        var st = document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>.value;		                        
                        result = removeChar(st);                        
                        result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    }
                    
                    function checkNumber2(){                        
                        var main = document.frmcashreceivedetail.<%=jspCashReceive.colNames[jspCashReceive.JSP_AMOUNT]%>.value;                        
                        main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        var currTotal = document.frmcashreceivedetail.total_detail.value;
                        currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
                        var idx = document.frmcashreceivedetail.select_idx.value;		
                        var booked = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_BOOKED_RATE]%>.value;		
                        booked = cleanNumberFloat(booked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        var st = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_AMOUNT]%>.value;		
                        result = removeChar(st);	
                        result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        var stCredit = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>.value;		
                        resultCredit = removeChar(stCredit);	
                        resultCredit = cleanNumberFloat(resultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        var result2 = 0;
                        if(parseFloat(idx)<0){       
                            var amount = parseFloat(currTotal) + parseFloat(result) - parseFloat(resultCredit);
                            document.frmcashreceivedetail.<%=jspCashReceive.colNames[jspCashReceive.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                                                                 
                        }else{                        
                        var editAmount =  document.frmcashreceivedetail.edit_amount.value;
                        var editCreditAmount =  document.frmcashreceivedetail.edit_creditamount.value;                        
                        var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result) + parseFloat(editCreditAmount) - parseFloat(resultCredit);;
                        document.frmcashreceivedetail.<%=jspCashReceive.colNames[jspCashReceive.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                        
                    }
                }
                
                function cmdUpdateExchange(){                    
                    var idCurr = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;                    
                <%if (currencies != null && currencies.size() > 0) {
                for (int i = 0; i < currencies.size(); i++) {
                    Currency cx = (Currency) currencies.get(i); 
%>
    if(idCurr=='<%=cx.getOID()%>'){
        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value="<%=cx.getRate()%>";        
    }	
    <%}
            }%>        
            
            var famount = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;            
            var fcreditamount = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value;
            
            famount = removeChar(famount);
            fcreditamount = removeChar(fcreditamount);
            
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);        
            fcreditamount = cleanNumberFloat(fcreditamount, sysDecSymbol, usrDigitGroup, usrDecSymbol);        
            
            if(parseFloat(famount)>0 && parseFloat(fcreditamount)>0){
                alert("tidak boleh mengisi keduanya debet dan kredit, system akan me-reset data kredit");
                fcreditamount = "0";
                
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>.value= formatFloat(parseFloat(fcreditamount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value= formatFloat(fcreditamount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                
            }            
            var fbooked = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value;
            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            
            
            if(!isNaN(famount)){
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>.value= formatFloat(parseFloat(fcreditamount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value= formatFloat(fcreditamount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            }            
            checkNumber2();            
        }
        
        
        function cmdUpdateExchangeCredit(){            
            var idCurr = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;                                
            <%if (currencies != null && currencies.size() > 0) {
                for (int i = 0; i < currencies.size(); i++) {
                    Currency cx = (Currency) currencies.get(i);
%>
    if(idCurr=='<%=cx.getOID()%>'){
        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value="<%=cx.getRate()%>";        
    }
    <%}
            }%>            
            var famount = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value;            
            famount = removeChar(famount);
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            var fbooked = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value;
            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            if(!isNaN(famount)){
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            }            
            checkNumber2();
        }
        
        
        function cmdUpdateExchangeXX(){
            
            var rate = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value;
            rate = removeChar(rate); 
            rate = cleanNumberFloat(rate , sysDecSymbol, usrDigitGroup, usrDecSymbol);  
            var famount = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;            
            famount = removeChar(famount);
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);           
            
            if(!isNaN(famount)){
                document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(rate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
                
            } 
            checkNumber2();           
            
        }        
        
        function cmdAsking(oidCashReceive){            
            var cfrm = confirm('Are you sure you want to delete ?');            
            if( cfrm==true){
                document.frmcashreceivedetail.select_idx.value=-1;
                document.frmcashreceivedetail.hidden_cash_receive_id.value=oidCashReceive;
                document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=0;
                document.frmcashreceivedetail.command.value="<%=JSPCommand.RESET%>";                
                document.frmcashreceivedetail.action="cashreceivedetail.jsp";
                document.frmcashreceivedetail.submit();
            }
        }        
        
        function cmdAsk(oidCashReceiveDetail){
            document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.ASK%>";            
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdConfirmDelete(oidCashReceiveDetail){
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.DELETE%>";            
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdSave(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.SUBMIT%>";            
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdSubmitCommand(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.SAVE%>";            
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdEdit(oidCashReceiveDetail){
            document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";            
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdCancel(oidCashReceiveDetail){
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";            
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdBack(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.BACK%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdDelPict(oidCashReceiveDetail){
            document.frmimage.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="cashreceivedetail.jsp";
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
        
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/savedoc2.gif')">
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
                                            <%@ include file="../main/menu.jsp"%>
                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"> 
                                                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                        %>
                                                        <%@ include file="../main/navigator.jsp"%>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcashreceivedetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="hidden_cash_receive_detail_id" value="<%=oidCashReceiveDetail%>">
                                                            <input type="hidden" name="hidden_cash_receive_id" value="<%=oidCashReceive%>">
                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>"><input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="approval_doc_id" value=""><input type="hidden" name="doc_type" value=""><input type="hidden" name="approval_doc_status" value="">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" colspan="3" class="container">                                                                         
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top">
                                                                                <td height="8" valign="top" colspan="3" width="100%"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                       
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="10%" colspan="5">   
                                                                                                            <table border="0" cellpadding="1" cellspacing="1" width="320">                                                                                                                                        
                                                                                                                <tr>                                                                                                                                            
                                                                                                                    <td class="tablecell1" > 
                                                                                                                        <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">                                                                                                                            
                                                                                                                            <%
            String jur_number = "";
            long cashRecId = 0;
            if (isLoad && reset_app != 1) {
                jur_number = cashReceive.getJournalNumber();
                cashRecId = cashReceive.getOID();
            }
                                                                                                                            %>
                                                                                                                            <tr height="5">
                                                                                                                                <td colspan="5"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td width="5">&nbsp;</td>
                                                                                                                                <td><font face="arial"><b><i><%=langCT[15]%></i></b></font></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td width="5">&nbsp;</td>
                                                                                                                                <td><font face="arial"><%=langCT[4]%></font></td>
                                                                                                                                <td width="40"><input size="25" type="text" name="jurnal_number" value="<%=jur_number%>"></td>
                                                                                                                                <td width="30">
                                                                                                                                    <input type="hidden" name="cash_id" value="<%=cashRecId%>">
                                                                                                                                    <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr height="25">
                                                                                                                                <td colspan="5"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" width="100%" height="20">&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr> 
                                                                                                        <td colspan="5" width="100%">
                                                                                                            <table width="800" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr><td background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>  
                                                                                                    <tr>
                                                                                                        <td colspan="5" >
                                                                                                            <table border="0" cellpadding="1" cellspacing="1" width="900">                                                                                                                                        
                                                                                                                <tr>                                                                                                                                            
                                                                                                                    <td class="tablecell1" > 
                                                                                                                        <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">                                                                                                        
                                                                                                                            <tr> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td colspan="5" height="23"><font face="arial"><b><i><%=langNav[4]%></i></b></font></td>
                                                                                                                            </tr>                                                                                                                            
                                                                                                                            <tr> 
                                                                                                                                <td ></td>
                                                                                                                                <td width="100" ><font face="arial"><%=langCT[4]%></font></td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="380"> 
                                                                                                                                    <%
            Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            String strNumber = "";
            Periode open = new Periode();
            if (cashReceive.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(cashReceive.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (periods != null && periods.size() > 0) {
                    open = (Periode) periods.get(0);
                }
            }
            int counterJournal = DbSystemDocNumber.getNextCounterBkm(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberBkm(counterJournal, open.getOID());
            if (cashReceive.getOID() != 0 || oidCashReceive != 0) {
                strNumber = cashReceive.getJournalNumber();
            }


                                                                                                                                    %>
                                                                                                                                    <%=strNumber%> 
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_NUMBER]%>">
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_COUNTER]%>">
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_PREFIX]%>">
                                                                                                                                </td>
                                                                                                                                <td width="120">
                                                                                                                                    <%if (periods.size() > 1) {%>
                                                                                                                                    <font face="arial"><%=langCT[20]%></font>
                                                                                                                                    <%} else {%>
                                                                                                                                    &nbsp;
                                                                                                                                    <%}%>
                                                                                                                                </td>
                                                                                                                                <td >
                                                                                                                                    <%if (open.getStatus().equals("Closed") || cashReceive.getOID() != 0) {%>
                                                                                                                                    <%=open.getName()%>
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                                                                    <%} else {%>
                                                                                                                                    <%if (periods.size() > 1) {%>
                                                                                                                                    <select name="<%=JspCashReceive.colNames[JspCashReceive.JSP_PERIODE_ID]%>">
                                                                                                                                        <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                                                                                                        %>
                                                                                                                                        <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == cashReceive.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                                        <%}%><%}%>
                                                                                                                                    </select>
                                                                                                                                    <%} else {%>
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                                                                    <%}
            }%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td ><font face="arial"><%=langCT[0]%></font></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td > 
                                                                                                                                    <select name="<%=JspCashReceive.colNames[JspCashReceive.JSP_COA_ID]%>">
                                                                                                                                        <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accLinks.size(); i++) {

                    AccLink accLink = (AccLink) accLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                        System.out.println("Exception " + e.toString());
                    }
                                                                                                                                        %>
                                                                                                                                        <option <%if (cashReceive.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                                        <%=getAccountRecursif(coa.getLevel() * -1, coa, cashReceive.getCoaId(), isPostableOnly)%> 
                                                                                                                                        <%}
} else {%>
                                                                                                                                        <option>select ..</option>
                                                                                                                                        <%}%>
                                                                                                                                    </select>
                                                                                                                                <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_COA_ID) %></td>
                                                                                                                                <td ><font face="arial"><%=langCT[5]%></font></td>
                                                                                                                                <td >
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <input name="<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((cashReceive.getTransDate() == null) ? new Date() : cashReceive.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                            </td>
                                                                                                                                            <td valign="top">&nbsp;<%=jspCashReceive.getErrorMsg(jspCashReceive.JSP_TRANS_DATE) %></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>       
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td ><font face="arial"><%=langCT[1]%></font></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td > 
                                                                                                                                    <input type="text" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_RECEIVE_FROM_NAME]%>" value="<%=cashReceive.getReceiveFromName()%>" size="30">
                                                                                                                                <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_RECEIVE_FROM_ID) %> </td>
                                                                                                                                <td ><%=langCT[16]%></td>                                                                                                                                
                                                                                                                                <td > 
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_CUSTOMER_ID]%>" value="<%=cashReceive.getCustomerId()%>">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <input type="text" name="cst_name" size="20" value="<%=cstName%>" onChange="javascript:cmdSearchCustomer()">
                                                                                                                                            </td>
                                                                                                                                            <td>
                                                                                                                                                &nbsp;<a href="javascript:cmdSearchCustomer()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>           
                                                                                                                            <%
            String jur_num = "";
            if (cashReceive.getReferensiId() != 0 || referensi_id != 0) {
                if (cashReceive.getReferensiId() != 0) {
                    jur_num = DbPettycashPayment.getNomorReferensi(cashReceive.getReferensiId());
                } else {
                    jur_num = DbPettycashPayment.getNomorReferensi(referensi_id);
                }
            }
                                                                                                                            %>
                                                                                                                            <tr> 
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td ><font face="arial"><%=langCT[2]%> <%=baseCurrency.getCurrencyCode()%></font></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td > 
                                                                                                                                <input type="text" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkNumber()" class="readonly" readOnly size="30">
                                                                                                                                &nbsp;&nbsp<%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_AMOUNT) %></td>
                                                                                                                                <td > 
                                                                                                                                    <%if (jur_num.length() > 0) {%> <font face="arial">Ref no</font>  <%} else {%> &nbsp;  <%}%>
                                                                                                                                </td>
                                                                                                                                <td > 
                                                                                                                                    <%if (jur_num.length() > 0) {%> <%=jur_num%>  <%} else {%> &nbsp;  <%}%>
                                                                                                                                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_REFERENSI_ID]%>" value="<%=cashReceive.getReferensiId()%>" >
                                                                                                                                <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_REFERENSI_ID) %> </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td valign="top"><font face="arial"><%=langCT[3]%></font></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <table cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td valign="top"><textarea name="<%=JspCashReceive.colNames[JspCashReceive.JSP_MEMO]%>" cols="40" rows="2"><%=cashReceive.getMemo()%></textarea></td>
                                                                                                                                            <td valign = "top">&nbsp;&nbsp; <%= jspCashReceive.getErrorMsg(jspCashReceive.JSP_MEMO) %> </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td colspan="2">                                                                                                                                    
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr>
                                                                                                                                            <td width="125" class="fontarial"><b><i><%=langCT[21]%></i></b></td>
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
            if (segments != null && segments.size() > 0) {
                for (int i = 0; i < segments.size(); i++) {
                    Segment segment = (Segment) segments.get(i);
                    String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + segment.getOID();
                    switch (i + 1) {
                        case 1:
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
                                                                                                                                        <tr> 
                                                                                                                                            <td ><font face="arial"><%=segment.getName()%></font></td>
                                                                                                                                            <td > 
                                                                                                                                                <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                                                                    <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                                        String selected = "";
                                                                                                                                                        switch (i + 1) {
                                                                                                                                                            case 1:
                                                                                                                                                                if (cashReceive.getSegment1Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 2:
                                                                                                                                                                if (cashReceive.getSegment2Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 3:
                                                                                                                                                                if (cashReceive.getSegment3Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 4:
                                                                                                                                                                if (cashReceive.getSegment4Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 5:
                                                                                                                                                                if (cashReceive.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 6:
                                                                                                                                                                if (cashReceive.getSegment6Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 7:
                                                                                                                                                                if (cashReceive.getSegment7Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 8:
                                                                                                                                                                if (cashReceive.getSegment8Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 9:
                                                                                                                                                                if (cashReceive.getSegment9Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 10:
                                                                                                                                                                if (cashReceive.getSegment10Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 11:
                                                                                                                                                                if (cashReceive.getSegment11Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 12:
                                                                                                                                                                if (cashReceive.getSegment12Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 13:
                                                                                                                                                                if (cashReceive.getSegment13Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 14:
                                                                                                                                                                if (cashReceive.getSegment14Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 15:
                                                                                                                                                                if (cashReceive.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
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
                                                                                                                                        <%}
            }%>
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="2">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>   
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="10"></td>
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
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" valign="middle" colspan="3" class="comment"></td>
                                                                            </tr>
                                                                            <%

                                                                            %>
                                                                            <tr align="left" valign="top">
                                                                                <td  valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td class="boxed1">                                                                                                
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td rowspan="2" class="tablearialhdr" nowrap width="15%"><%=langCT[21]%></td>
                                                                                                        <td rowspan="2" class="tablearialhdr" nowrap width="15%"><%=langCT[6]%></td>                                                                                                        
                                                                                                        <td class="tablearialhdr" colspan="2" width="20%"><%=langCT[7]%></td>
                                                                                                        <td rowspan="2" class="tablearialhdr" width="15%"><%=langCT[10]%></td>
                                                                                                        <td rowspan="2" class="tablearialhdr" width="10%"><%=langCT[11]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                                        
                                                                                                        <td rowspan="2" class="tablearialhdr" width="15%"><%=langCT[12]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablearialhdr"><%=langCT[8]%></td>
                                                                                                        <td class="tablearialhdr"><%=langCT[9]%></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
            //int idx = -1;

            if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {

                for (int i = 0; i < listCashReceiveDetail.size(); i++) {
                    CashReceiveDetail crd = (CashReceiveDetail) listCashReceiveDetail.get(i);
                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                    } catch (Exception e) {
                    }

                    String cssName = "tablecell";
                    if (i % 2 != 0) {
                        cssName = "tablecell1";
                    }
                                                                                                    %>
                                                                                                    <%
                                                                                                            if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <%	if (segments != null && segments.size() > 0) {
                                                                                                            for (int xx = 0; xx < segments.size(); xx++) {
                                                                                                                Segment seg = (Segment) segments.get(xx);
                                                                                                                Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                                                                                                                    %>
                                                                                                                    <tr> 
                                                                                                                        <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                                                        <td width="46%"> 
                                                                                                                            <select name="JSP_SEGMENT<%=xx + 1%>_ID_DETAIL">
                                                                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                            for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                String selected = "";
                                                                                                                                switch (xx + 1) {
                                                                                                                                    case 1:
                                                                                                                                        if (crd.getSegment1Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 2:
                                                                                                                                        if (crd.getSegment2Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 3:
                                                                                                                                        if (crd.getSegment3Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 4:
                                                                                                                                        if (crd.getSegment4Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 5:
                                                                                                                                        if (crd.getSegment5Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 6:
                                                                                                                                        if (crd.getSegment6Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 7:
                                                                                                                                        if (crd.getSegment7Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 8:
                                                                                                                                        if (crd.getSegment8Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 9:
                                                                                                                                        if (crd.getSegment9Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 10:
                                                                                                                                        if (crd.getSegment10Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 11:
                                                                                                                                        if (crd.getSegment11Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 12:
                                                                                                                                        if (crd.getSegment12Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 13:
                                                                                                                                        if (crd.getSegment13Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 14:
                                                                                                                                        if (crd.getSegment14Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                    case 15:
                                                                                                                                        if (crd.getSegment15Id() == sd.getOID()) {
                                                                                                                                            selected = "selected";
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
                                                                                                                    <%}
                                                                                                        }%>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_COA_ID]%>">
                                                                                                                <%
                                                                                                        if (incomeCoas != null && incomeCoas.size() > 0) {

                                                                                                            for (int x = 0; x < incomeCoas.size(); x++) {
                                                                                                                Coa coax = (Coa) incomeCoas.get(x);
                                                                                                                String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=coax.getOID()%>" <%if (crd.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                <%=getAccountRecursif(coax.getLevel() * -1, coax, crd.getCoaId(), isPostableOnly)%> 
                                                                                                                <%
                                                                                                            }
                                                                                                        }
                                                                                                                %>
                                                                                                            </select>
                                                                                                        <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_COA_ID) %> </td>                                                                                                        
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                                                                    <%
                                                                                                        if (currencies != null && currencies.size() > 0) {
                                                                                                            for (int x = 0; x < currencies.size(); x++) {
                                                                                                                Currency cx = (Currency) currencies.get(x);
                                                                                                                    %>
                                                                                                                    <option value="<%=cx.getOID()%>" <%if (crd.getForeignCurrencyId() == cx.getOID()) {%>selected<%}%>><%=cx.getCurrencyCode()%></option>
                                                                                                                    <%}
                                                                                                        }%>
                                                                                                                </select>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <input type="hidden" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignCreditAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">                                                                                                        
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" onBlur="javascript:cmdUpdateExchangeXX()"  onClick="this.select()">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <input type="hidden" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>                                                                                                        
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>" size="30" value="<%=crd.getMemo()%>">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr height="22">
                                                                                                        <td class="<%=cssName%>" width="16%"> 
                                                                                                            <div align="left"> 
                                                                                                                <%

                                                                                                        String segment = "";
                                                                                                        try {
                                                                                                            if (crd.getSegment1Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment1Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment2Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment2Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment3Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment3Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment4Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment4Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment5Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment5Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment6Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment6Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment7Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment7Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment8Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment8Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment9Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment9Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment10Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment10Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment11Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment11Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment12Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment12Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment13Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment13Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment14Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment14Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (crd.getSegment15Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(crd.getSegment15Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                        }

                                                                                                        if (segment.length() > 0) {
                                                                                                            segment = segment.substring(0, segment.length() - 3);
                                                                                                        }
                                                                                                                %>
                                                                                                            <%=segment%></div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssName%>" nowrap > 
                                                                                                            <%if (cashReceive.getPostedStatus() == 1) {%>
                                                                                                            <%=c.getCode()%> 
                                                                                                            <%} else {%>
                                                                                                            <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%></a> 
                                                                                                            <%}%>
                                                                                                        &nbsp;-&nbsp; <%=c.getName()%> </td>                                                                                                       
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
                                                                                                        Currency xc = new Currency();
                                                                                                        try {
                                                                                                            xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                                                        } catch (Exception e) {
                                                                                                            System.out.println("[Exception] " + e.toString());
                                                                                                        }
                                                                                                                %>
                                                                                                            <%=xc.getCurrencyCode()%></div>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="<%=cssName%>"><div align="right"><%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> </div></td>                                                                                                        
                                                                                                        <td class="<%=cssName%>"><div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div></td>
                                                                                                        <td class="<%=cssName%>"><div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div></td>                                                                                                        
                                                                                                        <td class="<%=cssName%>"><%=crd.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%}
                }
            }
            if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCode > 0 || iErrCodeRec != 0) && recIdx == -1) && !(isSave && iErrCode == 0 && iErrCodeRec == 0) && (cashReceive.getPostedStatus() != 1)) {
                                                                                                    %>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablearialcell" >
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <%
                                                                                                    if (segments != null && segments.size() > 0) {
                                                                                                        for (int xx = 0; xx < segments.size(); xx++) {
                                                                                                            Segment seg = (Segment) segments.get(xx);
                                                                                                            Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);
                                                                                                                    %>
                                                                                                                    <tr> 
                                                                                                                        <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                                                        <td width="46%"> 
                                                                                                                            <select name="JSP_SEGMENT<%=xx + 1%>_ID_DETAIL">
                                                                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                                for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                    SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                    String selected = "";
                                                                                                                                    switch (xx + 1) {
                                                                                                                                        case 1:
                                                                                                                                            if (cashReceiveDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 2:
                                                                                                                                            if (cashReceiveDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 3:
                                                                                                                                            if (cashReceiveDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 4:
                                                                                                                                            if (cashReceiveDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 5:
                                                                                                                                            if (cashReceiveDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 6:
                                                                                                                                            if (cashReceiveDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 7:
                                                                                                                                            if (cashReceiveDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 8:
                                                                                                                                            if (cashReceiveDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 9:
                                                                                                                                            if (cashReceiveDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 10:
                                                                                                                                            if (cashReceiveDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 11:
                                                                                                                                            if (cashReceiveDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 12:
                                                                                                                                            if (cashReceiveDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 13:
                                                                                                                                            if (cashReceiveDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 14:
                                                                                                                                            if (cashReceiveDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 15:
                                                                                                                                            if (cashReceiveDetail.getSegment15Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
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
                                                                                                                    <%}
                                                                                                    }%>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell"> 
                                                                                                            <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_COA_ID]%>">
                                                                                                                <%if (incomeCoas != null && incomeCoas.size() > 0) {
                                                                                                        for (int x = 0; x < incomeCoas.size(); x++) {
                                                                                                            Coa coax = (Coa) incomeCoas.get(x);
                                                                                                            String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=coax.getOID()%>" <%if (cashReceiveDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                <%=getAccountRecursif(coax.getLevel() * -1, coax, cashReceiveDetail.getCoaId(), isPostableOnly)%> 
                                                                                                                <%}
                                                                                                    }%>
                                                                                                            </select>
                                                                                                        <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_COA_ID)%> </td>
                                                                                                        <td class="tablearialcell"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                                                                    <%if (currencies != null && currencies.size() > 0) {
                                                                                                        for (int x = 0; x < currencies.size(); x++) {
                                                                                                            Currency c = (Currency) currencies.get(x);
                                                                                                                    %>
                                                                                                                    <option value="<%=c.getOID()%>" <%if (cashReceiveDetail.getForeignCurrencyId() == c.getOID()) {%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                                                                                                    <%}
                                                                                                    }%>
                                                                                                                </select>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell"> 
                                                                                                            <div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()"><%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <input type="hidden" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getForeignCreditAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMeCredit()">
                                                                                                        <td class="tablecell"><div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getBookedRate(), "#,###.##")%>" style="text-align:right"  onBlur="javascript:cmdUpdateExchangeXX()" onClick="this.select()">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell"><div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <input type="hidden" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly><%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_CREDIT_AMOUNT) %>                                                                                                        
                                                                                                        <td class="tablearialcell"><div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>" size="30" value="<%=cashReceiveDetail.getMemo()%>"></div></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td colspan="2" height="15">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (cashReceive.getPostedStatus() == 0) {%>
                                                                                                    <tr>
                                                                                                        <td width="78%"> 
                                                                                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%if (iErrCodeRec == 0 || iErrCode != 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td>
                                                                                                                        <%
    if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeRec == 0) || (isSave && iErrCode == 0 && iErrCodeRec == 0)) {
        if (privAdd) {%>
                                                                                                                        <%if (iJSPCommand == JSPCommand.RESET) {%>
                                                                                                                        <table>                                                                                                                              
                                                                                                                            <tr><td><table border="0" cellpadding="5" cellspacing="0" class="success" align="right"><tr><td width="20"><img src="../images/success.gif" width="20" height="20"></td><td width="220" nowrap>Delete Success</td></tr></table></td></tr>    
                                                                                                                            <tr><td>&nbsp;</td></tr>     
                                                                                                                            <tr><td><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a></td></tr>
                                                                                                                        </table>    
                                                                                                                        <%} else {%>
                                                                                                                        <a href="javascript:cmdAdd('<%=cashReceive.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> 
                                                                                                                        <%}%>
                                                                                                                        <%
                                                                                                                            }
                                                                                                                        } else {

                                                                                                                            if (iJSPCommand == JSPCommand.SUBMIT) {
                                                                                                                                if (recIdx == -1) {
                                                                                                                                    iJSPCommand = JSPCommand.ADD;
                                                                                                                                } else {
                                                                                                                                    iJSPCommand = JSPCommand.EDIT;
                                                                                                                                }
                                                                                                                            }
                                                                                                                            ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                            ctrLine.initDefault();
                                                                                                                            ctrLine.setTableWidth("90%");
                                                                                                                            String scomDel = "javascript:cmdAsk('" + oidCashReceiveDetail + "')";
                                                                                                                            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCashReceiveDetail + "')";
                                                                                                                            String scancel = "javascript:cmdEdit('" + oidCashReceiveDetail + "','" + recIdx + "')";

                                                                                                                            if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {
                                                                                                                                ctrLine.setBackCaption("Cancel");
                                                                                                                            } else {
                                                                                                                                ctrLine.setBackCaption("");
                                                                                                                            }

                                                                                                                            ctrLine.setJSPCommandStyle("command");
                                                                                                                            ctrLine.setDeleteCaption("Delete");

                                                                                                                            ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                                                                            ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/savenew2.gif',1)");
                                                                                                                            ctrLine.setSaveImage("<img src=\"" + approot + "/images/savenew.gif\" name=\"save\" height=\"22\" border=\"0\">");

                                                                                                                            ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
                                                                                                                            ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

                                                                                                                            ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
                                                                                                                            ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

                                                                                                                            ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
                                                                                                                            ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");

                                                                                                                            ctrLine.setWidthAllJSPCommand("90");
                                                                                                                            ctrLine.setErrorStyle("warning");
                                                                                                                            ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
                                                                                                                            ctrLine.setQuestionStyle("warning");
                                                                                                                            ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
                                                                                                                            ctrLine.setInfoStyle("success");
                                                                                                                            ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

                                                                                                                            if (privDelete) {
                                                                                                                                ctrLine.setConfirmDelJSPCommand(sconDelCom);
                                                                                                                                ctrLine.setDeleteJSPCommand(scomDel);
                                                                                                                                ctrLine.setEditJSPCommand(scancel);
                                                                                                                            } else {
                                                                                                                                ctrLine.setConfirmDelCaption("");
                                                                                                                                ctrLine.setDeleteCaption("");
                                                                                                                                ctrLine.setEditCaption("");
                                                                                                                            }
                                                                                                                            if (privAdd == false && privUpdate == false) {
                                                                                                                                ctrLine.setSaveCaption("");
                                                                                                                            }
                                                                                                                            if (privAdd == false) {
                                                                                                                                ctrLine.setAddCaption("");
                                                                                                                            }
                                                                                                                        %>
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <%if (submit && (iErrCode != 0 || iErrCodeRec != 0)) {%>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="warning"><tr><td width="20"><img src="../images/error.gif" width="20" height="20"></td><td width="300" nowrap><%=msgString%></td></tr></table>
                                                                                                                                </td>
                                                                                                                            </tr>    
                                                                                                                            <%}%>
                                                                                                                            <tr><td><%=ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%></td></tr>    
                                                                                                                        </table>    
                                                                                                                        <%} %>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%} else {%>
                                                                                                                <tr> 
                                                                                                                    <td align="left"> 
                                                                                                                        <%if (privUpdate || privAdd) {%>                                                                                                                        
                                                                                                                        <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savenew2.gif',1)"><img src="../images/savenew.gif" name="savedoc21" height="22" border="0" width="116"></a>                                                                                                                        
                                                                                                                        <% }%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr><td>&nbsp;</td></tr>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table border="0" cellpadding="2" cellspacing="0" class="warning" width="293" align="left">
                                                                                                                            <tr>
                                                                                                                                <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                                                                                <td width="253" nowrap><%=msgStringRec%></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td class="boxed1" width="22%"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="36%"><div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div></td>
                                                                                                                    <td width="64%"><div align="right"><b><%balance = cashReceive.getAmount() - totalDetail;%><input type="hidden" name="total_detail" value="<%=totalDetail%>"><%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" height="15">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top">
                                                                                                        <td height="1" valign="middle" colspan="2" width="100%"><table width="99%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr></table></td>
                                                                                                    </tr>
                                                                                                    <%}
            if (((submit && iErrCode == 0 && iErrCodeRec == 0) || (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0)) && cashReceive.getPostedStatus() != 1) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td colspan="2"> 
                                                                                                            <table border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr>
                                                                                                                    <td width="100">
                                                                                                                        <div onclick="this.style.visibility='hidden'">
                                                                                                                            <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a>
                                                                                                                        </div>
                                                                                                                    </td> 
                                                                                                                    <%if (cashReceive.getOID() != 0) {%>
                                                                                                                    <td width="120"><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="newdox" height="22" border="0"></a></td>
                                                                                                                    <td width="100"><a href="javascript:cmdPrintJournal('<%=cashReceive.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printdoc2.gif',1)"><img src="../images/printdoc.gif" name="print" width="112" border="0"></a></td>                                                                                                                    
                                                                                                                    <%}%>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                        
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                    
                                                                            <%if (cashReceive.getOID() != 0 || (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0)) {%>   
                                                                            <tr align="left" valign="top">
                                                                                <td height="6"></td>
                                                                            </tr>                                                                                                                                                     
                                                                            <tr align="left" valign="top"><td height="6"></td></tr>  
                                                                            <%if (cashReceive.getPostedStatus() == 1) {%>
                                                                            <tr align="right" valign="top">
                                                                                <td valign="middle" class="container"> 
                                                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr>
                                                                                            <td width="50%">
                                                                                                <a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="newdox" height="22" border="0"></a>
                                                                                                &nbsp;&nbsp;<a href="javascript:cmdPrintJournal('<%=cashReceive.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printdoc2.gif',1)"><img src="../images/printdoc.gif" name="print" width="112"  border="0"></a>
                                                                                            </td>
                                                                                            <td width="50%">
                                                                                                <table  cellpadding="0" cellspacing="5" align="right" class="success">
                                                                                                    <tr>
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" ></td>
                                                                                                        <td width="50" class="fontarial"><b>Posted</b></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr>                                                                                 
                                                                            <%}%>
                                                                            
                                                                            <%}%>
                                                                            <tr align="left" valign="top">
                                                                                <td height="6" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <%if (oidCashReceive != 0 && strApproval.equalsIgnoreCase("Y")) {%>
                                                                            <tr valign="top">                                                                                 
                                                                                <td colspan="3">
                                                                                    <%
    Vector temp = DbApprovalDoc.getDocApproval(oidCashReceive);

                                                                                    %>
                                                                                    <table width="800" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="7" height="20"><b><%=langApp[0].toUpperCase()%></b> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td><td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td>
                                                                                            <td width="18%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td><td width="11%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                            <td width="9%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td><td width="27%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td>
                                                                                            <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                                                                                        <%
    if (temp != null && temp.size() > 0) {
        Employee userEmp = new Employee();
        try {
            userEmp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }
        for (int i = 0; i < temp.size(); i++) {

            ApprovalDoc apd = (ApprovalDoc) temp.get(i);
            String tanggal = "";
            String status = "";
            String catatan = (apd.getNotes() == null) ? "" : apd.getNotes();
            String nama = "";
            Employee employee = new Employee();
            try {
                employee = DbEmployee.fetchExc(apd.getEmployeeId());
            } catch (Exception e) {
            }

            Department dep = new Department();
            try {
                dep = DbDepartment.fetchExc(employee.getDepartmentId());
            } catch (Exception e) {
            }

            Approval app = new Approval();
            try {
                app = DbApproval.fetchExc(apd.getApprovalId());
            } catch (Exception e) {
            }

            if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED || apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {
                tanggal = JSPFormater.formatDate(apd.getApproveDate(), "dd/MM/yyyy");
                status = DbApprovalDoc.strStatus[apd.getStatus()];
                nama = employee.getName();
            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="11%"><%=apd.getSequence()%></td><td width="13%"><%=employee.getPosition()%></td><td width="20%"><%=nama%></td><td width="13%"><%=tanggal%></td><td width="11%"><%=status%></td>
                                                                                            <td width="20%"> 
                                                                                                <%if (cashReceive.getPostedStatus() == 0) {
                                                                                                    if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED && user.getEmployeeId() == apd.getEmployeeId()) {%>
                                                                                                <div align="center"><input type="text" name="approval_doc_note" size="30" value="<%=catatan%>"></div>
                                                                                                <%} else if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {%>
                                                                                                <div align="center"><input type="text" name="approval_doc_note" size="30" value="<%=catatan%>"></div>
                                                                                                <%} else {%>
                                                                                                <%=catatan%> 
                                                                                                <%}
} else {%>
                                                                                                <%=catatan%> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="12%"> 
                                                                                                <%if (cashReceive.getPostedStatus() == 0) {%>
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td> 
                                                                                                            <%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                                                                                            %>
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr>
                                                                                                                        <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save1','','../images/success-2.gif',1)" alt="Klik : Untuk Menyetujui Dokumen"><img src="../images/success.gif" name="save1" height="20" border="0"></a></div></td>
                                                                                                                        <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no3','','../images/no1.gif',1)" alt="Klik : Untuk tidak menyetujui"><img src="../images/no.gif" name="no3" height="20" border="0"></a></div></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                            <% }
} else {
    if (user.getEmployeeId() == apd.getEmployeeId()) {
        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                                                                                                            %>
                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no','','../images/no1.gif',1)" alt="Klik : Untuk Membatalkan Persetujuan"><img src="../images/no.gif" name="no" height="20" border="0"></a></div>
                                                                                                            <%} else {%>
                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2','','../images/success-2.gif',1)" alt="Klik : Untuk Melakukan Persetujuan"><img src="../images/success.gif" name="save2" height="20" border="0"></a>                                                                                                                
                                                                                                            </div>
                                                                                                            <%}
        }
    }%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%} else {%>
                                                                                                &nbsp; 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%}
    }%>                                                                                        
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr> 
                                                                            <%}%>
                                                                             <%if (cashReceive.getOID() != 0) {
                                                                                String name = "-";
                                                                                String date = "";
                                                                                try{
                                                                                    User u = DbUser.fetch(cashReceive.getOperatorId());
                                                                                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                    name = e.getName();
                                                                                }catch(Exception e){}
                                                                                try{
                                                                                    date = JSPFormater.formatDate(cashReceive.getDate(),"dd MMM yyyy");
                                                                                }catch(Exception e){}
                                                                                
                                                                                
                                                                                String postedName = "";
                                                                                String postedDate = "";
                                                                                try{
                                                                                    User u = DbUser.fetch(cashReceive.getPostedById());
                                                                                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                                                                                    postedName = e.getName();
                                                                                }catch(Exception e){}
                                                                                try{
                                                                                    if(cashReceive.getPostedDate() != null){
                                                                                        postedDate = JSPFormater.formatDate(cashReceive.getPostedDate(),"dd MMM yyyy");
                                                                                    }
                                                                                }catch(Exception e){postedDate= "";}
                                                                            %>
                                                                            <tr>
                                                                                <td height="30">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="3" height="20"><b><i><%=langApp[0]%></i></b> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="100" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>                                                                                              
                                                                                            <td height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="100" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="20" ><font size="1">Create By</font></td>                                                                                              
                                                                                            <td height="20" ><font size="1"><%=name%></font></td>
                                                                                            <td height="20" nowrap><font size="1"><%=date%></font></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="20" ><font size="1">Posted By</font></td>                                                                                              
                                                                                            <td height="20" ><font size="1"><%=postedName%></font></td>
                                                                                            <td height="20" nowrap><font size="1"><%=postedDate%></font></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                                <tr>
                                                                    <td colspan="3" class="command">&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (iErrCode != 0 || iJSPCommand == JSPCommand.ADD) {%>
                                                                cmdUpdateExchange();
                                                                <%}%>                                                           
                                                            </script>
                                                        </form>
                                                    <!-- #EndEditable --> </td>
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
