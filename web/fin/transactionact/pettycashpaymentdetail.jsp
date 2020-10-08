
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
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../printing/printingvariables.jsp"%>
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
            long oidPettycashPayment = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int reset_app = JSPRequestValue.requestInt(request, "reset_app");
            String strApproval = DbSystemProperty.getValueByName("APPLY_DOC_WORKFLOW");
            int typePembayaran = JSPRequestValue.requestInt(request, "type_pembayaran");

            docChoice = 1;
            generalOID = oidPettycashPayment;

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("PPPAYMENT_DETAIL");
                oidPettycashPayment = 0;
                recIdx = -1;
            }

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
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

            if (reset_app == 1) {
                DbApprovalDoc.resetApproval(I_Project.TYPE_APPROVAL_BKK, pettycashPayment.getOID());
            }

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
                    try {
                        PettycashPaymentDetail ppd = (PettycashPaymentDetail) listPettycashPaymentDetail.get(recIdx);
                        DbPettycashPaymentDetail.deleteExc(ppd.getOID());
                    } catch (Exception e) {
                    }
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
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_PETTY_CASH_PAYMENT_SUSPENSE_ACCOUNT + "'", "");
            Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_PETTY_CASH, sysLocation.getOID());
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

            /*** LANG ***/
            String[] langCT = {"Suspense Account", "Amount in", "Memo", "Account Balance", "Journal Number", "Transaction Date", //0-5
                "Detail", "Expense Account", "Description", "Insufficient cash balance",//6-9
                "Petty cash payment document is ready to be saved", "Petty cash payment document has been saved successfully", //10 - 11
                "Searching", "Customer", "Department", "Non postable department, please select another department", "Payment to", "Credit in", "Period", "Segment", "Segment"}; //12-20

            String[] langNav = {"Cash Transaction", "Cash Payment", "Date", "Required", "Searching", "Disbushment Editor", "Payment Type"};

            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Account Pembayaran", "Jumlah", "Catatan", "Saldo Perkiraan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Detail", "Untuk Biaya", "Penjelasan", "Saldo kas tidak mencukupi", //6-9
                    "Dokumen pembayaran tunai siap untuk disimpan", "Dokumen pembayaran tunai sudah disimpan dengan sukses", //10 - 11
                    "Pencarian", "Konsumen", "Departemen", "Bukan department dengan level terendah, Harap memilih department yang levelnya postable", "Dibayarkan kepada", "Kredit", "Periode", "Segmen", "Segmen"}; //12-20
                langCT = langID;

                String[] navID = {"Transaksi Tunai", "Pembayaran Tunai", "Tanggal", "Harus diisi", "Pencarian", "Editor Pengakuan Biaya", "Tipe Pembayaran"};
                langNav = navID;

                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            Vector segments = DbSegment.list(0, 0, "", "");
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
            var numb = document.frmpettycashpaymentdetail.jurnal_number.value;                          
            window.open("<%=approot%>/transactionact/s_nom_jurnal.jsp?txt_jurnal=\'"+numb+"'&command=<%=JSPCommand.SEARCH%>&formName=frmpettycashpaymentdetail&txt_Id=cash_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=pettycashPayment.getOID()%>");
                }
                
                function cmdClickIt(obj){
                    obj.select();           
                }            
                
                function cmdNewJournal(){		
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
            
            var stCredit = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_CREDIT_AMOUNT]%>.value;		
            resultCredit = removeChar(stCredit);	
            resultCredit = cleanNumberFloat(resultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            if(parseFloat(st)>0 && parseFloat(stCredit)>0){
                alert("tidak boleh mengisi keduanya debet dan kredit, system akan me-reset data kredit");
                resultCredit = "0";		
                
            }else{    
            //add
            if(parseFloat(idx)<0){
                var amount = parseFloat(currTotal) + parseFloat(result) - parseFloat(resultCredit);        
                document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	        
            }
            //edit
            else{
                var editAmount =  document.frmpettycashpaymentdetail.edit_amount.value;
                var editCreditAmount =  0;       
                var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result) + parseFloat(editCreditAmount) - parseFloat(resultCredit);        
                document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
                
            }
        }
        
        document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
        document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_CREDIT_AMOUNT]%>.value = formatFloat(resultCredit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
    }
    
    function cmdSubmitCommand(){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdAdd(pettyCashPaymentOid){
        document.frmpettycashpaymentdetail.select_idx.value="-1";
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=pettyCashPaymentOid;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdAsk(idx){
        document.frmpettycashpaymentdetail.select_idx.value=idx;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=idx;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdConfirmDelete(oidPettycashPaymentDetail){
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdSave(){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdEdit(idxx){
        document.frmpettycashpaymentdetail.select_idx.value=idxx;
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=idxx;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdCancel(oidPettycashPaymentDetail){
        document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";    
        document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
        document.frmpettycashpaymentdetail.submit();
    }
    
    function cmdBack(){
        document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.BACK%>";
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
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
    }    
    
    function cmdSelect(){
        var st = document.frmpettycashpaymentdetail.type_pembayaran.value;
        if(parseFloat(st)==1){
            document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmpettycashpaymentdetail.action="pettycashpaymentdetailbudget.jsp";
            document.frmpettycashpaymentdetail.submit();
        }
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
    <!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/newdoc2.gif','../images/deletedoc2.gif')">
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
                    <form name="frmpettycashpaymentdetail" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                        
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
                                        <td colspan="4" height="10"></td>
                                    </tr>
                                    <tr> 
                                        <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">                                                                                                    
                                                <tr> 
                                                    <td width="10%" colspan="5">                                                                                                            
                                                        <table border="0" cellpadding="1" cellspacing="1" width="320">     
                                                            <tr>
                                                                <td class="fontarial">
                                                                    <table>
                                                                        <tr>
                                                                            <td><%=langNav[6]%></td>
                                                                            <td>:</td>
                                                                            <td>
                                                                                <select name="type_pembayaran" onChange="javascript:cmdSelect()" class="fontarial">
                                                                                    <option value="0" <%if (typePembayaran == 0) {%> selected <%}%> >< Transaksi Jurnal ></option>
                                                                                    <option value="1" <%if (typePembayaran == 1) {%> selected <%}%> >< Pembayaran Budget ></option>
                                                                                </select>
                                                                            </td>
                                                                        </tr>
                                                                    </table>    
                                                                </td>
                                                            </tr>  
                                                            <tr>
                                                                <td height="10"></td>
                                                            </tr> 
                                                            <tr>
                                                                <td >
                                                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                               
                                                                        <tr> 
                                                                            <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr> 
                                                            <tr>
                                                                <td height="10"></td>
                                                            </tr> 
                                                            <tr>                                                                                                                                            
                                                                <td class="tablecell1" > 
                                                                    <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">                                                                                                           
                                                                        <%
    String nom_jur = "";
    if (isLoad && reset_app != 1) {
        nom_jur = pettycashPayment.getJournalNumber();
    }
                                                                        %>
                                                                        <tr height="5">
                                                                            <td colspan="5"></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="5">&nbsp;</td>
                                                                            <td colspan="3"><font face="arial"><b><i><%=langCT[12]%></i></b></font></td>                                                                                                                                
                                                                        </tr>
                                                                        <tr>
                                                                            <td >&nbsp;</td>
                                                                            <td width="70" class="fontarial"><%=langCT[4]%></td>
                                                                            <td width="100"><input size="25" type="text" name="jurnal_number" value="<%=nom_jur%>"></td>
                                                                            <td><input size="50" type="hidden" name="cash_id" value="<%=pettycashPayment.getOID()%>">
                                                                                <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>  
                                                                            </td>
                                                                        </tr>
                                                                        <tr height="10">
                                                                            <td colspan="4"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>                                                                                                    
                                                <tr> 
                                                    <td colspan=5 height="10"></td>
                                                </tr>                                                                                                                                                                                                   
                                                <tr> 
                                                    <td colspan="5" >
                                                        <table border="0" cellpadding="1" cellspacing="1" width="900">        
                                                            
                                                            <tr>                                                                                                                                            
                                                                <td class="tablecell1" > 
                                                                    <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                        <tr> 
                                                                            <td width="5"></td>
                                                                            <td colspan="5" height="23"><font face="arial"><b><i><%=langNav[5]%></i></b></font></td>
                                                                        </tr> 
                                                                        <tr> 
                                                                            <td width="5">&nbsp;</td>
                                                                            <td width="100" nowrap class="fontarial"><%=langCT[4]%></td>
                                                                            <td width="1">&nbsp;</td>
                                                                            <td width="380" class="fontarial"> 
                                                                                <%

    Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

    String strNumber = "";
    Periode open = new Periode();
    if (pettycashPayment.getPeriodeId() != 0) {
        try {
            open = DbPeriode.fetchExc(pettycashPayment.getPeriodeId());
        } catch (Exception e) {
        }
    } else {
        if (periods != null && periods.size() > 0) {
            open = (Periode) periods.get(0);
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
                                                                            <td width="110" nowrap class="fontarial">
                                                                                <%if (periods.size() > 1) {%>
                                                                                <%=langCT[18]%>
                                                                                <%} else {%>
                                                                                &nbsp;
                                                                                <%}%>
                                                                            </td>
                                                                            <td >
                                                                                <%if (open.getStatus().equals("Closed") || pettycashPayment.getOID() != 0) {%>
                                                                                <%=open.getName()%>
                                                                                <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                <%} else {%>
                                                                                <%if (periods.size() > 1) {%>
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
                                                                                <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                <%}
    }%>                                                                                                                        
                                                                                <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>" readOnly style="text-align:right">
                                                                            </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td >&nbsp;</td>
                                                                            <td nowrap class="fontarial"><%=langCT[0]%></td>
                                                                            <td >&nbsp;</td>
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
                                                                            <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_COA_ID) %> </td>
                                                                            <td nowrap><%=langCT[5]%></td>
                                                                            <td > 
                                                                                <input name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((pettycashPayment.getTransDate() == null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                            <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_TRANS_DATE) %> </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="5">&nbsp;</td>
                                                                            <td class="fontarial"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                            <td >&nbsp;</td>
                                                                            <td > 
                                                                                <input type="text" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly size="30">
                                                                            <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_AMOUNT) %> </td>
                                                                            <td ><%=langCT[16]%></td>
                                                                            <td > 
                                                                                <input type="text" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_PAYMENT_TO]%>" style="text-align:left" value="<%=pettycashPayment.getPaymentTo()%>" size="30">
                                                                                <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_PAYMENT_TO) %>                                                                                                                         
                                                                            </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="5">&nbsp;</td>
                                                                            <td height="16" valign="top" class="fontarial"><%=langCT[2]%></td>
                                                                            <td height="16">&nbsp;</td>
                                                                            <td rowspan="2" valign="top"> 
                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr> 
                                                                                        <td> 
                                                                                            <textarea name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_MEMO]%>" cols="40" rows="3"><%=pettycashPayment.getMemo()%></textarea>
                                                                                        </td>
                                                                                        <td valign="top">&nbsp;</td>
                                                                                        <td><%= (jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO).length() > 0) ? "<br>" + jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO) : "" %></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                            <td height="16" colspan="2">
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr> 
                                                                                        <td> 
                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        
                                                                                        <tr>
                                                                                            <td width="110" class="fontarial"><b><i><%=langCT[19]%></i></b></td>
                                                                                            <td >&nbsp;</td>
                                                                                        </tr>
                                                                                    </tr>
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
                                                                                    <tr> 
                                                                                        <td ><%=segment.getName()%></td>
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
                                                                                    <%}
    }%>                                                                                                                                                                                                                                             
                                                                                    <tr> 
                                                                                        <td colspan="2">&nbsp;</td>                                                                                                                                                        
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr> 
                                                                <td colspan="6" height="15"></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
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
                                                                <tr height="28"> 
                                                                    <td class="tablearialhdr" width="25%" height="20"><%=langCT[20]%></td>
                                                                    <td class="tablearialhdr" width="25%" height="20"><%=langCT[7]%></td>                                                                                                                                            
                                                                    <td class="tablearialhdr" width="17%" height="20"><%=langCT[1]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                                                                            
                                                                    <td class="tablearialhdr" ><%=langCT[8]%></td>
                                                                </tr>
                                                                <%if (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0) {
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

                                                                %>
                                                                <%if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                <tr height="22"> 
                                                                    <td class="<%=cssString%>"> 
                                                                        <table width="49%" border="0" cellspacing="0" cellpadding="0" align="left">                                                                                                                                                   
                                                                            <tr> 
                                                                                <td width="62%" nowrap> 
                                                                                    <div align="left"> 
                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                            <%

    if (segments != null && segments.size() > 0) {
        for (int xx = 0; xx < segments.size(); xx++) {
            Segment seg = (Segment) segments.get(xx);
            Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);

                                                                                            %>
                                                                                            <tr> 
                                                                                                <td width="54%" nowrap class="fontarial"><%=seg.getName()%>&nbsp;</td>
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
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td class="<%=cssString%>">
                                                                    <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>">
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
                                                                    <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> </div>
                                                                </td>                                                                                                                                            
                                                                <td class="<%=cssString%>"> 
                                                                    <div align="center"> 
                                                                        <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                        <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt(this)">
                                                                        <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                </td>
                                                                <input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt(this)">                                                                                                                                            
                                                                <td class="<%=cssString%>"> 
                                                                    <div align="center"> 
                                                                        <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="40" value="<%=crd.getMemo()%>">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <%} else {%>
                                                            <tr> 
                                                                <td class="<%=cssString%>">
                                                                    <%

    if (segments != null && segments.size() > 0) {
                                                                    %>    
                                                                    <table border="0" cellpadding="1" cellspacing="1" >
                                                                        <%
                                                                            for (int is = 0; is < segments.size(); is++) {
                                                                                Segment objSeg = (Segment) segments.get(is);

                                                                        %>
                                                                        <tr>
                                                                            <td ><%=objSeg.getName()%>&nbsp;</td>
                                                                            <%
                                                                            String nameSeg = "";
                                                                            switch (is + 1) {
                                                                                case 1:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment1Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 2:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment2Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 3:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment3Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 4:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment4Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 5:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment5Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 6:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment6Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 7:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment7Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 8:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment8Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 9:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment9Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 10:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment10Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 11:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment11Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 12:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment12Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 13:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment13Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 14:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment14Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }

                                                                                case 15:
                                                                                    try {
                                                                                        SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment15Id());
                                                                                        nameSeg = sdet.getName();
                                                                                    } catch (Exception e) {
                                                                                    }
                                                                                    break;
                                                                            }
                                                                            %>
                                                                            <td >&nbsp;:&nbsp;&nbsp;<%=nameSeg%></td>
                                                                        </tr>                                                                                                                                                
                                                                        <%
                                                                            }
                                                                        %>    
                                                                    </table>
                                                                    <%
    }
                                                                %></td>
                                                                <td class="<%=cssString%>"> 
                                                                    <%if (pettycashPayment.getPostedStatus() == 0) {%>                                                                                                                                                
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%> - <%=c.getName()%></a>                                                                                                                                                
                                                                    <%} else {%>                                                                                                                                                
                                                                    <%=c.getCode()%> 
                                                                    &nbsp;-&nbsp; 
                                                                    <%=c.getName()%>
                                                                    <%}%>
                                                                </td>                                                                                                                                            
                                                                <td class="<%=cssString%>"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                </td>                                                                                                                                            
                                                                <td class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                            </tr>
                                                            <%}%>
                                                            <%
        }
    }
                                                            %>
                                                            <%

    if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCode > 0 || iErrCodeMain != 0) && recIdx == -1) && !(isSave && iErrCode == 0 && iErrCodeMain == 0) && (pettycashPayment.getPostedStatus() != 1)) {

                                                            %>
                                                            <tr height="22"> 
                                                                <td class="tablecell1"> 
                                                                    <table width="49%" border="0" cellspacing="0" cellpadding="0" align="left">                                                                                                                                                    
                                                                        <tr > 
                                                                            <td width="62%" nowrap> 
                                                                                <div align="left"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <%
                                                                    if (segments != null && segments.size() > 0) {
                                                                        for (int i = 0; i < segments.size(); i++) {
                                                                            Segment seg = (Segment) segments.get(i);
                                                                            Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="54%" nowrap class="fontarial"><%=seg.getName()%>&nbsp;</td>
                                                                                            <td width="46%"> 
                                                                                                <select name="JSP_SEGMENT<%=i + 1%>_ID_DETAIL">
                                                                                                    <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                        String selected = "";
                                                                                                        switch (i + 1) {
                                                                                                            case 1:
                                                                                                                if (pettycashPaymentDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 2:
                                                                                                                if (pettycashPaymentDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 3:
                                                                                                                if (pettycashPaymentDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 4:
                                                                                                                if (pettycashPaymentDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 5:
                                                                                                                if (pettycashPaymentDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 6:
                                                                                                                if (pettycashPaymentDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 7:
                                                                                                                if (pettycashPaymentDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 8:
                                                                                                                if (pettycashPaymentDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 9:
                                                                                                                if (pettycashPaymentDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 10:
                                                                                                                if (pettycashPaymentDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 11:
                                                                                                                if (pettycashPaymentDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 12:
                                                                                                                if (pettycashPaymentDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 13:
                                                                                                                if (pettycashPaymentDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 14:
                                                                                                                if (pettycashPaymentDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 15:
                                                                                                                if (pettycashPaymentDetail.getSegment15Id() == sd.getOID()) {
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
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td class="tablecell1"> 
                                                                    <div align="center"> 
                                                                        <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>">
                                                                            <%
                                                                    if (incomeCoas != null && incomeCoas.size() > 0) {

                                                                        for (int x = 0; x < incomeCoas.size(); x++) {
                                                                            Coa coax = (Coa) incomeCoas.get(x);
                                                                            String str = "";
                                                                            %>
                                                                            <option value="<%=coax.getOID()%>" <%if (pettycashPaymentDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                            <%=getAccountRecursif(coax.getLevel() * -1, coax, pettycashPaymentDetail.getCoaId(), isPostableOnly)%> 
                                                                            <%
                                                                        }
                                                                    }
                                                                            %>
                                                                        </select>                           
                                                                        
                                                                    <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> </div>
                                                                </td>                                                                                                                                            
                                                                <td class="tablecell1"> 
                                                                    <div align="center"> 
                                                                        <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(pettycashPaymentDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="20" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt(this)">
                                                                        <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                </td>
                                                                <input type="hidden" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(pettycashPaymentDetail.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt(this)">                                                                                                                                            
                                                                <td class="tablecell1"> 
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
                                        <td colspan="2" height="15"></td>
                                    </tr>
                                    <%if (pettycashPayment.getPostedStatus() == 0) {%>
                                    <tr> 
                                        <td width="78%"> 
                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                <%if (iErrCodeMain == 0 || iErrCode != 0) {%>
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
                                                                <td> <a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new12','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new12" height="22" border="0"></a> 
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
                                                            <tr><td> <%=ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%></td></tr>
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
                                                                <td width="37%"></td>
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
                        <%
    }

    if (((submit && iErrCode == 0 && iErrCodeMain == 0) || (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0)) && (pettycashPayment.getPostedStatus() != 1)) {
                        %>
                        <tr><td colspan="5" height="5"></td></tr>
                        <tr> 
                            <td colspan="5"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr><td height="2">&nbsp;</td></tr><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr><td colspan="5" height="5"></td></tr>
                        <tr> 
                            <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                    <td width="8%">
                                        <div onclick="this.style.visibility='hidden'">
                                    <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>                                                                                                                   
                                    </div>
                                    <td width="68%"><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new12','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new12" height="22" border="0"></a></td>
                                    <td width="24%"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%}%>
                    <%if (pettycashPayment.getOID() != 0 && pettycashPayment.getPostedStatus() == 1) {%>
                    <tr> 
                        <td colspan="5">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top"> 
                        <td valign="middle" colspan="5"> 
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td width="50%">
                                        <a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="newdox" height="22" border="0"></a>
                                        
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
                    <%if (pettycashPayment.getOID() != 0 || (listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0)) {%>
                    <tr> 
                        <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr><td height="2">&nbsp;</td></tr><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr><tr><td height="2">&nbsp;</td></tr>
                            </table>
                        </td>
                    </tr>                                                                                                    
                    <%}%>                                                                                                    
                </table>
            </td>
        </tr> 
        <%if (oidPettycashPayment != 0 && strApproval.equalsIgnoreCase("Y")) {%>
        <tr> 
            <td colspan="4"> 
                <%
    Vector temp = DbApprovalDoc.getDocApproval(oidPettycashPayment);
                %>
                <table width="800" border="0" cellspacing="1" cellpadding="1">
                    <tr><td colspan="7" height="20"><b><%=langApp[0].toUpperCase()%></b> </td></tr>
                    <tr><td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td>
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
                        <td width="11%"><%=apd.getSequence()%></td><td width="13%"><%=nama%></td><td width="20%"><%=employee.getPosition()%></td><td width="13%"><%=tanggal%></td><td width="11%"><%=status%></td>
                        <td width="20%"> 
                            <%if (pettycashPayment.getPostedStatus() == 0) {
                                if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED && user.getEmployeeId() == apd.getEmployeeId()) {%>
                            <div align="center"> 
                                <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                            </div>
                            <%} else if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {%>
                            <div align="center"> 
                                <input type="text" name="approval_doc_note" size="30" value="<%=catatan%>">
                            </div>
                            <%} else {%>
                            <%=catatan%> 
                            <%}
} else {%>
                            <%=catatan%> 
                            <%}%>
                        </td>
                        <td width="12%"> 
                            <%if (pettycashPayment.getPostedStatus() == 0) {
                                //if(user.getEmployeeId()==apd.getEmployeeId()){%>
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                <tr> 
                                    <td> 
                                        <%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                        %>
                                        <div align="center"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                <tr> 
                                                    <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"><img src="../images/success.gif" alt="Klik : Untuk Menyetujui Dokumen" border="0"></a></div></td>
                                                    <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')"><img src="../images/no.gif" alt="Klik : Untuk tidak menyetujui" border="0"></a></div></td>
                                                </tr>
                                            </table>
                                        </div>
                                        <% }
} else {
    if (user.getEmployeeId() == apd.getEmployeeId()) {
        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                                        %>
                                        <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','0')"><img src="../images/no.gif" alt="Klik : Untuk Membatalkan Persetujuan" border="0"></a></div>
                                        <%	} else {%>
                                        <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"><img src="../images/success.gif" alt="Klik : Untuk Melakukan Persetujuan" border="0"></a></div>
                                        <%}
        }
    }%>
                                    </td>
                                </tr>
                            </table>
                            <%//}
} else {%>
                            &nbsp; 
                            <%}%>
                        </td>
                    </tr>
                    <tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                    <%}
    }%>
                    <tr><td width="11%">&nbsp;</td><td width="13%">&nbsp;</td><td width="20%">&nbsp;</td><td width="13%">&nbsp;</td><td width="11%">&nbsp;</td><td width="20%">&nbsp;</td><td width="12%">&nbsp;</td></tr>
                </table>
            </td>
        </tr>
        <%}%>
        <%if (pettycashPayment.getOID() != 0) {
        String name = "-";
        String date = "";
        try {
            User u = DbUser.fetch(pettycashPayment.getOperatorId());
            Employee e = DbEmployee.fetchExc(u.getEmployeeId());
            name = e.getName();
        } catch (Exception e) {
        }
        try {
            date = JSPFormater.formatDate(pettycashPayment.getDate(), "dd MMM yyyy");
        } catch (Exception e) {
        }


        String postedName = "";
        String postedDate = "";
        try {
            User u = DbUser.fetch(pettycashPayment.getPostedById());
            Employee e = DbEmployee.fetchExc(u.getEmployeeId());
            postedName = e.getName();
        } catch (Exception e) {
        }
        try {
            if (pettycashPayment.getPostedDate() != null) {
                postedDate = JSPFormater.formatDate(pettycashPayment.getPostedDate(), "dd MMM yyyy");
            }
        } catch (Exception e) {
            postedDate = "";
        }
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
</table>
</td>
</tr>
<tr align="left" valign="top"><td colspan="4" class="command">&nbsp; </td></tr>
<tr align="left" valign="top" ><td colspan="4" class="command">&nbsp; </td></tr>
</table>
<%} catch (Exception e) {
                out.println(e.toString());
            }%>
<script language="JavaScript">  
    
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
    <td height="25" colspan="2"> <!-- #BeginEditable "footer" --> 
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
