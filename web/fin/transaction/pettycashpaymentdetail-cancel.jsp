
<%-- 
    Document   : pettycashpaymentdetail-cancel
    Created on : Feb 13, 2012, 3:30:29 PM
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
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>

<%
            boolean privUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_APPROVE_BKK, AppMenu.PRIV_UPDATE);
            boolean privAnggaran = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_BKK_ANGGARAN, AppMenu.PRIV_VIEW);
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

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPettycashPayment = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("PPPAYMENT_DETAIL");
                oidPettycashPayment = 0;
                recIdx = -1;
            }

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

            int iErrCodeMain = ctrlPettycashPayment.action(iJSPCommand, oidPettycashPayment);

            /* end switch*/
            JspPettycashPayment jspPettycashPayment = ctrlPettycashPayment.getForm();

            /*count list All PettycashPayment*/
            int vectSize = DbPettycashPayment.getCount(whereClause);

            PettycashPayment pettycashPayment = ctrlPettycashPayment.getPettycashPayment();

            String msgStringMain = ctrlPettycashPayment.getMessage();

            if (oidPettycashPayment == 0) {
                oidPettycashPayment = pettycashPayment.getOID();
            }

            if (oidPettycashPayment != 0) {
                try {
                    pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
                } catch (Exception e) {
                }
            }

//================================================= item detail

            boolean load = false;

            if (iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }

            long oidPettycashPaymentDetail = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_detail_id");

            CmdPettycashPaymentDetail ctrlPettycashPaymentDetail = new CmdPettycashPaymentDetail(request);

            Vector listPettycashPaymentDetail = new Vector(1, 1);

            //if (load) {
            listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID(), null);
            //}

            iErrCode = ctrlPettycashPaymentDetail.action(iJSPCommand, oidPettycashPaymentDetail);

            JspPettycashPaymentDetail jspPettycashPaymentDetail = ctrlPettycashPaymentDetail.getForm();

            PettycashPaymentDetail pettycashPaymentDetail = ctrlPettycashPaymentDetail.getPettycashPaymentDetail();
            msgString = ctrlPettycashPaymentDetail.getMessage();

            boolean submit = false;

            if (iJSPCommand == JSPCommand.SUBMIT) {
                submit = true;
                if (iErrCode == 0 && iErrCodeMain == 0) {
                    if (recIdx == -1) {
                        listPettycashPaymentDetail.add(pettycashPaymentDetail);
                    } else {
                        PettycashPaymentDetail ppd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(recIdx);
                        pettycashPaymentDetail.setOID(ppd.getOID());
                        listPettycashPaymentDetail.set(recIdx, pettycashPaymentDetail);
                    }
                }
            }

            if (iJSPCommand == JSPCommand.DELETE) {
                try {
                    PettycashPaymentDetail ppd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(recIdx);
                    DbPettycashPaymentDetail.deleteExc(ppd.getOID());
                    listPettycashPaymentDetail.remove(recIdx);
                } catch (Exception e) {
                }
            }

            boolean isSave = false;
            if (iJSPCommand == JSPCommand.SAVE) {

                if (pettycashPayment.getOID() != 0) {

                    DbPettycashPaymentDetail.saveAllDetail(pettycashPayment, listPettycashPaymentDetail);
                    listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, "pettycash_payment_id=" + pettycashPayment.getOID(), "");
                    isSave = true;
                }

            }

            String wherex = "account_group='Expense' or account_group='Other Expense' or account_group='Fixed Assets'";

            Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_PETTY_CASH, sysLocation.getOID());

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_PETTY_CASH_PAYMENT_SUSPENSE_ACCOUNT + "'", "");

            Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

            double balance = 0;
            double totalDetail = getTotalDetail(listPettycashPaymentDetail);

            pettycashPayment.setAmount(totalDetail);

            if (iJSPCommand == JSPCommand.RESET && iErrCodeMain == 0) {
                totalDetail = 0;
                pettycashPayment = new PettycashPayment();
                listPettycashPaymentDetail = new Vector();
                session.removeValue("PPPAYMENT_DETAIL");
            }


            if (((iJSPCommand == JSPCommand.SUBMIT && recIdx == -1)) && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                pettycashPaymentDetail = new PettycashPaymentDetail();
                recIdx = -1;
            }

            String whereDep = "";

            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            /*** LANG ***/
            String[] langCT = {"Suspense Account", "Debet in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Expense Account", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully",
                "Search Journal Number", "Customer", "Department", "Non postable department, please select another department", "Payment to", "Credit in", "Budget Balance", "Total Cash"
            }; //10-19

            String[] langNav = {"Home", "BKK APPROVAL", "Date", "Required", "SEARCHING", "BKK APPROVAL"};

            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Account Sementara", "Debet", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Untuk Biaya", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses",
                    "Cari Nomor Jurnal", "Konsumen", "Departemen", "Bukan department dengan level terendah, Harap memilih department yang levelnya postable", "Dibayarkan kepada", "Kredit", "Sisa Anggaran", "Total Kas"
                }; //10-19

                langCT = langID;

                String[] navID = {"Home", "APPROVAL BKK ", "Tanggal", "Harus diisi", "PENCARIAN", "APPROVAL BKK"};
                langNav = navID;

                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }
