
<%-- 
    Document   : merchant
    Created on : Nov 19, 2012, 1:52:21 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspMerchant frmObject, Merchant objEntity, Vector objectClass, long merchantId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");

        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader("Lokasi", "10%", "2", "0");
        ctrlist.addHeader("Merchant ID", "10%", "2", "0");
        ctrlist.addHeader("Merchant", "10%", "2", "0");

        ctrlist.addHeader("Bank/Voucher", "17%", "0", "2");
        ctrlist.addHeader("Name", "7%", "0", "0");
        ctrlist.addHeader("Coa", "10%", "0", "0");

        ctrlist.addHeader("Biaya", "14%", "0", "2");
        ctrlist.addHeader("(%)", "4%", "0", "0");
        ctrlist.addHeader("Coa", "10%", "0", "0");

        ctrlist.addHeader("Diskon", "14%", "0", "2");
        ctrlist.addHeader("(%)", "4%", "0", "0");
        ctrlist.addHeader("Coa", "14%", "0", "0");
        ctrlist.addHeader("Pendapatan", "10%", "2", "0");
        ctrlist.addHeader("Tipe Pembayaran", "10%", "2", "0");
        ctrlist.addHeader("Pembayaran Biaya", "5%", "2", "0");
        ctrlist.addHeader("Posting Expense", "5%", "2", "0");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        Vector vLocation = DbLocation.list(0, 0, "", null);
        Vector vBank = DbBank.list(0, 0, "", null);
        Vector coas = DbCoa.list(0, 0, "", "code");

        Vector posting_key = new Vector();
        Vector posting_value = new Vector();

        posting_value.add("" + DbMerchant.POSTING_EXPENSE);
        posting_value.add("" + DbMerchant.NON_POSTING_EXPENSE);

        posting_key.add("" + DbMerchant.strPosting[DbMerchant.POSTING_EXPENSE]);
        posting_key.add("" + DbMerchant.strPosting[DbMerchant.NON_POSTING_EXPENSE]);

        Vector type_value = new Vector(1, 1);
        Vector type_key = new Vector(1, 1);

        type_key.add("" + DbMerchant.TYPE_CREDIT_CARD);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_CREDIT_CARD]);

        type_key.add("" + DbMerchant.TYPE_DEBIT_CARD);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_DEBIT_CARD]);

        type_key.add("" + DbMerchant.TYPE_FINANCE);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_FINANCE]);

        type_key.add("" + DbMerchant.TYPE_VOUCHER);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_VOUCHER]);

        type_key.add("" + DbMerchant.TYPE_FINANCE_FIF);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_FINANCE_FIF]);

        type_key.add("" + DbMerchant.TYPE_VOUCHER_SATKER);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_VOUCHER_SATKER]);

        type_key.add("" + DbMerchant.TYPE_VOUCHER_PU);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_VOUCHER_PU]);

        type_key.add("" + DbMerchant.TYPE_VOUCHER_DPRD);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_VOUCHER_DPRD]);

        type_key.add("" + DbMerchant.TYPE_VOUCHER_ASTRA);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_VOUCHER_ASTRA]);

        type_key.add("" + DbMerchant.TYPE_VOUCHER_KUPON);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_VOUCHER_KUPON]);
        
        type_key.add("" + DbMerchant.TYPE_CASH_BACK);
        type_value.add("" + DbMerchant.strType[DbMerchant.TYPE_CASH_BACK]);

        for (int i = 0; i < objectClass.size(); i++) {
            Merchant merchant = (Merchant) objectClass.get(i);
            Vector coaid_value = new Vector(1, 1);
            Vector coaid_key = new Vector(1, 1);
            String sel_coaid = "" + merchant.getCoaId();
            String sel_coaExpid = "" + merchant.getCoaExpenseId();
            String sel_coaDisId = "" + merchant.getCoaDiskonId();

            coaid_value.add("- ");
            coaid_key.add("0");

            if (coas != null && coas.size() > 0) {
                for (int ix = 0; ix < coas.size(); ix++) {
                    Coa coa = (Coa) coas.get(ix);

                    String str = "";

                    switch (coa.getLevel()) {
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

                    coaid_key.add("" + coa.getOID());
                    coaid_value.add(str + coa.getCode() + " - " + coa.getName());
                }
            }

            rowx = new Vector();
            if (merchantId == merchant.getOID()) {
                index = i;
            }

            Vector pay_value = new Vector(1, 1);
            Vector pay_key = new Vector(1, 1);

            pay_key.add("" + DbMerchant.PAYMENT_BY_COMPANY);
            pay_value.add("Company");

            pay_key.add("" + DbMerchant.PAYMENT_BY_CUSTOMER);
            pay_value.add("Customer");

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {

                Vector location_value = new Vector(1, 1);
                Vector location_key = new Vector(1, 1);

                Vector bank_value = new Vector(1, 1);
                Vector bank_key = new Vector(1, 1);

                bank_key.add("" + 0);
                bank_value.add("select bank");

                String selBankId = "" + merchant.getBankId();
                String selLocationId = "" + merchant.getLocationId();
                String selTypePayment = "" + merchant.getTypePayment();
                String selPaymentBy = "" + merchant.getPaymentBy();
                String selPendapatan = "" + merchant.getPendapatanMerchant();
                String selPosting = "" + merchant.getPostingExpense();

                if (vLocation != null && vLocation.size() > 0) {
                    for (int ix = 0; ix < vLocation.size(); ix++) {
                        Location location = (Location) vLocation.get(ix);
                        location_key.add("" + location.getOID());
                        location_value.add("" + location.getName());
                    }
                }

                if (vBank != null && vBank.size() > 0) {
                    for (int ix = 0; ix < vBank.size(); ix++) {
                        Bank bank = (Bank) vBank.get(ix);
                        bank_key.add("" + bank.getOID());
                        bank_value.add("" + bank.getName());
                    }
                }

                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_LOCATION_ID], null, selLocationId, location_key, location_value, "", "formElemen"));
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_CODE_MERCHANT] + "\" value=\"" + merchant.getCodeMerchant() + "\" class=\"formElemen\" size=\"10\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_DESCRIPTION] + "\" value=\"" + merchant.getDescription() + "\" class=\"formElemen\" size=\"20\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_BANK_ID], null, selBankId, bank_key, bank_value, "", "formElemen"));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_COA_ID], null, sel_coaid, coaid_key, coaid_value, "", "formElemen"));
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_PERSEN_EXPENSE] + "\" value=\"" + merchant.getPersenExpense() + "\" class=\"formElemen\" size=\"5\" style=\"text-align:right\" onChange=\"javascript:cmdUpdateExchange()\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_COA_EXPENSE_ID], null, sel_coaExpid, coaid_key, coaid_value, "", "formElemen"));
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_PERSEN_DISKON] + "\" value=\"" + merchant.getPersenDiskon() + "\" class=\"formElemen\" size=\"5\" style=\"text-align:right\" onChange=\"javascript:cmdUpdateDiskon()\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_COA_DISKON_ID], null, sel_coaDisId, coaid_key, coaid_value, "", "formElemen"));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_PENDAPATAN_MERCHANT], null, selPendapatan, coaid_key, coaid_value, "", "formElemen"));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_TYPE_PAYMENT], null, selTypePayment, type_key, type_value, "", "formElemen"));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_PAYMENT_BY], null, selPaymentBy, pay_key, pay_value, "", "formElemen"));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_POSTING_EXPENSE], null, selPosting, posting_value, posting_key, "", "formElemen"));

            } else {

                Location location = new Location();
                Bank bank = new Bank();

                try {
                    location = DbLocation.fetchExc(merchant.getLocationId());
                } catch (Exception e) {
                }

                try {
                    bank = DbBank.fetchExc(merchant.getBankId());
                } catch (Exception e) {
                }

                String typePayment = "";
                if (merchant.getTypePayment() == DbMerchant.TYPE_CREDIT_CARD) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_CREDIT_CARD];
                } else if (merchant.getTypePayment() == DbMerchant.TYPE_DEBIT_CARD) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_DEBIT_CARD];
                } else if (merchant.getTypePayment() == DbMerchant.TYPE_FINANCE) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_FINANCE];
                } else if (merchant.getTypePayment() == DbMerchant.TYPE_VOUCHER) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_VOUCHER];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_FINANCE_FIF) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_FINANCE_FIF];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_VOUCHER_SATKER) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_VOUCHER_SATKER];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_VOUCHER_PU) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_VOUCHER_PU];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_VOUCHER_DPRD) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_VOUCHER_DPRD];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_VOUCHER_ASTRA) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_VOUCHER_ASTRA];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_VOUCHER_KUPON) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_VOUCHER_KUPON];
                }else if (merchant.getTypePayment() == DbMerchant.TYPE_CASH_BACK) {
                    typePayment = DbMerchant.strType[DbMerchant.TYPE_CASH_BACK];
                }

                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(merchant.getOID()) + "')\">" + location.getName() + "</a>");
                rowx.add("" + merchant.getCodeMerchant());
                rowx.add("" + merchant.getDescription());
                rowx.add("" + bank.getName());
                Coa objCoa = new Coa();
                try {
                    objCoa = DbCoa.fetchExc(merchant.getCoaId());
                } catch (Exception e) {
                }
                if (objCoa.getOID() == 0) {
                    rowx.add("-");
                } else {
                    rowx.add("" + objCoa.getCode() + "-" + objCoa.getName());
                }

                rowx.add("<div align=\"center\">" + merchant.getPersenExpense() + "</div>");
                Coa objCoax = new Coa();
                try {
                    objCoax = DbCoa.fetchExc(merchant.getCoaExpenseId());
                } catch (Exception e) {
                }

                if (objCoax.getOID() == 0) {
                    rowx.add("-");
                } else {
                    rowx.add("" + objCoax.getCode() + "-" + objCoax.getName());
                }

                rowx.add("<div align=\"center\">" + merchant.getPersenDiskon() + "</div>");

                Coa objCoay = new Coa();
                try {
                    objCoay = DbCoa.fetchExc(merchant.getCoaDiskonId());
                } catch (Exception e) {
                }

                if (objCoay.getOID() == 0) {
                    rowx.add("-");
                } else {
                    rowx.add("" + objCoay.getCode() + "-" + objCoay.getName());
                }

                Coa objCoaP = new Coa();
                try {
                    objCoaP = DbCoa.fetchExc(merchant.getPendapatanMerchant());
                } catch (Exception e) {
                }

                if (objCoaP.getOID() == 0) {
                    rowx.add("-");
                } else {
                    rowx.add("" + objCoaP.getCode() + "-" + objCoaP.getName());
                }

                String paymentBy = "";
                if (merchant.getPaymentBy() == DbMerchant.PAYMENT_BY_COMPANY) {
                    paymentBy = "Company";
                } else if (merchant.getPaymentBy() == DbMerchant.PAYMENT_BY_CUSTOMER) {
                    paymentBy = "Customer";
                }

                rowx.add("" + typePayment);
                rowx.add("" + paymentBy);
                rowx.add(DbMerchant.strPosting[merchant.getPostingExpense()]);
            }
            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {

            Vector location_value = new Vector(1, 1);
            Vector location_key = new Vector(1, 1);

            Vector bank_value = new Vector(1, 1);
            Vector bank_key = new Vector(1, 1);

            String selBankId = "" + objEntity.getBankId();
            String selLocationId = "" + objEntity.getLocationId();
            String selTypePayment = "" + objEntity.getTypePayment();
            String selPaymentBy = "" + objEntity.getPaymentBy();

            Vector coaid_value = new Vector(1, 1);
            Vector coaid_key = new Vector(1, 1);
            String sel_coaid = "" + objEntity.getCoaId();
            String sel_coaExpid = "" + objEntity.getCoaExpenseId();
            String sel_coaDiskid = "" + objEntity.getCoaDiskonId();
            String sel_coaPend = "" + objEntity.getPendapatanMerchant();
            String sel_posting = "" + objEntity.getPostingExpense();

            coaid_value.add("- ");
            coaid_key.add("0");

            Vector pay_value = new Vector(1, 1);
            Vector pay_key = new Vector(1, 1);

            pay_key.add("" + DbMerchant.PAYMENT_BY_COMPANY);
            pay_value.add("Company");

            pay_key.add("" + DbMerchant.PAYMENT_BY_CUSTOMER);
            pay_value.add("Customer");


            if (coas != null && coas.size() > 0) {
                for (int ix = 0; ix < coas.size(); ix++) {
                    Coa coa = (Coa) coas.get(ix);

                    String str = "";

                    switch (coa.getLevel()) {
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

                    coaid_key.add("" + coa.getOID());
                    coaid_value.add(str + coa.getCode() + " - " + coa.getName());
                }
            }


            if (vLocation != null && vLocation.size() > 0) {
                for (int ix = 0; ix < vLocation.size(); ix++) {
                    Location location = (Location) vLocation.get(ix);
                    location_key.add("" + location.getOID());
                    location_value.add("" + location.getName());
                }
            }

            bank_key.add("" + 0);
            bank_value.add("select bank");

            if (vBank != null && vBank.size() > 0) {
                for (int ix = 0; ix < vBank.size(); ix++) {
                    Bank bank = (Bank) vBank.get(ix);
                    bank_key.add("" + bank.getOID());
                    bank_value.add("" + bank.getName());
                }
            }

            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_LOCATION_ID], null, selLocationId, location_key, location_value, "", "formElemen"));
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_CODE_MERCHANT] + "\" value=\"" + objEntity.getCodeMerchant() + "\" class=\"formElemen\" size=\"20\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_DESCRIPTION] + "\" value=\"" + objEntity.getDescription() + "\" class=\"formElemen\" size=\"20\">");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_BANK_ID], null, selBankId, bank_key, bank_value, "", "formElemen"));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_COA_ID], null, sel_coaid, coaid_key, coaid_value, "", "formElemen"));
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_PERSEN_EXPENSE] + "\" value=\"" + objEntity.getPersenExpense() + "\" class=\"formElemen\" size=\"5\" style=\"text-align:right\" onChange=\"javascript:cmdUpdateExchange()\" >");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_COA_EXPENSE_ID], null, sel_coaExpid, coaid_key, coaid_value, "", "formElemen"));
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspMerchant.JSP_PERSEN_DISKON] + "\" value=\"" + objEntity.getPersenDiskon() + "\" class=\"formElemen\" size=\"5\" style=\"text-align:right\" onChange=\"javascript:cmdUpdateDiskon()\" >");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_COA_DISKON_ID], null, sel_coaDiskid, coaid_key, coaid_value, "", "formElemen"));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_PENDAPATAN_MERCHANT], null, sel_coaPend, coaid_key, coaid_value, "", "formElemen"));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_TYPE_PAYMENT], null, selTypePayment, type_key, type_value, "", "formElemen"));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_PAYMENT_BY], null, selPaymentBy, pay_key, pay_value, "", "formElemen"));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspMerchant.JSP_POSTING_EXPENSE], null, sel_posting, posting_value, posting_key, "", "formElemen"));

        }

        lstData.add(rowx);
        return ctrlist.drawList(index);
    }

