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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPP, AppMenu.PRIV_DELETE);   
%>
<!-- Jsp Block -->
<%!
    public Vector addNewDetail(Vector listPettycashPaymentDetail, PettycashPaymentDetail pettycashPaymentDetail) {
        boolean found = false;
        if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
            for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {
                PettycashPaymentDetail cr = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
                if (cr.getCoaId() == pettycashPaymentDetail.getCoaId() && cr.getDepartmentId() == pettycashPaymentDetail.getDepartmentId()) {                    				
                    cr.setAmount(cr.getAmount() + pettycashPaymentDetail.getAmount());
                    found = true;
                }
            }
        }

        if (!found) {
            listPettycashPaymentDetail.add(pettycashPaymentDetail);
        }

        return listPettycashPaymentDetail;
    }

    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                PettycashPaymentDetail crd = (PettycashPaymentDetail) listx.get(i);
                result = result + crd.getAmount();
            }
        }
        return result;
    }

    public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly){

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
                        switch (coax.getLevel()){
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
            long oidPettycashPayment = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");

            if (iJSPCommand == JSPCommand.NONE) {

                session.removeValue("PPPAYMENT_DETAIL");
                oidPettycashPayment = 0;
                recIdx = -1;
            }
            
            /*variable declaration*/
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";

            boolean isLoad = false;

            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("PPPAYMENT_DETAIL");
                oidPettycashPayment = JSPRequestValue.requestLong(request, "cash_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdPettycashPayment ctrlPettycashPayment = new CmdPettycashPayment(request);
            JSPLine ctrLine = new JSPLine();
            Vector listPettycashPayment = new Vector(1, 1);

            /*switch statement */
            int iErrCodeMain = ctrlPettycashPayment.action(iJSPCommand, oidPettycashPayment);

            /* end switch*/
            JspPettycashPayment jspPettycashPayment = ctrlPettycashPayment.getForm();

            /*count list All PettycashPayment*/
            int vectSize = DbPettycashPayment.getCount(whereClause);

            PettycashPayment pettycashPayment = ctrlPettycashPayment.getPettycashPayment();
            
            String msgStringMain = ctrlPettycashPayment.getMessage();

            if(oidPettycashPayment == 0){
                oidPettycashPayment = pettycashPayment.getOID();
            }
            
            if (oidPettycashPayment != 0) {
                pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
            }

            System.out.println("\n -- start detail session ---\n");

%>
<%
//CASH RECEIVE DETAIL
//===================================update============================
            boolean load = false;

            if (iJSPCommand == JSPCommand.LOAD){
                load = true;
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }
//=====================================================================
            long oidPettycashPaymentDetail = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_detail_id");

            /*variable declaration*/

            CmdPettycashPaymentDetail ctrlPettycashPaymentDetail = new CmdPettycashPaymentDetail(request);

            Vector listPettycashPaymentDetail = new Vector(1, 1);

            if (load) {
                listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID(), null);
            }

            /*switch statement */
            iErrCode = ctrlPettycashPaymentDetail.action(iJSPCommand, oidPettycashPaymentDetail);
            /* end switch*/
            JspPettycashPaymentDetail jspPettycashPaymentDetail = ctrlPettycashPaymentDetail.getForm();

            PettycashPaymentDetail pettycashPaymentDetail = ctrlPettycashPaymentDetail.getPettycashPaymentDetail();
            msgString = ctrlPettycashPaymentDetail.getMessage();
       
            if (session.getValue("PPPAYMENT_DETAIL") != null){
                listPettycashPaymentDetail = (Vector) session.getValue("PPPAYMENT_DETAIL");
            }
            
            boolean submit = false;

            if (iJSPCommand == JSPCommand.SUBMIT){
                submit = true;
                if (iErrCode == 0) {
                    if (recIdx == -1) {
                        //listPettycashPaymentDetail = addNewDetail(listPettycashPaymentDetail, pettycashPaymentDetail);
                        listPettycashPaymentDetail.add(pettycashPaymentDetail);

                    } else {
                        listPettycashPaymentDetail.set(recIdx, pettycashPaymentDetail);
                        //listPettycashPaymentDetail.remove(recIdx);
                        //listPettycashPaymentDetail = addNewDetail(listPettycashPaymentDetail, pettycashPaymentDetail);

                    }
                }
            }

            if (iJSPCommand == JSPCommand.DELETE) {
                if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > recIdx) {
                    listPettycashPaymentDetail.remove(recIdx);
                }
            }

            boolean isSave = false;
            if (iJSPCommand == JSPCommand.SAVE) {

                if (pettycashPayment.getOID() != 0) {

                    DbPettycashPaymentDetail.saveAllDetail(pettycashPayment, listPettycashPaymentDetail);
                    listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, "pettycash_payment_id=" + pettycashPayment.getOID(), "");
                    isSave = true;
                }
                iJSPCommand = JSPCommand.ADD;
            }

            session.putValue("PPPAYMENT_DETAIL", listPettycashPaymentDetail);

            Vector incomeCoas = DbCoa.list(0,0, "", "code");//DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_PETTY_CASH, sysLocation.getOID());
            
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_PETTY_CASH_PAYMENT_SUSPENSE_ACCOUNT+ "'", "");

            Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

            double balance = 0;
            double totalDetail = getTotalDetail(listPettycashPaymentDetail);

            pettycashPayment.setAmount(totalDetail);

            if (((iJSPCommand == JSPCommand.SUBMIT && recIdx == -1)) && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                pettycashPaymentDetail = new PettycashPaymentDetail();
                recIdx = -1;
            }

            String whereDep = "";

            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            /*** LANG ***/
            String[] langCT = {"Suspense Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Account - Description", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully", "Search Journal Number","Customer", "SEARCH", "EXPENSE BOOKING EDITOR", "Segment"}; //10-15

            String[] langNav = {"Petty Cash", "Disbushment", "Date","Required"};

            if (lang == LANG_ID) {
                String[] langID = {"Account Sementara", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Perkiraan", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal","Sarana", "PENCARIAN", "EDITOR PENGAKUAN BIAYA", "Segmen"}; //10-15
                langCT = langID;

                String[] navID = {"Kas Kecil", "Pengakuan Biaya", "Tanggal","Harus diisi"};
                langNav = navID;
            }
			
			Vector segments = DbSegment.list(0,0, "", "");
			long selectModuleId = 0;
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />        
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
			function cmdOpenModule(){
				window.open("<%=approot%>/transactionact/moduledtopen.jsp?source_name=frmpettycashpaymentdetail", null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
			}
			function cmdOpenCoa(){
				window.open("<%=approot%>/transactionact/coalist.jsp", null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
			}
			function cmdInactveAct(x){
				var y = parseInt(x);
				if(y==0){
					document.all.coa_btn.style.display="";
					document.all.act_data.style.display="none";
					document.all.act_data1.style.display="";
				}
				else{
					document.all.coa_btn.style.display="none";
					document.all.act_data.style.display="";
					document.all.act_data1.style.display="none";
				}			
			}
            function cmdSearchJurnal(){
                window.open("<%=approot%>/transaction/s_nom_jurnal.jsp?formName=frmpettycashpaymentdetail&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            function cmdDepartment(){
                    var oid = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>.value;
         <%if (deps != null && deps.size() > 0) {
                for (int i = 0; i < deps.size(); i++) {
                    Department d = (Department) deps.get(i);
         %>
             if(oid=='<%=d.getOID()%>'){
                                 <%if (d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                        Department d0 = (Department) deps.get(0);
                                 %>
                                     alert("Non postable department\nplease select another department");
                                     document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
                                     <%}%>
                                 }
         <%}
            }%>
        }
        
        function cmdPrintJournal(){	 
            window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=pettycashPayment.getOID()%>");
            }
            
            function cmdClickIt(){
                document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.select();
            }
            
            function cmdGetBalance(){
                
                var x = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>.value;
                
         <%if (accountBalance != null && accountBalance.size() > 0) {
                for (int i = 0; i < accountBalance.size(); i++) {
                    
                    Coa c = (Coa) accountBalance.get(i);
                    double coaBalance = DbCoa.getCoaBalance(c.getOID());
         %>
             if(x=='<%=c.getOID()%>'){
                 document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>.value="<%=JSPFormater.formatNumber(coaBalance, "###.##")%>";
                 if(<%=coaBalance%><0)
                     {
                         document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((coaBalance < 0) ? coaBalance * -1 : coaBalance, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
                            
					 }else
					 {
						 document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((coaBalance < 0) ? coaBalance * -1 : coaBalance, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
						 }
						 
						 //document.frmpettycashpaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(coaBalance, "###.##")%>";
						 <%if (coaBalance < 1 && iJSPCommand != JSPCommand.SAVE) {%>
						 //alert('No account balance to do transaction. <%=c.getOpeningBalance()%>');
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
        
        function cmdFixing(){	
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.POST%>";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();	
        }
        
        function cmdNewJournal(){		
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();	
        }
        
        function cmdNone(){	
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();    
        }
        
        var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
        var usrDigitGroup = "<%=sUserDigitGroup%>";
        var usrDecSymbol = "<%=sUserDecimalSymbol%>";
        
        function removeChar(number){
            
            var ix;
            var result = "";
            for(ix=0; ix<number.length; ix++){
                var xx = number.charAt(ix);
                //alert(xx);
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
            
            var st = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value;		
            var ab = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>.value;		
            
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
        
        document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
    }
    
    function checkNumber2(){
        var main = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value;		
        main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var currTotal = document.frmpettycashpaymentdetail.total_detail.value;
        currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	        
        var idx = document.frmpettycashpaymentdetail.select_idx.value;
        
        var maxtransaction = document.frmpettycashpaymentdetail.max_pcash_transaction.value;
        maxtransaction = cleanNumberFloat(maxtransaction, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var pbalanace = document.frmpettycashpaymentdetail.pcash_balance.value;
        pbalanace = cleanNumberFloat(pbalanace, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var limit = parseFloat(maxtransaction);
        
        if(limit > parseFloat(pbalanace)){
            //limit = parseFloat(pbalanace);
        }
        
        var st = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value;		
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
            
            document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
            
        }
        //edit
        else{
            var editAmount =  document.frmpettycashpaymentdetail.edit_amount.value;
            var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
            
            if(amount>limit){//parseFloat(main)){
                alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
                result = parseFloat(editAmount);			
                amount = limit;
            }
            
            var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
            
            document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
            
        }
        
        document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
    }
    
    function cmdSubmitCommand(){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdActivity(oid){
        <%if (oidPettycashPayment != 0) {%>
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=oid;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
        document.frmpettycashpaymentdetail.submit();
        <%} else {%>
        alert('Please finish and post this journal before continue to activity data.');
        <%}%>
    }
    
    function cmdAdd(){
        document.frmpettycashpaymentdetail.select_idx.value="-1";
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdAsk(idx){
        document.frmpettycashpaymentdetail.select_idx.value=idx;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdConfirmDelete(oidPettycashPaymentDetail){
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdSave(){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdEdit(idxx){
        document.frmpettycashpaymentdetail.select_idx.value=idxx;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdCancel(oidPettycashPaymentDetail){
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdBack(){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.BACK%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    function cmdDelPict(oidPettycashPaymentDetail){
        document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmimage.command.value="<%=JSPCommand.POST%>";
        document.frmimage.action="pettycashpaymentdetail.jsp";
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
                  						<%@ include file="../main/menu.jsp"%><%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <% String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %><%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmpettycashpaymentdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_pettycash_payment_detail_id" value="<%=oidPettycashPaymentDetail%>">
                                                            <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidPettycashPayment%>">
                                                            <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_TYPE]%>" value="<%=DbPettycashPayment.STATUS_TYPE_PENGAKUAN_BIAYA%>">
                                                            <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_STATUS]%>" value="<%=DbPettycashPayment.STATUS_TYPE_APPROVED%>">
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
                                          <td colspan="4">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                              <tr> 
                                                <td colspan="5" nowrap><b><U><%=langCT[14]%></U></b></td>
                                              </tr>
                                              <%  
												String nom_jur = "";
												
												if(isLoad){
													nom_jur = pettycashPayment.getJournalNumber();
												}
												%>
                                              <tr> 
                                                <td width="10%" nowrap><%=langCT[12]%></td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <table>
                                                    <tr> 
                                                      <td> 
                                                        <input size="25" readonly type="text" name="jurnal_number" value="<%=nom_jur%>">
                                                      </td>
                                                      <td> 
                                                        <input size="50" type="hidden" name="cash_id" value="<%=pettycashPayment.getOID()%>">
                                                        <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" width="100%"> 
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
                                                <td colspan=5 height=10px><b><u><%=langCT[15]%></u></b></td>
                                              </tr>
                                              <tr> 
                                                <td colspan=5 height=10px>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan=5 height=10px>*) <%=langNav[3]%></td>
                                              </tr>
                                              <tr> 
                                                <td colspan=5 height=10px>&nbsp;</td>
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
												
													if (pettycashPayment.getOID() != 0 || oidPettycashPayment != 0) {
														strNumber = pettycashPayment.getJournalNumber();
													}
												%>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_NUMBER]%>">
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_COUNTER]%>">
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%"> 
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>" readOnly style="text-align:right">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap><%=langCT[0]%></td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <select name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>">
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
                                                    <option <%if (pettycashPayment.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                    <%=getAccountRecursif(coa, pettycashPayment.getCoaId(), isPostableOnly)%> 
                                                    <%}
} else {%>
                                                    <option>select ..</option>
                                                    <%}%>
                                                  </select>
                                                  <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_COA_ID) %> </td>
                                                <td width="13%" nowrap><%=langCT[5]%></td>
                                                <td width="38%"> 
                                                  <input name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((pettycashPayment.getTransDate() == null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_TRANS_DATE) %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <input type="text" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly size="47">
                                                  <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_AMOUNT) %> </td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="16"><%=langCT[2]%></td>
                                                <td width="2%" height="16">&nbsp;</td>
                                                <td rowspan="2" width="37%" valign="top"> 
                                                  <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr> 
                                                      <td> 
                                                        <textarea name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_MEMO]%>" cols="47" rows="3"><%=pettycashPayment.getMemo()%></textarea>
                                                      </td>
                                                      <td valign="top">&nbsp;*)</td>
                                                      <td><%= (jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO).length() > 0) ? "<br>" + jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO) : "" %></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td colspan="2" height="16" rowspan="2" valign="top"> 
                                                  <table width="60%" border="0" cellspacing="3" cellpadding="3" bgcolor="#F3F3F3">
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="42%"><b><%=langCT[16]%></b></td>
                                                            <td width="58%">&nbsp;</td>
                                                          </tr>
                                                          <%
												  if(segments!=null && segments.size()>0){
												  for(int i=0; i<segments.size(); i++){
												  	Segment segment = (Segment)segments.get(i);
													
													
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
																wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment15Id();
															}
															break;
													}
								
													Vector sgDetails = DbSegmentDetail.list(0, 0, wh, "");
													
												  %>
                                                          <tr> 
                                                            <td width="42%"><%=segment.getName()%></td>
                                                            <td width="58%"> 
                                                              <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
															for (int x = 0; x < sgDetails.size(); x++) {
																SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
																String selected = "";
																switch (i + 1) {
																	case 1:
																		if (pettycashPayment.getSegment1Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 2:
																		if (pettycashPayment.getSegment2Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 3:
																		if (pettycashPayment.getSegment3Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 4:
																		if (pettycashPayment.getSegment4Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 5:
																		if (pettycashPayment.getSegment5Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 6:
																		if (pettycashPayment.getSegment6Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 7:
																		if (pettycashPayment.getSegment7Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 8:
																		if (pettycashPayment.getSegment8Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 9:
																		if (pettycashPayment.getSegment9Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 10:
																		if (pettycashPayment.getSegment10Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 11:
																		if (pettycashPayment.getSegment11Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 12:
																		if (pettycashPayment.getSegment12Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 13:
																		if (pettycashPayment.getSegment13Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 14:
																		if (pettycashPayment.getSegment14Id() == sd.getOID()) {
																			selected = "selected";
																		}
																		break;
																	case 15:
																		if (pettycashPayment.getSegment5Id() == sd.getOID()) {
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
                                                          <%}}%>
                                                          
                                                          <tr> 
                                                            <td width="42%">&nbsp;</td>
                                                            <td width="58%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="100%" class="page"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr> 
                                                                  <td  class="tablehdr" width="30%" height="20">Kegiatan</td>
                                                                  <td  class="tablehdr" width="30%" height="20"><%=langCT[7]%></td>
                                                                  <td class="tablehdr" width="15%" height="20"><%=langCT[1]%> 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                  <td class="tablehdr" width="55%" height="20"><%=langCT[8]%></td>
                                                                </tr>
                                                                <%if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
        for (int i = 0; i < listPettycashPaymentDetail.size(); i++){

            PettycashPaymentDetail crd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
            Coa c = new Coa();
            try {
                c = DbCoa.fetchExc(crd.getCoaId());
            } catch (Exception e) {
            }

            String cssString = "tablecell";
            if (i % 2 != 0) {
                cssString = "tablecell1";
            }

                                                                                                                                        %>
                                                                <%

                                                                                                                                            if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx){%>
                                                                <tr> 
                                                                  <td class="tablecell" width="30%"> 
                                                                    <table width="49%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                                      <tr id="act_data"> 
                                                                        <td width="62%" nowrap> 
                                                                          <%
															  Module module = new Module();
															  try{
															  	module = DbModule.fetchExc(crd.getModuleId());
															  }
															  catch(Exception e){
															  }
															  %>
                                                                          <input type="text" name="module_txt" size="30" value="<%=module.getDescription()%>" readonly class="readonly">
                                                                          &nbsp;
																		  <input type="hidden" name="<%=JspPettycashPaymentDetail.colNames[JspPettycashPaymentDetail.JSP_MODULE_ID]%>" value="<%=crd.getModuleId()%>">
                                                                        </td>
                                                                        <td width="38%" nowrap><a href="javascript:cmdOpenModule()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="19" border="0" style="padding:0px" alt="Buka list kegiatan"></a></td>
                                                                        <td width="38%" nowrap><a href="javascript:cmdInactveAct('0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21x','','../images/search.jpg',1)"><img src="../images/no.gif" name="new211x" border="0" style="padding:0px" width="18" alt="Klik jika non kegiatan"></a></td>
                                                                      </tr>
                                                                      <tr id="act_data1"> 
                                                                        <td width="62%" nowrap> 
                                                                          <div align="center"> 
                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                              <%
																
																if(segments!=null && segments.size()>0){
																	for(int xx=0; xx<segments.size(); xx++){
																		Segment seg = (Segment)segments.get(xx);
																		Vector sgDetails = DbSegmentDetail.list(0,0, "segment_id="+seg.getOID(), "");
																		
																%>
                                                                              <tr> 
                                                                                <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                <td width="46%"> 
                                                                                  <%
																	  //out.println("crd.getSegment1Id() : "+crd.getSegment1Id());
																	  //out.println("crd.getSegment2Id() : "+crd.getSegment2Id());
																	  //out.println("crd.getSegment3Id() : "+crd.getSegment3Id());
																	 // out.println("crd.getSegment4Id() : "+crd.getSegment4Id());
																	  %>
                                                                                  <select name="JSP_SEGMENT<%=xx+1%>_ID">
                                                                                    <%if(sgDetails!=null && sgDetails.size()>0){
																			for(int x=0; x<sgDetails.size(); x++){
																				SegmentDetail sd = (SegmentDetail)sgDetails.get(x);
																				String selected = "";
																				switch(xx+1){
																					case 1 :
																						if(crd.getSegment1Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 2 :
																						if(crd.getSegment2Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 3 :
																						if(crd.getSegment3Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 4 :
																						if(crd.getSegment4Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 5 :
																						if(crd.getSegment5Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 6 :
																						if(crd.getSegment6Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 7 :
																						if(crd.getSegment7Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 8 :
																						if(crd.getSegment8Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 9 :
																						if(crd.getSegment9Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 10 :
																						if(crd.getSegment10Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 11 :
																						if(crd.getSegment11Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 12 :
																						if(crd.getSegment12Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 13 :
																						if(crd.getSegment13Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 14 :
																						if(crd.getSegment14Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 15 :
																						if(crd.getSegment15Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																																
																						//.... lanjut
																					 
																				}
																		  %>
                                                                                    <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                    <%}}%>
                                                                                  </select>
                                                                                </td>
                                                                              </tr>
                                                                              <%}}%>
                                                                            </table>
                                                                          </div>
                                                                        </td>
                                                                        <td width="38%" nowrap id="module_btn" valign="bottom">&nbsp;<a href="javascript:cmdInactveAct('1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21xx','','../images/search.jpg',1)"><img src="../images/success.gif" name="new211xx" border="0" style="padding:0px" width="20" alt="Aktifkan kegiatan" height="20"></a></td>
                                                                        <td width="38%" nowrap>&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                  <td class="tablecell" width="30%">
																  <div align="center"> 
                                                                      <table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                                        <tr> 
                                                                          <td width="67%"> 
                                                                            <input type="text" name="coa_txt" value="<%=c.getCode()+" - "+c.getName()%>" readonly class="readonly" size="30">
                                                                <input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>" value="<%=crd.getCoaId()%>">
                                                              </td>
                                                                          <td id="coa_btn" width="33%" nowrap>&nbsp;<a href="javascript:cmdOpenCoa()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21a','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211a" height="19" border="0" style="padding:0px" alt="Buka list perkiraan"></a></td>
                                                            </tr>
                                                          </table>
                                                          <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> </div>
														         </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="55%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="40" value="<%=crd.getMemo()%>">
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%}else{%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="30%"><%
													  
													  String outStr = "";
													  
													  //out.println("crd.getModuleId() : "+crd.getModuleId());
													  if(crd.getModuleId()!=0){
														    Module module = new Module();
														    try{
															  module = DbModule.fetchExc(crd.getModuleId());
														    }
														    catch(Exception e){
														    }
														  
														    //String outStr = (module.getOID()==0) ? "Non kegiatan " : module.getCode()+" - "+module.getDescription();
														  
														    //Tokenizer untuk Sasaran
															
															StringTokenizer strTok = new StringTokenizer(module.getDescription(), ";");
												
															int countOut = 0;
												
															while (strTok.hasMoreTokens()) {
												
																if (countOut != 0) {
																	outStr = "("+(countOut+1)+") "+outStr + " ";
																}
												
																outStr = outStr + strTok.nextToken();
																countOut++;
															}
															//=== END Tokenizer untuk Sasaran ===
														  
													  }
													  else{
													  		outStr = "Non Kegiatan";  
													  }
													  
													  out.println(outStr);
													  %></td>
                                                                  <td class="<%=cssString%>" width="30%"> 
                                                                    <%if (pettycashPayment.getOID() == 0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%>&nbsp;-&nbsp; 
                                                                    <%=c.getName()%></a> 
                                                                    <%} else {%>
                                                                    <%=c.getCode()%>&nbsp;-&nbsp; 
                                                                    <%=c.getName()%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="15%" class="<%=cssString%>"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                  <td width="55%" class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                                </tr>
                                                                <%}%>
                                                                <%}
    																}%>
                                                                <%
    																if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCodeMain > 0 || iErrCode != 0) && recIdx == -1 && ((submit && ( iErrCodeMain > 0 || iErrCode != 0 )) || !submit))){ %>
                                                                <tr> 
                                                                  <td class="tablecell" width="30%"> 
                                                                    <table width="49%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                                      <tr id="act_data"> 
                                                                        <td width="62%" nowrap> 
                                                                          <%
															  Module module = new Module();
															  try{
															  	module = DbModule.fetchExc(pettycashPaymentDetail.getModuleId());
															  }
															  catch(Exception e){
															  }
															  %>
                                                                          <input type="text" name="module_txt" size="30" value="<%=module.getDescription()%>" readonly class="readonly">
                                                                          &nbsp; 
                                                                          <input type="hidden" name="<%=JspPettycashPaymentDetail.colNames[JspPettycashPaymentDetail.JSP_MODULE_ID]%>" value="<%=pettycashPaymentDetail.getModuleId()%>">
                                                                        </td>
                                                                        <td width="38%" nowrap><a href="javascript:cmdOpenModule()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="19" border="0" style="padding:0px" alt="Buka list kegiatan"></a></td>
                                                                        <td width="38%" nowrap><a href="javascript:cmdInactveAct('0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21x','','../images/search.jpg',1)"><img src="../images/no.gif" name="new211x" border="0" style="padding:0px" width="18" alt="Klik jika non kegiatan"></a></td>
                                                                      </tr>
                                                                      <tr id="act_data1"> 
                                                                        <td width="62%" nowrap> 
                                                                          <div align="center"> 
                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                              <%
																
																if(segments!=null && segments.size()>0){
																	for(int i=0; i<segments.size(); i++){
																		Segment seg = (Segment)segments.get(i);
																		Vector sgDetails = DbSegmentDetail.list(0,0, "segment_id="+seg.getOID(), "");
																		
																%>
                                                                              <tr> 
                                                                                <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                <td width="46%"> 
                                                                                  <select name="JSP_SEGMENT<%=i+1%>_ID">
                                                                                    <%if(sgDetails!=null && sgDetails.size()>0){
																			for(int x=0; x<sgDetails.size(); x++){
																				SegmentDetail sd = (SegmentDetail)sgDetails.get(x);
																				String selected = "";
																				switch(i+1){
																					case 1 :
																						if(pettycashPaymentDetail.getSegment1Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 2 :
																						if(pettycashPaymentDetail.getSegment2Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 3 :
																						if(pettycashPaymentDetail.getSegment3Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 4 :
																						if(pettycashPaymentDetail.getSegment4Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 5 :
																						if(pettycashPaymentDetail.getSegment5Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 6 :
																						if(pettycashPaymentDetail.getSegment6Id()==sd.getOID()){
																							selected = "selected";
																						}
																						break;
																					case 7 :
																						if(pettycashPaymentDetail.getSegment7Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 8 :
																						if(pettycashPaymentDetail.getSegment8Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 9 :
																						if(pettycashPaymentDetail.getSegment9Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 10 :
																						if(pettycashPaymentDetail.getSegment10Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 11 :
																						if(pettycashPaymentDetail.getSegment11Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 12 :
																						if(pettycashPaymentDetail.getSegment12Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 13 :
																						if(pettycashPaymentDetail.getSegment13Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 14 :
																						if(pettycashPaymentDetail.getSegment14Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																					case 15 :
																						if(pettycashPaymentDetail.getSegment15Id()==sd.getOID()){
																							selected = "selected";
																						}																										
																						break;
																																
																						//.... lanjut
																					 
																				}
																		  %>
                                                                                    <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                    <%}}%>
                                                                                  </select>
                                                                                </td>
                                                                              </tr>
                                                                              <%}}%>
                                                                            </table>
                                                                          </div>
                                                                        </td>
                                                                        <td width="38%" nowrap id="module_btn" valign="bottom">&nbsp;<a href="javascript:cmdInactveAct('1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21xx','','../images/search.jpg',1)"><img src="../images/success.gif" name="new211xx" border="0" style="padding:0px" alt="Aktifkan kegiatan"></a></td>
                                                                        <td width="38%" nowrap>&nbsp;</td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                  <td class="tablecell" width="30%"> 
                                                                    
																	<div align="center"> 
																  <%
																  Coa coax = new Coa();
																  try{
																	coax = DbCoa.fetchExc(pettycashPaymentDetail.getCoaId());
																  }
																  catch(Exception e){
																  }
																  %>
																      <table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                                        <tr> 
																	      <td width="62%"> 
                                                                            <input type="text" name="coa_txt" value="<%=coax.getCode()+" - "+coax.getName()%>" readonly class="readonly" size="30">
																		<input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>" value="<%=pettycashPaymentDetail.getCoaId()%>">
																	  </td>
																	      <td id="coa_btn" width="38%" nowrap>&nbsp;<a href="javascript:cmdOpenCoa()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21a','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211a" height="19" border="0" style="padding:0px" alt="Buka list perkiraan"></a></td>
																	</tr>
																  </table>
																  <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> </div>
																  
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(pettycashPaymentDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="55%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="40" value="<%=pettycashPaymentDetail.getMemo()%>">
                                                                    </div>
                                                                  </td>
                                                                </tr>
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
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="78%">&nbsp;</td>
                                                      <td width="22%">&nbsp;</td>
                                                    </tr>
                                                    <%if (pettycashPayment.getAmount() != 0 && iErrCode == 0 && iErrCodeMain == 0 && balance == 0 && submit){%>
                                                    <tr> 
                                                      <td colspan=2> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                            <td width="68%">&nbsp;</td>
                                                            <td width="24%"> 
                                                              <div align="right" class="msgnextaction"> 
                                                                <table border="0" cellpadding="5" cellspacing="0" class="info" width="214" align="right">
                                                                  <tr> 
                                                                    <td width="8"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                    <td width="176" nowrap><%=langCT[10]%></td>
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
                                                      <td width="78%">&nbsp;</td>
                                                      <td width="22%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan=2 height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="78%">&nbsp;</td>
                                                      <td width="22%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="78%"> 
                                                        <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                          <%if (iErrCodeMain == 0 || iErrCode != 0 || listPettycashPaymentDetail == null || listPettycashPaymentDetail.size() == 0) {%>
                                                          <tr> 
                                                            <td> 
                                                              <% if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeMain == 0)) {%>
                                                              <% if(privAdd){%>
                                                              <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> 
                                                              <%}%>
                                                              <%
                                                                                                                                        } else {
                                                                                                                                    %>
                                                              <%
                                                                                                                                            
                                                                                                                                            if ((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) && (iErrCode != 0 || iErrCodeMain != 0)) {
                                                                                                                                                iJSPCommand = JSPCommand.SAVE;
                                                                                                                                            }

                                                                                                                                            ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                            ctrLine.initDefault();
                                                                                                                                            ctrLine.setTableWidth("90%");
                                                                                                                                            String scomDel = "javascript:cmdAsk('" + oidPettycashPaymentDetail + "')";
                                                                                                                                            String sconDelCom = "javascript:cmdConfirmDelete('" + oidPettycashPaymentDetail + "')";
                                                                                                                                            String scancel = "javascript:cmdEdit('" + oidPettycashPaymentDetail + "')";
                                                                                                                                            
                                                                                                                                            if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
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

                                                                                                                                            if (privAdd == false){
                                                                                                                                                ctrLine.setAddCaption("");
                                                                                                                                            }

                                                                                                                                    %>
                                                              <%if (pettycashPayment.getPostedStatus() != 1){%>
                                                              <%if(!(submit && iErrCode == 0 && iErrCodeMain == 0)){ %>
                                                              <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                              <%}%>
                                                              <%} else {%>
                                                              <a href="javascript:cmdNone()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"> 
                                                              <img src="../images/new.gif" name="new" width="71" height="22" border="0"></a> 
                                                              <%}%>
                                                              <%}
//}%>
                                                            </td>
                                                          </tr>
                                                          <%} else {%>
                                                          <tr> 
                                                            <td> 
                                                              <table border="0" cellpadding="2" cellspacing="0"width="293" align="left">
                                                                <tr> 
                                                                  <td width="20" class="warning" ><img src="../images/error.gif" width="18" height="18"></td>
                                                                  <td width="253"  class="warning"  nowrap><%=msgStringMain%></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="5"></td>
                                                          </tr>
                                                          <tr> 
                                                            <td> 
                                                              <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td width="63%"><a href="javascript:cmdFixing()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="savedoc21" height="22" border="0" width="115"></a></td>
                                                                  <td width="37%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new111','','../images/close2.gif',1)"><img src="../images/close.gif" name="new111"  border="0"></a></td>
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
                                                            <td width="36%"> 
                                                              <div align="left"><b>Total 
                                                                <%=baseCurrency.getCurrencyCode()%> : 
                                                                </b></div>
                                                            </td>
                                                            <td width="64%"> 
                                                              <div align="right"><b> 
                                                                <%
    balance = pettycashPayment.getAmount() - totalDetail;
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
                                              <%if (pettycashPayment.getOID() != 0){%>
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
                                                        <%
    out.print("<a href=\"../freport/rpt_pettycashpayment.jsp?pettycashPayment_id=" + pettycashPayment.getOID() + "\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
                                                                                                                        %>
                                                      </td>
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="9%"><a href="<%=approot%>/transaction/pettycashpaymentdetail.jsp?menu_idx=1" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                                                      <td width="49%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                      <td width="36%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <%if (isSave == true && iErrCodeMain == 0 && iErrCode == 0) {%>
                                                          <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                            <tr> 
                                                              <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                              <td width="220"><%=langCT[11]%></td>
                                                            </tr>
                                                          </table>
                                                          <%} else {%>
                                                          &nbsp; 
                                                          <%}%>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%if(pettycashPayment.getOID() != 0 && pettycashPayment.getPostedStatus() == 1) {%>
                                              <tr> 
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr align="left" valign="top"> 
                                                <td valign="middle" colspan="3"> 
                                                  <div align="left" class="msgnextaction"> 
                                                    <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                      <tr> 
                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                        <td width="150">Posted</td>
                                                      </tr>
                                                    </table>
                                                  </div>
                                                </td>
                                              </tr>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="18%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
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
                          <%} catch (Exception e) { out.println(e.toString());}%>
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
							<script language="JavaScript">
                    <%if (iJSPCommand == JSPCommand.ADD || iErrCode != 0) {%>
						cmdInactveAct(1);
                    <%}
					if(iJSPCommand==JSPCommand.EDIT){
						//System.out.println("pettycashPaymentDetail.getModuleId() : "+pettycashPaymentDetail.getModuleId());
						//System.out.println("pettycashPaymentDetail.getModuleId() : "+selectModuleId);
						if(selectModuleId==0){							
						%>
							cmdInactveAct(0);	
						<%
						}else{%>
							cmdInactveAct(1);	
					<%}}%>
                </script>
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
