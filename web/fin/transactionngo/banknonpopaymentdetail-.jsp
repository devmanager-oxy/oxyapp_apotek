
<%
            /*******************************************************************
             *  eka & Roy
             *******************************************************************/
%>
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public Vector addNewDetail(Vector listBanknonpoPaymentDetail, BanknonpoPaymentDetail banknonpoPaymentDetail) {
        boolean found = false;
        if (listBanknonpoPaymentDetail != null && listBanknonpoPaymentDetail.size() > 0) {
            for (int i = 0; i < listBanknonpoPaymentDetail.size(); i++) {
                BanknonpoPaymentDetail cr = (BanknonpoPaymentDetail) listBanknonpoPaymentDetail.get(i);
                if (cr.getForeignCurrencyId() == banknonpoPaymentDetail.getForeignCurrencyId() && cr.getCoaId() == banknonpoPaymentDetail.getCoaId() && cr.getDepartmentId() == banknonpoPaymentDetail.getDepartmentId()) {

                    cr.setForeignAmount(cr.getForeignAmount() + banknonpoPaymentDetail.getForeignAmount());
                    cr.setAmount(cr.getAmount() + banknonpoPaymentDetail.getAmount());

                    listBanknonpoPaymentDetail.set(i, cr);

                    found = true;
                }
            }
        }
        if (!found) {
            listBanknonpoPaymentDetail.add(banknonpoPaymentDetail);
        }
        return listBanknonpoPaymentDetail;
    }

    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail) listx.get(i);
                result = result + crd.getAmount();
            }
        }
        return result;
    }

    public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly) {

        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");
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

    public static String getStrLevel(int level) {
        String str = "";
        switch (level) {
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
        return str;
    }
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidBanknonpoPayment = JSPRequestValue.requestLong(request, "hidden_banknonpo_payment_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            long xxx = JSPRequestValue.requestLong(request, "xxx");
            int reset_app = JSPRequestValue.requestInt(request, "reset_app");

            boolean isUseJemaat = false;
            try {
                String useJemaat = DbSystemProperty.getValueByName("USE_JEMAAT");
                if (useJemaat.compareTo("Y") == 0) {
                    isUseJemaat = true;
                }
            } catch (Exception e) {
            }

            docChoice = 7;
            generalOID = oidBanknonpoPayment;
            boolean isNone = false;
            if (iJSPCommand == JSPCommand.NONE) {
                isNone = true;
                session.removeValue("BNOPPAYMENT_DETAIL");
                oidBanknonpoPayment = 0;
                recIdx = -1;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            boolean isLoad = false;
            boolean isReconfirm = false;

            if (iJSPCommand == JSPCommand.RECONFIRM) {
                isReconfirm = true;
                isLoad = true;
                recIdx = -1;
            }

            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("BNOPPAYMENT_DETAIL");
                oidBanknonpoPayment = JSPRequestValue.requestLong(request, "bank_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdBanknonpoPayment ctrlBanknonpoPayment = new CmdBanknonpoPayment(request);
            JSPLine ctrLine = new JSPLine();
            Vector listBanknonpoPayment = new Vector(1, 1);

            /*switch statement */
            int iErrCodeMain = ctrlBanknonpoPayment.action(iJSPCommand, oidBanknonpoPayment);
            /* end switch*/
            JspBanknonpoPayment jspBanknonpoPayment = ctrlBanknonpoPayment.getForm();

            /*count list All BanknonpoPayment*/
            int vectSize = DbBanknonpoPayment.getCount(whereClause);
            BanknonpoPayment banknonpoPayment = ctrlBanknonpoPayment.getBanknonpoPayment();
            String msgStringMain = ctrlBanknonpoPayment.getMessage();

            if (oidBanknonpoPayment == 0) {
                oidBanknonpoPayment = banknonpoPayment.getOID();
            }

            if (oidBanknonpoPayment != 0) {
                try {
                    banknonpoPayment = DbBanknonpoPayment.fetchExc(oidBanknonpoPayment);
                } catch (Exception e) {
                }
            }

            if (reset_app == 1) {  // jika terjadi proses untuk mereset approval
                DbApprovalDoc.resetApproval(I_Project.TYPE_APPROVAL_BKK, banknonpoPayment.getOID());
            }

            boolean load = false;
            if (iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }

%>

<%
            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
            }
            long oidBanknonpoPaymentDetail = JSPRequestValue.requestLong(request, "hidden_banknonpo_payment_detail_id");
            CmdBanknonpoPaymentDetail ctrlBanknonpoPaymentDetail = new CmdBanknonpoPaymentDetail(request);
            Vector listBanknonpoPaymentDetail = new Vector(1, 1);

            if (isLoad) {
                listBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0, 0, DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID] + "=" + banknonpoPayment.getOID(), null);
            }

            /*switch statement */
            iErrCode = ctrlBanknonpoPaymentDetail.action(iJSPCommand, oidBanknonpoPaymentDetail);
            /* end switch*/
            JspBanknonpoPaymentDetail jspBanknonpoPaymentDetail = ctrlBanknonpoPaymentDetail.getForm();

            BanknonpoPaymentDetail banknonpoPaymentDetail = ctrlBanknonpoPaymentDetail.getBanknonpoPaymentDetail();
            msgString = ctrlBanknonpoPaymentDetail.getMessage();

            if (session.getValue("BNOPPAYMENT_DETAIL") != null) {
                listBanknonpoPaymentDetail = (Vector) session.getValue("BNOPPAYMENT_DETAIL");
            }

            boolean submit = false;
            if (iJSPCommand == JSPCommand.SUBMIT) {
                submit = true;
                if (iErrCode == 0 && iErrCodeMain == 0) {
                    if (recIdx == -1) {
                        listBanknonpoPaymentDetail.add(banknonpoPaymentDetail);
                    } else {
                        BanknonpoPaymentDetail bpd = (BanknonpoPaymentDetail) listBanknonpoPaymentDetail.get(recIdx);
                        banknonpoPaymentDetail.setOID(bpd.getOID());
                        listBanknonpoPaymentDetail.set(recIdx, banknonpoPaymentDetail);
                    }
                }
            }

            if (iJSPCommand == JSPCommand.DELETE) {
                try {
                    try {
                        BanknonpoPaymentDetail ppd = (BanknonpoPaymentDetail) listBanknonpoPaymentDetail.get(recIdx);
                        DbPettycashPaymentDetail.deleteExc(ppd.getOID());
                    } catch (Exception e) {
                    }
                    listBanknonpoPaymentDetail.remove(recIdx);
                } catch (Exception e) {
                }
            }

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                if (banknonpoPayment.getOID() != 0) {
                    DbBanknonpoPaymentDetail.saveAllDetail(banknonpoPayment, listBanknonpoPaymentDetail);
                    listBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0, 0, "banknonpo_payment_id=" + banknonpoPayment.getOID(), "");
                    isSave = true;
                }
            }

            session.putValue("BNOPPAYMENT_DETAIL", listBanknonpoPaymentDetail);
            Vector expenseCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_BANK_NOPO_PAYMENT_DEBET, sysLocation.getOID());
            Vector empAdvance = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_EMPLOYEE_ADVANCE + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            Vector currencies = DbCurrency.list(0, 0, "", "");
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_NOPO_PAYMENT_CREDIT + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            ExchangeRate eRate = DbExchangeRate.getStandardRate();
            Vector accountBalance = new Vector();
            Vector vendors = DbVendor.list(0, 0, "", "");

            double balance = 0;
            double totalDetail = getTotalDetail(listBanknonpoPaymentDetail);

            banknonpoPayment.setAmount(totalDetail);

            if (((iJSPCommand == JSPCommand.SUBMIT && recIdx == -1)) && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                banknonpoPaymentDetail = new BanknonpoPaymentDetail();
                recIdx = -1;
            }

            if (iJSPCommand == JSPCommand.PRINT) {
                banknonpoPayment.setVendorId(xxx);
                iJSPCommand = JSPCommand.ADD;
                recIdx = -1;
                banknonpoPaymentDetail = new BanknonpoPaymentDetail();
            }

            String whereDep = "";

            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            /*** LANG ***/
            String[] langBT = {"Vendor", "Type", "Payment from Account", "Payment Method", "Bank Reference Number", "Amount in", "Memo", //0-6
                "Balance", "Journal Number", "Transaction Date", "Invoice Number", //7-10
                "Disbursement", "Account - Description", "Department", "Currency", "Code", "Amount", "Booked Rate", "Amount in", "Description", //11-19
                "Journal is ready to be saved", "Journal has been saved", "Insufficient bank balance", "Customer", "Period" //20-24
            };

            String[] langNav = {"Bank", "Non PO Payment", "Date", "Select...", "SEARCHING", "BANK PAYMENT EDITOR", "Payment to"};

            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Suplier", "Tipe", "Pembayaran dari Perkiraan", "Cara Pembayaram", "Nomor Referensi Bank", "Jumlah", "Catatan",
                    "Saldo", "Nomor Jurnal", "Tanggal Transaksi", "Nomor Faktur",
                    "Disbursement", "Perkiraan", "Departemen", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan",
                    "Jurnal siap untuk disimpan", "Jurnal sukses disimpan", "Saldo bank tidak mencukupi", "Sarana", "Periode"
                };
                langBT = langID;

                String[] navID = {"Bank", "Pembayaran Bank Langsung", "Tanggal", "Pilih...", "PENCARIAN", "EDITOR PEMBAYARAN BANK", "Dibayarkan kepada"};
                langNav = navID;

                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            Vector periodes = DbPeriode.listAll();
            Vector segments = DbSegment.list(0, 0, "", "");
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
            window.open("s_banknonpo.jsp?formName=frmbanknonpopaymentdetail&txt_Id=bank_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdCetak(param){	
                document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.LOAD%>";
                document.frmbanknonpopaymentdetail.command_print.value=param;
                document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
                document.frmbanknonpopaymentdetail.submit();	
            }            
            
            function cmdDepartment(){
                var oid = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>.value;
         <%if (deps != null && deps.size() > 0) {
                for (int i = 0; i < deps.size(); i++) {
                    Department d = (Department) deps.get(i);
         %>
             if(oid=='<%=d.getOID()%>'){
                                 <%if (d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                        Department d0 = (Department) deps.get(0);
                                 %>
                                     alert("Non postable department\nplease select another department");
                                     document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
                                     <%}%>
                                 }
         <%}
            }%>
        }
        
        function cmdTypeChange(){
            var type = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TYPE]%>.value;            
            
            if(type=="0"){                
                document.all.withActivity.style.display="";
                <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode != 0) {%>			
                document.all.noActivity1.style.display="none";
                document.all.withActivity1.style.display="";
                <%}%>
                document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>.value=0;
            }else if(type=="1"){
            
            document.all.withActivity.style.display="none";		
            <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode != 0) {%>			
            document.all.noActivity1.style.display="";
            document.all.withActivity1.style.display="none";	
            <%}%>			
            document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>.value=1;
        }	
        
    }
    
    function cmdActivity(oid){
        <%if (oidBanknonpoPayment != 0) {%>
        document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_id.value=oid;
        document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
        document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
        document.frmbanknonpopaymentdetail.action="banknonpoactivity.jsp";
        document.frmbanknonpopaymentdetail.submit();
        <%} else {%>
        alert('Please finish and post this journal before continue to activity data.');
        <%}%>        
    }
    
    function cmdPrintJournal(){	 
        window.open("<%=printroot%>.report.RptBanknonpoPaymentPDF?oid=<%=appSessUser.getLoginId()%>&nonpo_id=<%=oidBanknonpoPayment%>");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  				
        }
        
        function cmdNewVendor(){
            window.open("vendor.jsp?command=<%=JSPCommand.ADD%>","addvendor","scrollbars=yes,height=500,width=800, menubar=no,toolbar=no,location=no");
            }
            
            function cmdEditVendor(){
                var oid = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_VENDOR_ID]%>.value;
                window.open("vendor.jsp?command=<%=JSPCommand.EDIT%>&hidden_vendor_id="+oid,"editvendor","scrollbars=yes,height=500,width=800, menubar=no,toolbar=no,location=no");
                }
                
                function cmdVendor(){
                    var oid = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_VENDOR_ID]%>.value;
                    var found = false;
         <%if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor vx = (Vendor) vendors.get(i);
                         %>
                             if('<%=vx.getOID()%>'==oid){
                                 found = true;
                                 document.frmbanknonpopaymentdetail.vnd_address.value="<%=vx.getAddress() + ((vx.getCity().length() > 0) ? ", " + vx.getCity() : "") + ((vx.getState().length() > 0) ? ", " + vx.getState() : "") %>";
                             }
         <%}
            }%>		
            if(!found){
                document.frmbanknonpopaymentdetail.vnd_address.value="";
            }
        }
        
        function cmdClickIt(){
            document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.select();
        }
        
        function reloadPeriod(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.RECONFIRM%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();	
        }    
        
        function cmdGetBalance(){
            
            var x = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_COA_ID]%>.value;
            
         <%if (accountBalance != null && accountBalance.size() > 0) {
                for (int i = 0; i < accountBalance.size(); i++) {
                    Coa c = (Coa) accountBalance.get(i);
         %>
             if(x=='<%=c.getOID()%>'){
                 document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(), "###.##")%>";
                 
                 <%if (c.getOpeningBalance() < 0) {%>
                 document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance() * -1, "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
                     <%} else {%>
                     document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance(), "###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         <%}%>
                         
                         document.frmbanknonpopaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(), "###.##")%>";
                         <%if (c.getOpeningBalance() < 1) {%>		                         
                         document.all.command_line.style.display="none";
                         document.all.emptymessage.style.display="";
                         <%} else {%>
                         document.all.command_line.style.display="";
                         document.all.emptymessage.style.display="none";
                         <%}%>
                     }
         <%}
            }%>
        }
        
        function cmdFixing(){	
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.POST%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();	
        }
        
        function cmdNewJournal(){	
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value = 0;
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_id.value = 0;
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();	
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
            var st = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value;		
            var ab = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value;		
            
            result = removeChar(st);
            
            result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            if(parseFloat(result) > parseFloat(ab)){
                if(parseFloat(ab)<1){
                    result = "0";
                    alert("No account balance available,\nCan not continue the transaction.");
                }
                else{
                    result = ab;
                    result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    alert("Transaction amount over the account balance,\nSystem will reset the amount into maximum allowed.");
                }
            }
            
            document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
        }
        
        function checkNumber2(){
            
            var main = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value;		
            main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var currTotal = document.frmbanknonpopaymentdetail.total_detail.value;
            currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
            var idx = document.frmbanknonpopaymentdetail.select_idx.value;
            
            var maxtransaction = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value;
            var pbalanace = maxtransaction;
            var bnpAmount = "<%=banknonpoPayment.getAmount()%>";
            bnpAmount = removeChar(bnpAmount);	
            bnpAmount = cleanNumberFloat(bnpAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var limit = parseFloat(maxtransaction);
            
            var st = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value;		
            result = removeChar(st);	
            result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            //add
            if(parseFloat(idx)<0){
                
                var amount = parseFloat(currTotal) + parseFloat(result);
                
                if(amount>limit){                    
                    alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");                    
                    result = 0;
                    amount = 0;
                    
                    document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 				
                }
                
                document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
                
            }
            //edit
            else{
                var editAmount =  document.frmbanknonpopaymentdetail.edit_amount.value;
                var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
                
                if(amount>limit){//parseFloat(main)){
                    alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");                    
                    result = 0;			
                    amount = 0;
                    
                    document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 				
                }
                
                document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
                
            }
            
            document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
        }
        
        function cmdUpdateExchange(){
            var idCurr = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
            
         <%if (currencies != null && currencies.size() > 0) {
                for (int i = 0; i < currencies.size(); i++) {
                    Currency cx = (Currency) currencies.get(i);
         %>
             if(idCurr=='<%=cx.getOID()%>'){
                 <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                 document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
                 <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                 document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                 <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                 document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                 <%}%>
             }	
         <%}
            }%>
            
            var famount = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value;            
            famount = removeChar(famount);
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            var fbooked = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value;
            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);            
            if(!isNaN(famount)){
                document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            }            
            checkNumber2();
        }
        
        function cmdUpdateExchangeXX(){            
            var fbooked = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value;
            fbooked = removeChar(fbooked); 
            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            var famount = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value;
            
            famount = removeChar(famount);
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            if(!isNaN(famount)){
                document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                
            }
            
            checkNumber2();
        }
        
        function cmdSubmitCommand(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.SAVE%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdAdd(oidBank){
            document.frmbanknonpopaymentdetail.select_idx.value="-1";
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_id.value=oidBank;
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value="0";
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.ADD%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdAsk(idx){
            document.frmbanknonpopaymentdetail.select_idx.value=idx;
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=0;
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.ASK%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdConfirmDelete(oidBanknonpoPaymentDetail){
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.DELETE%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdSave(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdEdit(idxx){
            <%if (privUpdate) {%>
            document.frmbanknonpopaymentdetail.select_idx.value=idxx;
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=0;
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
            <%}%>
        }
        
        function cmdCancel(oidBanknonpoPaymentDetail){
            document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdBack(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.BACK%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdListFirst(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.FIRST%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdListPrev(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.PREV%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdListNext(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NEXT%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        function cmdListLast(){
            document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.LAST%>";
            document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
            document.frmbanknonpopaymentdetail.submit();
        }
        
        //-------------- script form image -------------------
        
        function cmdDelPict(oidBanknonpoPaymentDetail){
            document.frmimage.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="banknonpopaymentdetail.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/add2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<tr><td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%"><tr><td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
        </td>
    </tr>
    <tr><td valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <!--DWLayoutTable-->
            <tr><td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                <!-- #EndEditable -->
            </td>
            <td width="100%" valign="top"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0"><tr> 
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
                    <form name="frmbanknonpopaymentdetail" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_banknonpo_payment_detail_id" value="<%=oidBanknonpoPaymentDetail%>">
                    <input type="hidden" name="hidden_banknonpo_payment_id" value="<%=oidBanknonpoPayment%>">
                    <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                    <input type="hidden" name="select_idx" value="<%=recIdx%>">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                    <input type="hidden" name="pcash_balance" value="">                                                            
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top">
                        <td height="8"  colspan="3" class="container">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                                <td height="8" valign="top" colspan="3">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="4">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="31%"></td>
                                                    <td width="32%">&nbsp;</td>
                                                    <td width="37%"> 
                                                        <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                        : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%if (!isReconfirm) {%><%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_OPERATOR_ID) %><%}%>&nbsp;</div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td colspan="4">
                                        <table width="100%"  cellspacing="0" cellpadding="1" border="0">   
                                        <tr>
                                            <td colspan="4">
                                            <table width="950" cellspacing="0" cellpadding="1" border="0"> 
                                                <%
            String nom_jur = "";
            if (isLoad && reset_app != 1) {
                nom_jur = banknonpoPayment.getJournalNumber();
            }
                                                %>   
                                                <tr>
                                                    <td colspan="4">
                                                        <table bgcolor="#F3F3F3" border="0" cellspacing="3" cellpadding="3">                                                    
                                                            <tr>
                                                                <td><B><font face="arial">Pencarian</font></B></td><td></td><td></td>
                                                            </tr>                                                      
                                                            <tr>
                                                                <td>Nomor Journal&nbsp;&nbsp;</td>    
                                                                <td size="25"><input size="25" readonly type="text" name="jurnal_number" value="<%=nom_jur%>"></td>
                                                                <td><input size="50" type="hidden" name="bank_id" value="<%=banknonpoPayment.getOID()%>">
                                                                    <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                </td>
                                                            </tr>                                                    
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" width="100%">
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
                                                    <td width="16%" nowrap>&nbsp;</td>
                                                    <td width="31%">&nbsp;</td>
                                                    <td width="12%" nowrap>&nbsp;</td>
                                                    <td width="39%">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                    <td nowrap><a href="javascript:cmdEditVendor()"><%=langBT[0]%></a></td>
                                                    <td colspan="3">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td width="18%"> 
                                                                    <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                                        <option value="0"><%=langNav[3]%></option>
                                                                        <%if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor vx = (Vendor) vendors.get(i);
                                                                        %>
                                                                        <option value="<%=vx.getOID()%>" <%if (vx.getOID() == banknonpoPayment.getVendorId()) {%>selected<%}%>><%=vx.getCode()%> - <%=vx.getName()%></option>
                                                                        <%}
            }%>
                                                                    </select>
                                                                <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_VENDOR_ID) %></td>
                                                                <td width="2%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                <td width="14%"></td>
                                                                <td width="66%"><input type="hidden" name="xxx" value="<%=xxx%>"></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap>&nbsp;</td>
                                                    <td colspan="3"><b><i><textarea name="vnd_address" cols="40" rows="3" class="readonly" readOnly>Vendor address ..</textarea></i></b>
                                                    </td>
                                                </tr>   
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
            if (banknonpoPayment.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(banknonpoPayment.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (preClosedPeriod.getOID() != 0) {
                    open = DbPeriode.getPreClosedPeriod();
                } else {
                    open = DbPeriode.getOpenPeriod();
                }
            }
            int counterJournal = DbSystemDocNumber.getNextCounterBbk(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberBbk(counterJournal, open.getOID());

            if (banknonpoPayment.getOID() != 0 || oidBanknonpoPayment != 0) {
                strNumber = banknonpoPayment.getJournalNumber();
            }
                                                %>
                                                <tr>
                                                    <td nowrap><%=langNav[6]%></td>
                                                    <td >
                                                        <input type="text" size="43" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_PAYMENT_TO]%>" value="<%=banknonpoPayment.getPaymentTo()  %>" >
                                                    </td>
                                                    <%if (preClosedPeriod.getOID() != 0) {%>
                                                    <td><%=langBT[24]%></td>
                                                    <td>
                                                        <%if (preClosedPeriod.getOID() != 0) {%>
                                                        <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_PERIODE_ID]%>">
                                                            <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                            %>
                                                            <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == banknonpoPayment.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                            <%}%>
                                                            <%}%>
                                                        </select>
                                                        <%} else {%>
                                                        <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_PERIODE_ID]%>" value="<%=openPeriod.getOID()%>">
                                                        <%}%>   
                                                    </td>
                                                    <%} else {%>
                                                    <td colspan="2">&nbsp;</td>
                                                    <%}%>
                                                </tr>
                                                <tr>
                                                    <td nowrap><%=langBT[1]%></td>
                                                    <td >
                                                        <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TYPE]%>" onChange="javascript:cmdTypeChange()">
                                                            <%
            for (int i = 0; i < 1; i++) {
                                                            %>
                                                            <option value="<%=i%>" <%if (i == banknonpoPayment.getType()) {%>selected<%}%>><%=I_Project.nonpoTypeGroup[0]%></option>
                                                            <%
            }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td nowrap><%=langBT[9]%></td>
                                                    <td >
                                                        <input name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((banknonpoPayment.getTransDate() == null) ? new Date() : banknonpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                        <%if (!isReconfirm) {%><%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_TRANS_DATE) %> <%}%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                <td nowrap><%=langBT[2]%></td>
                                                <td >
                                                    <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_COA_ID]%>" >
                                                        <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accLinks.size(); i++) {
                    AccLink acl = (AccLink) accLinks.get(i);
                    Coa coay = new Coa();
                    try {
                        coay = DbCoa.fetchExc(acl.getCoaId());
                    } catch (Exception e) {
                    }
                    if (banknonpoPayment.getCoaId() == 0 && i == 0) {
                        banknonpoPayment.setCoaId(acl.getCoaId());
                    }
                                                        %>
                                                        <option value="<%=acl.getCoaId()%>" <%if (acl.getCoaId() == banknonpoPayment.getCoaId()) {%>selected<%}%>><%=coay.getCode() + " - " + coay.getName()%></option>
                                                        <%=getAccountRecursif(coay, banknonpoPayment.getCoaId(), isPostableOnly)%> 
                                                        <%}
            }%>
                                                    </select>
                                                    <%if (!isReconfirm) {%><%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_COA_ID)%><%}%></b>
                                                </td>
                                                <td><%=langBT[8]%></td>
                                                <td>
                                                    <%=strNumber%> 
                                                    <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_JOURNAL_NUMBER]%>">
                                                    <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_JOURNAL_COUNTER]%>">
                                                    <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap><%=langBT[3]%></td>
                                                <td >
                                                    <%
            Vector vpm = DbPaymentMethod.list(0, 0, "", "");
                                                    %>
                                                    <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_PAYMENT_METHOD_ID]%>">
                                                        <%if (vpm != null && vpm.size() > 0) {
                for (int i = 0; i < vpm.size(); i++) {
                    PaymentMethod pm = (PaymentMethod) vpm.get(i);
                                                        %>
                                                        <option value="<%=pm.getOID()%>" <%if (pm.getOID() == banknonpoPayment.getPaymentMethodId()) {%>selected<%}%>><%=pm.getDescription()%></option>
                                                        <%}
            }%>
                                                    </select>
                                                </td>
                                                <td nowrap><%=langBT[10]%></td>
                                                <td >
                                                    <input type="text" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_INVOICE_NUMBER]%>" value="<%=banknonpoPayment.getInvoiceNumber()%>" size="43">
                                                    <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>" readOnly style="text-align:right">
                                                    <b><a id="tot_saldo_akhir"></a></b> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td ><%=langBT[4]%></td>
                                                <td > 
                                                    <input type="text" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_REF_NUMBER]%>" value="<%=banknonpoPayment.getRefNumber()%>" size="43">
                                                    <%if (!isReconfirm) {%><%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_REF_NUMBER) %><%}%>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>                                            
                                            <tr> 
                                                <td><%=langBT[5]%><%=baseCurrency.getCurrencyCode()%></td>
                                                <td> 
                                                    <input type="text" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()"   class="readonly" readOnly size="25">
                                                <%if (!isReconfirm) {%><%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_AMOUNT) %> <%}%></td>
                                                <td ></td>
                                                <td ></td>
                                            </tr>
                                            <tr> 
                                                <td ><%=langBT[6]%></td>
                                                <td > 
                                                    <textarea name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_MEMO]%>" cols="40" rows="3"><%=banknonpoPayment.getMemo()%></textarea>
                                                    <%if (!isReconfirm) {%><%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_MEMO) %><%}%> 
                                                </td>
                                                <td valign="top" colspan="2">
                                                    <table width="60%" border="0" cellspacing="3" cellpadding="3" bgcolor="#F3F3F3">
                                                        <tr>
                                                            <td> 
                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                    <tr>
                                                                        <td width="42%"><b>Segment</b></td>
                                                                    <td width="58%">&nbsp;</td></tr>
                                                                    <%
            if (segments != null && segments.size() > 0) {
                for (int i = 0; i < 1; i++) {
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
                    Vector sgDetails = DbSegmentDetail.list(0, 0, wh, "");
                                                                    %>
                                                                    <tr> 
                                                                        <td width="42%"><font face="arial"><%=segment.getName()%></font></td>
                                                                        <td width="58%"> 
                                                                            <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                for (int x = 0; x < sgDetails.size(); x++) {
                                                                                    SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                    String selected = "";
                                                                                    switch (i + 1) {
                                                                                        case 1:
                                                                                            if (banknonpoPayment.getSegment1Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 2:
                                                                                            if (banknonpoPayment.getSegment2Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 3:
                                                                                            if (banknonpoPayment.getSegment3Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 4:
                                                                                            if (banknonpoPayment.getSegment4Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 5:
                                                                                            if (banknonpoPayment.getSegment5Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 6:
                                                                                            if (banknonpoPayment.getSegment6Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 7:
                                                                                            if (banknonpoPayment.getSegment7Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 8:
                                                                                            if (banknonpoPayment.getSegment8Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 9:
                                                                                            if (banknonpoPayment.getSegment9Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 10:
                                                                                            if (banknonpoPayment.getSegment10Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 11:
                                                                                            if (banknonpoPayment.getSegment11Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 12:
                                                                                            if (banknonpoPayment.getSegment12Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 13:
                                                                                            if (banknonpoPayment.getSegment13Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 14:
                                                                                            if (banknonpoPayment.getSegment14Id() == sd.getOID()) {
                                                                                                selected = "selected";
                                                                                            }
                                                                                            break;
                                                                                        case 15:
                                                                                            if (banknonpoPayment.getSegment5Id() == sd.getOID()) {
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
                                                <td colspan="2"></td>
                                                <td colspan="2">
                                                    
                                                </td> 
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr> 
                                    <td colspan="4">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr><td>&nbsp;</td></tr><tr><td>&nbsp; </td></tr><tr> 
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0"><tr> 
                                                            <td width="100%" class="page">
                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1"><!--DWLayoutTable-->
                                                                    <tr>
                                                                        <td class="tablehdr" rowspan="2" width="19%">Segment</td>
                                                                        <td class="tablehdr" rowspan="2" width="19%"><%=langBT[12]%></td>
                                                                        <%if (isUseJemaat) {%>
                                                                        <td class="tablehdr" rowspan="2" width="15%">Jemaat</td>
                                                                        <%} else {%>
                                                                        <td class="tablehdr" rowspan="2" width="15%"><%=langBT[13]%></td>
                                                                        <%}%>
                                                                        <td class="tablehdr" colspan="2"><%=langBT[14]%></td>
                                                                        <td class="tablehdr" rowspan="2" width="9%"><%=langBT[17]%></td>
                                                                        <td class="tablehdr" rowspan="2" width="12%"><%=langBT[18]%><%=baseCurrency.getCurrencyCode()%></td>
                                                                        <td class="tablehdr" rowspan="2" width="28%"><%=langBT[19]%></td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td class="tablehdr" width="6%"><%=langBT[15]%></td>
                                                                        <td class="tablehdr" width="11%"><%=langBT[16]%></td>
                                                                    </tr>
                                                                    <%
            if (listBanknonpoPaymentDetail != null && listBanknonpoPaymentDetail.size() > 0) {
                for (int i = 0; i < listBanknonpoPaymentDetail.size(); i++) {
                    BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail) listBanknonpoPaymentDetail.get(i);
                    Coa c = new Coa();
                    try {
                        if (banknonpoPayment.getType() == 0) {
                            c = DbCoa.fetchExc(crd.getCoaId());
                        } else if (banknonpoPayment.getType() == 1) {
                            if (crd.getCoaIdTemp() == 0) {
                                c = DbCoa.fetchExc(crd.getCoaId());
                            } else {
                                c = DbCoa.fetchExc(crd.getCoaIdTemp());
                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    String cssString = "tablecell";
                    if (i % 2 != 0) {
                        cssString = "tablecell1";
                    }
                                                                    %>
                                                                    <%
                                                                            if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                    <tr> 
                                                                        <td class="tablecell" width="19%" valign="middle"> 
                                                                            <table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td> 
                                                                                        <div align="center"> 
                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                <%
                                                                        if (segments != null && segments.size() > 0) {
                                                                            for (int xx = 0; xx < segments.size(); xx++) {
                                                                                Segment seg = (Segment) segments.get(xx);
                                                                                Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), "");
                                                                                                %>
                                                                                                <tr> 
                                                                                                    <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                                    <td width="46%"> 
                                                                                                        <select name="JSP_SEGMENT<%=xx + 1%>_DETAIL_ID">
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
                                                                        <td>
                                                                            <div align="center">
                                                                                <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID]%>">
                                                                                    <%if (expenseCoas != null && expenseCoas.size() > 0) {
                                                                            for (int x = 0; x < expenseCoas.size(); x++) {
                                                                                Coa coax = (Coa) expenseCoas.get(x);
                                                                                String str = "";

                                                                                    %>
                                                                                    <option value="<%=coax.getOID()%>" <%if (crd.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                    <%=getAccountRecursif(coax, crd.getCoaId(), isPostableOnly)%> 
                                                                                    <%}
                                                                        }%>
                                                                                </select>   
                                                                                <%if (!isReconfirm) {%>
                                                                                <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_COA_ID) %> 
                                                                                <%}%>
                                                                            </div>
                                                                        </td>
                                                                        
                                                                        <td width="15%" class="tablecell">
                                                                            <div align="center"> 
                                                                                <input type="hidden" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>" value="<%=banknonpoPayment.getType()%>">
                                                                                <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                                                    <%if (deps != null && deps.size() > 0) {
                                                                            for (int x = 0; x < deps.size(); x++) {
                                                                                Department d = (Department) deps.get(x);

                                                                                String str = "";
                                                                                str = getStrLevel(d.getLevel());
                                                                                    %>
                                                                                    <option value="<%=d.getOID()%>" <%if (crd.getDepartmentId() == d.getOID()) {%>selected<%}%>><%=str + d.getCode() + " - " + d.getName()%></option>
                                                                                    <%}
                                                                        }%>
                                                                                </select>
                                                                                <%if (!isReconfirm) {%><%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID) %>
                                                                                <%}%>
                                                                            </div>
                                                                        </td>
                                                                        <td width="6%" class="tablecell"><div align="center"> 
                                                                                <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
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
                                                                        <td width="11%" class="tablecell"><div align="center"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:cmdUpdateExchange()" onClick="this.select()"></div>
                                                                        </td>
                                                                        <td width="9%" class="tablecell"><div align="center"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateExchangeXX()" onClick="this.select()"></div>
                                                                        </td>
                                                                        <td width="12%" class="tablecell"><div align="center"> 
                                                                                <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                                <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()"  class="readonly" readOnly>
                                                                                <%if (!isReconfirm) {%>
                                                                                <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_AMOUNT) %>
                                                                                <%}%> 
                                                                            </div>
                                                                        </td><td width="28%" class="tablecell"><div align="left"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_MEMO]%>" size="20" value="<%=crd.getMemo()%>"></div></td>
                                                                    </tr>
                                                                    <%} else {%>
                                                                    <tr> 
                                                                        <td class="<%=cssString%>" width="16%"> 
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
                                                                        <td class="<%=cssString%>" width="19%" nowrap> 
                                                                            <%if (banknonpoPayment.getPostedStatus() == 1) {%>
                                                                            <%=c.getCode()%> 
                                                                            <%} else {%>
                                                                            <a href="javascript:cmdEdit('<%=i%>')"> <%=c.getCode()%> </a> 
                                                                            <%}%>
                                                                            &nbsp;-&nbsp;<%=c.getName()%>
                                                                        </td>
                                                                        <td width="15%" class="<%=cssString%>" nowrap> 
                                                                            <input type="hidden" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>" value="<%=banknonpoPayment.getType()%>">
                                                                            <%
                                                                        Department d = new Department();
                                                                        try {
                                                                            d = DbDepartment.fetchExc(crd.getDepartmentId());
                                                                        } catch (Exception e) {
                                                                        }
                                                                            %>
                                                                        <%=d.getCode() + " - " + d.getName()%></td>
                                                                        <td width="6%" class="<%=cssString%>"> <div align="center"> <%
                                                                        Currency xc = new Currency();
                                                                        try {
                                                                            xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                        } catch (Exception e) {
                                                                        }
                                                                                %>
                                                                                <%=xc.getCurrencyCode()%> 
                                                                            </div>
                                                                        </td>
                                                                        <td width="11%" class="<%=cssString%>"><div align="right"><%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%></div>
                                                                        </td>
                                                                        <td width="9%" class="<%=cssString%>"><div align="right"><%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div></td>
                                                                        <td width="12%" class="<%=cssString%>"><div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div></td>
                                                                        <td width="28%" class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                                    </tr>
                                                                    <%}%>
                                                                    <%}
            }%>
                                                                    <%
            if (((isReconfirm || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCode > 0 || iErrCodeMain != 0) && recIdx == -1) && !(isSave && iErrCode == 0 && iErrCodeMain == 0) && (banknonpoPayment.getPostedStatus() != 1)) {
                                                                    %>
                                                                    <tr> 
                                                                        <td class="tablecell" width="16%">
                                                                            <div align="center"> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                    <%
                                                                        if (segments != null && segments.size() > 0) {
                                                                            for (int xx = 0; xx < segments.size(); xx++) {
                                                                                Segment seg = (Segment) segments.get(xx);
                                                                                Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), "");
                                                                                    %>
                                                                                    <tr> 
                                                                                        <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                        <td width="46%"> 
                                                                                            <select name="JSP_SEGMENT<%=xx + 1%>_DETAIL_ID">
                                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                    SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                    String selected = "";
                                                                                                    switch (xx + 1) {
                                                                                                        case 1:
                                                                                                            if (banknonpoPaymentDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 2:
                                                                                                            if (banknonpoPaymentDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 3:
                                                                                                            if (banknonpoPaymentDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 4:
                                                                                                            if (banknonpoPaymentDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 5:
                                                                                                            if (banknonpoPaymentDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 6:
                                                                                                            if (banknonpoPaymentDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 7:
                                                                                                            if (banknonpoPaymentDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 8:
                                                                                                            if (banknonpoPaymentDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 9:
                                                                                                            if (banknonpoPaymentDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 10:
                                                                                                            if (banknonpoPaymentDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 11:
                                                                                                            if (banknonpoPaymentDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 12:
                                                                                                            if (banknonpoPaymentDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 13:
                                                                                                            if (banknonpoPaymentDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 14:
                                                                                                            if (banknonpoPaymentDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                selected = "selected";
                                                                                                            }
                                                                                                            break;
                                                                                                        case 15:
                                                                                                            if (banknonpoPaymentDetail.getSegment15Id() == sd.getOID()) {
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
                                                                        <td class="tablecell" valign="middle"> 
                                                                            <table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="center"><select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID]%>">
                                                                                                <%if (expenseCoas != null && expenseCoas.size() > 0) {
                                                                            for (int x = 0; x < expenseCoas.size(); x++) {
                                                                                Coa coax = (Coa) expenseCoas.get(x);

                                                                                String str = "";

                                                                                                %>
                                                                                                <option value="<%=coax.getOID()%>" <%if (banknonpoPaymentDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                <%=getAccountRecursif(coax, banknonpoPaymentDetail.getCoaId(), isPostableOnly)%> 
                                                                                                <%}
                                                                        }%>
                                                                                            </select>
                                                                                            <%if (!isReconfirm) {%><%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_COA_ID) %><%}%> 
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>                                                                                
                                                                            </table>
                                                                        </td>
                                                                        <td width="15%" class="tablecell"><div align="center"> 
                                                                                <input type="hidden" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>" value="<%=banknonpoPayment.getType()%>">
                                                                                <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                                                    <%if (deps != null && deps.size() > 0) {
                                                                            for (int x = 0; x < deps.size(); x++) {
                                                                                Department d = (Department) deps.get(x);

                                                                                String str = "";
                                                                                str = getStrLevel(d.getLevel());

                                                                                    %>
                                                                                    <option value="<%=d.getOID()%>" <%if (banknonpoPaymentDetail.getDepartmentId() == d.getOID()) {%>selected<%}%>><%=str + d.getCode() + " - " + d.getName()%></option>
                                                                                    <%}
                                                                        }%>
                                                                                </select>
                                                                                <%if (!isReconfirm) {%>
                                                                                <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID) %>
                                                                                <%}%> 
                                                                            </div>
                                                                        </td>
                                                                        <td width="6%" class="tablecell"><div align="center"><select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                                    <%
                                                                        if (currencies != null && currencies.size() > 0) {
                                                                            for (int x = 0; x < currencies.size(); x++) {
                                                                                Currency cx = (Currency) currencies.get(x);
                                                                                    %>
                                                                                    <option value="<%=cx.getOID()%>" <%if (banknonpoPaymentDetail.getForeignCurrencyId() == cx.getOID()) {%>selected<%}%>><%=cx.getCurrencyCode()%></option>
                                                                                    <%}
                                                                        }%>
                                                                                </select>
                                                                            </div>
                                                                        </td><td width="11%" class="tablecell"><div align="center"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>" value="<%=JSPFormater.formatNumber(banknonpoPaymentDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:cmdUpdateExchange()" onClick="this.select()"></div>
                                                                        </td><td width="9%" class="tablecell"><div align="center"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>" value="<%=JSPFormater.formatNumber(banknonpoPaymentDetail.getBookedRate(), "#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:cmdUpdateExchangeXX()" onClick="this.select()"></div>
                                                                        </td><td width="12%" class="tablecell"> 
                                                                            <div align="center"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()"  class="readonly" readOnly>
                                                                                <%if (!isReconfirm) {%>
                                                                                <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_AMOUNT) %> 
                                                                        <%}%></div></td>
                                                                    <td width="28%" class="tablecell"><div align="left"><input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_MEMO]%>" size="20" value="<%=banknonpoPaymentDetail.getMemo()%>"></div></td></tr>
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
                                <tr> 
                                    <td colspan="4">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="78%"> 
                                                    <table width="50%" border="0" cellspacing="0" cellpadding="0"><%if (iErrCodeMain == 0 || iErrCode != 0) {%>
                                                        <tr><td> 
                                                                <%

    if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeMain == 0) || (isSave && iErrCode == 0 && iErrCodeMain == 0)) {

                                                                %>
                                                                <%if (iJSPCommand == JSPCommand.RESET) {%>
                                                                <table>                                                                                                                              
                                                                    <tr><td><table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                <tr><td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                            <td width="220" nowrap>Delete Success</td></tr></table>
                                                                        </td>
                                                                    </tr>    
                                                                    <tr><td>&nbsp;</td></tr><tr>
                                                                        <td><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a></td>
                                                                    </tr>
                                                                </table>    
                                                                <%} else {%>
                                                                <a href="javascript:cmdAdd('<%=banknonpoPayment.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> 
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
                                                                        String scomDel = "javascript:cmdAsk('" + oidBanknonpoPaymentDetail + "')";
                                                                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidBanknonpoPaymentDetail + "')";
                                                                        String scancel = "javascript:cmdEdit('" + oidBanknonpoPaymentDetail + "')";
                                                                        if (listBanknonpoPaymentDetail != null && listBanknonpoPaymentDetail.size() > 0) {
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
                                                                <%if (banknonpoPayment.getPostedStatus() != 1) {%>
                                                                <table border="0" cellpadding="0" cellspacing="0"><tr><td><%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%></td></tr></table>
                                                                <%}%>
                                                                <%}
                                                                %>
                                                            </td>
                                                        </tr>
                                                        <%} else {%>
                                                        <%if (banknonpoPayment.getPostedStatus() != 1) {%>
                                                        <tr> 
                                                            <td align="left"><%if (privUpdate || privAdd) {%><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savenew2.gif',1)"><img src="../images/savenew.gif" name="savedoc21" height="22" border="0" width="116"></a><% }%></td>
                                                        </tr>
                                                        <%}%>
                                                        <tr>
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                        <tr> 
                                                            <td>
                                                                <%if (!isReconfirm) {%>
                                                                <table border="0" cellpadding="2" cellspacing="0" class="warning" width="293" align="left">
                                                                    <tr><td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                    <td width="253" nowrap><%=msgStringMain%></td></tr>
                                                                </table>
                                                                <%}%>
                                                            </td>
                                                        </tr>
                                                        <%}%>
                                                    </table>
                                                </td>
                                                <td class="boxed1" width="22%"> 
                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1"><tr><td width="36%"><div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                            </td><td width="64%"><div align="right"><b> 
                                                                        <%

            balance = banknonpoPayment.getAmount() - totalDetail;
                                                                        %>
                                                                        <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                <%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div>
                                                            </td>
                                                        </tr>
                                    </table></td></tr></table></td>
                                </tr>
                                <tr><td colspan="4">&nbsp; </td></tr>
                                <%if (((submit && iErrCode == 0 && iErrCodeMain == 0) || (listBanknonpoPaymentDetail != null && listBanknonpoPaymentDetail.size() > 0)) && banknonpoPayment.getPostedStatus() != 1) {
                                %>
                                <tr> 
                                    <td colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2">&nbsp;</td></tr><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr>
                                    </table></td>
                                </tr>
                                <tr> 
                                    <td colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                                <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" border="0"></a></td>
                                                <%if (banknonpoPayment.getOID() != 0) {%>
                                                <td width><a href="javascript:cmdAsking('<%=banknonpoPayment.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('dl','','../images/deletedoc2.gif',1)"><img src="../images/deletedoc.gif" name="dl" height="22" border="0"  alt="Delete Doc"></a></td>
                                                <%}%>
                                                <td width="64%">&nbsp;</td><td width="28%"><table border="0" cellpadding="5" cellspacing="0" class="info" width="213" align="right"><tr><td width="12"><img src="../images/inform.gif" width="20" height="20"></td><td width="181" nowrap><%=langBT[20]%></td></tr></table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <%}%>
                                <%if (banknonpoPayment.getOID() != 0 || (listBanknonpoPaymentDetail != null && listBanknonpoPaymentDetail.size() > 0)) {%>
                                <tr> 
                                    <td colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2">&nbsp;</td></tr><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr></table>
                                    </td>
                                </tr>
                                <tr align="left" valign="top"><td height="6"></td></tr>  
                                <%if (banknonpoPayment.getPostedStatus() == 1) {%>
                                <tr align="left" valign="top">                                            
                                    <td valign="middle" colspan="4"><div align="left" class="msgnextaction"><table border="0" cellpadding="5" cellspacing="0" class="success" align="left"><tr><td width="20"><img src="../images/success.gif" width="20" height="20"></td><td width="150">Posted</td></tr></table></div>
                                    </td>
                                </tr><tr align="left" valign="top"><td height="6"></td></tr>          
                                <%}%>
                                <tr> 
                                    <td colspan="4"> 
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <%if(banknonpoPayment.getOID() != 0){%>
                                                <td > <%
    out.print("<a href=\"../freport/banknonpo_priview_main.jsp?banknonpopayment_id=" + banknonpoPayment.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/print2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");
                                                %></td>
                                                &nbsp;<td > <%
    out.print("<a href=\"../freport/banknonpo_priview.jsp?banknonpopayment_id=" + banknonpoPayment.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt2','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt2\" height=\"22\" border=\"0\"></a></div>");
                                                %>&nbsp;</td>
                                                <%}%>
                                                <td ><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                                                <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                <td width="38%">
                                                    <%if (isSave == true && iErrCodeMain == 0 && iErrCode == 0) {%>
                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                        <tr>
                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                        <td width="220"><%=langBT[21]%></td></tr>
                                                    </table>
                                                    <%}%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <%}%>
                                <tr><td colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr> 
                                                <td><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2">&nbsp;</td></tr><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr>
                                                </table></td>
                                            </tr><tr> <td><div align="right" class="msgnextaction"></div></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>                                
                                <%if (oidBanknonpoPayment != 0) {%>
                                <tr> 
                                    <td colspan="4"> 
                                        <%
    Vector temp = DbApprovalDoc.getDocApproval(oidBanknonpoPayment);
                                        %>
                                        <table width="800" border="0" cellspacing="1" cellpadding="1">
                                            <tr><td colspan="7" height="20"><b><%=langApp[0].toUpperCase()%></b> </td></tr>
                                            <tr><td width="5%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[1]%> </font></b></td><td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td><td width="18%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[2]%></font></b></td><td width="11%" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                            <td width="9%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td><td width="27%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[6]%></font></b></td><td width="15%" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[7]%></font></b></td></tr>
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
                                                <td width="20%"><%if (banknonpoPayment.getPostedStatus() == 0) {
                                                        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED && user.getEmployeeId() == apd.getEmployeeId()) {%>
                                                    <div align="center"><input type="text" name="approval_doc_note" size="30" value="<%=catatan%>"></div>
                                                    <%} else if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {%>
                                                    <div align="center"><input type="text" name="approval_doc_note" size="30" value="<%=catatan%>"></div>
                                                    <%} else {%><%=catatan%> 
                                                    <%}
} else {%>
                                                <%=catatan%><%}%></td>
                                                <td width="12%"><%if (banknonpoPayment.getPostedStatus() == 0) {
                                                    %>
                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                        <tr><td><%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                                                %>
                                                                <div align="center"><table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr><td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')"><img src="../images/success.gif" alt="Klik : Untuk Menyetujui Dokumen" border="0"></a></div>
                                                                            </td><td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')"><img src="../images/no.gif" alt="Klik : Untuk tidak menyetujui" border="0"></a></div></td>
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
} else {%>&nbsp; 
                                            <%}%></td></tr><tr><td colspan="7" height="1" bgcolor="#CCCCCC"></td></tr>
                                            <%}
    }%>
                                            <tr><td width="11%">&nbsp;</td><td width="13%">&nbsp;</td><td width="20%">&nbsp;</td><td width="13%">&nbsp;</td><td width="11%">&nbsp;</td><td width="20%">&nbsp;</td><td width="12%">&nbsp;</td></tr>
</table></td></tr><%}%></table></td></tr></table></td></tr></table></td></tr></table><script language="JavaScript">
                                 <%

            if ((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode != 0) && isNone) {%>					
                    cmdUpdateExchange();
                    <%}%>
                    cmdVendor();
                    </script>
</form><!-- #EndEditable --></td></tr><tr><td>&nbsp;</td></tr></table></td></tr></table></td></tr>
<tr><td height="25"> 
        <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
        <!-- #EndEditable -->
</td></tr></table></td></tr></table></body>
<!-- #EndTemplate --></html>