
<%-- 
    Document   : bankdepositdetail-det
    Created on : Feb 16, 2012, 10:11:37 AM
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
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
    boolean privView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_APPROVE_BKM, AppMenu.PRIV_VIEW);
    boolean privUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_APPROVE_BKM, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
    public Vector addNewDetail(Vector listBankDepositDetail, BankDepositDetail bankDepositDetail) {
        boolean found = false;
        if (listBankDepositDetail != null && listBankDepositDetail.size() > 0) {
            for (int i = 0; i < listBankDepositDetail.size(); i++) {
                BankDepositDetail bd = (BankDepositDetail) listBankDepositDetail.get(i);
                if (bd.getCoaId() == bankDepositDetail.getCoaId() && bd.getForeignCurrencyId() == bankDepositDetail.getForeignCurrencyId()) {
                    bd.setForeignAmount(bd.getForeignAmount() + bankDepositDetail.getForeignAmount());
                    bd.setAmount(bd.getAmount() + bankDepositDetail.getAmount());
                    found = true;
                }
            }
        }
        if (!found) { listBankDepositDetail.add(bankDepositDetail); }

        return listBankDepositDetail;
    }

    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                BankDepositDetail bdd = (BankDepositDetail) listx.get(i);
                result = result + bdd.getAmount();
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
                "Receipt From", "Currency", "Code", "Amount", "Booked Rate", "Amount in", "Description", //6-12
                "Cash Received document is ready to be saved", "Cash Receive document has been saved successfully", "Search Journal Number", "Customer", "Search Advance"}; //13-17

            String[] langNav = {"Cash", "Cash Receive", "Date", "SEARCHING", "CASH RECEIVE FORM", "required"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {

                String[] langID = {"Diterima Pada", "Diterima Dari", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Dari Perkiraan", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan",//6-12
                    "Dokumen Penerimaan Tunai siap untuk disimpan", "Dokumen Penerimaan Tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Konsumen", "Cari Kasbon"}; //13-17

                langCT = langID;
                String[] navID = {"Home", "Bank Deposit", "Tanggal", "PENCARIAN", "BANK DEPOSIT", "Data harus diisi"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBankDeposit = JSPRequestValue.requestLong(request, "hidden_bank_deposit_id");
            long oidBankDepositDetail = JSPRequestValue.requestLong(request, "hidden_bank_deposit_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("BANK_DETAIL");
                oidBankDeposit = 0;
                recIdx = -1;
            }

            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";

            boolean isLoad = false;
            long referensi_id = 0;

            if (iJSPCommand == JSPCommand.REFRESH) {
                session.removeValue("BANK_DETAIL");
                oidBankDeposit = JSPRequestValue.requestLong(request, "bank_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdBankDeposit ctrlBankDeposit = new CmdBankDeposit(request);
            JSPLine ctrLine = new JSPLine();

            int iErrCodeRec = ctrlBankDeposit.action(iJSPCommand, oidBankDeposit);

            JspBankDeposit jspBankDeposit = ctrlBankDeposit.getForm();

            int vectSize = DbBankDeposit.getCount(whereClause);

            BankDeposit bankDeposit = ctrlBankDeposit.getBankDeposit();

            String msgStringRec = ctrlBankDeposit.getMessage();

            if (oidBankDeposit == 0) {
                oidBankDeposit = bankDeposit.getOID();
            }

            if (oidBankDeposit != 0) {
                try {
                    bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
                } catch (Exception e) {}
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankDeposit.actionList(iJSPCommand, start, vectSize, recordToGet);
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

            CmdBankDepositDetail ctrlBankDepositDetail = new CmdBankDepositDetail(request);

            Vector listBankDepositDetail = new Vector(1, 1);
            
            listBankDepositDetail = DbBankDepositDetail.list(0, 0, DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] + "=" + bankDeposit.getOID(), null);

            iErrCode = ctrlBankDepositDetail.action(iJSPCommand, oidBankDepositDetail);

            JspBankDepositDetail jspBankDepositDetail = ctrlBankDepositDetail.getForm();

            vectSize = DbBankDepositDetail.getCount(whereClause);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankDepositDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            BankDepositDetail bankDepositDetail = ctrlBankDepositDetail.getBankDepositDetail();
            msgString = ctrlBankDepositDetail.getMessage();

            boolean submit = false;

            if (iJSPCommand == JSPCommand.SUBMIT) {

                submit = true;
                if (iErrCode == 0 && iErrCodeRec == 0) {
                    if (recIdx == -1) {
                        listBankDepositDetail.add(bankDepositDetail);
                    } else {
                        BankDepositDetail bdd = (BankDepositDetail) listBankDepositDetail.get(recIdx);
                        bankDepositDetail.setOID(bdd.getOID());
                        listBankDepositDetail.set(recIdx, bankDepositDetail);
                    }
                }
            }

            if (iJSPCommand == JSPCommand.DELETE) {
                try {
                    BankDepositDetail crdd = (BankDepositDetail) listBankDepositDetail.get(recIdx);
                    DbBankDepositDetail.deleteExc(crdd.getOID());
                    listBankDepositDetail.remove(recIdx);
                } catch (Exception e) {}
            }

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE){
                if (bankDeposit.getOID() != 0) {
                    DbBankDepositDetail.saveAllDetail(bankDeposit, listBankDepositDetail);
                    listBankDepositDetail = DbBankDepositDetail.list(0, 0, "cash_receive_id=" + bankDeposit.getOID(), "");
                    isSave = true;
                }
            }

            session.putValue("BANK_DETAIL", listBankDepositDetail);
            Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_CASH_CREDIT, sysLocation.getOID());
            Vector currencies = DbCurrency.list(0, 0, "", "");
            ExchangeRate eRate = DbExchangeRate.getStandardRate();
            double balance = 0;
            double totalDetail = getTotalDetail(listBankDepositDetail);
            //bankDeposit.setAmount(totalDetail);

            if (iJSPCommand == JSPCommand.RESET && iErrCodeRec == 0) {
                totalDetail = 0;
                bankDeposit = new BankDeposit();
                listBankDepositDetail = new Vector();
                session.removeValue("BANK_DETAIL");
            }

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeRec == 0 && recIdx == -1) {
                iJSPCommand = JSPCommand.ADD;
                bankDepositDetail = new BankDepositDetail();
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_CASH + "'", "");
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
            <%if (!privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdApproval(apdid, status){
                if(parseInt(status)==1){
                    if(confirm("Anda yakin menyetujui dokumen ini ? ")){
                        document.frmbankdepositdetail.approval_doc_id.value=apdid;
                        document.frmbankdepositdetail.approval_doc_status.value=status;
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.SUBMIT%>";
                        document.frmbankdepositdetail.action="<%=approot%>/home.jsp";
                        document.frmbankdepositdetail.submit();
                    }				
                }
                else{
                    if(confirm("Anda yakin membatalkan persetujuan dokumen ini ? ")){
                        document.frmbankdepositdetail.approval_doc_id.value=apdid;
                        document.frmbankdepositdetail.approval_doc_status.value=status;
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.SUBMIT%>";
                        document.frmbankdepositdetail.action="<%=approot%>/home.jsp";
                        document.frmbankdepositdetail.submit();
                    }
                }
            }
            
            function cmdSearchJurnal(){
                window.open("<%=approot%>/transaction/s_nomorjurnal.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function cmdSearchKasbon(){
                    window.open("<%=approot%>/transaction/s_nomorkasbon.jsp?formName=frmbankdepositdetail&txt_Id=referensi_id&txt_Name=referensi_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }    
                    
                    function cmdClickMe(){
                        var x = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;	
                        document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.select();
                    }
                    
                    function cmdFixing(){	
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.POST%>";
                        document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                        document.frmbankdepositdetail.submit();	
                    }
                    
                    function cmdNewJournal(){	
                        document.frmbankdepositdetail.hidden_bank_deposit_id.value="0";
                        document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value="0";
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.NONE%>";
                        document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                        document.frmbankdepositdetail.submit();	
                    }
                    
                    function cmdAdd(cashReceiveId){	
                        document.frmbankdepositdetail.hidden_bank_deposit_id.value=cashReceiveId;
                        document.frmbankdepositdetail.select_idx.value="-1";
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.ADD%>";
                        document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                        document.frmbankdepositdetail.submit();	
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
                            }
                            else{
                                if(xx==',' || xx=='.'){
                                    result = result + xx;
                                }
                            }
                        }
                        
                        return result;
                    }
                    
                    function checkNumber(){
                        var st = document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>.value;		                        
                        result = removeChar(st);                        
                        result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    }
                    
                    function checkNumber2(){
                        
                        var main = document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value;		
                        main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        var currTotal = document.frmbankdepositdetail.total_detail.value;
                        currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
                        var idx = document.frmbankdepositdetail.select_idx.value;		
                        var booked = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_BOOKED_RATE]%>.value;		
                        booked = cleanNumberFloat(booked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        
                        var st = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_AMOUNT]%>.value;		
                        result = removeChar(st);	
                        result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        var result2 = 0;
                        
                        if(parseFloat(idx)<0){                            
                            var amount = parseFloat(currTotal) + parseFloat(result);
                            document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);         
                        }else{
                        var editAmount =  document.frmbankdepositdetail.edit_amount.value;
                        var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
                        document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);              
                    }
                }
                
                function cmdUpdateExchange(){
                    var idCurr = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
                    
         <%if (currencies != null && currencies.size() > 0) {
                for (int i = 0; i < currencies.size(); i++) {
                    Currency cx = (Currency) currencies.get(i);
         %>
             if(idCurr=='<%=cx.getOID()%>'){
                 <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                 document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
                 <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                 document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                 document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 <%}%>
             }	
         <%}
            }%>            
            var famount = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;            
            famount = removeChar(famount);
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            var fbooked = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value;
            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            if(!isNaN(famount)){
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            }            
            checkNumber2();
        }
        
        
        function cmdAsking(oidBankDeposit){            
            var cfrm = confirm('Are you sure you want to delete ?');            
            if( cfrm==true){
                document.frmbankdepositdetail.select_idx.value=-1;
                document.frmbankdepositdetail.hidden_bank_deposit_id.value=oidBankDeposit;
                document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=0;
                document.frmbankdepositdetail.command.value="<%=JSPCommand.RESET%>";
                document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                document.frmbankdepositdetail.submit();
            }
        }        
        
        function cmdAsk(oidBankDepositDetail){
            document.frmbankdepositdetail.select_idx.value=oidBankDepositDetail;
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.ASK%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdConfirmDelete(oidBankDepositDetail){
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.DELETE%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdSave(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdSubmitCommand(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.SAVE%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdEdit(oidBankDepositDetail){
            document.frmbankdepositdetail.select_idx.value=oidBankDepositDetail;
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdCancel(oidBankDepositDetail){
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdNone(){	
            document.frmbankdepositdetail.hidden_bank_deposit_id.value="0";
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value="0";
            document.frmbankdepositdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdBack(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.BACK%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdListFirst(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.FIRST%>";
            document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdListPrev(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.PREV%>";
            document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdListNext(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.NEXT%>";
            document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdListLast(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.LAST%>";
            document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdDelPict(oidBankDepositDetail){
            document.frmimage.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="bankdepositdetail.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/savedoc2.gif','../images/no1.gif','../images/success1.gif','../images/back2.gif')">
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
            String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                        %>
                                                        <%@ include file="../main/navigator.jsp"%>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmbankdepositdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_bank_deposit_detail_id" value="<%=oidBankDepositDetail%>">
                                                            <input type="hidden" name="hidden_bank_deposit_id" value="<%=oidBankDeposit%>">
                                                            <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="approval_doc_id" value="">
                                                            <input type="hidden" name="approval_doc_status" value="">
                                                            <input type="hidden" name="preview_type" value="<%=previewType%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" width="1%">&nbsp;</td>
                                                                                <td height="8" valign="top" colspan="3" width="99%"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="3" height="23"><font face = "arial" font="2"><b><u><%=langNav[4]%></u></b></font></td>
                                                                                                        <td width="9%" height="23">&nbsp;</td>
                                                                                                        <td width="55%" height="23">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="5"></td>
                                                                                                    </tr>                                                                                                   
                                                                                                    <tr> 
                                                                                                        <td height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[4]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"> <%=bankDeposit.getJournalNumber()%> 
                                                                                                            <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_NUMBER]%>">
                                                                                                            <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_COUNTER]%>">
                                                                                                            <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_PREFIX]%>">
                                                                                                        </td>
                                                                                                        <td width="12%"><%=langCT[5]%></td>
                                                                                                        <td width="42%"><table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr> 
                                                                                                                    <td> <%=JSPFormater.formatDate((bankDeposit.getTransDate() == null) ? new Date() : bankDeposit.getTransDate(), "dd/MM/yyyy")%> </td>
                                                                                                                    <td valign="top">&nbsp;<%=jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_TRANS_DATE) %></td>
                                                                                                                </tr>
                                                                                                            </table></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[0]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"> 
                                                                                                            <%

            Coa coa = new Coa();

            try {
                coa = DbCoa.fetchExc(bankDeposit.getCoaId());
            } catch (Exception e) {
                System.out.println("Exception " + e.toString());
            }
                                                                                                            %>
                                                                                                        <%=coa.getCode() + " - " + coa.getName()%> </td>
                                                                                                        <td width="12%"><%=langCT[16]%></td>
                                                                                                        <td width="42%"><%

            Customer cus = new Customer();
            try {
                cus = DbCustomer.fetchExc(bankDeposit.getCustomerId());
            } catch (Exception e) {}
                                                                                                            %>
                                                                                                        <%=cus.getName()%> </td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="10%" valign="top"><%=langCT[3]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td colspan="3"> 
                                                                                                            <table cellpadding="0" cellspacing="0">
                                                                                                                <tr> 
                                                                                                                    <td> <%=bankDeposit.getMemo()%> </td>
                                                                                                                    <td valign = "top">&nbsp;&nbsp; 
                                                                                                                    <%= jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_MEMO) %> </td>
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
                                                                                <td height="20" valign="middle" width="1%" class="comment">&nbsp;</td>
                                                                                <td height="20" valign="middle" colspan="3" class="comment" width="99%">&nbsp;</td>
                                                                            </tr>
                                                                            <%

                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td  valign="middle" width="1%">&nbsp;</td>
                                                                                <td  valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td class="boxed1"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td rowspan="2" class="tablehdr" nowrap width="10%"><%=langCT[6]%></td>
                                                                                                        <td colspan="2" class="tablehdr"><%=langCT[7]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="12%"><%=langCT[10]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="13%"><%=langCT[11]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="46%"><%=langCT[12]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%" class="tablehdr"><%=langCT[8]%></td>
                                                                                                        <td width="13%" class="tablehdr"><%=langCT[9]%></td>
                                                                                                    </tr>
                                                                                                    <%
            int idx = -1;

            if (listBankDepositDetail != null && listBankDepositDetail.size() > 0) {

                for (int i = 0; i < listBankDepositDetail.size(); i++) {

                    BankDepositDetail bdd = (BankDepositDetail) listBankDepositDetail.get(i);
                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(bdd.getCoaId());
                    } catch (Exception e) {}

                    if (bdd.getOID() == oidBankDepositDetail) {
                        idx = i;
                    }

                    String cssName = "tablecell";
                    if (i % 2 != 0) {
                        cssName = "tablecell1";
                    }

                                                                                                    %>
                                                                                                    <%

                                                                                                            if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td class="<%=cssName%>" nowrap width="10%"> 
                                                                                                        <%=c.getCode()%> &nbsp;-&nbsp; <%=c.getName()%> </td>
                                                                                                        <td width="6%" class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
                                                                                                                                                                                                                    Currency xc = new Currency();
                                                                                                                                                                                                                    try {
                                                                                                                                                                                                                        xc = DbCurrency.fetchExc(bdd.getForeignCurrencyId());
                                                                                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                                                                                        System.out.println("[Exception] " + e.toString());
                                                                                                                                                                                                                    }
                                                                                                                %>
                                                                                                            <%=xc.getCurrencyCode()%></div>
                                                                                                        </td>
                                                                                                        <%  
                                                                                                        String famount = "";
                                                                                                        
                                                                                                        if(bdd.getAmount() == 0){
                                                                                                            famount = "("+JSPFormater.formatNumber(bdd.getForeignCreditAmount(), "#,###.##")+")";
                                                                                                        }else{
                                                                                                            famount = JSPFormater.formatNumber(bdd.getForeignAmount(), "#,###.##");
                                                                                                        }
                                                                                                        %>
                                                                                                        <td width="13%" class="<%=cssName%>"> 
                                                                                                            <div align="right"><%=famount%></div>
                                                                                                        </td>
                                                                                                        <td width="12%" class="<%=cssName%>"> 
                                                                                                            <div align="right"> <%=JSPFormater.formatNumber(bdd.getBookedRate(), "#,###.##")%> </div>
                                                                                                        </td>
                                                                                                        <%  
                                                                                                        String amount = "";
                                                                                                        
                                                                                                        if(bdd.getAmount() == 0){
                                                                                                            amount = "("+JSPFormater.formatNumber(bdd.getCreditAmount(), "#,###.##")+")";
                                                                                                        }else{
                                                                                                            amount = JSPFormater.formatNumber(bdd.getAmount(), "#,###.##");
                                                                                                        }
                                                                                                        %>
                                                                                                        <td width="13%" class="<%=cssName%>"> 
                                                                                                            <div align="right"><%=amount%></div>
                                                                                                        </td>
                                                                                                        <td width="46%" class="<%=cssName%>"><%=bdd.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%}
                }
            }

                                                                                                    %>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td colspan="2" height="15">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (bankDeposit.getPostedStatus() == 0) {%>
                                                                                                    <tr> 
                                                                                                        <td width="78%">&nbsp;</td>
                                                                                                        <td class="boxed1" width="22%"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="36%"> 
                                                                                                                        <div align="left"><b>Total 
                                                                                                                        <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                                                                    </td>
                                                                                                                    <td width="64%"> 
                                                                                                                        <div align="right"><b> 
                                                                                                                                <%
    balance = bankDeposit.getAmount() - totalDetail;
                                                                                                                                %>
                                                                                                                                <input type="hidden" name="total_detail" value="<%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%>">
                                                                                                                        <%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></b></div>
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
                                                                                </td>
                                                                            </tr>
                                                                            <%if (bankDeposit.getOID() != 0 || (listBankDepositDetail != null && listBankDepositDetail.size() > 0)) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="1%">&nbsp;</td>
                                                                                <td valign="middle" colspan="3" width="99%"> 
                                                                                    <%
    Vector temp = DbApprovalDoc.getDocApproval(oidBankDeposit);
    
    int totCancel = 0;
    try {
        totCancel = DbApprovalDoc.listTotalDocCancel(oidBankDeposit);
    } catch (Exception e) {
    }

    ApprovalDoc appX = new ApprovalDoc();
    try {
        appX = DbApprovalDoc.listPersonCancel(oidBankDeposit);
    } catch (Exception e) {
    }

    ApprovalDoc appLast = new ApprovalDoc();
    try {
        appLast = DbApprovalDoc.lastApp(oidBankDeposit);
    } catch (Exception e) {
    }
    
%>
                                                                                    <table width="700" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="7" height="20"><font face="arial"><b><%=langApp[0].toUpperCase()%></b></font></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="11%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td>
                                                                                            <td width="13%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td>
                                                                                            <td width="20%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="13%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                            <td width="11%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>
                                                                                            <td width="20%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td>
                                                                                            <td width="12%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
    if (temp != null && temp.size() > 0) {

        Employee userEmp = new Employee();
        try {
            userEmp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }
        boolean approved = false;
        for (int i = 0; i < temp.size(); i++) {

            ApprovalDoc apd = (ApprovalDoc) temp.get(i);
            
            if (i == 0) {
                approved = true;
            }

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
                                                                                            <td ><%=(i + 1)%></td>
                                                                                            <td nowrap><%=employee.getPosition()%></td>
                                                                                            <td nowrap><%=nama%></td>
                                                                                            <td ><%=tanggal%></td>
                                                                                            <td >
                                                                                                <%if (apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {%>
                                                                                                <font color = "FF0000"><%=status%></font>
                                                                                                <%} else {%>
                                                                                                <%=status%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td > 
                                                                                                <%if (totCancel > 0) { //jika dicancel %>
                                                                                                <%if (appX.getEmployeeId() == user.getEmployeeId() && apd.getEmployeeId() == user.getEmployeeId()) {%>
                                                                                                <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                                                                                                <%}%>
                                                                                                
                                                                                                <%} else {%>
                                                                                                
                                                                                                <%if (apd.getStatus() != DbApprovalDoc.STATUS_APPROVED) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition()) && approved) {%>
                                                                                                <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                                                                                                <%}%>         
                                                                                                <%} else {%>
                                                                                                
                                                                                                <%if (appLast != null && appLast.getEmployeeId() == user.getEmployeeId() && apd.getEmployeeId() == user.getEmployeeId()) {%>
                                                                                                <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">                                    
                                                                                                <%}%>     
                                                                                                <%}%>         
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td > 
                                                                                                <%if (totCancel > 0) { //jika dicancel %>
                                                                                                <%if (appX.getEmployeeId() == user.getEmployeeId() && apd.getEmployeeId() == user.getEmployeeId()) {%>
                                                                                                <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21<%=i%>','','../images/success1.gif',1)"><img src="../images/success.gif" name="new21<%=i%>"  border="0" alt="Klik untuk menyetujui dokumen"></a></div>                            
                                                                                                <%}%>
                                                                                                
                                                                                                <%} else {%>
                                                                                                
                                                                                                <%if (apd.getStatus() != DbApprovalDoc.STATUS_APPROVED) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition()) && approved) {
                                                                                                %>
                                                                                                <div align="left"> 
                                                                                                <table border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr> 
                                                                                                                        <td> 
                                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21<%=i%>','','../images/success1.gif',1)"><img src="../images/success.gif" name="new21<%=i%>"  border="0" alt="Klik untuk menyetujui dokumen"></a></div>
                                                                                                                        </td>
                                                                                                                        <td> 
                                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no21x<%=i%>','','../images/no1.gif',1)"><img src="../images/no.gif" name="no21x<%=i%>" border="0"  alt="Klik untuk TIDAK menyetujui dokumen"></a></div>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                                </div>
                                                                                                <%}%>         
                                                                                                <%} else {%>
                                                                                                
                                                                                                <%if (appLast != null && appLast.getEmployeeId() == user.getEmployeeId() && apd.getEmployeeId() == user.getEmployeeId()) {%>
                                                                                                <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no21x<%=i%>','','../images/no1.gif',1)"><img src="../images/no.gif" name="no21x<%=i%>1" border="0"  alt="Klik untuk TIDAK menyetujui dokumen"></a></div>
                                                                                                
                                                                                                <%}%>     
                                                                                                <%}%>         
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
        if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
                approved = false;
            }
        
        }
    }%>
                                                                                        <tr> 
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                            <td >&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="8" colspan="3" class="container"><a href="<%=approot%>/home.jsp?preview_type=<%=previewType%>"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" border="0"  alt="Kembali ke lembar kerja anda"></a></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td colspan="3" class="command">&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">							
                                                                <%if (iErrCode != 0 || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT) {%>                                                                
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
