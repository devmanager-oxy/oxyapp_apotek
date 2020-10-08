
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD, AppMenu.PRIV_DELETE);
%>

<%!
    public String drawList(int iJSPCommand, JspBankDepositDetail frmObject, BankDepositDetail objEntity, Vector objectClass, long bankDepositDetailId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Cash Receive Id", "14%");
        ctrlist.addHeader("Coa Id", "14%");
        ctrlist.addHeader("Foreign Currency Id", "14%");
        ctrlist.addHeader("Foreign Amount", "14%");
        ctrlist.addHeader("Booked Rate", "14%");
        ctrlist.addHeader("Amount", "14%");
        ctrlist.addHeader("Memo", "14%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        Vector coaid_value = new Vector(1, 1);
        Vector coaid_key = new Vector(1, 1);
        coaid_value.add("");
        coaid_key.add("---select---");

        Vector foreigncurrencyid_value = new Vector(1, 1);
        Vector foreigncurrencyid_key = new Vector(1, 1);
        foreigncurrencyid_value.add("");
        foreigncurrencyid_key.add("---select---");

        for (int i = 0; i < objectClass.size(); i++) {
            BankDepositDetail bankDepositDetail = (BankDepositDetail) objectClass.get(i);
            rowx = new Vector();
            if (bankDepositDetailId == bankDepositDetail.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_BANK_DEPOSIT_ID] + "\" value=\"" + bankDepositDetail.getBankDepositId() + "\" class=\"formElemen\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_COA_ID], null, "" + bankDepositDetail.getCoaId(), coaid_value, coaid_key, "formElemen", ""));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID], null, "" + bankDepositDetail.getForeignCurrencyId(), foreigncurrencyid_value, foreigncurrencyid_key, "formElemen", ""));
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT] + "\" value=\"" + bankDepositDetail.getForeignAmount() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_BOOKED_RATE] + "\" value=\"" + bankDepositDetail.getBookedRate() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_AMOUNT] + "\" value=\"" + bankDepositDetail.getAmount() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_MEMO] + "\" value=\"" + bankDepositDetail.getMemo() + "\" class=\"formElemen\">");
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(bankDepositDetail.getOID()) + "')\">" + String.valueOf(bankDepositDetail.getBankDepositId()) + "</a>");
                rowx.add(String.valueOf(bankDepositDetail.getCoaId()));
                rowx.add(String.valueOf(bankDepositDetail.getForeignCurrencyId()));
                rowx.add(String.valueOf(bankDepositDetail.getForeignAmount()));
                rowx.add(String.valueOf(bankDepositDetail.getBookedRate()));
                rowx.add(String.valueOf(bankDepositDetail.getAmount()));
                rowx.add(bankDepositDetail.getMemo());
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {

            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_BANK_DEPOSIT_ID] + "\" value=\"" + objEntity.getBankDepositId() + "\" class=\"formElemen\">");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_COA_ID], null, "" + objEntity.getCoaId(), coaid_value, coaid_key, "formElemen", ""));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID], null, "" + objEntity.getForeignCurrencyId(), foreigncurrencyid_value, foreigncurrencyid_key, "formElemen", ""));
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT] + "\" value=\"" + objEntity.getForeignAmount() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_BOOKED_RATE] + "\" value=\"" + objEntity.getBookedRate() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspBankDepositDetail.JSP_MEMO] + "\" value=\"" + objEntity.getMemo() + "\" class=\"formElemen\">");

        }

        lstData.add(rowx);

        return ctrlist.draw();
    }

    public Vector addNewDetail(Vector listBankDepositDetail, BankDepositDetail bankDepositDetail) {
        boolean found = false;
        if (listBankDepositDetail != null && listBankDepositDetail.size() > 0) {
            for (int i = 0; i < listBankDepositDetail.size(); i++) {
                BankDepositDetail cr = (BankDepositDetail) listBankDepositDetail.get(i);
                if (cr.getCoaId() == bankDepositDetail.getCoaId() && cr.getForeignCurrencyId() == bankDepositDetail.getForeignCurrencyId()) {
                    cr.setForeignAmount(cr.getForeignAmount() + bankDepositDetail.getForeignAmount());
                    cr.setAmount(cr.getAmount() + bankDepositDetail.getAmount());
                    found = true;
                }
            }
        }

        if (!found) {
            listBankDepositDetail.add(bankDepositDetail);
        }

        return listBankDepositDetail;
    }

    public double getTotalDetail(Vector listx) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                BankDepositDetail crd = (BankDepositDetail) listx.get(i);
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
            long oidBankDeposit = JSPRequestValue.requestLong(request, "hidden_bank_deposit_id");
            long oidBankDepositDetail = JSPRequestValue.requestLong(request, "hidden_bank_deposit_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int reset_app = JSPRequestValue.requestInt(request, "reset_app");

            // variable ini untuk printing
            docChoice = 4;
            generalOID = oidBankDeposit;
            //=================

            boolean isAkunting = true;
            int isPrivAkunting = 0;
            long grp_akunting_id = 0;

            try {
                isPrivAkunting = Integer.parseInt(DbSystemProperty.getValueByName("PRIV_PRINT_AKUNTING"));
            } catch (Exception e) {
                isPrivAkunting = 0;
            }
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
            
            boolean isUseJemaat = false;
            try{
                String useJemaat = DbSystemProperty.getValueByName("USE_JEMAAT");
                if(useJemaat.compareTo("Y")==0){
                    isUseJemaat = true;
                }
            }catch(Exception e){}
            
            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("BANK_DEPOSIT");
                oidBankDeposit = 0;
                recIdx = -1;
            }

            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            boolean isLoad = false;

            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("BANK_DEPOSIT");
                oidBankDeposit = JSPRequestValue.requestLong(request, "bankdeposit_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdBankDeposit ctrlBankDeposit = new CmdBankDeposit(request);
            JSPLine ctrLine = new JSPLine();
            Vector listBankDeposit = new Vector(1, 1);

            int iErrCodeMain = ctrlBankDeposit.action(iJSPCommand, oidBankDeposit);
            JspBankDeposit jspBankDeposit = ctrlBankDeposit.getForm();
            int vectSize = DbBankDeposit.getCount(whereClause);
            BankDeposit bankDeposit = ctrlBankDeposit.getBankDeposit();
            String msgStringMain = ctrlBankDeposit.getMessage();

            if (oidBankDeposit == 0) {
                oidBankDeposit = bankDeposit.getOID();
            }

            if (oidBankDeposit != 0) {
                try {
                    bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
                } catch (Exception e) {
                }
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankDeposit.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listBankDeposit = DbBankDeposit.list(start, recordToGet, whereClause, orderClause);

            if (listBankDeposit.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST;
                }
                listBankDeposit = DbBankDeposit.list(start, recordToGet, whereClause, orderClause);
            }

            if (reset_app == 1) {
                DbApprovalDoc.resetApproval(I_Project.TYPE_APPROVAL_BKM_BANK, bankDeposit.getOID());
            }

            boolean load = false;

            if (iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }

            CmdBankDepositDetail ctrlBankDepositDetail = new CmdBankDepositDetail(request);

            Vector listBankDepositDetail = new Vector(1, 1);
            if (load) {
                listBankDepositDetail = DbBankDepositDetail.list(0, 0, DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] + "=" + bankDeposit.getOID(), null);
            }

            iErrCode = ctrlBankDepositDetail.action(iJSPCommand, oidBankDepositDetail);
            JspBankDepositDetail jspBankDepositDetail = ctrlBankDepositDetail.getForm();
            vectSize = DbBankDepositDetail.getCount(whereClause);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlBankDepositDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            BankDepositDetail bankDepositDetail = ctrlBankDepositDetail.getBankDepositDetail();
            msgString = ctrlBankDepositDetail.getMessage();

            if (session.getValue("BANK_DEPOSIT") != null) {
                listBankDepositDetail = (Vector) session.getValue("BANK_DEPOSIT");
            }

            boolean submit = false;
            if (iJSPCommand == JSPCommand.SUBMIT) {
                submit = true;
                if (iErrCode == 0 && iErrCodeMain == 0) {
                    if (recIdx == -1) {
                        listBankDepositDetail.add(bankDepositDetail);
                    } else {
                        try {
                            BankDepositDetail bddUpdate = (BankDepositDetail) listBankDepositDetail.get(recIdx);
                            bankDepositDetail.setOID(bddUpdate.getOID());
                            listBankDepositDetail.set(recIdx, bankDepositDetail);
                        } catch (Exception e) {
                        }
                    }
                }
            }
            if (iJSPCommand == JSPCommand.DELETE) {
                try {
                    BankDepositDetail bankDepositDetailDel = (BankDepositDetail) listBankDepositDetail.get(recIdx);
                    DbBankDepositDetail.deleteExc(bankDepositDetailDel.getOID());
                    listBankDepositDetail.remove(recIdx);
                } catch (Exception e) {
                }
            }

            boolean isSave = false;
            if (iJSPCommand == JSPCommand.SAVE) {
                if (bankDeposit.getOID() != 0) {
                    DbBankDepositDetail.saveAllDetail(bankDeposit, listBankDepositDetail);
                    listBankDepositDetail = DbBankDepositDetail.list(0, 0, "bank_deposit_id=" + bankDeposit.getOID(), "");
                    isSave = true;
                }
                iJSPCommand = JSPCommand.ADD;
            }

            session.putValue("BANK_DEPOSIT", listBankDepositDetail);
            Vector incomeCoas = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_CREDIT + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            Vector currencies = DbCurrency.list(0, 0, "", "");
            ExchangeRate eRate = DbExchangeRate.getStandardRate();
            double balance = 0;
            double totalDetail = getTotalDetail(listBankDepositDetail);
            bankDeposit.setAmount(totalDetail);

            if (iJSPCommand == JSPCommand.RESET && iErrCodeMain == 0) {
                totalDetail = 0;
                bankDeposit = new BankDeposit();
                listBankDepositDetail = new Vector();
                session.removeValue("BANK_DEPOSIT");
            }

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeMain == 0 && recIdx == -1) {
                iJSPCommand = JSPCommand.ADD;
                bankDepositDetail = new BankDepositDetail();
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_DEBET + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");

            String[] langBT = {"Deposit to Account", "Amount", "Memo", "Journal Number", "Transaction Date", //0-4
                "Account - Description", "Currency", "Code", "Amount", "Booked Rate", "Amount", "Description", //5-11
                "Journal is ready to be saved", "Journal has been saved", "Searching", "Customer", "Segments", "Search for Bank Deposit", "Bank Deposit Editor", "Credit", "Amount Credit", "Period", "Receive From", "Segment"}; //12-23

            String[] langNav = {"Bank", "Deposit", "Date", "Select..."};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Setoran ke Perkiraan", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-4
                    "Perkiraan", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan", //5-11
                    "Jurnal siap untuk di simpan", "Jurnal sukses di simpan", "Pencarian", "Konsumen", "Segmen", "Pencarian", "Editor Bank Deposit", "Credit", "Jumlah Credit", "Periode", "Diterima Dari", "Segmen"}; //12-23

                langBT = langID;
                String[] navID = {"Bank", "Setoran", "Tanggal", "Pilih..."};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }
            Vector deps = DbDepartment.list(0, 0, "", "code");
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
                document.frmbankdepositdetail.command.value="<%=JSPCommand.LOAD%>";
                document.frmbankdepositdetail.command_print.value=param;
                document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                document.frmbankdepositdetail.submit();	
            }
            
            function cmdSearchJurnal(){
                window.open("s_bankdeposit.jsp?formName=frmbankdepositdetail&txt_Id=bankdeposit_id&txt_Name=jurnal_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function cmdNone(){	
                    document.frmbankdepositdetail.hidden_bank_deposit_id.value="0";
                    document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value="0";
                    document.frmbankdepositdetail.command.value="<%=JSPCommand.NONE%>";
                    document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                    document.frmbankdepositdetail.submit();
                }
                
                function cmdPrintJournal(){	 
                    window.open("<%=printroot%>.report.RptBankDepositPDF?oid=<%=appSessUser.getLoginId()%>&dep_id=<%=bankDeposit.getOID()%>");				
                    }
                    
                    function cmdClickMe(){
                        var x = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;	
                        document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.select();
                    }
                    
                    function cmdClickMeCredit(){
                        var x = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value;	
                        document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.select();
                    }
                    
                    function cmdFixing(){	
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.POST%>";
                        document.frmbankdepositdetail.action="bankdepositdetail.jsp";
                        document.frmbankdepositdetail.submit();	
                    }
                    
                    function cmdNewJournal(){	
                        document.frmbankdepositdetail.command.value="<%=JSPCommand.NONE%>";
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
                            }else{
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
                    
                    var stCredit = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_CREDIT_AMOUNT]%>.value;		
                    resultCredit = removeChar(stCredit);	
                    resultCredit = cleanNumberFloat(resultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    
                    var result2 = 0;
                    
                    //add
                    if(parseFloat(idx)<0){                        
                        var amount = parseFloat(currTotal) + parseFloat(result) - parseFloat(resultCredit);
                        document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    }
                    //edit
                    else{
                        var editAmount =  document.frmbankdepositdetail.edit_amount.value;
                        var editCreditAmount =  document.frmbankdepositdetail.edit_creditamount.value;
                        
                        var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result) + parseFloat(editCreditAmount) - parseFloat(resultCredit);
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
            var fcreditamount = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value;
            
            famount = removeChar(famount);
            fcreditamount = removeChar(fcreditamount);
            
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            fcreditamount = cleanNumberFloat(fcreditamount, sysDecSymbol, usrDigitGroup, usrDecSymbol); 
            
            if(parseFloat(famount)>0 && parseFloat(fcreditamount)>0){
                alert("tidak boleh mengisi keduanya debet dan kredit, system akan me-reset data kredit");
                fcreditamount = "0";
                
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_CREDIT_AMOUNT]%>.value= formatFloat(parseFloat(fcreditamount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value= formatFloat(fcreditamount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                 
            }    
            
            var fbooked = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value;
            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            if(!isNaN(famount)){
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_CREDIT_AMOUNT]%>.value= formatFloat(parseFloat(fcreditamount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>.value= formatFloat(fcreditamount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            }
            
            checkNumber2();
        }
        
        function cmdUpdateExchangeXX(){            
            var rate = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value;
            rate = removeChar(rate); 
            rate = cleanNumberFloat(rate , sysDecSymbol, usrDigitGroup, usrDecSymbol);  
            var famount = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;            
            famount = removeChar(famount);
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);                        
            if(!isNaN(famount)){
                document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(rate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
                
            } 
            checkNumber2();                       
        }
        
        function cmdAdd(bankDepositId){	
            document.frmbankdepositdetail.select_idx.value="-1";
            document.frmbankdepositdetail.hidden_bank_deposit_id.value=bankDepositId;
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value="0";
            document.frmbankdepositdetail.command.value="<%=JSPCommand.ADD%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdAsk(oidBankDepositDetail){
            document.frmbankdepositdetail.select_idx.value=oidBankDepositDetail;
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.ASK%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
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
            <%if (privUpdate) {%>
            document.frmbankdepositdetail.select_idx.value=oidBankDepositDetail;
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
            <%}%>
        }
        
        function cmdCancel(oidBankDepositDetail){
            document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmbankdepositdetail.command.value="<%=JSPCommand.EDIT%>";
            document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdBack(){
            document.frmbankdepositdetail.command.value="<%=JSPCommand.BACK%>";
            document.frmbankdepositdetail.action="bankdepositdetail.jsp";
            document.frmbankdepositdetail.submit();
        }
        
        function cmdDelPict(oidBankDepositDetail){
            document.frmimage.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="bankdepositdetail.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/cancel2.gif','../images/savenew2.gif','../images/newdoc2.gif')">
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
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                        
                                                                                        <tr> 
                                                                                            <td colspan="4">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="10%" colspan="4">                                                                                                            
                                                                                                            <table border="0" cellspacing="3" cellpadding="3" bgcolor="#F3F3F3">                                                                                                            
                                                                                                                <%
            String jur_number = "";
            long bangdepositId = 0;
            if (isLoad && reset_app != 1) {
                jur_number = bankDeposit.getJournalNumber();
                bangdepositId = bankDeposit.getOID();
            }
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td><font face="arial"><b><%=langBT[14]%></b></font></td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td><%=langBT[3]%></td>
                                                                                                                    <td><input size="30" readonly type="text" name="jurnal_number" value="<%=jur_number%>"></td>
                                                                                                                    <td><input type="hidden" name="bankdeposit_id" value="<%=bangdepositId%>">
                                                                                                                        <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr heoght="5">
                                                                                                                    <td colspan="4"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" width="100%"> 
                                                                                                            <table width="75%" border="0" cellspacing="0" cellpadding="0">
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
                                                                                                        <td colspan="4" height="20"><font face = "arial"><b><u><%=langBT[18].toUpperCase()%></u></b></font></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="15">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="15">
                                                                                                            <table width=1000" border="0" cellpadding="1" cellspacing="0">
                                                                                                                <tr> 
                                                                                                                    <td width="13%"><%=langBT[3]%></td>
                                                                                                                    <td width="33%"> 
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

            if (bankDeposit.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(bankDeposit.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (preClosedPeriod.getOID() != 0) {
                    open = DbPeriode.getPreClosedPeriod();
                } else {
                    open = DbPeriode.getOpenPeriod();
                }
            }
            int counterJournal = DbSystemDocNumber.getNextCounterBbm(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberBbm(counterJournal, open.getOID());
            if (bankDeposit.getOID() != 0 || oidBankDeposit != 0) {
                strNumber = bankDeposit.getJournalNumber();
            }

                                                                                                                        %>
                                                                                                                        <%=strNumber%> 
                                                                                                                        <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_NUMBER]%>">
                                                                                                                        <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_COUNTER]%>">
                                                                                                                        <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_PREFIX]%>">
                                                                                                                    </td>
                                                                                                                    <td width="12%"> 
                                                                                                                        <%if (preClosedPeriod.getOID() != 0) {%>
                                                                                                                        <div align="left"><%=langBT[21]%></div>
                                                                                                                        <%} else {%>
                                                                                                                        &nbsp;
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="42%"> 
                                                                                                                        <%if (preClosedPeriod.getOID() != 0) {%>
                                                                                                                        <select name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_PERIODE_ID]%>">
                                                                                                                            <%
    if (periods != null && periods.size() > 0) {

        for (int t = 0; t < periods.size(); t++) {

            Periode objPeriod = (Periode) periods.get(t);

                                                                                                                            %>
                                                                                                                            <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == bankDeposit.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                            <%}%>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%} else {%>
                                                                                                                        <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_PERIODE_ID]%>" value="<%=openPeriod.getOID()%>">
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="13%"><%=langBT[0]%></td>
                                                                                                                    <td> 
                                                                                                                        <select name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_COA_ID]%>">
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accLinks.size(); i++) {
                    AccLink accLink = (AccLink) accLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                    }

                    if (bankDeposit.getCoaId() == 0 && i == 0) {
                        bankDeposit.setCoaId(accLink.getCoaId());
                    }
                                                                                                                            %>
                                                                                                                            <option <%if (bankDeposit.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, bankDeposit.getCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                    <%= jspBankDeposit.getErrorMsg(JspBankDeposit.JSP_COA_ID) %> </td>
                                                                                                                    <td> 
                                                                                                                        <div align="left"><%=langBT[4]%></div>
                                                                                                                    </td>
                                                                                                                    <td> 
                                                                                                                        <input name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankDeposit.getTransDate() == null) ? new Date() : bankDeposit.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                        <%= jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_TRANS_DATE) %> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="13%"><%=langBT[1]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td width="33%"> 
                                                                                                                        <input type="text" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()"  class="readonly" readOnly size="50"><%= jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_AMOUNT) %>
                                                                                                                    </td>
                                                                                                                    <td width="12%"><div align="left"><%=langBT[15]%>&nbsp;&nbsp;</div></td>
                                                                                                                    <td valign="top">
                                                                                                                        <%

            String order = DbCustomer.colNames[DbCustomer.COL_NAME];

            Vector vCustomer = DbCustomer.list(0, 0, "", order);
                                                                                                                        %>
                                                                                                                        <select name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_CUSTOMER_ID]%>">
                                                                                                                            <option value="0">-</option>
                                                                                                                            <%
            if (vCustomer != null && vCustomer.size() > 0) {

                for (int iC = 0; iC < vCustomer.size(); iC++) {

                    Customer objCustomer = (Customer) vCustomer.get(iC);

                                                                                                                            %>
                                                                                                                            <option <%if (bankDeposit.getCustomerId() == objCustomer.getOID()) {%>selected<%}%> value="<%=objCustomer.getOID()%>"><%=objCustomer.getName()%></option>
                                                                                                                            <%
                                                                                                                                }
                                                                                                                            } else {
                                                                                                                            %>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="13%" valign="top"><div align="left"><%=langBT[22]%>&nbsp;&nbsp;</div></td>
                                                                                                                    <td width="33%" valign="top"><input type="text" size="25" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_RECEIVE_FROM]%>" value="<%=bankDeposit.getReceiveFrom()%>"> </td>
                                                                                                                    <td width="12%" valign="top"></td>
                                                                                                                    <td valign="top"></td>
                                                                                                                </tr>     
                                                                                                                <tr> 
                                                                                                                    <td width="13%" valign="top"><%=langBT[2]%></td>
                                                                                                                    <td width="33%" valign="top"> 
                                                                                                                        <textarea name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_MEMO]%>" cols="47" rows="4"><%=bankDeposit.getMemo()%></textarea>
                                                                                                                    <%= jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_MEMO) %> </td>
                                                                                                                    <td width="12%" valign="top" colspan="2">
                                                                                                                        <table width="60%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td height="2"></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td bgcolor="#F3F3F3"> 
                                                                                                                                    <table width="95%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="42%">&nbsp;<b><%=langBT[16]%></b></td>
                                                                                                                                            <td width="58%">&nbsp;</td>
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
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + bankDeposit.getSegment15Id();
                            }
                            break;
                    }

                    Vector sgDetails = DbSegmentDetail.list(0, 0, wh, "");

                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="42%">&nbsp;<%=segment.getName()%></td>
                                                                                                                                            <td width="58%"> 
                                                                                                                                                <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                                                                    <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                                        String selected = "";
                                                                                                                                                        switch (i + 1) {
                                                                                                                                                            case 1:
                                                                                                                                                                if (bankDeposit.getSegment1Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 2:
                                                                                                                                                                if (bankDeposit.getSegment2Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 3:
                                                                                                                                                                if (bankDeposit.getSegment3Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 4:
                                                                                                                                                                if (bankDeposit.getSegment4Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 5:
                                                                                                                                                                if (bankDeposit.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 6:
                                                                                                                                                                if (bankDeposit.getSegment6Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 7:
                                                                                                                                                                if (bankDeposit.getSegment7Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 8:
                                                                                                                                                                if (bankDeposit.getSegment8Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 9:
                                                                                                                                                                if (bankDeposit.getSegment9Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 10:
                                                                                                                                                                if (bankDeposit.getSegment10Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 11:
                                                                                                                                                                if (bankDeposit.getSegment11Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 12:
                                                                                                                                                                if (bankDeposit.getSegment12Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 13:
                                                                                                                                                                if (bankDeposit.getSegment13Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 14:
                                                                                                                                                                if (bankDeposit.getSegment14Id() == sd.getOID()) {
                                                                                                                                                                    selected = "selected";
                                                                                                                                                                }
                                                                                                                                                                break;
                                                                                                                                                            case 15:
                                                                                                                                                                if (bankDeposit.getSegment5Id() == sd.getOID()) {
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
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td class="boxed1">                                                                                                 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td rowspan="2" class="tablehdr"  nowrap><%=langBT[23]%></td>
                                                                                                        <td rowspan="2" class="tablehdr"  nowrap><%=langBT[5]%></td>
                                                                                                        <%if(isUseJemaat){%>
                                                                                                        <td rowspan="2" class="tablehdr" nowrap>Jemaat</td>
                                                                                                        <%}%>
                                                                                                        <td colspan="2" class="tablehdr" ><%=langBT[6]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" ><%=langBT[9]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="10%"><%=langBT[10]%> <%=baseCurrency.getCurrencyCode()%></td>                                                                                                        
                                                                                                        <td rowspan="2" class="tablehdr" width="15%"><%=langBT[11]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr"><%=langBT[7]%></td>
                                                                                                        <td class="tablehdr"><%=langBT[8]%></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
                                                                                if (listBankDepositDetail != null && listBankDepositDetail.size() > 0) {

                                                                                    for (int i = 0; i < listBankDepositDetail.size(); i++) {
                                                                                        BankDepositDetail crd = (BankDepositDetail) listBankDepositDetail.get(i);
                                                                                        Coa c = new Coa();
                                                                                        try {
                                                                                            c = DbCoa.fetchExc(crd.getCoaId());
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        String cssString = "tablecell";
                                                                                        if (i % 2 != 0) {
                                                                                            cssString = "tablecell1";
                                                                                        }

                                                                                        if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <%	if (segments != null && segments.size() > 0) {
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
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_COA_ID]%>">
                                                                                                                    <%if (incomeCoas != null && incomeCoas.size() > 0) {
                                                                                                                    for (int x = 0; x < incomeCoas.size(); x++) {

                                                                                                                        AccLink accLink = (AccLink) incomeCoas.get(x);
                                                                                                                        Coa coax = new Coa();
                                                                                                                        try {
                                                                                                                            coax = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                        } catch (Exception e) {
                                                                                                                            System.out.println("[exception] " + e.toString());
                                                                                                                        }
                                                                                                                        String str = "";
                                                                                                                    %>
                                                                                                                    <option value="<%=coax.getOID()%>" <%if (crd.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                    <%=getAccountRecursif(coax.getLevel() * -1, coax, crd.getCoaId(), isPostableOnly)%> 
                                                                                                                    <%}
                                                                                                                }%>
                                                                                                                </select>
                                                                                                            <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_COA_ID) %> </div>
                                                                                                        </td>
                                                                                                        <%if(isUseJemaat){%>
                                                                                                        <td class="tablecell"><div align="center">
                                                                                                                <select name="<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment(this)">
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
                                                                                                        <%= jspBankDepositDetail.getErrorMsg(jspBankDepositDetail.JSP_DEPARTMENT_ID) %> </div></td>
                                                                                                        <%}%>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
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
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                                                                            <%= jspBankDepositDetail.getErrorMsg(jspBankDepositDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <input type="hidden" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignCreditAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMeCredit()">                                                                                                        
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>" size="4" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchangeXX()" onClick="this.select()">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_AMOUNT) %> </div>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="tablecell"> 
                                                                                                            <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_MEMO]%>" size="30" value="<%=crd.getMemo()%>">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td class="<%=cssString%>" nowrap> 
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
                                                                                                            <%=segment%> </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssString%>" nowrap> 
                                                                                                            <%if (bankDeposit.getPostedStatus() == 0) {%>
                                                                                                            <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%></a> 
                                                                                                            <%} else {%>
                                                                                                            <%=c.getCode()%>
                                                                                                            <%}%>
                                                                                                        &nbsp;-&nbsp; <%=c.getName()%></td>
                                                                                                        <%if(isUseJemaat){%>
                                                                                                        <td class="<%=cssString%>" nowrap><%
                                                                                                                Department d = new Department();
                                                                                                                try {
                                                                                                                    d = DbDepartment.fetchExc(crd.getDepartmentId());
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            %>
                                                                                                        <%=d.getCode() + " - " + d.getName()%></td>
                                                                                                        <%}%>
                                                                                                        <td class="<%=cssString%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
                                                                                                                Currency xc = new Currency();
                                                                                                                try {
                                                                                                                    xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                                                                } catch (Exception e) {
                                                                                                                    System.out.println("[exception] " + e.toString());
                                                                                                                }
                                                                                                                %>
                                                                                                            <%=xc.getCurrencyCode()%> </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssString%>"> 
                                                                                                            <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> </div>
                                                                                                        </td>                                                                                                        
                                                                                                        <td class="<%=cssString%>"> 
                                                                                                            <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>
                                                                                                        </td>
                                                                                                        <td class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                                                        </td>                                                                                                       
                                                                                                        <td class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%}
                                                                                }

                                                                                if (((iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SAVE || iErrCodeMain > 0 || iErrCode != 0)  && recIdx == -1) && bankDeposit.getPostedStatus() != 1  && !(isSave && iErrCode == 0 && iErrCodeMain == 0)) {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell"> 
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
                                                                                                                                                if (bankDepositDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 2:
                                                                                                                                                if (bankDepositDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 3:
                                                                                                                                                if (bankDepositDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 4:
                                                                                                                                                if (bankDepositDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 5:
                                                                                                                                                if (bankDepositDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 6:
                                                                                                                                                if (bankDepositDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 7:
                                                                                                                                                if (bankDepositDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 8:
                                                                                                                                                if (bankDepositDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 9:
                                                                                                                                                if (bankDepositDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 10:
                                                                                                                                                if (bankDepositDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 11:
                                                                                                                                                if (bankDepositDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 12:
                                                                                                                                                if (bankDepositDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 13:
                                                                                                                                                if (bankDepositDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 14:
                                                                                                                                                if (bankDepositDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 15:
                                                                                                                                                if (bankDepositDetail.getSegment15Id() == sd.getOID()) {
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
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_COA_ID]%>">
                                                                                                                    <%if (incomeCoas != null && incomeCoas.size() > 0) {
                                                                                                            for (int x = 0; x < incomeCoas.size(); x++) {

                                                                                                                AccLink accLink = (AccLink) incomeCoas.get(x);
                                                                                                                Coa coax = new Coa();
                                                                                                                try {
                                                                                                                    coax = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                                String str = "";

                                                                                                                    %>
                                                                                                                    <option value="<%=coax.getOID()%>" <%if (bankDepositDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                    <%=getAccountRecursif(coax.getLevel() * -1, coax, bankDepositDetail.getCoaId(), isPostableOnly)%> 
                                                                                                                    <%}
                                                                                                        }%>
                                                                                                                </select>
                                                                                                            <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_COA_ID) %> </div>
                                                                                                        </td>
                                                                                                        <%if(isUseJemaat){%>
                                                                                                        <td class="tablecell"><div align="center"> 
                                                                                                                <select name="<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment(this)">
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
                                                                                                                    <option value="<%=d.getOID()%>" <%if (bankDepositDetail.getDepartmentId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                    <%}
                                                                                                        }%>
                                                                                                                </select>
                                                                                                        <%= jspBankDepositDetail.getErrorMsg(jspBankDepositDetail.JSP_DEPARTMENT_ID) %> </div></td>
                                                                                                        <%}%>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                                                                    <%if (currencies != null && currencies.size() > 0) {
                                                                                                            for (int x = 0; x < currencies.size(); x++) {
                                                                                                                Currency c = (Currency) currencies.get(x);
                                                                                                                    %>
                                                                                                                    <option value="<%=c.getOID()%>" <%if (bankDepositDetail.getForeignCurrencyId() == c.getOID()) {%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                                                                                                    <%}
                                                                                                        }%>
                                                                                                                </select>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(bankDepositDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                                                                            <%= jspBankDepositDetail.getErrorMsg(jspBankDepositDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                                                                        </td>                                                                                                        
                                                                                                        <input type="hidden" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CREDIT_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(bankDepositDetail.getForeignCreditAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMeCredit()">                                                                                                                                                                                                                
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>" size="4" value="<%=JSPFormater.formatNumber(bankDepositDetail.getBookedRate(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchangeXX()" onClick="this.select()">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <input type="hidden" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_CREDIT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(bankDepositDetail.getCreditAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>                                                                                                        
                                                                                                        <td class="tablecell"> 
                                                                                                            <div align="left"> 
                                                                                                                <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_MEMO]%>" size="30" value="<%=bankDepositDetail.getMemo()%>">
                                                                                                            </div>
                                                                                                        </td>
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
                                                                                                    <tr> 
                                                                                                        <td width="78%"> 
                                                                                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <%if ((iErrCodeMain == 0 || iErrCode != 0)) {%>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <%if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeMain == 0) || (isSave && iErrCode == 0 && iErrCodeMain == 0)) {
        if (privAdd) {%>                                                                                                
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
                                                                                                                        <a href="javascript:cmdAdd('<%=bankDeposit.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> 
                                                                                                                        <%}%>
                                                                                                                        <%}
} else {

    if ((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST || iJSPCommand == JSPCommand.REFRESH) && (iErrCode != 0 || iErrCodeMain != 0)) {
        iJSPCommand = JSPCommand.SAVE;
    }

    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("90%");
    String scomDel = "javascript:cmdAsk('" + oidBankDepositDetail + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidBankDepositDetail + "')";
    String scancel = "javascript:cmdEdit('" + oidBankDepositDetail + "')";
    if (listBankDepositDetail != null && listBankDepositDetail.size() > 0) {
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

    if (iErrCode == 0 && iErrCodeMain != 0) {
        ctrLine.setSaveJSPCommand("javascript:cmdFixing()");
    }
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
                                                                                                                        <%if (bankDeposit.getPostedStatus() != 1) {%>
                                                                                                                        <%=ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                                                        <%} else {%>
                                                                                                                        
                                                                                                                        <%}
    }%>
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
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table border="0" cellpadding="2" cellspacing="0" class="warning" width="293" align="left">
                                                                                                                            <tr> 
                                                                                                                                <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                                                                                <td width="253" nowrap><%=msgStringMain%></td>
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
                                                                                                                        <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                                                                    </td>
                                                                                                                    <td width="64%"> 
                                                                                                                        <div align="right"><b> 
                                                                                                                                <% balance = bankDeposit.getAmount() - totalDetail;%>
                                                                                                                                <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                                                                        <%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="1" valign="middle" colspan="2" width="100%"> 
                                                                                                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
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
                                                                                                        <td colspan=2>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                if (bankDeposit.getAmount() != 0 && ((iErrCode == 0 && iErrCodeMain == 0 && balance == 0) || listBankDepositDetail.size() > 0) && bankDeposit.getPostedStatus() != 1) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="2"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="11%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                                                                                    <%if (bankDeposit.getOID() != 0) {%>
                                                                                                                    <td width><a href="javascript:cmdAsking('<%=bankDeposit.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('dl','','../images/deletedoc2.gif',1)"><img src="../images/deletedoc.gif" name="dl" height="22" border="0"  alt="Delete Doc"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <td width="40%">&nbsp;</td>
                                                                                                                    <td width="26%" nowrap> 
                                                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="info" width="219" align="right">
                                                                                                                            <tr> 
                                                                                                                                <td width="16"><img src="../images/inform.gif" width="20" height="20"></td>
                                                                                                                                <td width="183" nowrap><%=langBT[12]%></td>
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
                                                                                            <td>&nbsp; </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            } catch (Exception exc) {
            }%>
                                                                            
                                                                            
                                                                            <%if (bankDeposit.getOID() != 0 && bankDeposit.getPostedStatus() == 1) {%>
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
                                                                            <%if (bankDeposit.getOID() != 0) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="1" valign="middle" colspan="3"> 
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="4%"> 
                                                                                                <%
    out.print("<a href=\"../freport/rpt_bankdeposit_main.jsp?bankdeposit_id=" + bankDeposit.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt2','','../images/print2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"prt2\" height=\"22\" border=\"0\"></a></div>");
                                                                                                %>                                                                                            
                                                                                            </td>
                                                                                            <td width="3%" nowrap>&nbsp;&nbsp;&nbsp;</td>
                                                                                            <td width="4%"> 
                                                                                                <%
    if (isAkunting) {
                                                                                                %>
                                                                                                <%
        out.print("<a href=\"../freport/rpt_bankdeposit.jsp?bankdeposit_id=" + bankDeposit.getOID() + "\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");
    }
                                                                                                %>
                                                                                            </td>
                                                                                            <td width="3%" nowrap>&nbsp;&nbsp;&nbsp;</td>
                                                                                            <td width="10%" nowrap><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a></td>
                                                                                            <td width="3%" nowrap>&nbsp;&nbsp;&nbsp;</td>
                                                                                            <td width="48%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                                                            <td width="35%"> 
                                                                                                <%if (isSave == true && iErrCodeMain == 0 && iErrCode == 0) {%>
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                        <td width="220"><%=langBT[13]%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>                                                                            
                                                                            <%if (bankDeposit.getOID() != 0) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <%
    Vector temp = DbApprovalDoc.getDocApproval(oidBankDeposit);
                                                                                    %>
                                                                                    <table width="800" border="0" cellspacing="1" cellpadding="1">
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
                                                                                            <td width="11%"><%=apd.getSequence()%></td>
                                                                                            <td width="13%"><%=employee.getPosition()%></td>
                                                                                            <td width="20%"><%=nama%></td>
                                                                                            <td width="13%"><%=tanggal%></td>
                                                                                            <td width="11%"><%=status%></td>
                                                                                            <td width="20%"> 
                                                                                                <%if (bankDeposit.getPostedStatus() == 0) {
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
                                                                                                <%if (bankDeposit.getPostedStatus() == 0) {%>
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td> 
                                                                                                            <%if (apd.getStatus() == DbApprovalDoc.STATUS_DRAFT) {
        if (userEmp.getPosition().equalsIgnoreCase(employee.getPosition())) {
                                                                                                            %>
                                                                                                            <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr> 
                                                                                                                        <td> 
                                                                                                                            <div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save1','','../images/success-2.gif',1)" alt="Klik : Untuk Menyetujui Dokumen"><img src="../images/success.gif" name="save1" height="20" border="0"></a></div>
                                                                                                                        </td>
                                                                                                                        <td><div align="center"><a href="javascript:cmdApproval('<%=apd.getOID()%>','2')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no3','','../images/no1.gif',1)" alt="Klik : Untuk tidak menyetujui"><img src="../images/no.gif" name="no3" height="20" border="0"></a></div></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                            <% }
} else {
    if (user.getEmployeeId() == apd.getEmployeeId()) {
        if (apd.getStatus() == DbApprovalDoc.STATUS_APPROVED) {
                                                                                                            %>
                                                                                                            <div align="center">
                                                                                                                <a href="javascript:cmdApproval('<%=apd.getOID()%>','0')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('no','','../images/no1.gif',1)" alt="Klik : Untuk Membatalkan Persetujuan"><img src="../images/no.gif" name="no" height="20" border="0"></a>                                                                                                                
                                                                                                            </div>
                                                                                                            <%	} else {%>
                                                                                                            <div align="center">
                                                                                                                <a href="javascript:cmdApproval('<%=apd.getOID()%>','1')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2','','../images/success-2.gif',1)" alt="Klik : Untuk Melakukan Persetujuan"><img src="../images/success.gif" name="save2" height="20" border="0"></a>                                                                                                                
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
                                                                                        <tr> 
                                                                                            <td width="11%">&nbsp;</td><td width="13%">&nbsp;</td><td width="20%">&nbsp;</td><td width="13%">&nbsp;</td><td width="11%">&nbsp;</td><td width="20%">&nbsp;</td><td width="12%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr> 
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"><td height="8" valign="middle" width="17%">&nbsp;</td><td height="8" colspan="2" width="83%">&nbsp; </td></tr>
                                                                <tr align="left" valign="top" ><td colspan="3" class="command">&nbsp; </td></tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>.value="<%=JSPFormater.formatNumber(totalDetail, "#,###.##")%>";
                                                                <%if (iErrCode != 0 || iJSPCommand == JSPCommand.ADD) {%>
                                                                cmdUpdateExchange();
                                                                <%}%>
                                                            </script>
                                                        </form>
                                                        <!-- #EndEditable -->
                                                    </td>
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