
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
<% int appObjCode = 1;%>
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
    public Vector addNewDetail(Vector listCashReceiveDetail, CashReceiveDetail cashReceiveDetail) {
        boolean found = false;
        if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {
            for (int i = 0; i < listCashReceiveDetail.size(); i++) {
                CashReceiveDetail cr = (CashReceiveDetail) listCashReceiveDetail.get(i);
                if (cr.getCoaId() == cashReceiveDetail.getCoaId() && cr.getForeignCurrencyId() == cashReceiveDetail.getForeignCurrencyId()) {
                    cr.setForeignAmount(cr.getForeignAmount() + cashReceiveDetail.getForeignAmount());
                    cr.setAmount(cr.getAmount() + cashReceiveDetail.getAmount());
                    found = true;
                }
            }
        }
        if (!found) {
            listCashReceiveDetail.add(cashReceiveDetail);
        }
        return listCashReceiveDetail;
    }

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
                "Receipt From", "Currency", "Code", "Credit", "Booked Rate", "Debet Amount in", "Description", //6-12
                "Cash Received document is ready to be saved", "Cash Receive document has been saved successfully", "Search Journal Number", "Customer", "Search Advance", "Credit", "Credit Amount in", "Period"}; //13-20
            String[] langNav = {"Cash", "Cash Receive", "Date", "SEARCHING", "CASH RECEIVE EDITOR FORM", "required"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Diterima Pada", "Diterima Dari", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Dari Perkiraan", "Mata Uang", "Kode", "Debet", "Kurs Transaksi", "Jumlah Debet", "Keterangan",//6-12
                    "Dokumen Penerimaan Tunai siap untuk disimpan", "Dokumen Penerimaan Tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Konsumen", "Cari Kasbon", "Credit", "Jumlah Credit", "Periode"}; //13-20
                langCT = langID;
                String[] navID = {"Tunai", "Penerimaan Tunai", "Tanggal", "PENCARIAN", "EDITOR PENERIMAAN TUNAI", "Data harus diisi"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCashReceive = JSPRequestValue.requestLong(request, "hidden_cash_receive_id");
            long oidCashReceiveDetail = JSPRequestValue.requestLong(request, "hidden_cash_receive_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int reset_app = JSPRequestValue.requestInt(request, "reset_app");

            // variable ini untuk printing
            // di setiap ada printing page harus ada ini
            // dan diset valuenya sesuai oid yg di get
            docChoice = 2;
            generalOID = oidCashReceive;
            
            boolean isAkunting = true;
            int isPrivAkunting = 0;
            long grp_akunting_id = 0;

            try {
                isPrivAkunting = Integer.parseInt(DbSystemProperty.getValueByName("PRIV_PRINT_AKUNTING"));
            } catch (Exception e) { isPrivAkunting = 0; }

            if (isPrivAkunting == 1) {
                isAkunting = false;
                try {
                    grp_akunting_id = Long.parseLong(DbSystemProperty.getValueByName("ID_GRP_AKUNTING"));
                    Vector vx = DbUserGroup.list(0, 0, DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "=" + appSessUser.getUserOID(), "");

                    if (vx != null && vx.size() > 0) {
                        UserGroup ug = (UserGroup) vx.get(0);
                        if (grp_akunting_id == ug.getGroupID()) {
                            isAkunting = true;
                        }
                    }
                } catch (Exception e) {}
            }

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("RECEIVE_DETAIL");
                oidCashReceive = 0;
                recIdx = -1;
            }

            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";

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
            int vectSize = DbCashReceive.getCount(whereClause);
            CashReceive cashReceive = ctrlCashReceive.getCashReceive();
            String msgStringRec = ctrlCashReceive.getMessage();
            if (oidCashReceive == 0) {
                oidCashReceive = cashReceive.getOID();
            }
            if (oidCashReceive != 0) {
                try {
                    cashReceive = DbCashReceive.fetchExc(oidCashReceive);
                } catch (Exception e) {}
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCashReceive.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            
            if(reset_app == 1){
                DbApprovalDoc.resetApproval(I_Project.TYPE_APPROVAL_BKM, cashReceive.getOID());
            }
%>
<%
            boolean load = false;
            if (iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD) { load = true; }
            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD) { iJSPCommand = JSPCommand.ADD;}
            CmdCashReceiveDetail ctrlCashReceiveDetail = new CmdCashReceiveDetail(request);
            Vector listCashReceiveDetail = new Vector(1, 1);

            if (load) { listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + "=" + cashReceive.getOID(), null); }

            iErrCode = ctrlCashReceiveDetail.action(iJSPCommand, oidCashReceiveDetail);

            JspCashReceiveDetail jspCashReceiveDetail = ctrlCashReceiveDetail.getForm();

            vectSize = DbCashReceiveDetail.getCount(whereClause);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCashReceiveDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

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
                    } catch (Exception e) { System.out.println("[exception]" + e.toString());}
                    listCashReceiveDetail.remove(recIdx);
                } catch (Exception e) {}
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
            ExchangeRate eRate = DbExchangeRate.getStandardRate();

            double balance = 0;
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

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_CASH + "'", "");
            Vector deps = DbDepartment.list(0, 0, "", "code");
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdCetak(param){	
				document.frmcashreceivedetail.command.value="<%=JSPCommand.LOAD%>";
				document.frmcashreceivedetail.command_print.value=param;
				document.frmcashreceivedetail.action="cashreceivedetail.jsp";
				document.frmcashreceivedetail.submit();	
            }
            
            function cmdSearchJurnal(){
                window.open("<%=approot%>/transaction/s_nomorjurnal.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function cmdSearchKasbon(){
                    window.open("<%=approot%>/transaction/s_nomorkasbon.jsp?formName=frmcashreceivedetail&txt_Id=referensi_id&txt_Name=referensi_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }    
                    
                    function cmdClickMe(){
                        var x = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;	
                        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.select();
                    }
                    
                    function cmdClickMeCredit(){
                        var x = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value;	
                        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.select();
                    }
                    
                    function cmdFixing(){	
                        document.frmcashreceivedetail.command.value="<%=JSPCommand.POST%>";
                        document.frmcashreceivedetail.action="cashreceivedetail.jsp";
                        document.frmcashreceivedetail.submit();	
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
                 <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                 document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
                 <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                 document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                 document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 <%}%>
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
                 <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                 document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
                 <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                 document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                 document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 <%}%>
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
                document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmcashreceivedetail.action="cashreceivedetail.jsp";
                document.frmcashreceivedetail.submit();
            }
        }        
        
        function cmdAsk(oidCashReceiveDetail){
            document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.ASK%>";
            document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdConfirmDelete(oidCashReceiveDetail){
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.DELETE%>";
            document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdSave(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdSubmitCommand(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.SAVE%>";
            document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdEdit(oidCashReceiveDetail){
            document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdCancel(oidCashReceiveDetail){
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
            document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdNone(){	
            document.frmcashreceivedetail.hidden_cash_receive_id.value="0";
            document.frmcashreceivedetail.hidden_cash_receive_detail_id.value="0";
            document.frmcashreceivedetail.command.value="<%=JSPCommand.NONE%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdBack(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.BACK%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdListFirst(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.FIRST%>";
            document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdListPrev(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.PREV%>";
            document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdListNext(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.NEXT%>";
            document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmcashreceivedetail.action="cashreceivedetail.jsp";
            document.frmcashreceivedetail.submit();
        }
        
        function cmdListLast(){
            document.frmcashreceivedetail.command.value="<%=JSPCommand.LAST%>";
            document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.LAST%>";
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
            String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                        %>
                                                        <%@ include file="../main/navigator.jsp"%>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcashreceivedetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>"><input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>"><input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
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
                                                                                            <td colspan="4"> 
                                                                                                <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td height="23"><font face="arial"><b><u><%=langNav[3]%></u></b></font></td>
                                                                                                        <td nowrap> 
                                                                                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                                                                            : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr><td colspan="5" height=5px></td></tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[15]%></td><td width="3%">&nbsp;</td><td width="33%"> 
                                                                                                            <%
            String jur_number = ""; long cashRecId = 0;
            if (isLoad && reset_app != 1) { jur_number = cashReceive.getJournalNumber(); cashRecId = cashReceive.getOID();}
                                                                                                            %>
                                                                                                            <table>
                                                                                                                <tr> 
                                                                                                                    <td><input size="25" readonly type="text" name="jurnal_number" value="<%=jur_number%>"></td>
                                                                                                                    <td><input type="hidden" name="cash_id" value="<%=cashRecId%>">
                                                                                                                        <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="12%">&nbsp;</td><td width="42%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr><td colspan="5" height=20px>&nbsp;</td></tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td background="../images/line.gif"><img src="../images/line.gif"></td></tr></table></td>
                                                                                                    </tr>                                              
                                                                                                    <tr> 
                                                                                                        <td colspan="3" height="23"><font face="arial"><b><u><%=langNav[4]%></u></b></font></td><td width="9%" height="23">&nbsp;</td><td width="55%" height="23">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr><td height="5"></td></tr><tr><td height="23">&nbsp;</td><td height="23">&nbsp;</td><td height="23">*)&nbsp;<%=langNav[5]%></td><td width="9%" height="23">&nbsp;</td><td width="55%" height="23">&nbsp;</td></tr><tr><td height="5"></td></tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[4]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"> 
                                                                                                            <%
            Vector periods = new Vector(); Periode preClosedPeriod = new Periode(); Periode openPeriod = new Periode();
            Vector vPreClosed = DbPeriode.list(0,0, DbPeriode.colNames[DbPeriode.COL_STATUS]+"='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"'", ""+DbPeriode.colNames[DbPeriode.COL_START_DATE]);            
            openPeriod = DbPeriode.getOpenPeriod();
            if(vPreClosed != null && vPreClosed.size() > 0){
                for(int i = 0; i < vPreClosed.size(); i++){
                    Periode prClosed = (Periode)vPreClosed.get(i);
                    if(i== 0){ preClosedPeriod = prClosed; } periods.add(prClosed);
                }
            }
            
            if (openPeriod.getOID() != 0) {
                periods.add(openPeriod);
            }
            String strNumber = "";
            Periode open = new Periode();
            
            if (cashReceive.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(cashReceive.getPeriodeId());
                } catch (Exception e) {}
            } else {
                if (preClosedPeriod.getOID() != 0) {
                    open = DbPeriode.getPreClosedPeriod();
                } else {
                    open = DbPeriode.getOpenPeriod();
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
                                                                                                        <td width="12%">
                                                                                                            <%if (preClosedPeriod.getOID() != 0) {%>
                                                                                                            <%=langCT[20]%>
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="42%">
                                                                                                            <%if (preClosedPeriod.getOID() != 0) {%>
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
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_PERIODE_ID]%>" value="<%=openPeriod.getOID()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[0]%></td><td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"> 
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
                                                                                                        <td width="12%"><%=langCT[5]%></td>
                                                                                                        <td width="42%">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr><td>
                                                                                                                        <input name="<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((cashReceive.getTransDate() == null) ? new Date() : cashReceive.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td valign="top">&nbsp;<%=jspCashReceive.getErrorMsg(jspCashReceive.JSP_TRANS_DATE) %></td>
                                                                                                                </tr></table>       
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[1]%></td><td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"> 
                                                                                                            <input type="text" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_RECEIVE_FROM_NAME]%>" value="<%=cashReceive.getReceiveFromName()%>">
                                                                                                        <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_RECEIVE_FROM_ID) %> </td>
                                                                                                        <td width="12%"><%=langCT[16]%></td>
                                                                                                        <td width="42%"> 
                                                                                                            <%

            String order = DbCustomer.colNames[DbCustomer.COL_NAME];
            Vector vCustomer = DbCustomer.list(0, 0, "", order);
                                                                                                            %>
                                                                                                            <select name="<%=JspCashReceive.colNames[JspCashReceive.JSP_CUSTOMER_ID]%>">
                                                                                                                <option value=0>select ..</option>
                                                                                                                <%
            if (vCustomer != null && vCustomer.size() > 0) {
                for (int iC = 0; iC < vCustomer.size(); iC++) {
                    Customer objCustomer = (Customer) vCustomer.get(iC);
                                                                                                                %>
                                                                                                                <option <%if (cashReceive.getCustomerId() == objCustomer.getOID()) {%>selected<%}%> value="<%=objCustomer.getOID()%>"><%=objCustomer.getName()%></option>
                                                                                                                <%
                                                                                                                    }
                                                                                                                } else {
                                                                                                                %>
                                                                                                                <option value=0>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>
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
                                                                                                        <td width="10%"><%=langCT[2]%> <%=baseCurrency.getCurrencyCode()%></td><td width="3%">&nbsp;</td>
                                                                                                        <td width="33%"> 
                                                                                                        <input type="text" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkNumber()" class="readonly" readOnly size="30">
                                                                                                        &nbsp;*)&nbsp<%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_AMOUNT) %></td>
                                                                                                        <td width="12%"> 
                                                                                                            <%if (jur_num.length() > 0) {%> Ref no  <%} else {%> &nbsp;  <%}%>
                                                                                                        </td>
                                                                                                        <td width="42%"> 
                                                                                                            <%if (jur_num.length() > 0) {%> <%=jur_num%>  <%} else {%> &nbsp;  <%}%>
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_REFERENSI_ID]%>" value="<%=cashReceive.getReferensiId()%>" >
                                                                                                        <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_REFERENSI_ID) %> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" valign="top"><%=langCT[3]%></td><td width="3%">&nbsp;</td>
                                                                                                        <td colspan="3"><table cellpadding="0" cellspacing="0">
                                                                                                                <tr><td><textarea name="<%=JspCashReceive.colNames[JspCashReceive.JSP_MEMO]%>" cols="50" rows="2"><%=cashReceive.getMemo()%></textarea></td>
                                                                                                                    <td valign = "top">&nbsp;*)&nbsp; <%= jspCashReceive.getErrorMsg(jspCashReceive.JSP_MEMO) %> </td></tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> <td height="20" valign="middle" colspan="3" class="comment" width="99%">&nbsp;</td></tr>
                                                                            <%

                                                                            %>
                                                                            <tr align="left" valign="top">
                                                                                <td  valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td class="boxed1">                                                                                                
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td rowspan="2" class="tablehdr" nowrap width="15%"><%=langCT[6]%></td><td class="tablehdr" rowspan="2" width="15%">Department</td>
                                                                                                        <td class="tablehdr" colspan="3" width="20%"><%=langCT[7]%></td><td rowspan="2" class="tablehdr" width="15%"><%=langCT[10]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="10%"><%=langCT[11]%> <%=baseCurrency.getCurrencyCode()%></td><td rowspan="2" class="tablehdr" width="10%"><%=langCT[19]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="15%"><%=langCT[12]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="4%" class="tablehdr"><%=langCT[8]%></td><td width="8%" class="tablehdr"><%=langCT[9]%></td><td width="8%" class="tablehdr"><%=langCT[18]%></td>
                                                                                                    </tr>
                                                                                                    <%
            int idx = -1;

            if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {

                for (int i = 0; i < listCashReceiveDetail.size(); i++) {
                    CashReceiveDetail crd = (CashReceiveDetail) listCashReceiveDetail.get(i);
                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                    } catch (Exception e) {}
                    if (crd.getOID() == oidCashReceiveDetail) {
                        idx = i;
                    }
                    String cssName = "tablecell";
                    if (i % 2 != 0) {
                        cssName = "tablecell1";
                    }
                                                                                                    %>
                                                                                                    <%
                                                                                                            if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                                                    <tr> 
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
                                                                                                                <select name="<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment(this)">
                                                                                                                    <%if (deps != null && deps.size() > 0) {
                                                                                                            for (int x = 0; x < deps.size(); x++) {
                                                                                                                Department d = (Department) deps.get(x);
                                                                                                                String str = "";
                                                                                                                switch (d.getLevel()) {
                                                                                                                    case 0:
                                                                                                                        break;
                                                                                                                    case 1:
                                                                                                                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                        break;
                                                                                                                    case 2:
                                                                                                                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                        break;
                                                                                                                    case 3:
                                                                                                                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                        break;

                                                                                                                }
                                                                                                                    %>
                                                                                                                    <option value="<%=d.getOID()%>" <%if (crd.getDepartmentId() == d.getOID()) {%>selected<%}%>><%=str + d.getCode() + " - " + d.getName()%></option>
                                                                                                                    <%}
                                                                                                        }%>
                                                                                                                </select>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(jspCashReceiveDetail.JSP_DEPARTMENT_ID) %> </div>
                                                                                                        </td>
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
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignCreditAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT) %> </div>
                                                                                                        </td>
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
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="hidden" name="edit_creditamount" value="<%=crd.getCreditAmount()%>">
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_CREDIT_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>" size="30" value="<%=crd.getMemo()%>">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td class="<%=cssName%>" nowrap > 
                                                                                                            <%if (cashReceive.getPostedStatus() == 1) {%>
                                                                                                            <%=c.getCode()%> 
                                                                                                            <%} else {%>
                                                                                                            <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%></a> 
                                                                                                            <%}%>
                                                                                                            <%//} else {%>
                                                                                                            <%//=c.getCode()%>
                                                                                                            <%//}%>
                                                                                                        &nbsp;-&nbsp; <%=c.getName()%> </td>
                                                                                                        <td class="<%=cssName%>"> 
                                                                                                            <%
                                                                                                        Department d = new Department();
                                                                                                        try {
                                                                                                            d = DbDepartment.fetchExc(crd.getDepartmentId());
                                                                                                        } catch (Exception e) {}
                                                                                                            %>
                                                                                                        <%=d.getCode() + " - " + d.getName()%></td>
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
                                                                                                        <td class="<%=cssName%>"><div align="right"> <%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> </div></td>
                                                                                                        <td class="<%=cssName%>"><div align="right"> <%=JSPFormater.formatNumber(crd.getForeignCreditAmount(), "#,###.##")%> </div></td>
                                                                                                        <td class="<%=cssName%>"><div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div></td>
                                                                                                        <td class="<%=cssName%>"><div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div></td>
                                                                                                        <td class="<%=cssName%>"><div align="right"><%=JSPFormater.formatNumber(crd.getCreditAmount(), "#,###.##")%></div></td>
                                                                                                        <td class="<%=cssName%>"><%=crd.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%}
                }
            }
            if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCode > 0 || iErrCodeRec != 0) && recIdx == -1) && !(isSave && iErrCode == 0 && iErrCodeRec == 0) && (cashReceive.getPostedStatus() != 1)) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell"> 
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
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment(this)">
                                                                                                                    <%if (deps != null && deps.size() > 0) {
                                                                                                        for (int x = 0; x < deps.size(); x++) {
                                                                                                            Department d = (Department) deps.get(x);
                                                                                                            String str = "";
                                                                                                            switch (d.getLevel()) {
                                                                                                                case 0:
                                                                                                                    break;
                                                                                                                case 1:
                                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                    break;
                                                                                                                case 2:
                                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                    break;
                                                                                                                case 3:
                                                                                                                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                    break;

                                                                                                            }
                                                                                                                    %>
                                                                                                                    <option value="<%=d.getOID()%>" <%if (cashReceiveDetail.getDepartmentId() == d.getOID()) {%>selected<%}%>><%=str + d.getCode() + " - " + d.getName()%></option>
                                                                                                                    <%}
                                                                                                    }%>
                                                                                                                </select>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(jspCashReceiveDetail.JSP_DEPARTMENT_ID) %> </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"> 
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
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()"><%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"><div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getForeignCreditAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMeCredit()">
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_CREDIT_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"><div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getBookedRate(), "#,###.##")%>" style="text-align:right"  onBlur="javascript:cmdUpdateExchangeXX()" onClick="this.select()">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"><div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"><div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly><%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_CREDIT_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"><input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>" size="30" value="<%=cashReceiveDetail.getMemo()%>"></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr><td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr><td colspan="2" height="15">&nbsp;</td></tr>
                                                                                                    <%if (cashReceive.getPostedStatus() == 0) {%>
                                                                                                    <tr><td width="78%"> 
                                                                                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%if (iErrCodeRec == 0 || iErrCode != 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td>
                                                                                                                        <%
    if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeRec == 0) || (isSave && iErrCode == 0 && iErrCodeRec == 0)) {
        if (privAdd) {%>
                                                                                                                        <%if (iJSPCommand == JSPCommand.RESET){%>
                                                                                                                        <table>                                                                                                                              
                                                                                                                            <tr><td><table border="0" cellpadding="5" cellspacing="0" class="success" align="right"><tr><td width="20"><img src="../images/success.gif" width="20" height="20"></td><td width="220" nowrap>Delete Success</td></tr></table>
                                                                                                                                </td>
                                                                                                                            </tr>    
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
                                                                                                                            <tr><td>
                                                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="warning"><tr><td width="20"><img src="/btdc-fin/images/error.gif" width="20" height="20"></td><td width="300" nowrap><%=msgString%></td></tr></table>
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
                                                                                                                    <td><table border="0" cellpadding="2" cellspacing="0" class="warning" width="293" align="left"><tr><td width="20"><img src="../images/error.gif" width="18" height="18"></td><td width="253" nowrap><%=msgStringRec%></td></tr></table></td>
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
                                                                                                    <tr><td colspan="2" height="15">&nbsp;</td></tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="1" valign="middle" colspan="2" width="100%"> 
                                                                                                            <table width="99%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr></table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}
            if (((submit && iErrCode == 0 && iErrCodeRec == 0) || (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0)) && cashReceive.getPostedStatus() != 1) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td colspan="2"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr>
                                                                                                                    <td width="11%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                                                                                    <%if (cashReceive.getOID() != 0) {%>
                                                                                                                    <td width><a href="javascript:cmdAsking('<%=cashReceive.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('dl','','../images/deletedoc2.gif',1)"><img src="../images/deletedoc.gif" name="dl" height="22" border="0"  alt="Delete Doc"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <td width>&nbsp;</td>
                                                                                                                    <td width="40%">&nbsp;</td>
                                                                                                                    <td width="26%" nowrap> 
                                                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="info" width="219" align="right">
                                                                                                                            <tr><td width="16"><img src="../images/inform.gif" width="20" height="20"></td><td width="183" nowrap><%=langCT[13]%></td></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr><td colspan="2" height="2"></td></tr>    
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="1" valign="middle" colspan="3" width="100%" align="center"> 
                                                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr></table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"><td height="6"></td></tr>  
                                                                            <%if (cashReceive.getPostedStatus() == 1) {%>
                                                                            <tr align="left" valign="top">
                                                                                <td valign="middle" colspan="4"> 
                                                                                    <div align="left" class="msgnextaction"> 
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                            <tr><td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                <td width="150">Posted</td></tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"><td height="6"></td></tr>          
                                                                            <%}%>
                                                                            <tr align="left" valign="top">
                                                                                <td valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="99%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr>
                                                                                            <td width="6%"> 
                                                                                                <%
    out.print("<a href=\"../freport/rpt_cashreceive_main.jsp?cash_receive_id=" + cashReceive.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt2','','../images/print2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"prt2\" height=\"22\" border=\"0\"></a></div>");
                                                                                                %>
                                                                                            </td>
                                                                                            <%
    if (isAkunting) {
                                                                                            %>
                                                                                            <td width="6%"> 
                                                                                                <%
                                                                                                out.print("<a href=\"../freport/rpt_cashreceive_detail.jsp?cash_receive_id=" + cashReceive.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");
                                                                                                %>
                                                                                            </td>
                                                                                            <%}%>                                                                                           
                                                                                            <td width="8%" nowrap>&nbsp;&nbsp;<a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="newdox" height="22" border="0"></a>&nbsp;&nbsp;</td>
                                                                                            <td width="39%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                                                            <td width="41%" nowrap> 
                                                                                                <%if (isSave == true && iErrCodeRec == 0 && iErrCode == 0) {%>
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                                    <tr><td width="20"><img src="../images/success.gif" width="20" height="20"></td><td width="220" nowrap><%=langCT[14]%></td></tr>
                                                                                                </table>
                                                                                                <%} else {%>
                                                                                                &nbsp; 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr align="left" valign="top"><td height="6" colspan="3">&nbsp;</td></tr> 
                                                                            <%if (oidCashReceive != 0) {%>
                                                                            <tr align="left" valign="top"><td height="6" colspan="3"><%@ include file="../printing/printing.jsp"%>&nbsp;</td></tr> 
                                                                            <%}%>
                                                                            <%if (oidCashReceive != 0) {%>
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
                                                                                            <td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td><td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="18%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td><td width="11%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                            <td width="9%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td><td width="27%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td>
                                                                                            <td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                                                                                        <%
    if (temp != null && temp.size() > 0) {
        Employee userEmp = new Employee();
        try {
            userEmp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {}
        for (int i = 0; i < temp.size(); i++) {

            ApprovalDoc apd = (ApprovalDoc) temp.get(i);
            String tanggal = "";
            String status = "";
            String catatan = (apd.getNotes() == null) ? "" : apd.getNotes();
            String nama = "";
            Employee employee = new Employee();
            try {
                employee = DbEmployee.fetchExc(apd.getEmployeeId());
            } catch (Exception e) {}

            Department dep = new Department();
            try {
                dep = DbDepartment.fetchExc(employee.getDepartmentId());
            } catch (Exception e) {}

            Approval app = new Approval();
            try {
                app = DbApproval.fetchExc(apd.getApprovalId());
            } catch (Exception e) {}

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
                                                                                                    <tr><td> 
                                                                                                            <%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                                                                                            %>
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr><td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save1','','../images/success-2.gif',1)" alt="Klik : Untuk Menyetujui Dokumen"><img src="../images/success.gif" name="save1" height="20" border="0"></a></div></td><td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no3','','../images/no1.gif',1)" alt="Klik : Untuk tidak menyetujui"><img src="../images/no.gif" name="no3" height="20" border="0"></a></div></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                            <% }
} else {
    if (user.getEmployeeId() == apd.getEmployeeId()) {
        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                                                                                                            %>
                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no','','../images/no1.gif',1)" alt="Klik : Untuk Membatalkan Persetujuan"><img src="../images/no.gif" name="no" height="20" border="0"></a></div>
                                                                                                            <%	} else {%>
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
                                                                                        <tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                                                                                        <%}
    }%>
                                                                                        <tr><td width="11%" colspan="7">&nbsp;</td></tr>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr> 
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                                <tr><td colspan="3" class="command">&nbsp;</td></tr>
                                                            </table>
                                                            <script language="JavaScript"><%if (iErrCode != 0 || iJSPCommand == JSPCommand.ADD) {%>cmdUpdateExchange();<%}%></script>
                                                        </form>
                                                    <!-- #EndEditable --> </td>
                                                </tr>
                                                <tr><td>&nbsp;</td></tr>
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