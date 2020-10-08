
<%-- 
    Document   : kasbon
    Created on : Jul 25, 2011, 2:06:13 PM
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
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../printing/printingvariables.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CPPA, AppMenu.PRIV_DELETE);
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

            // variable ini untuk printing // di setiap ada printing page harus ada ini // dan diset valuenya sesuai oid yg di get
            docChoice = 3;
            generalOID = oidPettycashPayment;
            
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

            JspPettycashPayment jspPettycashPayment = ctrlPettycashPayment.getForm();

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
%>
<%

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

            if (load) {
                listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID(), null);
            }

            iErrCode = ctrlPettycashPaymentDetail.action(iJSPCommand, oidPettycashPaymentDetail);

            JspPettycashPaymentDetail jspPettycashPaymentDetail = ctrlPettycashPaymentDetail.getForm();

            PettycashPaymentDetail pettycashPaymentDetail = ctrlPettycashPaymentDetail.getPettycashPaymentDetail();

            msgString = ctrlPettycashPaymentDetail.getMessage();

            if (session.getValue("PPPAYMENT_DETAIL") != null) {
                listPettycashPaymentDetail = (Vector) session.getValue("PPPAYMENT_DETAIL");
            }

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
                    PettycashPaymentDetail ppdd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(recIdx);
                    DbPettycashPaymentDetail.deleteExc(ppdd.getOID());
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

            session.putValue("PPPAYMENT_DETAIL", listPettycashPaymentDetail);

            Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_PETTY_CASH_PAYMENT_KASBON, sysLocation.getOID());

            //Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_PETTY_CASH_CREDIT + "'", "");
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
            }

            String whereDep = "";

            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            /*** LANG ***/
            String[] langCT = {"Taken From Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Advance Account", "Description", "Insufficient cash balance",//6-9
                "Advance document is ready to be saved", "Advance document has been saved successfully", "Search Journal Number", "Customer", "Employee", "Search Parameter", "Advance Editor", "Advance document is ready to be saved", "Period","Payment to"}; //10-19

            String[] langNav = {"Petty Cash", "Advance", "Date", "Data required"};

            if (lang == LANG_ID) {
                String[] langID = {"Diambil Dari Akun", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Akun Kasbon Karyawan", "Keterangan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen kasbon siap untuk disimpan", "Dokumen kasbon sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Sarana", "Pegawai", "Pencarian Data", "Editor Kasbon", "Dokumen kasbon siap untuk disimpan", "Periode","Dibayarkan kepada"}; //10-19

                langCT = langID;

                String[] navID = {"Kas Kecil", "Kasbon", "Tanggal", "Data harus diisi"};
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
        
        function cmdCetak(param){
			document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LOAD%>";
			document.frmpettycashpaymentdetail.command_print.value=param;
			document.frmpettycashpaymentdetail.action="kasbon.jsp";
			document.frmpettycashpaymentdetail.submit();	
		}

        
        function cmdSearchJurnal(){
            window.open("<%=approot%>/transaction/s_kasbon.jsp?formName=frmpettycashpaymentdetail&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
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
                         }
         <%}
            }%>
        }
        
        function cmdFixing(){	
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.POST%>";
            document.frmpettycashpaymentdetail.action="kasbon.jsp";
            document.frmpettycashpaymentdetail.submit();	
        }
        
        function cmdNewJournal(){		
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmpettycashpaymentdetail.action="kasbon.jsp";
            document.frmpettycashpaymentdetail.submit();	
        }
        
        function cmdNone(){	
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmpettycashpaymentdetail.action="kasbon.jsp";
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
    
    if(limit > parseFloat(pbalanace)){}
    
    var st = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value;		
    result = removeChar(st);	
    result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
    if(parseFloat(idx)<0){        
        var amount = parseFloat(currTotal) + parseFloat(result);        
        var amount = parseFloat(currTotal) + parseFloat(result);        
        document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	        
    }else{
        var editAmount =  document.frmpettycashpaymentdetail.edit_amount.value;
        var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);        
        var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);        
        document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
    }
    
    document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdSubmitCommand(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdDeleteCommand(){
    if(confirm("Anda yakin menghapus data kasbon ini ?")){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.RESET%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="kasbon.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
}

function cmdAsking(oidPettycashPayment){            
    var cfrm = confirm('Are you sure you want to delete ?');            
    if( cfrm==true){
        document.frmpettycashpaymentdetail.select_idx.value=-1;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=oidPettycashPayment;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.RESET%>";
        document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmpettycashpaymentdetail.action="kasbon.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
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

function cmdAdd(pettycashpaymentOid){
    document.frmpettycashpaymentdetail.select_idx.value="-1";
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=pettycashpaymentOid;
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdAsk(idx){
    document.frmpettycashpaymentdetail.select_idx.value=idx;
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdConfirmDelete(oidPettycashPaymentDetail){
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdSave(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdEdit(idxx){
    document.frmpettycashpaymentdetail.select_idx.value=idxx;
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdCancel(oidPettycashPaymentDetail){
    document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdBack(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.BACK%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdListFirst(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdListPrev(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdListNext(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdListLast(){
    document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
    document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
    document.frmpettycashpaymentdetail.action="kasbon.jsp";
    document.frmpettycashpaymentdetail.submit();
}

function cmdDelPict(oidPettycashPaymentDetail){
    document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
    document.frmimage.command.value="<%=JSPCommand.POST%>";
    document.frmimage.action="kasbon.jsp";
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

    </script>
    <!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/newdoc2.gif','../images/deletedoc2.gif')">
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
                                <td> 
                                    <form name="frmpettycashpaymentdetail" method ="post" action="">
                                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                    <input type="hidden" name="start" value="<%=start%>">
                                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                    <input type="hidden" name="hidden_pettycash_payment_detail_id" value="<%=oidPettycashPaymentDetail%>">
                                    <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidPettycashPayment%>">
                                    <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                    <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_TYPE]%>" value="<%=DbPettycashPayment.STATUS_TYPE_KASBON%>">
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
                                                                    <td colspan="4" height="4"></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td colspan="4"><b><u><%=langCT[15].toUpperCase()%></u></b></td>
                                                                </tr>
                                                                <tr> 
                                                                    <td colspan="5">&nbsp;</td>
                                                                </tr>
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
                                                                                <td colspan=5 height=20px><b><u><%=langCT[16].toUpperCase()%></u></b></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan=5 height="15"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="10%">&nbsp;</td>
                                                                                <td width="2%">&nbsp;</td>
                                                                                <td width="37%">*)&nbsp;<%=langNav[3]%></td>
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="38%"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan=5 height="15"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="10%" nowrap><%=langCT[4]%></td>
                                                                                <td width="2%">&nbsp;</td>
                                                                                <td width="37%"> 
                                                                                    <%
    Vector periods = new Vector();

    Periode preClosedPeriod = new Periode();
    Periode openPeriod = new Periode();

    //preClosedPeriod = DbPeriode.getPreClosedPeriod();
    Vector vPreClosed = DbPeriode.list(0,0, DbPeriode.colNames[DbPeriode.COL_STATUS]+"='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"'", ""+DbPeriode.colNames[DbPeriode.COL_START_DATE]);
    openPeriod = DbPeriode.getOpenPeriod();

    //if (preClosedPeriod.getOID() != 0) { periods.add(preClosedPeriod); }
    if(vPreClosed != null && vPreClosed.size() > 0){
        for(int i = 0; i < vPreClosed.size(); i++){
                    Periode prClosed = (Periode)vPreClosed.get(i);
                    if(i== 0){
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

    if (pettycashPayment.getPeriodeId() != 0) {
        try {
            open = DbPeriode.fetchExc(pettycashPayment.getPeriodeId());
        } catch (Exception e) {
        }
    } else {
        if (preClosedPeriod.getOID() != 0) {
            open = DbPeriode.getPreClosedPeriod();
        } else {
            open = DbPeriode.getOpenPeriod();
        }
    }

    int counterJournal = DbSystemDocNumber.getNextCounterBkk(open.getOID());
    strNumber = DbSystemDocNumber.getNextNumberBkk(counterJournal, open.getOID());

    if (pettycashPayment.getOID() != 0 || oidPettycashPayment != 0) {
        strNumber = pettycashPayment.getJournalNumber();
    }
                                                                                    %>
                                                                                    <%=strNumber%> 
                                                                                    <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_NUMBER]%>">
                                                                                    <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_COUNTER]%>">
                                                                                    <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_PREFIX]%>">
                                                                                </td>
                                                                                <td width="13%" nowrap>
                                                                                    <%if (preClosedPeriod.getOID() != 0) {%>
                                                                                    <%=langCT[18]%>
                                                                                    <%} else {%>
                                                                                    &nbsp;
                                                                                    <%}%>
                                                                                </td>
                                                                                <td width="38%"> 
                                                                                    <%if (preClosedPeriod.getOID() != 0) {%>
                                                                                    <select name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_PERIODE_ID]%>">
                                                                                        <%
    if (periods != null && periods.size() > 0) {

        for (int t = 0; t < periods.size(); t++) {

            Periode objPeriod = (Periode) periods.get(t);

                                                                                        %>
                                                                                        <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == pettycashPayment.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                    </select>
                                                                                    <%} else {%>
                                                                                    <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_PERIODE_ID]%>" value="<%=openPeriod.getOID()%>">
                                                                                    <%}%>
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
                                                                                        <%=getAccountRecursif(coa.getLevel() * -1, coa, pettycashPayment.getCoaId(), isPostableOnly)%> 
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
                                                                                    <input type="text" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly size="50">
                                                                                <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_AMOUNT) %> </td>
                                                                                <td width="13%"><%=langCT[14]%></td>
                                                                                <td width="38%"> 
                                                                                    <%
    String orderEmp = DbEmployee.colNames[DbEmployee.COL_NAME];
    String where = DbEmployee.colNames[DbEmployee.COL_CAN_TAKE_ADVANCE] + " = " + DbEmployee.CAN_TAKE_ADVANCE;

    Vector vEmployee = DbEmployee.list(0, 0, where, orderEmp);
                                                                                    %>
                                                                                    <select name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_EMPLOYEE_ID]%>">
                                                                                        <%
    if (vEmployee != null && vEmployee.size() > 0) {

        for (int ix = 0; ix < vEmployee.size(); ix++) {

            Employee objEmployee = (Employee) vEmployee.get(ix);

                                                                                        %>
                                                                                        <option <%if (pettycashPayment.getEmployeeId() == objEmployee.getOID()) {%>selected<%}%> value="<%=objEmployee.getOID()%>"><%=objEmployee.getName()%></option>
                                                                                        <%
                                                                                            }
                                                                                        } else {
                                                                                        %>
                                                                                        <option>select ..</option>
                                                                                        <%}%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="10%" height="16"><%=langCT[2]%></td>
                                                                                <td width="2%" height="16">&nbsp;</td>
                                                                                <td rowspan="2" width="37%" valign="top"> 
                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <textarea name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_MEMO]%>" cols="47" rows="3"><%=pettycashPayment.getMemo()%></textarea>
                                                                                            </td>
                                                                                            <td valign="top">&nbsp;*)</td>
                                                                                            <td valign="top">&nbsp;<%= (jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO).length() > 0) ? "" + jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO) : "" %></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="13%" height="16"><%=langCT[19]%></td>
                                                                                <td width="38%" height="16"><input type="text" size="25" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_PAYMENT_TO]%>" value="<%=pettycashPayment.getPaymentTo()%>"> </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4">&nbsp;</td>
                                                                            </tr>
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
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td  class="tablehdr" width="30%" height="20"><%=langCT[7]%></td>
                                                                                                                    <td class="tablehdr" width="15%" height="20"><%=langCT[1]%> 
                                                                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td class="tablehdr" width="55%" height="20"><%=langCT[8]%></td>
                                                                                                                </tr>
                                                                                                                <%if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
        for (int i = 0; i < listPettycashPaymentDetail.size(); i++) {

            PettycashPaymentDetail crd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(i);
            Coa c = new Coa();
            try {
                c = DbCoa.fetchExc(crd.getCoaId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            String cssString = "tablecell";
            if (i % 2 != 0) {
                cssString = "tablecell1";
            }

                                                                                                                %>
                                                                                                                <%

                                                                                                                    if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" width="30%"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>">
                                                                                                                                <%if (incomeCoas != null && incomeCoas.size() > 0) {
                                                                                                                                                                                                                                            for (int x = 0; x < incomeCoas.size(); x++) {
                                                                                                                                                                                                                                                Coa coax = (Coa) incomeCoas.get(x);

                                                                                                                                                                                                                                                String str = "";

                                                                                                                                %>
                                                                                                                                <option value="<%=coax.getOID()%>" <%if (crd.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                                <%=getAccountRecursif(coax.getLevel() * -1, coax, crd.getCoaId(), isPostableOnly)%> 
                                                                                                                                <%}
                                                                                                                                                                                                                                        }%>
                                                                                                                            </select>
                                                                                                                            <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> 
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                                                                            <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>"  style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                                                                            <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td width="55%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="50" value="<%=crd.getMemo()%>">
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%} else {%>
                                                                                                                <tr> 
                                                                                                                    <td class="<%=cssString%>" width="30%"> 
                                                                                                                        <%if (pettycashPayment.getPostedStatus() == 0) {%>
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

    if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCode > 0 || iErrCodeMain != 0) && recIdx == -1) && !(isSave && iErrCode == 0 && iErrCodeMain == 0) && (pettycashPayment.getPostedStatus() != 1)) {

                                                                                                                %>
                                                                                                                
                                                                                                            
                                                                                                            
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" width="30%"> 
                                                                                                                        <div align="left"> 
                                                                                                                            <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>">
                                                                                                                                <%if (incomeCoas != null && incomeCoas.size() > 0) {

                                                                                                                            for (int x = 0; x < incomeCoas.size(); x++) {

                                                                                                                                Coa coax = (Coa) incomeCoas.get(x);

                                                                                                                                String str = "";

                                                                                                                                %>
                                                                                                                                <option value="<%=coax.getOID()%>" <%if (pettycashPaymentDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                                <%=getAccountRecursif(coax.getLevel() * -1, coax, pettycashPaymentDetail.getCoaId(), isPostableOnly)%> 
                                                                                                                                <%}
                                                                                                                        }%>
                                                                                                                            </select>
                                                                                                                            <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> 
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="right"> 
                                                                                                                            <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(pettycashPaymentDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                                                                            <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td width="55%" class="tablecell"> 
                                                                                                                        <div align="left"> 
                                                                                                                            <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="50" value="<%=pettycashPaymentDetail.getMemo()%>">
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
                                                                                    <td colspan="2">                                                                                         
                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                            <%if (pettycashPayment.getPostedStatus() == 0) {%>
                                                                                            <tr> 
                                                                                                <td width="78%"> 
                                                                                                    <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                                                        <%if (iErrCodeMain == 0 || iErrCode != 0) {


                                                                                                        %>
                                                                                                        <tr> 
                                                                                                            <td> 
                                                                                                                <%
    if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeMain == 0) || (isSave && iErrCode == 0 && iErrCodeMain == 0)) {
                                                                                                                %>                                                                                                                                    
                                                                                                                <% if (privAdd) {%>
                                                                                                                <%if (iJSPCommand == JSPCommand.RESET) {%>
                                                                                                                <table>                                                                                                                              
                                                                                                                    <tr>
                                                                                                                        <td>
                                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                                                                <tr> 
                                                                                                                                    <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                                    <td width="220" nowrap>Delete Success</td>
                                                                                                                                </tr>   
                                                                                                                            </table>
                                                                                                                        </td>
                                                                                                                    </tr>    
                                                                                                                    <tr>
                                                                                                                        <td>&nbsp;</td>
                                                                                                                    </tr>     
                                                                                                                    <tr>
                                                                                                                        <td>
                                                                                                                            <a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                                <%} else {%>
                                                                                                                <a href="javascript:cmdAdd('<%=pettycashPayment.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> 
                                                                                                                <%}
                                                                                                                    }%>
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

                                                                                                                    if (privAdd == false) {
                                                                                                                        ctrLine.setAddCaption("");
                                                                                                                    }

                                                                                                                %>
                                                                                                                <table border="0" cellpadding="0" cellspacing="0">                                                                                                                                        
                                                                                                                    <tr>
                                                                                                                        <td>
                                                                                                                            <%=ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                                                        </td>
                                                                                                                    </tr>    
                                                                                                                </table> 
                                                                                                                <%
    }
                                                                                                                %>
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
                                                                                                                        <td width="63%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savenew2.gif',1)"><img src="../images/savenew.gif" name="savedoc21" height="22" border="0"></a></td>
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
                                                                                                                <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> :</b></div>
                                                                                                            </td>
                                                                                                            <td width="64%"> 
                                                                                                                <div align="right">
                                                                                                                    <b> 
                                                                                                                        <%
    balance = pettycashPayment.getAmount() - totalDetail;
                                                                                                                        %>
                                                                                                                        <input type="hidden" name="total_detail" value="<%=totalDetail%>"><%=JSPFormater.formatNumber(totalDetail, "#,###.##")%>
                                                                                                                    </b>
                                                                                                                </div>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <%
    }
                                                                                        %> 
                                                                                    </td>
                                                                                </tr>  
                                                                                <%
    if (((submit && iErrCode == 0 && iErrCodeMain == 0) || (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0)) && (pettycashPayment.getPostedStatus() != 1)) {
                                                                                %>
                                                                                <tr>
                                                                                    <td colspan="2">
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
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </td>   
                                                                            <tr>
                                                                                <td colspan="2">                                                                                        
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                                                            <td width="68%">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                                <%if (pettycashPayment.getOID() != 0 && pettycashPayment.getPostedStatus() == 0) {%>
                                                                                                <a href="javascript:cmdAsking('<%=pettycashPayment.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post1','','../images/deletedoc2.gif',1)"><img src="../images/deletedoc.gif" name="post1" height="22" border="0"></a> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="24%">
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="info" width="219" align="right">
                                                                                                    <tr> 
                                                                                                        <td width="16"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                                                        <td width="183" nowrap><%=langCT[17]%></td>
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
                                                        </td>
                                                    </tr>
                                                    <%if (pettycashPayment.getOID() != 0) {%>
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
                                                        <td colspan="5">&nbsp;</td> 
                                                    </tr>    
                                                    <tr> 
                                                        <td colspan="5"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td width="4%"> 
                                                                        <%
    out.print("<a href=\"../freport/rpt_pettycashpayment.jsp?pettycashPayment_id=" + pettycashPayment.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");

                                                                        %>
                                                                    </td>
                                                                    <td width="2%">&nbsp;</td>
                                                                    <td width="9%" nowrap><a href="<%=approot%>/transaction/kasbon.jsp?menu_idx=1" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a>&nbsp;&nbsp;&nbsp;</td>                                                                                                                    
                                                                    <td width="49%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                                    <td width="36%"> 
                                                                        <div align="right" class="msgnextaction"> 
                                                                            <%if (isSave == true && iErrCodeMain == 0 && iErrCode == 0) {%>
                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                <tr> 
                                                                                    <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                    <td width="240"><%=langCT[11]%></td>
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
                                                    <%if (pettycashPayment.getOID() != 0 && pettycashPayment.getPostedStatus() == 1) {%>
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
                                            <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="4"><%if (oidPettycashPayment != 0) {%><%@ include file="../printing/printing.jsp"%><%}%>&nbsp;</td>
                                        </tr>

                                        
                                        <%if (oidPettycashPayment != 0) {%>
                                        <tr> 
                                            <td colspan="4">
                                                <%
    Vector temp = DbApprovalDoc.getDocApproval(oidPettycashPayment);
    //out.println(temp);
%>
                                                
                                                <table width="800" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                        <td colspan="7" height="20"><b>STATUS 
                                                        PERSETUJUAN</b> </td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="11%" height="20" bgcolor="#F3F3F3"><b><font size="1">Urutan 
                                                        Persetujuan </font></b></td>
                                                        <td width="13%" height="20" bgcolor="#F3F3F3"><b><font size="1">Oleh</font></b></td>
                                                        <td width="20%" height="20" bgcolor="#F3F3F3"><b><font size="1">Posisi</font></b></td>
                                                        <td width="13%" height="20" bgcolor="#F3F3F3"><b><font size="1">Tanggal 
                                                        Disetujui</font></b></td>
                                                        <td width="11%" height="20" bgcolor="#F3F3F3"><b><font size="1">Status</font></b></td>
                                                        <td width="20%" height="20" bgcolor="#F3F3F3"><b><font size="1">Catatan</font></b></td>
                                                        <td width="12%" height="20" bgcolor="#F3F3F3"><b><font size="1">Tindakan</font></b></td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="7" height="1" bgcolor="#CCCCCC"></td>
                                                    </tr>
                                                    <%
    if (temp != null && temp.size() > 0) {
        for (int i = 0; i < temp.size(); i++) {
            ApprovalDoc apd = (ApprovalDoc) temp.get(i);

            String tanggal = "";
            String status = "";
            String catatan = (apd.getNotes() == null) ? "" : apd.getNotes();
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

            if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                tanggal = JSPFormater.formatDate(apd.getApproveDate(), "dd/MM/yyyy");
                status = DbApprovalDoc.strStatus[DbApprovalDoc.STATUS_APPROVED];

            }

                                                    %>
                                                    <tr> 
                                                        <td width="11%"><%=apd.getSequence()%></td>
                                                        <td width="13%"><%=employee.getName()%></td>
                                                        <td width="20%"><%=employee.getPosition()%></td>
                                                        <td width="13%"><%=tanggal%></td>
                                                        <td width="11%"><%=status%></td>
                                                        <td width="20%"> 
                                                            
                                                            <%if (false) {// && user.getEmployeeId()==apd.getEmployeeId()){%>
                                                            <div align="center">
                                                                <input type="text" name="approval_doc_note" size="30">
                                                            </div>
                                                            <%} else {%>
                                                            <%=catatan%> &nbsp;
                                                            <%}%>
                                                            
                                                        </td>
                                                        <td width="12%">
                                                            <%if (false) {// && user.getEmployeeId()==apd.getEmployeeId()){%>
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                    <td>
                                                                        <%if (apd.getStatus() != DbApprovalDoc.STATUS_APPROVED) {%> 
                                                                        <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"><img src="../images/success.gif" width="20" height="20" alt="Klik : Untuk Menyetujui Dokumen" border="0"></a></div>
                                                                        <%} else {%>
                                                                        <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','0')"><img src="../images/no.gif" width="13" alt="Klik : Untuk Membatalkan Persetujuan" border="0"></a></div>
                                                                        <%}%>
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
                                        <%}%>
                                        
                               
                               
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align="left" valign="top">
                    <td colspan="4" class="command">&nbsp;</td>
                </tr>
                <tr align="left" valign="top" > 
                    <td colspan="4" class="command">&nbsp;</td>
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
    <td height="25">
        <%@ include file="../main/footer.jsp"%>
    </td>
</tr>
</table>
</td>
</tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

