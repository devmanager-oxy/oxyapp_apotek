
<%-- 
    Document   : pelunasanbankproses
    Created on : Jul 4, 2011, 9:43:03 AM
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BC, AppMenu.PRIV_DELETE);
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

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBankPoPayment = JSPRequestValue.requestLong(request, "hidden_bank_po_payment_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("PPPAYMENT_DETAIL");
                recIdx = -1;
            }

            BankpoPayment objBankpoPayment = new BankpoPayment();

            if (oidBankPoPayment != 0 && iJSPCommand == JSPCommand.SAVE) {

                objBankpoPayment = DbBankpoPayment.fetchExc(oidBankPoPayment);
                objBankpoPayment.setStatus(DbBankpoPayment.STATUS_PAID);

                try {
                    DbBankpoPayment.updateExc(objBankpoPayment);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                oidBankPoPayment = 0;

            }

            BankpoPayment bankpoPayment = new BankpoPayment();

            CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);

            JspBankpoPayment jspBankpoPayment = ctrlBankpoPayment.getForm();

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {

                jspBankpoPayment.requestEntityObject(bankpoPayment);

                bankpoPayment.setOID(0);
                bankpoPayment.setJournalNumber(objBankpoPayment.getJournalNumber() + "B");
                bankpoPayment.setJournalPrefix(objBankpoPayment.getJournalPrefix());
                bankpoPayment.setJournalCounter(objBankpoPayment.getJournalCounter());
                bankpoPayment.setDate(objBankpoPayment.getDate());
                bankpoPayment.setStatus(DbBankpoPayment.STATUS_PAID);
                isSave = true;

                try {

                    oidBankPoPayment = DbBankpoPayment.insertExc(bankpoPayment);
                    bankpoPayment = DbBankpoPayment.fetchExc(oidBankPoPayment);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }

            if (iJSPCommand != JSPCommand.SAVE) {
                bankpoPayment = DbBankpoPayment.fetchExc(oidBankPoPayment);
            }

            /*variable declaration*/

            int iErrCode = JSPMessage.NONE;
            String whereClause = DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER] + "='" + bankpoPayment.getJournalNumber() + "'";

            /*switch statement */
            int iErrCodeMain = JSPMessage.NONE;

            /*count list All PettycashPayment*/
            int vectSize = DbPettycashPayment.getCount(whereClause);
%>

