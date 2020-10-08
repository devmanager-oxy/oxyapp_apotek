
<%-- 
    Document   : cash_receive_detail
    Created on : Jun 22, 2011, 2:02:57 PM
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_DELETE);
%>

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
            long coaSuspense = JSPRequestValue.requestLong(request, "hidden_coa_suspense");

            docChoice = 1;
            generalOID = oidPettycashPayment;

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("PPPAYMENT_DETAIL");
                recIdx = -1;
            }

            PettycashPayment objPettycashPayment = new PettycashPayment();

            boolean prosesOk = false;
            if (oidPettycashPayment != 0 && iJSPCommand == JSPCommand.SAVE) {
                long oidCoa = JSPRequestValue.requestLong(request, JspPettycashPayment.colNames[JspPettycashPayment.JSP_COA_ID]);
                Date transDt = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspPettycashPayment.colNames[JspPettycashPayment.JSP_TRANS_DATE]), "dd/MM/yyyy");  //JSPFormater.formatDate(JSPRequestValue.requestString((JspPettycashPayment.colNames[JspPettycashPayment.JSP_TRANS_DATE]), "dd/MM/yyyy");
                long perId = JSPRequestValue.requestLong(request, JspPettycashPayment.colNames[JspPettycashPayment.JSP_PERIODE_ID]);

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

                objPettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
                if (err == false) {
                    objPettycashPayment.setStatus(DbPettycashPayment.STATUS_TYPE_PAID);
                    try {
                        DbPettycashPayment.updateExc(objPettycashPayment);                        
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    oidPettycashPayment = 0;
                }
            }

            PettycashPayment pettycashPayment = new PettycashPayment();
            CmdPettycashPayment ctrlPettycashPayment = new CmdPettycashPayment(request);
            JspPettycashPayment jspPettycashPayment = ctrlPettycashPayment.getForm();
            boolean isSave = false;
            String msgErr = "";

            if (iJSPCommand == JSPCommand.SAVE) {

                isSave = true;
                jspPettycashPayment.requestEntityObject(pettycashPayment);
                try {
                    Coa coa = DbCoa.fetchExc(pettycashPayment.getCoaId());
                    if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        msgErr = "postable account required";
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                if (pettycashPayment.getPeriodeId() != 0) {

                    String wherex = "";
                    Periode preClosedPeriodx = DbPeriode.getPreClosedPeriod();

                    if (preClosedPeriodx.getOID() != 0) {
                        wherex = "'" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                                " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + pettycashPayment.getPeriodeId();
                    } else {
                        wherex = "'" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                                " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                    }

                    Vector v = DbPeriode.list(0, 0, wherex, "");
                    if (v == null || v.size() == 0) {
                        msgErr = "transaction date out of open period range";
                    }
                }

                pettycashPayment.setOID(0);
                pettycashPayment.setJournalNumber(objPettycashPayment.getJournalNumber() + "B");
                pettycashPayment.setJournalPrefix(objPettycashPayment.getJournalPrefix());
                pettycashPayment.setJournalCounter(objPettycashPayment.getJournalCounter());
                pettycashPayment.setActivityStatus(I_Project.STATUS_NOT_POSTED);
                pettycashPayment.setDate(objPettycashPayment.getDate());

                if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                    pettycashPayment.setActivityStatus(I_Project.STATUS_POSTED);
                }

                if (msgErr.length() <= 0) {
                    pettycashPayment.setStatus(DbPettycashPayment.STATUS_TYPE_PAID);
                    pettycashPayment.setPostedStatus(1);
                    try {
                        oidPettycashPayment = DbPettycashPayment.insertExc(pettycashPayment);
                        prosesOk = true;
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }

            if (iJSPCommand != JSPCommand.SAVE) {
                pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
            }
%>

<%
            long oidPettycashPaymentDetail = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_detail_id");
            CmdPettycashPaymentDetail ctrlPettycashPaymentDetail = new CmdPettycashPaymentDetail(request);

            Vector listPettycashPaymentDetail = new Vector(1, 1);
            JspPettycashPaymentDetail jspPettycashPaymentDetail = ctrlPettycashPaymentDetail.getForm();

            PettycashPaymentDetail pettycashPaymentDetail = ctrlPettycashPaymentDetail.getPettycashPaymentDetail();

            if (session.getValue("PPPAYMENT_DETAIL") != null) {
                listPettycashPaymentDetail = (Vector) session.getValue("PPPAYMENT_DETAIL");
            }


            if (iJSPCommand == JSPCommand.SAVE) {
                jspPettycashPaymentDetail.requestEntityObject(pettycashPaymentDetail);
                if (pettycashPayment.getOID() != 0) {
                    try {                        
                        pettycashPaymentDetail.setPettycashPaymentId(pettycashPayment.getOID());
                        DbPettycashPaymentDetail.insertExc(pettycashPaymentDetail);
                        listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, "" + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID(), "");
                        DbPettycashPayment.postJournalPelunasanTunai(pettycashPayment, listPettycashPaymentDetail, user.getOID());
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
                iJSPCommand = JSPCommand.ADD;
            }

            session.putValue("PPPAYMENT_DETAIL", listPettycashPaymentDetail);
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_PETTY_CASH_CREDIT + "'", "");
            double totalDetail = getTotalDetail(listPettycashPaymentDetail);
            String whereDep = "";
            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            String[] langCT = {"Receipt to Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Account - Description", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully", "Search Journal Number", "Paid", "Period"}; //10-14

            String[] langNav = {"Cash Transaction", "Cash Payment", "Date", "CASH PAYMENT EDITOR"};

            if (lang == LANG_ID) {
                String[] langID = {"Perkiraan", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Perkiraan", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Paid", "Periode"}; //10-14
                langCT = langID;

                String[] navID = {"Transaksi Tunai", "Pembayaran Tunai", "Tanggal", "EDITOR PEMBAYARAN TUNAI"};
                langNav = navID;
            }

            Vector segments = DbSegment.list(0, 0, "", "");
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
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LOAD%>";
            document.frmpettycashpaymentdetail.command_print.value=param;
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();	
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
            
            function cmdNone(){	
                document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
                document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
                document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
                document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
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
                
                if(amount>limit){
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
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
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
        
        function cmdSave(){
            document.frmpettycashpaymentdetail.select_idx.value="-1";
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.POST%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        
        function cmdAdd(){
            document.frmpettycashpaymentdetail.select_idx.value="-1";
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdAsk(idx){
            document.frmpettycashpaymentdetail.select_idx.value=idx;
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdConfirmDelete(oidPettycashPaymentDetail){
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdSave(){
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdEdit(idxx){
            document.frmpettycashpaymentdetail.select_idx.value=idxx;
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdCancel(oidPettycashPaymentDetail){
            document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdBack(){       
            document.frmpettycashpaymentdetail.action="cash_receive.jsp";
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.BACK%>";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdCancel(){       
            document.frmpettycashpaymentdetail.action="cash_receive.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdListFirst(){
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdListPrev(){
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdListNext(){
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        function cmdListLast(){
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
            document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmpettycashpaymentdetail.action="cash_receive_detail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
        
        //-------------- script form image -------------------
        
        function cmdDelPict(oidPettycashPaymentDetail){
            document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="cash_receive_detail.jsp";
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
                                    <form name="frmpettycashpaymentdetail" method ="post" action="">
                                    <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                    <input type="hidden" name="start" value="<%=start%>">
                                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                    <input type="hidden" name="hidden_pettycash_payment_detail_id" value="<%=oidPettycashPaymentDetail%>">
                                    <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidPettycashPayment%>">
                                    <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                    <input type="hidden" name="<%=JspPettycashPayment.colNames[JspPettycashPayment.JSP_TYPE]%>" value="<%=DbPettycashPayment.STATUS_TYPE_PELUNASAN_TUNAI%>">
                                    <input type="hidden" name="<%=JspPettycashPaymentDetail.colNames[JspPettycashPaymentDetail.JSP_TYPE]%>" value="<%=DbPettycashPayment.STATUS_TYPE_PELUNASAN_TUNAI%>">                                                            
                                    <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                    <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                                    <input type="hidden" name="pcash_balance" value="">
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
                                                                    <td>&nbsp;</td>
                                                                </tr>                                                                                                                
                                                                <tr> 
                                                                    <td>
                                                                        <table border="0" cellpadding="1" cellspacing="1" width="650">                                                                                                                                        
                                                                            <tr>                                                                                                                                            
                                                                                <td class="tablecell1" > 
                                                                                    <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">  
                                                                                        <tr> 
                                                                                            <td colspan="5" height="10"></td>                                                                                  
                                                                                        </tr>                                                                                                    
                                                                                        <tr> 
                                                                                            <td width="5">&nbsp;</td>
                                                                                            <td width="80" class="fontarial"><%=langCT[4]%></td>                                                                                            
                                                                                            <td width="250">
                                                                                                <%
    Vector periods = new Vector();

    Periode preClosedPeriod = new Periode();
    Periode openPeriod = new Periode();

    Vector vPreClosed = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE]);
    openPeriod = DbPeriode.getOpenPeriod();
    if (vPreClosed != null && vPreClosed.size() > 0) {
        for (int i = 0; i < vPreClosed.size(); i++) {
            Periode prClosed = (Periode) vPreClosed.get(i);
            if (i == 0) {
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
    strNumber = DbSystemDocNumber.getNextNumberBkk(counterJournal, open.getOID()) + "B";

    if ((pettycashPayment.getOID() != 0 || oidPettycashPayment != 0) && isSave == false) {
        strNumber = pettycashPayment.getJournalNumber() + "B";
    } else {
        strNumber = pettycashPayment.getJournalNumber();
    }

                                                                                                %> 
                                                                                                <%=strNumber%> 
                                                                                                <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_NUMBER]%>">
                                                                                                <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_COUNTER]%>">
                                                                                                <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_PREFIX]%>">
                                                                                            </td>
                                                                                            <td width="120" class="fontarial">
                                                                                                <%if (preClosedPeriod.getOID() != 0) {%>
                                                                                                <%=langCT[14]%>
                                                                                                <%} else {%>
                                                                                                &nbsp;
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="fontarial">
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
                                                                                            </td>                                                                                                                                                                                             
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td >&nbsp;</td>
                                                                                            <td nowrap class="fontarial"><%=langCT[0]%></td>                                                                                            
                                                                                            <td >
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
                                                                                                <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_COA_ID) %> 
                                                                                            </td>
                                                                                            <td class="fontarial"><%=langCT[5]%></td>
                                                                                            <td>
                                                                                                <input name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((pettycashPayment.getTransDate() == null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_TRANS_DATE) %> 
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td >&nbsp;</td>
                                                                                            <td class="fontarial"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                            
                                                                                            <td colspan="3"><input type="text" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly size="30"></td>                                                                                            
                                                                                            
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td >&nbsp;</td>
                                                                                            <td valign="top" class="fontarial"><%=langCT[2]%></td>                                                                                            
                                                                                            <td > 
                                                                                                <textarea name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_MEMO]%>" cols="35" rows="2"><%=pettycashPayment.getMemo()%></textarea>
                                                                                            </td>
                                                                                            <td valign="top" colspan="2">
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td width="125" class="fontarial"><b><i>Segmen</i></b></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>                                                                                              
                                                                                                    <%
    if (segments != null && segments.size() > 0) {
        for (int i = 0; i < 1; i++) {
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

            Vector sgDetails = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);

                                                                                                    %>
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="110" class="fontarial"><%=segment.getName()%></td>
                                                                                                        <td > 
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
                                                                                                </table>
                                                                                                <%
        }
    }
                                                                                                %> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                    
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                                                                
                                                                <tr> 
                                                                    <td>&nbsp;</td>
                                                                </tr>                                                                                                                
                                                                <tr> 
                                                                    <td> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="100%" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr height="28"> 
                                                                                            <td class="tablearialhdr" width="20%" height="20">Segmen</td>
                                                                                            <td class="tablearialhdr" width="30%" height="20"><%=langCT[7]%></td>
                                                                                            <td class="tablearialhdr" width="15%" height="20"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                            <td class="tablearialhdr" width="35%" height="20"><%=langCT[8]%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="tablearialcell1">
                                                                                                <%
    if (segments != null && segments.size() > 0) {
        for (int i = 0; i < 1; i++) {
            Segment segment = (Segment) segments.get(i);

            String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + segment.getOID();

            switch (i + 1) {
                case 1:
                    //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                    //maka akan di tampikan sesuai dengan segment yang ditentukan
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment1Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment1Id();
                    }
                    break;
                case 2:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment2Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment2Id();
                    }
                    break;
                case 3:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment3Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment3Id();
                    }
                    break;
                case 4:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment3Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment3Id();
                    }
                    break;
                case 5:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment5Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment5Id();
                    }
                    break;
                case 6:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment6Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment6Id();
                    }
                    break;
                case 7:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment7Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment7Id();
                    }
                    break;
                case 8:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment8Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment8Id();
                    }
                    break;
                case 9:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment9Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment9Id();
                    }
                    break;
                case 10:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment10Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment10Id();
                    }
                    break;
                case 11:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment11Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment11Id();
                    }
                    break;
                case 12:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment12Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment12Id();
                    }
                    break;
                case 13:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment13Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment13Id();
                    }
                    break;
                case 14:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment14Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment14Id();
                    }
                    break;
                case 15:
                    if (iJSPCommand == JSPCommand.NONE) {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPayment.getSegment15Id();
                    } else {
                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + pettycashPaymentDetail.getSegment15Id();
                    }
                    break;
            }

            Vector sgDetails = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);

                                                                                                %>
                                                                                                <table border="0" bgcolor="#F3F3F3">                                                                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td class="fontarial"><%=segment.getName()%>&nbsp;&nbsp;</td>
                                                                                                        <td > 
                                                                                                            <select name="JSP_SEGMENT<%=i + 1%>_ID_DETAIL">
                                                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                            for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                String selected = "";
                                                                                                                switch (i + 1) {
                                                                                                                    case 1:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment1Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }

                                                                                                                        break;
                                                                                                                    case 2:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment2Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 3:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment3Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 4:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment4Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 5:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment5Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 6:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment6Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 7:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment7Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 8:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment8Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 9:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment9Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 10:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment10Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 11:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment11Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 12:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment12Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 13:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment13Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 14:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment14Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        }
                                                                                                                        break;
                                                                                                                    case 15:
                                                                                                                        if (iJSPCommand == JSPCommand.NONE) {
                                                                                                                            if (pettycashPayment.getSegment5Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            if (pettycashPaymentDetail.getSegment5Id() == sd.getOID()) {
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
                                                                                            <td class="tablearialcell1">                                                                                                                                             
                                                                                                <%

    if (iJSPCommand == JSPCommand.NONE) {
        coaSuspense = pettycashPayment.getCoaId();
    }

    Coa objCoaSuspense = new Coa();
    try {
        objCoaSuspense = DbCoa.fetchExc(coaSuspense);
    } catch (Exception e) {
    }
                                                                                                %>   
                                                                                                <input type="hidden" name="hidden_coa_suspense" value="<%=coaSuspense%>">
                                                                                                <input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>" value="<%=coaSuspense%>">
                                                                                                <%=objCoaSuspense.getCode()%>&nbsp;-&nbsp; <%=objCoaSuspense.getName()%>                                                                                                                                                
                                                                                            </td>
                                                                                            <td class="tablearialcell1">
                                                                                                <input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=pettycashPayment.getAmount()%>">
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <%
    String notes = "";
    if (iJSPCommand == JSPCommand.NONE) {
        notes = pettycashPayment.getMemo();
    } else {
        notes = pettycashPaymentDetail.getMemo();
    }
                                                                                            %>
                                                                                            <input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" value="<%=notes%>">
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;<%=notes%></td>
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
                                                                    <td width="78%"> 
                                                                        <%if(prosesOk == false){%>
                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="120">
                                                                                    <%if (privUpdate || privAdd) {%>                                                                                   
                                                                                    <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="new1" border="0"></a>
                                                                                    <%}%>                                                                                    
                                                                                </td>
                                                                                <td width="120">
                                                                                    <a href="javascript:cmdCancel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel" border="0"></a>
                                                                                </td>                                                                    
                                                                            </tr>
                                                                        </table>    
                                                                        <%}else{%>
                                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td width="120">
                                                                                    <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" border="0"></a>
                                                                                </td>                                                                    
                                                                            </tr>
                                                                        </table>  

                                                                        <%}%>
                                                                    </td>
                                                                    <td class="boxed1" width="22%"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td width="36%" class="fontarial"> 
                                                                                    <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                                </td>
                                                                                <td width="64%" class="fontarial"> 
                                                                                    <div align="right"><b> 
                                                                                            <input type="hidden" name="total_detail" value="<%=pettycashPayment.getAmount()%>">
                                                                                    <%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></b></div>
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
                                                        <td colspan="5" height="15"></td>
                                                    </tr>    
                                                    <tr> 
                                                        <td colspan="5">
                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                <tr>
                                                                    <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                <td width="150" nowrap><%=msgErr%></td></tr>
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
                        </table>
                    </td>
                </tr>              
                <tr align="left" valign="top" > 
                    <td colspan="4" class="command">&nbsp; </td>
                </tr>
            </table>
            <%} catch (Exception e) {
                out.println(e.toString());
            }%>
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