%>
<html >
<head>
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
        <%if (!privUpdate) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function cmdApproval(apdid, status){
            if(parseInt(status)==1){
                if(confirm("Anda yakin menyetujui dokumen ini ? ")){
                    document.frmpettycashpaymentdetail.approval_doc_id.value=apdid;
                    document.frmpettycashpaymentdetail.approval_doc_status.value=status;
                    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmpettycashpaymentdetail.action="<%=approot%>/home.jsp";
                    document.frmpettycashpaymentdetail.submit();
                }				
            }
            else{
                if(confirm("Anda yakin membatalkan persetujuan dokumen ini ? ")){
                    document.frmpettycashpaymentdetail.approval_doc_id.value=apdid;
                    document.frmpettycashpaymentdetail.approval_doc_status.value=status;
                    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmpettycashpaymentdetail.action="<%=approot%>/home.jsp";
                    document.frmpettycashpaymentdetail.submit();
                }
            }
        }
        
        function cmdSearchJurnal(){
            window.open("<%=approot%>/transaction/s_nom_jurnal.jsp?formName=frmpettycashpaymentdetail&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdDepartment(sel){                    
                var oid = sel.options[sel.selectedIndex].value;                    
                          <%if (deps != null && deps.size() > 0) {
                for (int i = 0; i < deps.size(); i++) {
                    Department d = (Department) deps.get(i);
                          %>
                              if(oid=='<%=d.getOID()%>'){
                                                          <%if (d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                        Department d0 = (Department) deps.get(0);
                                                          %>
                                                              alert("<%=langCT[15]%>");
                                                                  document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
                                                                  <%}%>
                                                              }
                 <%		}
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
        
    }
    
    var st = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value;		
    result = removeChar(st);	
    result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
    //add
    if(parseFloat(idx)<0){
        
        var amount = parseFloat(currTotal) + parseFloat(result);
        
        if(amount>limit){
            alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
            
            result = "0";
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

function cmdAdd(pettyCashPaymentOid){
    document.frmpettycashpaymentdetail.select_idx.value="-1";
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=pettyCashPaymentOid;
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdAsk(idx){
    document.frmpettycashpaymentdetail.select_idx.value=idx;
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=idx;
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
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=idxx;
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

function cmdListFirst(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
    document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdListPrev(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
    document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdListNext(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
    document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdAsking(oidPettycashPayment){            
    var cfrm = confirm('Are you sure you want to delete ?');            
    if( cfrm==true){
        document.frmpettycashpaymentdetail.select_idx.value=-1;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=oidPettycashPayment;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.RESET%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
}    

function cmdListLast(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
    document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
    document.frmpettycashpaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidPettycashPaymentDetail){
    document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
    document.frmimage.command.value="<%=JSPCommand.POST%>";
    document.frmimage.action="pettycashpaymentdetail.jsp";
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
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/success1.gif','../images/no1.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<tr> 
<td valign="top"> 
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr> 
        <td height="96"> 
            <%@ include file="../main/hmenu.jsp"%>
        </td>
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
                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                </tr-->
                <tr> 
                    <td> 
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
                    <input type="hidden" name="approval_doc_id" value="">
                    <input type="hidden" name="approval_doc_status" value="">
                    <input type="hidden" name="preview_type" value="<%=previewType%>">
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
                                        <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                        <%
    String nom_jur = "";

    if (isLoad) {
        nom_jur = pettycashPayment.getJournalNumber();
    }
                                        %>                                        
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
                                                <%
    Coa coaxx = new Coa();
    try {
        coaxx = DbCoa.fetchExc(pettycashPayment.getCoaId());
    } catch (Exception e) {
    }
                                                %>
                                            <%=coaxx.getCode() + " - " + coaxx.getName()%></td>
                                            <td width="13%" nowrap><%=langCT[5]%></td>
                                            <td width="38%"><%=JSPFormater.formatDate((pettycashPayment.getTransDate() == null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                        </tr>
                                        <tr> 
                                            <td width="10%"><%=langCT[19]%> <%=baseCurrency.getCurrencyCode()%></td>
                                            <td width="2%">&nbsp;</td>
                                            <td width="37%"> <%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></td>
                                            <td width="13%"><%=langCT[16]%></td>
                                            <td width="38%"><%=pettycashPayment.getPaymentTo()%> 
                                                <%
    String order = DbCustomer.colNames[DbCustomer.COL_NAME];
    Vector vCustomer = DbCustomer.list(0, 0, "", order);
                                                %>
                                                <!--select name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_CUSTOMER_ID]%>">
                                                <option value="0">Select ...</option>
                                                    <%
    if (vCustomer != null && vCustomer.size() > 0) {
        for (int iC = 0; iC < vCustomer.size(); iC++) {
            Customer objCustomer = (Customer) vCustomer.get(iC);
                                                                                                         %>
                                                    <option <%if (pettycashPayment.getCustomerId() == objCustomer.getOID()) {%>selected<%}%> value="<%=objCustomer.getOID()%>"><%=objCustomer.getName()%></option>
                                                    <%
        }
    } else {
                                                                                                         %>
                                                    <option>select ..</option>
                                                    <%}%>
                                                </select-->
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td width="10%" height="16"><%=langCT[2]%></td>
                                            <td width="2%" height="16">&nbsp;</td>
                                            <td rowspan="2" width="37%" valign="top"> 
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr> 
                                                        <td> <%=pettycashPayment.getMemo()%> </td>
                                                        <td valign="top">&nbsp;</td>
                                                        <td><%= (jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO).length() > 0) ? "<br>" + jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO) : "" %></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="13%" height="16">&nbsp;</td>
                                            <td width="38%" height="16">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="5" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                <td> 
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="100%" class="page"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                            <tr> 
                                                                <td  class="tablehdr" width="17%" height="20"><%=langCT[7]%></td>
                                                                <td class="tablehdr" width="16%" height="20"><%=langCT[14]%></td>
                                                                <td class="tablehdr" width="16%" height="20"><%=langCT[1]%> 
                                                                <%=baseCurrency.getCurrencyCode()%></td>
                                                                <td class="tablehdr" width="16%" height="20"><%=langCT[17]%> 
                                                                <%=baseCurrency.getCurrencyCode()%></td>
                                                                <%if (privAnggaran) {%>
                                                                <td class="tablehdr" width="16%" height="20"><%=langCT[18]%> 
                                                                </td>
                                                                <%}%>
                                                                <td class="tablehdr" width="35%" height="20"><%=langCT[8]%></td>
                                                            </tr>
                                                            <%



    if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
        for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {

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

            double sisaAnggaran = 0;
            if (privAnggaran) {
                double budget = DbCoaBudget.getTotalBudgetByCoaInMonth(crd.getCoaId(), crd.getDepartmentId(), periodeXXX);
                RptFormatDetailCoa rdf = new RptFormatDetailCoa();
                rdf.setCoaId(crd.getCoaId());
                rdf.setDepId(crd.getDepartmentId());
                double transaction = DbGlDetail.getAmountInPeriodMTD(periodeXXX.getOID(), rdf);
                sisaAnggaran = budget - transaction;
            }

                                                            %>
                                                            <%if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                            <%} else {%>
                                                            <tr> 
                                                            <td class="<%=cssString%>" width="17%"> 
                                                                <%=c.getCode()%> 
                                                                &nbsp;-&nbsp; 
                                                                <%=c.getName()%> 
                                                            </td>
                                                            <td width="16%" class="<%=cssString%>"> 
                                                                <%
    Department d = new Department();
    try {
        d = DbDepartment.fetchExc(crd.getDepartmentId());
    } catch (Exception e) {
    }

                                                                %>
                                                            <%=d.getCode() + " - " + d.getName()%></td>
                                                            <td width="16%" class="<%=cssString%>"> 
                                                                <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                            </td>
                                                            <td width="16%" class="<%=cssString%>">
                                                                <div align="right"><%=JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##")%></div>
                                                            </td>
                                                            <%if (privAnggaran) {%>
                                                            <td width="16%" <%if (sisaAnggaran < crd.getAmount()) {%>bgcolor="#FF0000"<%} else if ((sisaAnggaran / crd.getAmount()) < 2) {%>bgcolor="yellow"<%} else {%>class="<%=cssString%>"<%}%>> 
                                                                <div align="right"><%=JSPFormater.formatNumber(sisaAnggaran, "#,###.##")%></div>
                                                            </td>
                                                            <%}%>
                                                            <td width="35%" class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                        </tr>
                                                        <%}%>
                                                        <%
        }
    }
                                                        %>
                                                        <%

    if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCode > 0 || iErrCodeMain != 0) && recIdx == -1) && !(isSave && iErrCode == 0 && iErrCodeMain == 0) && (pettycashPayment.getPostedStatus() != 1)) {

                                                        %>
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
                                    <td colspan="2" height="15"></td>
                                </tr>
                                <%if (pettycashPayment.getPostedStatus() == 0) {%>
                                <tr> 
                                    <td width="78%">&nbsp; </td>
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
                    <%}%>
                </table>
            </td>
        </tr>
        <tr> 
            <td colspan="4"> 
                <%
    Vector temp = DbApprovalDoc.getDocApproval(oidPettycashPayment);
                %>
                <table width="700" border="0" cellspacing="1" cellpadding="1">
                    <tr> 
                        <td colspan="7" height="20"><b><%=langApp[0].toUpperCase()%></b> </td>
                    </tr>
                    <tr> 
                        <td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td>
                        <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                        <td width="18%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td>
                        <td width="11%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                        <td width="9%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>
                        <td width="27%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td>
                        <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td>
                    </tr>
                    <tr> 
                        <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                    </tr>
                    <%
    if (temp != null && temp.size() > 0) {

        int totNotApprove = DbApprovalDoc.listTotalDocCancel(oidPettycashPayment);

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
                    <tr height="20"> 
                        <td width="11%"><%=apd.getSequence()%></td>
                        <td width="13%" nowrap><%=employee.getPosition()%></td>
                        <td width="20%" nowrap><%=nama%></td>
                        <td width="13%"><%=tanggal%></td>                        
                        <%
                            String red = "";
                            String fontRed = "";
                            String fontEndRed = "";
                            if (apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {
                                red = "bgcolor=\"#C32F2F\"";
                                fontRed = "<font color=\"FFFFFF\">";
                                fontEndRed = "</font>";
                        %>
                        <%}%>
                        <td width="11%" <%=red%> ><%=fontRed%><%=status%><%=fontEndRed%></td>
                        <td width="20%">
                            <%if (totNotApprove > 0 && user.getEmployeeId() == apd.getEmployeeId() && apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {%>
                            <div align="center"> 
                                <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                            </div>
                            <%}else{%>
                                <%=catatan%>
                            <%}%> 
                        </td>
                        <td width="12%"> 
                            <%if (totNotApprove > 0 && user.getEmployeeId() == apd.getEmployeeId() && apd.getStatus() == DbApprovalDoc.STATUS_NOT_APPROVED) {%>
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                <tr> 
                                    <td> 
                                        <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21<%=i%>','','../images/success1.gif',1)"><img src="../images/success.gif" name="new21<%=i%>"  border="0" alt="Klik untuk menyetujui dokumen"></a></div>
                                    </td>
                                </tr>
                            </table>                            
                            <%}%>
                        </td>
                    </tr>
                    <tr> 
                        <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                    </tr>
                    <%}
    }%>
                    <tr> 
                        <td width="11%">&nbsp;</td>
                        <td width="13%">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="13%">&nbsp;</td>
                        <td width="11%">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="12%">&nbsp;</td>
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
    <td colspan="4" class="container"> <a href="<%=approot%>/home.jsp?preview_type=<%=previewType%>"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" border="0"  alt="Kembali ke lembar kerja anda"></a> 
    </td>
</tr>
<tr align="left" valign="top" > 
    <td colspan="4" class="command">&nbsp; </td>
</tr>
</table>
<%} catch (Exception e) {
                out.println(e.toString());
            }%>
<script language="JavaScript">
    
    </script>
</form>
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
    <td height="25" colspan="2"> 
        <%@ include file="../main/footer.jsp"%>
    </td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