<%
//bagian DETAIL

            long oidBankpoPaymentDetail = JSPRequestValue.requestLong(request, "hidden_bank_po_payment_detail_id");

            CmdBankpoPaymentDetail ctrlBankpoPaymentDetail = new CmdBankpoPaymentDetail(request);

            iErrCode = ctrlBankpoPaymentDetail.action(iJSPCommand, oidBankpoPaymentDetail);
            /* end switch*/
            JspBankpoPaymentDetail jspBankpoPaymentDetail = ctrlBankpoPaymentDetail.getForm();

            BankpoPaymentDetail dataBankpoPaymentDetail = new BankpoPaymentDetail();

            try {

                dataBankpoPaymentDetail.setBankpoPaymentId(oidBankPoPayment);
                dataBankpoPaymentDetail.setCoaId(bankpoPayment.getCoaId());
                dataBankpoPaymentDetail.setCurrencyId(bankpoPayment.getCurrencyId());
                dataBankpoPaymentDetail.setMemo(bankpoPayment.getMemo());
                dataBankpoPaymentDetail.setInvoiceId(0);

            } catch (Exception e) {
                System.out.println("[exception ]" + e.toString());
            }

            /*variable declaration*/

            Vector listBankpoPaymentDetail = new Vector(1, 1);

            listBankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment.getOID(), null);

            /* end switch*/

            BankpoPaymentDetail bankpoPaymentDetail = ctrlBankpoPaymentDetail.getBankpoPaymentDetail();

            if (session.getValue("PPPAYMENT_DETAIL") != null) {
                listBankpoPaymentDetail = (Vector) session.getValue("PPPAYMENT_DETAIL");
            }

            if (iJSPCommand == JSPCommand.SAVE) {

                if (bankpoPayment.getOID() != 0) {

                    try {

                        jspBankpoPaymentDetail.requestEntityObject(bankpoPaymentDetail);
                        bankpoPaymentDetail.setBankpoPaymentId(bankpoPayment.getOID());

                        DbBankpoPaymentDetail.insertExc(bankpoPaymentDetail);

                        listBankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, "" + DbPettycashPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment.getOID(), "");

                        DbBankpoPayment.postJournalPembelianTunai(bankpoPayment, user.getOID());

                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
                iJSPCommand = JSPCommand.ADD;
            }

            session.putValue("PPPAYMENT_DETAIL", listBankpoPaymentDetail);

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT + "'", "");

            Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

            double balance = 0;
            double totalDetail = getTotalDetail(listBankpoPaymentDetail);

            bankpoPayment.setAmount(totalDetail);

            String whereDep = "";

            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            /*** LANG ***/
            String[] langCT = {"Receipt to Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Account - Description", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully", "Search Journal Number", "Paid"}; //10-13

            String[] langNav = {"Petty Cash", "Cash Payment", "Date"};

            if (lang == LANG_ID) {

                String[] langID = {"Perkiraan", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Perkiraan", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Paid"}; //10-13
                langCT = langID;

                String[] navID = {"Kas Kecil", "Pelunasan Tunai", "Tanggal"};
                langNav = navID;
            }
%>
<html >
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
            
            function cmdSearchJurnal(){
                window.open("<%=approot%>/transaction/s_nom_jurnal.jsp?formName=frmbankpopaymentdetail&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                
                function cmdDepartment(){
                    var oid = document.frmbankpopaymentdetail.<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_DEPARTMENT_ID]%>.value;
         <%if (deps != null && deps.size() > 0) {
                for (int i = 0; i < deps.size(); i++) {
                    Department d = (Department) deps.get(i);
         %>
             if(oid=='<%=d.getOID()%>'){
                                 <%if (d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                        Department d0 = (Department) deps.get(0);
                                 %>
                                     alert("Non postable department\nplease select another department");
                                     document.frmbankpopaymentdetail.<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
                                     <%}%>
                                 }
         <%}
            }%>
        }
        
        function cmdPrintJournal(){
            
            window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=bankpoPayment.getOID()%>");
            }
            
            function cmdClickIt(){
                document.frmbankpopaymentdetail.<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_AMOUNT]%>.select();
            }
            
            function cmdGetBalance(){
                
                var x = document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_COA_ID]%>.value;
                //alert(x);
                
         <%if (accountBalance != null && accountBalance.size() > 0) {
                for (int i = 0; i < accountBalance.size(); i++) {
                    Coa c = (Coa) accountBalance.get(i);


                    double coaBalance = DbCoa.getCoaBalance(c.getOID());
         %>
             if(x=='<%=c.getOID()%>'){
                 //document.frmbankpopaymentdetail.<%//=jspBankpoPayment.colNames[jspBankpoPayment.JSP_ACCOUNT_BALANCE]%>//.value="<%//=JSPFormater.formatNumber(coaBalance, "###.##")%>//";
                 if(<%=coaBalance%><0)
                     {
                         document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((coaBalance < 0) ? coaBalance * -1 : coaBalance, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
                         }else
                         {
                             document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((coaBalance < 0) ? coaBalance * -1 : coaBalance, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                             }
                             
                             document.frmbankpopaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(coaBalance, "###.##")%>";
                             <%if (coaBalance < 1 && iJSPCommand != JSPCommand.SAVE) {%>
                             //alert('No account balance to do transaction. <%//=c.getOpeningBalance()%>//');
                             //document.all.command_line.style.display="none";
                             //document.all.emptymessage.style.display="";
                             <%} else {%>
                             //document.all.command_line.style.display="";
                             //document.all.emptymessage.style.display="none";
                             <%}%>
                         }
         <%}
            }%>
            
        }
        
        function cmdNone(){	
            document.frmbankpopaymentdetail.hidden_pettycash_payment_id.value="0";
            document.frmbankpopaymentdetail.hidden_pettycash_payment_detail_id.value="0";
            document.frmbankpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
            document.frmbankpopaymentdetail.submit();    
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
            
            var st = document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value;		
            var ab = 0;//document.frmbankpopaymentdetail.<%//=jspBankpoPayment.colNames[jspBankpoPayment.JSP_ACCOUNT_BALANCE]%>//.value;		
            
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
    
    function checkNumber2(){
        var main = document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value;		
        main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var currTotal = document.frmbankpopaymentdetail.total_detail.value;
        currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	        
        var idx = document.frmbankpopaymentdetail.select_idx.value;
        
        var maxtransaction = document.frmbankpopaymentdetail.max_pcash_transaction.value;
        maxtransaction = cleanNumberFloat(maxtransaction, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var pbalanace = document.frmbankpopaymentdetail.pcash_balance.value;
        pbalanace = cleanNumberFloat(pbalanace, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var limit = parseFloat(maxtransaction);
        
        if(limit > parseFloat(pbalanace)){
            //limit = parseFloat(pbalanace);
        }
        
        var st = document.frmbankpopaymentdetail.<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_AMOUNT]%>.value;		
        result = removeChar(st);	
        result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        //add
        if(parseFloat(idx)<0){
            
            var amount = parseFloat(currTotal) + parseFloat(result);
            
            if(amount>limit){//parseFloat(main)){
                alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");                		
                result = "0";//parseFloat(limit)-parseFloat(currTotal);
            }
            
            var amount = parseFloat(currTotal) + parseFloat(result);
            
            document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
            
        }
        //edit
        else{
            var editAmount =  document.frmbankpopaymentdetail.edit_amount.value;
            var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
            
            if(amount>limit){
                alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");              
                result = parseFloat(editAmount);			
                amount = limit;
            }
            
            var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
            
            document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
            
        }        
        document.frmbankpopaymentdetail.<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
    }
    
    function cmdSubmitCommand(){
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.SAVE%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdActivity(oid){
        <%if (oidBankPoPayment != 0) {%>
        document.frmbankpopaymentdetail.hidden_pettycash_payment_id.value=oid;
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pettycashpaymentactivity.jsp";
        document.frmbankpopaymentdetail.submit();
        <%} else {%>
        alert('Please finish and post this journal before continue to activity data.');
        <%}%>
    }
    
    function cmdSave(){
        document.frmbankpopaymentdetail.select_idx.value="-1";
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.POST%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    
    function cmdAdd(){
        document.frmbankpopaymentdetail.select_idx.value="-1";
        document.frmbankpopaymentdetail.hidden_pettycash_payment_id.value="0";
        document.frmbankpopaymentdetail.hidden_pettycash_payment_detail_id.value="0";
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.ADD%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdAsk(idx){
        document.frmbankpopaymentdetail.select_idx.value=idx;
        document.frmbankpopaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.ASK%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdConfirmDelete(oidPettycashPaymentDetail){
        document.frmbankpopaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.DELETE%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdSave(){
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdEdit(idxx){
        document.frmbankpopaymentdetail.select_idx.value=idxx;
        document.frmbankpopaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdCancel(oidPettycashPaymentDetail){
        document.frmbankpopaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdBack(){       
        document.frmbankpopaymentdetail.action="cash_receive.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdCancel(){       
        document.frmbankpopaymentdetail.action="cash_receive.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdListFirst(){
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.FIRST%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdListPrev(){
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.PREV%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdListNext(){
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.NEXT%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdListLast(){
        document.frmbankpopaymentdetail.command.value="<%=JSPCommand.LAST%>";
        document.frmbankpopaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
        document.frmbankpopaymentdetail.action="pelunasanbankproses.jsp";
        document.frmbankpopaymentdetail.submit();
    }
    
    function cmdDelPict(oidPettycashPaymentDetail){
        document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmimage.command.value="<%=JSPCommand.POST%>";
        document.frmimage.action="pelunasanbankproses.jsp";
        document.frmimage.submit();
    }
    
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
                                                        <form name="frmbankpopaymentdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            
                                                            <input type="hidden" name="hidden_bank_po_payment_id" value="<%=oidBankPoPayment%>">
                                                            <input type="hidden" name="hidden_bank_po_payment_detail_id" value="<%=oidBankpoPaymentDetail%>">  
                                                            
                                                            <input type="hidden" name="<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_TYPE]%>" value="<%=DbBankpoPayment.TYPE_PEMBELIAN_TUNAI%>">
                                                            
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            
                                                            <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                                                            
                                                            <input type="hidden" name="pcash_balance" value="">
                                                            
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="31%">&nbsp;</td>
                                                                                                        <td width="32%">&nbsp;</td>
                                                                                                        <td width="37%"> 
                                                                                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                                                                            : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="10%" nowrap>&nbsp;</td>
                                                                                                        <td width="2%">&nbsp;</td>
                                                                                                        <td width="37%">&nbsp;</td>
                                                                                                        <td width="13%" nowrap>&nbsp;</td>
                                                                                                        <td width="38%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan=5 height=20px>&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr> 
                                                                                                        <td width="10%" nowrap><%=langCT[4]%></td>
                                                                                                        <td width="2%">&nbsp;</td>
                                                                                                        <td width="37%">
                                                                                                            <%
    String strNumber = "";

    Date dt = new Date();
    Date dtx = (Date) dt.clone();
    dtx.setDate(1);
    int mnth = dt.getMonth() + 1;

    String month = "";
    //Untuk memberikan value, jika antara bulan 1 sampai 9 maka di awalnya akan di tambahkan 0, 
    //sedangkan bila bulan 10 - 12 maka tidak di berikan 0 di depannya

    if (mnth >= 10) {
        month = "" + mnth;
    } else {
        month = "0" + mnth;
    }

    SystemDocCode systemDocCode = new SystemDocCode();
    systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
    String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + month + systemDocCode.getSeparator() + JSPFormater.formatDate(dtx, "yy");

    int counterJournal = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

    strNumber = counterJournal + systemDocCode.getSeparator() + formatDocCode;
    //String strNumber = DbBankpoPayment.getNextNumber(bankpoPayment.getJournalCounter(),0);

    if ((bankpoPayment.getOID() != 0 || oidBankPoPayment != 0) && isSave == false) {
        strNumber = bankpoPayment.getJournalNumber() + "B";
    } else {
        strNumber = bankpoPayment.getJournalNumber();
    }



                                                                                                            %>
                                                                                                            <%=strNumber%> 
                                                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_NUMBER]%>">
                                                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_COUNTER]%>">
                                                                                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_PREFIX]%>">
                                                                                                        </td>
                                                                                                        <td width="13%" nowrap>&nbsp;</td>
                                                                                                        <td width="38%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" nowrap><%=langCT[0]%></td>
                                                                                                        <td width="2%">&nbsp;</td>
                                                                                                        <td width="37%">
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
                                                                                                                <%=getAccountRecursif(coa, bankpoPayment.getCoaId(), isPostableOnly)%> 
                                                                                                                <%}
} else {%>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_COA_ID) %> 
                                                                                                        </td>
                                                                                                        <td width="13%" nowrap><%=langCT[5]%></td>
                                                                                                        <td width="38%"> 
                                                                                                            <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getTransDate() == null) ? new Date() : bankpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopaymentdetail.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_TRANS_DATE) %> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td width="2%">&nbsp;</td>
                                                                                                        <td width="37%"> 
                                                                                                            <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly size="50">
                                                                                                        </td>
                                                                                                        <td width="13%">&nbsp;</td>
                                                                                                        <td width="38%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" height="16"><%=langCT[2]%></td>
                                                                                                        <td width="2%" height="16">&nbsp;</td>
                                                                                                        <td rowspan="2" width="37%" valign="top"> 
                                                                                                            <textarea readonly name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_MEMO]%>" cols="50" rows="3"><%=bankpoPayment.getMemo()%></textarea>
                                                                                                        </td>
                                                                                                        <td width="13%" height="16">&nbsp</td>
                                                                                                        <td width="38%" height="16">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="2%">&nbsp;</td>
                                                                                                        <td width="13%">&nbsp;</td>
                                                                                                        <td width="38%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr > 
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                                                <td class="tab"><%=langCT[6]%></td>
                                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                <%if (applyActivity) {%>
                                                                                                                                <td class="tabin"> 
                                                                                                                                    <%if (true) {%>
                                                                                                                                    <a href="javascript:cmdActivity('<%=oidBankPoPayment%>')" class="tablink">Activity</a> 
                                                                                                                                    <%} else {%>
                                                                                                                                    <a href="#" class="tablink" title="petty cash payment required">Activity</a> 
                                                                                                                                    <%}%>
                                                                                                                                </td>
                                                                                                                                <%}%>
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
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td  class="tablehdr" width="30%" height="20"><%=langCT[7]%></td>
                                                                                                                                            <td class="tablehdr" width="15%" height="20"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                                            <td class="tablehdr" width="55%" height="20"><%=langCT[8]%></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablecell" width="30%">                                                                                                                                             
                                                                                                                                                <%
    Coa objCoaSuspense = DbCoa.fetchExc(bankpoPayment.getCoaId());
                                                                                                                                                %>                                                                                                                                                
                                                                                                                                                <%=objCoaSuspense.getCode()%>&nbsp;-&nbsp; <%=objCoaSuspense.getName()%>
                                                                                                                                                <input type="hidden" name="<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_COA_ID]%>" value="<%=objCoaSuspense.getOID()%>">
                                                                                                                                            </td>
                                                                                                                                            <td width="15%" class="tablecell">                                                                                                                                                                                                                                                                                               
                                                                                                                                                <input type="hidden" name="<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_AMOUNT]%>" value="<%=bankpoPayment.getAmount()%>">
                                                                                                                                                <div align="right"><%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%></div>
                                                                                                                                            </td>
                                                                                                                                            <input type="hidden" name="<%=jspBankpoPaymentDetail.colNames[jspBankpoPaymentDetail.JSP_MEMO]%>" value="<%=bankpoPayment.getMemo()%>">
                                                                                                                                            <td width="55%" class="tablecell"><%=bankpoPayment.getMemo()%></td>
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
                                                                                                                    <td width="78%"> &nbsp;</td>
                                                                                                                    <td class="boxed1" width="22%"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td width="36%"> 
                                                                                                                                    <div align="left"><b>Total 
                                                                                                                                            <%=baseCurrency.getCurrencyCode()%> : 
                                                                                                                                    </b></div>
                                                                                                                                </td>
                                                                                                                                <td width="64%"> 
                                                                                                                                    <div align="right"><b> 
                                                                                                                                            <%
    balance = bankpoPayment.getAmount() - totalDetail;
                                                                                                                                            %>
                                                                                                                                            <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                                                                                    <%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <%if (bankpoPayment.getStatus().equals(DbBankpoPayment.STATUS_PAID)) {%>
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
                                                                                                                    <td width="68%">&nbsp;</td>
                                                                                                                    <td width="24%"> 
                                                                                                                        <div align="right" class="msgnextaction"> 
                                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="info" width="214" align="right">
                                                                                                                                <tr> 
                                                                                                                                    <td width="8"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                                                                                    <td width="176" nowrap><%=langCT[13]%></td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    
                                                                                                    <%if (bankpoPayment.getOID() != 0 && bankpoPayment.getStatus().equals(DbBankpoPayment.STATUS_POSTED)) {%>
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
                                                                                                                    <td width="4%">
                                                                                                                        <%if(privAdd || privUpdate){%>
                                                                                                                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="new1" border="0"></a>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="4%">
                                                                                                                        <a href="javascript:cmdCancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel" border="0"></a>
                                                                                                                    </td>
                                                                                                                    <td width="9%">&nbsp;</td>
                                                                                                                    <td width="49%">&nbsp;</td>
                                                                                                                    <td width="36%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5"> 
                                                                                                            &nbsp;
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
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="4" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>
                                                            <%} catch (Exception e) {
                out.println(e.toString());
            }%>
                                                            <script language="JavaScript">
                                                                
                                                                //cmdGetBalance();
                                                                
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