%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidMerchant = JSPRequestValue.requestLong(request, "hidden_merchant_id");

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = DbMerchant.colNames[DbMerchant.COL_LOCATION_ID];

            CmdMerchant ctrlMerchant = new CmdMerchant(request);
            JSPLine ctrLine = new JSPLine();
            Vector listMerchant = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlMerchant.action(iJSPCommand, oidMerchant);
            /* end switch*/
            JspMerchant jspMerchant = ctrlMerchant.getForm();

            /*count list All Merchant*/
            int vectSize = DbMerchant.getCount(whereClause);

            /*switch list Merchant*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlMerchant.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Merchant merchant = ctrlMerchant.getMerchant();
            msgString = ctrlMerchant.getMessage();

            /* get record to display */
            listMerchant = DbMerchant.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listMerchant.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listMerchant = DbMerchant.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/indexsp.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
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
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>"; var usrDigitGroup = "<%=sUserDigitGroup%>"; var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function cmdUpdateExchange(){                    
                var famount = document.frmmerchant.<%=JspMerchant.colNames[JspMerchant.JSP_PERSEN_EXPENSE]%>.value;                   
                famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);  
                
                if(!isNaN(famount)){
                    document.frmmerchant.<%=JspMerchant.colNames[JspMerchant.JSP_PERSEN_EXPENSE]%>.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                    
                }            
            }
            
            function cmdUpdateDiskon(){                    
                var famount = document.frmmerchant.<%=JspMerchant.colNames[JspMerchant.JSP_PERSEN_DISKON]%>.value;                   
                famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);  
                
                if(!isNaN(famount)){
                    document.frmmerchant.<%=JspMerchant.colNames[JspMerchant.JSP_PERSEN_DISKON]%>.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                    
                }            
            }
            
            
            function cmdAdd(){
                document.frmmerchant.hidden_merchant_id.value="0";
                document.frmmerchant.command.value="<%=JSPCommand.ADD%>";
                document.frmmerchant.prev_command.value="<%=prevJSPCommand%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdAsk(oidMerchant){
                document.frmmerchant.hidden_merchant_id.value=oidMerchant;
                document.frmmerchant.command.value="<%=JSPCommand.ASK%>";
                document.frmmerchant.prev_command.value="<%=prevJSPCommand%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdConfirmDelete(oidMerchant){
                document.frmmerchant.hidden_merchant_id.value=oidMerchant;
                document.frmmerchant.command.value="<%=JSPCommand.DELETE%>";
                document.frmmerchant.prev_command.value="<%=prevJSPCommand%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdSave(){
                document.frmmerchant.command.value="<%=JSPCommand.SAVE%>";
                document.frmmerchant.prev_command.value="<%=prevJSPCommand%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdEdit(oidMerchant){
                document.frmmerchant.hidden_merchant_id.value=oidMerchant;
                document.frmmerchant.command.value="<%=JSPCommand.EDIT%>";
                document.frmmerchant.prev_command.value="<%=prevJSPCommand%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdCancel(oidMerchant){
                document.frmmerchant.hidden_merchant_id.value=oidMerchant;
                document.frmmerchant.command.value="<%=JSPCommand.EDIT%>";
                document.frmmerchant.prev_command.value="<%=prevJSPCommand%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdBack(){
                document.frmmerchant.command.value="<%=JSPCommand.BACK%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdListFirst(){
                document.frmmerchant.command.value="<%=JSPCommand.FIRST%>";
                document.frmmerchant.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdListPrev(){
                document.frmmerchant.command.value="<%=JSPCommand.PREV%>";
                document.frmmerchant.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdListNext(){
                document.frmmerchant.command.value="<%=JSPCommand.NEXT%>";
                document.frmmerchant.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            function cmdListLast(){
                document.frmmerchant.command.value="<%=JSPCommand.LAST%>";
                document.frmmerchant.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmerchant.action="merchant.jsp";
                document.frmmerchant.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidMerchant){
                document.frmimage.hidden_merchant_id.value=oidMerchant;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="merchant.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> 
                                <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Merchant</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmerchant" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_merchant_id" value="<%=oidMerchant%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                </td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                <%= drawList(iJSPCommand, jspMerchant, merchant, listMerchant, oidMerchant)%> </td>
                                                                            </tr>
                                                                            <%
            } catch (Exception exc) {
            }%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="3" class="command"> 
                                                                                    <span class="command"> 
                                                                                        <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                        %>
                                                                                        <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                        %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && (iErrCode == 0)) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("60%");
    String scomDel = "javascript:cmdAsk('" + oidMerchant + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidMerchant + "')";
    String scancel = "javascript:cmdEdit('" + oidMerchant + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

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
                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <!-- #EndEditable -->
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
                                <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
