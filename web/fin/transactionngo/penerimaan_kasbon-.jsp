
<%-- 
    Document   : penerimaan_kasbon
    Created on : Jul 27, 2011, 4:56:28 PM
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
<%@ page import = "com.project.printman.*" %>
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../printing/printingvariables.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CRA, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspCashReceiveDetail frmObject, CashReceiveDetail objEntity, Vector objectClass, long cashReceiveDetailId, int iErrCode2) {

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
        String whereCls = "";
        String orderCls = "";

        /* selected CoaId*/
        Vector coaid_value = new Vector(1, 1);
        Vector coaid_key = new Vector(1, 1);
        coaid_value.add("");
        coaid_key.add("---select---");

        /* selected ForeignCurrencyId*/
        Vector foreigncurrencyid_value = new Vector(1, 1);
        Vector foreigncurrencyid_key = new Vector(1, 1);
        foreigncurrencyid_value.add("");
        foreigncurrencyid_key.add("---select---");

        for (int i = 0; i < objectClass.size(); i++) {

            CashReceiveDetail cashReceiveDetail = (CashReceiveDetail) objectClass.get(i);
            rowx = new Vector();

            if (cashReceiveDetailId == cashReceiveDetail.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || (iErrCode2 != 0 && cashReceiveDetailId != 0))) {

                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_CASH_RECEIVE_ID] + "\" value=\"" + cashReceiveDetail.getCashReceiveId() + "\" class=\"formElemen\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_COA_ID], null, "" + cashReceiveDetail.getCoaId(), coaid_value, coaid_key, "formElemen", ""));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID], null, "" + cashReceiveDetail.getForeignCurrencyId(), foreigncurrencyid_value, foreigncurrencyid_key, "formElemen", ""));
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT] + "\" value=\"" + cashReceiveDetail.getForeignAmount() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] + "\" value=\"" + cashReceiveDetail.getBookedRate() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_AMOUNT] + "\" value=\"" + cashReceiveDetail.getAmount() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_MEMO] + "\" value=\"" + cashReceiveDetail.getMemo() + "\" class=\"formElemen\">");

            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(cashReceiveDetail.getOID()) + "')\">" + String.valueOf(cashReceiveDetail.getCashReceiveId()) + "</a>");
                rowx.add(String.valueOf(cashReceiveDetail.getCoaId()));
                rowx.add(String.valueOf(cashReceiveDetail.getForeignCurrencyId()));
                rowx.add(String.valueOf(cashReceiveDetail.getForeignAmount()));
                rowx.add(String.valueOf(cashReceiveDetail.getBookedRate()));
                rowx.add(String.valueOf(cashReceiveDetail.getAmount()));
                rowx.add(cashReceiveDetail.getMemo());
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && cashReceiveDetailId == 0)) {
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_CASH_RECEIVE_ID] + "\" value=\"" + objEntity.getCashReceiveId() + "\" class=\"formElemen\">");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_COA_ID], null, "" + objEntity.getCoaId(), coaid_value, coaid_key, "formElemen", ""));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID], null, "" + objEntity.getForeignCurrencyId(), foreigncurrencyid_value, foreigncurrencyid_key, "formElemen", ""));
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT] + "\" value=\"" + objEntity.getForeignAmount() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] + "\" value=\"" + objEntity.getBookedRate() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspCashReceiveDetail.JSP_MEMO] + "\" value=\"" + objEntity.getMemo() + "\" class=\"formElemen\">");
        }

        lstData.add(rowx);
        return ctrlist.draw();
    }

    public Vector addNewDetail(Vector listCashReceiveDetail, CashReceiveDetail cashReceiveDetail) {
        boolean found = false;
        if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {
            for (int i = 0; i < listCashReceiveDetail.size(); i++) {
                CashReceiveDetail cr = (CashReceiveDetail) listCashReceiveDetail.get(i);
                if (cr.getCoaId() == cashReceiveDetail.getCoaId() && cr.getForeignCurrencyId() == cashReceiveDetail.getForeignCurrencyId()) {
                    //jika coa sama dan currency sama lakukan penggabungan
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
%>
<%

            String[] langCT = {"Receive to Account", "Receive From", "Amount", "Memo", "Journal Number", "Transaction Date", //0-5
                "Account - Description", "Currency", "Code", "Amount", "Booked Rate", "Amount in", "Description", //6-12
                "Advance Received document is ready to be saved", "Cash Receive document has been saved successfully", "Search Journal Number", "Customer", "Searching",//13-17
                "Ref. Number", "Period", "Segment"}; //18-20

            String[] langNav = {"Cash", "Advance Receive", "Date", "Search Advance first", "Please click search button to show advance datas", "SEARCHING", "ADVANCE RECEIVE EDITOR FORM"};

            if (lang == LANG_ID) {

                String[] langID = {"Perkiraan", "Diterima Dari", "Jumlah", "Catatan", "Nomor Jurnal", "Tanggal Transaksi", //0-5
                    "Perkiraan", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Jumlah", "Keterangan",//6-12admin    admin
                    "Dokumen Penerimaan Kasbon siap untuk disimpan", "Dokumen Penerimaan Tunai sudah disimpan dengan sukses", "Cari Nomor Jurnal", "Sarana", "Pencarian",//13-17
                    "Ref. No", "Periode", "Segmen" //18-20
                };

                langCT = langID;

                String[] navID = {"Tunai", "Pengembalian Sisa Kasbon", "Tanggal", "Cari kasbon terlebih dahulu", "Click tombol search untuk menampilkan data kasbon", "PENCARIAN", "EDITOR PENGEMBALIAN SISA KASBON"};
                langNav = navID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCashReceive = JSPRequestValue.requestLong(request, "hidden_cash_receive_id");
            long oidCashReceiveDetail = JSPRequestValue.requestLong(request, "hidden_cash_receive_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");

// variable ini untuk printing // di setiap ada printing page harus ada ini // dan diset valuenya sesuai oid yg di get
            docChoice = 5;
            generalOID = oidCashReceive;

            boolean first = false;

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("RECEIVE_DETAIL");
                oidCashReceive = 0;
                recIdx = -1;
                first = true;
            }

            /* variable declaration */
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            boolean isLoad = false;

            long referensi_id = 0;
            String referensi_no = "";

            if (iJSPCommand == JSPCommand.REFRESH) {
                session.removeValue("RECEIVE_DETAIL");
                oidCashReceive = JSPRequestValue.requestLong(request, "cash_id");
                recIdx = -1;
                isLoad = true;
            }

            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("RECEIVE_DETAIL");
                referensi_id = JSPRequestValue.requestLong(request, "referensi_id");
                referensi_no = JSPRequestValue.requestString(request, "referensi_number");

                try {
                    oidCashReceive = DbCashReceive.getCashReceiveOid(referensi_id);
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }

                recIdx = -1;
                isLoad = true;
            }

            CmdCashReceive ctrlCashReceive = new CmdCashReceive(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCashReceive = new Vector(1, 1);

            /*switch statement */
            int iErrCodeRec = ctrlCashReceive.action(iJSPCommand, oidCashReceive);

            /* end switch*/
            JspCashReceive jspCashReceive = ctrlCashReceive.getForm();

            /*count list All CashReceive*/
            int vectSize = DbCashReceive.getCount(whereClause);

            CashReceive cashReceive = ctrlCashReceive.getCashReceive();
            String msgStringRec = ctrlCashReceive.getMessage();

            if (oidCashReceive == 0) {
                oidCashReceive = cashReceive.getOID();
            }

            if (oidCashReceive != 0) {
                cashReceive = DbCashReceive.fetchExc(oidCashReceive);
            }

            long tmp_pettycashPaymentId = 0;
            String nameEmployee = "";

            if (iJSPCommand == JSPCommand.LOAD) {
                referensi_id = JSPRequestValue.requestLong(request, "referensi_id");
                referensi_no = JSPRequestValue.requestString(request, "referensi_number");
                PettycashPayment pettycashPayment = new PettycashPayment();
                try {
                    pettycashPayment = DbPettycashPayment.fetchExc(referensi_id);
                    tmp_pettycashPaymentId = pettycashPayment.getOID();
                    try {
                        Employee emp = DbEmployee.fetchExc(pettycashPayment.getEmployeeId());
                        nameEmployee = emp.getName();
                    } catch (Exception e) {
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
                cashReceive.setReferensiId(pettycashPayment.getOID());
                cashReceive.setReceiveFromId(pettycashPayment.getEmployeeId());

            }

            if ((cashReceive.getOID() != 0 || cashReceive.getReferensiId() != 0) && iJSPCommand != JSPCommand.LOAD) {
                nameEmployee = cashReceive.getReceiveFromName();
            }
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCashReceive.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listCashReceive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCashReceive.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCashReceive = DbCashReceive.list(start, recordToGet, whereClause, orderClause);
            }
%>
<%
            boolean load = false;

            if (iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }

            CmdCashReceiveDetail ctrlCashReceiveDetail = new CmdCashReceiveDetail(request);

            Vector listCashReceiveDetail = new Vector(1, 1);
            Vector listPettycashPayment = new Vector(1, 1);

            ExchangeRate eRate = DbExchangeRate.getStandardRate();

            int sumDetail = 0;

            if (load) {
                if (cashReceive.getOID() != 0) {
                    String whereCRD = DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + " = " + cashReceive.getOID();
                    listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, whereCRD, null);
                } else {
                    String whereDetail = DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "=" + tmp_pettycashPaymentId;
                    listPettycashPayment = DbPettycashPaymentDetail.list(0, 0, whereDetail, null);
                    for (int ix = 0; ix < listPettycashPayment.size(); ix++) {
                        PettycashPaymentDetail tmpPettycashPaymentDetail = (PettycashPaymentDetail) listPettycashPayment.get(ix);
                        CashReceiveDetail tmpCashReceiveDetail = new CashReceiveDetail();
                        tmpCashReceiveDetail.setCoaId(tmpPettycashPaymentDetail.getCoaId());
                        tmpCashReceiveDetail.setBookedRate(eRate.getValueIdr());
			      tmpCashReceiveDetail.setSegment1Id(tmpPettycashPaymentDetail.getSegment1Id());
                        listCashReceiveDetail.add(tmpCashReceiveDetail);
                        sumDetail = sumDetail++;
                    }
                }
            }

            /*switch statement */
            iErrCode = ctrlCashReceiveDetail.action(iJSPCommand, oidCashReceiveDetail);
            /* end switch*/
            JspCashReceiveDetail jspCashReceiveDetail = ctrlCashReceiveDetail.getForm();
            /*count list All CashReceiveDetail*/
            vectSize = DbCashReceiveDetail.getCount(whereClause);
            /*switch list CashReceiveDetail*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) || (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCashReceiveDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            CashReceiveDetail cashReceiveDetail = ctrlCashReceiveDetail.getCashReceiveDetail();
            msgString = ctrlCashReceiveDetail.getMessage();
            if (session.getValue("RECEIVE_DETAIL") != null) {
                listCashReceiveDetail = (Vector) session.getValue("RECEIVE_DETAIL");
            }
            if (iJSPCommand == JSPCommand.DELETE) {
                listCashReceiveDetail.remove(recIdx);
            }
            boolean isSave = false;
//jika terjadi proses penyimpanan

            if (iJSPCommand == JSPCommand.SAVE) {
                if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {
                    Vector tmpList = new Vector();
                    for (int icr = 0; icr < listCashReceiveDetail.size(); icr++) {
                        CashReceiveDetail tmpObj = new CashReceiveDetail();

                        tmpObj = (CashReceiveDetail) listCashReceiveDetail.get(icr);
                        long coaId = JSPRequestValue.requestLong(request, "xxJSP_COA_ID_" + icr);
                        long cur = JSPRequestValue.requestLong(request, "xxJSP_FOREIGN_CURRENCY_ID_" + icr);
                        double foreign = JSPRequestValue.requestDouble(request, "xxJSP_FOREIGN_AMOUNT_" + icr);
                        double bookedRate = JSPRequestValue.requestDouble(request, "xxJSP_BOOKED_RATE_" + icr);
				long segId = JSPRequestValue.requestLong(request, "JSP_SEGMENT1_ID_DETAIL");

                        double amount = JSPRequestValue.requestDouble(request, "edit_amount_" + icr);
                        String memo = JSPRequestValue.requestString(request, "xxJSP_MEMO_" + icr);

                        tmpObj.setCoaId(coaId);
                        tmpObj.setMemo(memo);
                        tmpObj.setForeignCurrencyId(cur);
                        tmpObj.setForeignAmount(foreign);
                        tmpObj.setBookedRate(bookedRate);
                        tmpObj.setAmount(amount);
				tmpObj.setSegment1Id(segId);
                        tmpList.add(tmpObj);

                    }
                    listCashReceiveDetail = new Vector();
                    listCashReceiveDetail = tmpList;
                }

                if (cashReceive.getOID() != 0) {
                    DbCashReceiveDetail.saveAllDetail(cashReceive, listCashReceiveDetail);
                    listCashReceiveDetail = DbCashReceiveDetail.list(0, 0, "cash_receive_id=" + cashReceive.getOID(), "");
                    isSave = true;
                }
                iJSPCommand = JSPCommand.ADD;
            }
            session.putValue("RECEIVE_DETAIL", listCashReceiveDetail);

            Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_CASH_CREDIT, sysLocation.getOID());

            Vector currencies = DbCurrency.list(0, 0, "", "");

            double balance = 0;
            double totalDetail = getTotalDetail(listCashReceiveDetail);
            cashReceive.setAmount(totalDetail);
            boolean isSubmit = false;
            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeRec == 0 && recIdx == -1) {
                iJSPCommand = JSPCommand.ADD;
                isSubmit = true;
            }
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_CASH + "'", "");
            Vector segments = DbSegment.list(0, 0, "", "");
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
            // Identify a caption for all images. This can also be set inline for each image.
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
                document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                document.frmcashreceivedetail.submit();	
            }
            
            function cmdSearchJurnal(){
                window.open("s_nomorjurnal.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                
                function cmdSearchKasbon(){
                    window.open("s_nomorkasbon.jsp?formName=frmcashreceivedetail&txt_Id=referensi_id&txt_Name=referensi_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }    
                    
                    function cmdClickMe(index){
                        
                        <%if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {%>
                        
                        switch(index){
                            
                            <%for (int ik = 0; ik < listCashReceiveDetail.size(); ik++) {%>
                            
                            case <%="" + ik%>:
                            
                            var x = document.frmcashreceivedetail.<%="xxJSP_FOREIGN_CURRENCY_ID_" + ik%>.value;	
                            document.frmcashreceivedetail.<%="xxJSP_FOREIGN_CURRENCY_ID_" + ik%>.select();
                            
                            break;
                            
                            <%}%>   
                            
                        }
                        
                        <%}%>
                        
                    }
                    
                    function cmdFixing(){	
                        document.frmcashreceivedetail.command.value="<%=JSPCommand.POST%>";
                        document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                        document.frmcashreceivedetail.submit();	
                    }
                    
                    function cmdNewJournal(){	
                        document.frmcashreceivedetail.command.value="<%=JSPCommand.NONE%>";
                        document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                        document.frmcashreceivedetail.submit();	
                    }
                    
                    function cmdAdd(){	
                        document.frmcashreceivedetail.command.value="<%=JSPCommand.ADD%>";
                        document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
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
                    
                    function checkNumber2(index){
                        
                        <%if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {%>     
                        
                        var sum = 0;
                        
                        <%for (int ik = 0; ik < listCashReceiveDetail.size(); ik++) {%>
                        
                        var tmpSum = document.frmcashreceivedetail.<%="edit_amount_" + ik%>.value;	
                        tmpSum = cleanNumberFloat(tmpSum, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        
                        sum = sum + parseFloat(tmpSum);
                        
                        <%}%>
                        
                        document.frmcashreceivedetail.JSP_AMOUNT_MAIN.value=formatFloat(sum, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                        
                        <%}%>
                    }
                    
                    function cmdUpdateExchange(index){
                        
                        <%if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {%>                            
                        
                        switch(index){
                            
                            <%for (int ik = 0; ik < listCashReceiveDetail.size(); ik++) {%>
                            
                            case <%="" + ik%>:
                            
                            var idCurr = document.frmcashreceivedetail.<%="xxJSP_FOREIGN_CURRENCY_ID_" + ik%>.value; 
                            
                                        <%if (currencies != null && currencies.size() > 0) {

        for (int ix = 0; ix < currencies.size(); ix++) {

            Currency cx = (Currency) currencies.get(ix);

                                        %>    
                                            if(idCurr=='<%=cx.getOID()%>'){
                                                
                                                <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                                                document.frmcashreceivedetail.<%="xxJSP_BOOKED_RATE_" + ik%>.value="<%=eRate.getValueIdr()%>";
                                                <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                                                document.frmcashreceivedetail.<%="xxJSP_BOOKED_RATE_" + ik%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                                <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                                                document.frmcashreceivedetail.<%="xxJSP_BOOKED_RATE_" + ik%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                                                <%}%>                                                
                                            }    
                                        <%
        }
    }
                                        %>                                            
                                            var famount = document.frmcashreceivedetail.<%="xxJSP_FOREIGN_AMOUNT_" + ik%>.value;                                            
                                            famount = removeChar(famount);
                                            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                            
                                            var fbooked = document.frmcashreceivedetail.<%="xxJSP_BOOKED_RATE_" + ik%>.value;
                                            fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                            
                                            if(!isNaN(famount)){
                                                document.frmcashreceivedetail.<%="xxJSP_AMOUNT_" + ik%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                                document.frmcashreceivedetail.<%="edit_amount_" + ik%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                                document.frmcashreceivedetail.<%="xxJSP_FOREIGN_AMOUNT_" + ik%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                            }
                                            checkNumber2(<%=ik%>);
                                                
                                                break; 
                                                
                                                <%}%>
                                                
                                            }
                                            
                                            <%}%>    
                                        }
                                        <%if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {%>                                        
                                        function cmdUpdateExchange1(index){                                            
                                            switch(index){
                                                
                                    <%
    for (int k = 0; k < listCashReceiveDetail.size(); k++) {
                                    %>
                                        
                                        case <%="" + k%>:
                                        
                                        var idCurr = document.frmcashreceivedetail.<%="xxJSP_FOREIGN_CURRENCY_ID_" + k%>.value;                                    
                                        
                                        <%if (currencies != null && currencies.size() > 0) {

            for (int i = 0; i < currencies.size(); i++) {
                Currency cx = (Currency) currencies.get(i);
                                                %>
                                                    if(idCurr=='<%=cx.getOID()%>'){
                                                        <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                                                        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] + "_" + k%>.value="<%=eRate.getValueIdr()%>";
                                                        <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                                                        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] + "_" + k%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                                                        <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                                                        document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] + "_" + k%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                                        <%}%>
                                                    }	
                                            <%}
        }%>
        
        var famount = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT] + "_" + k%>.value;
        
        famount = removeChar(famount);
        famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        var fbooked = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] + "_" + k%>.value;
        fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        if(!isNaN(famount)){
            document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT] + "_" + k%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
            document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT] + "_" + k%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        }
        
        checkNumber2();
        
        break;
                                    <%
    } 
                                    %>
                                        
                                    }
                                }    
                                <%}%>
                                
                                function cmdAdd(){	
                                    document.frmcashreceivedetail.select_idx.value="-1";
                                    document.frmcashreceivedetail.hidden_cash_receive_id.value="0";
                                    document.frmcashreceivedetail.hidden_cash_receive_detail_id.value="0";
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.ADD%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdAsk(oidCashReceiveDetail){
                                    document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
                                    document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.ASK%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdConfirmDelete(oidCashReceiveDetail){
                                    document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.DELETE%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdSave(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.SUBMIT%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdSubmitCommand(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.SAVE%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdEdit(oidCashReceiveDetail){
                                    document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
                                    document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdCancel(oidCashReceiveDetail){
                                    document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdNone(){	
                                    document.frmcashreceivedetail.hidden_cash_receive_id.value="0";
                                    document.frmcashreceivedetail.hidden_cash_receive_detail_id.value="0";
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.NONE%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdBack(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.BACK%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdListFirst(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.FIRST%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.FIRST%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdListPrev(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.PREV%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.PREV%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdListNext(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.NEXT%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.NEXT%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                function cmdListLast(){
                                    document.frmcashreceivedetail.command.value="<%=JSPCommand.LAST%>";
                                    document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.LAST%>";
                                    document.frmcashreceivedetail.action="penerimaan_kasbon.jsp";
                                    document.frmcashreceivedetail.submit();
                                }
                                
                                //-------------- script form image -------------------
                                
                                function cmdDelPict(oidCashReceiveDetail){
                                    document.frmimage.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                                    document.frmimage.command.value="<%=JSPCommand.POST%>";
                                    document.frmimage.action="penerimaan_kasbon.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/close2.gif','../images/savedoc2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
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
                                                        <form name="frmcashreceivedetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_cash_receive_detail_id" value="<%=oidCashReceiveDetail%>">
                                                            <input type="hidden" name="hidden_cash_receive_id" value="<%=oidCashReceive%>">
                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_TYPE]%>" value="<%=DbCashReceive.TYPE_CASH_INCOME_KASBON%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" width="1%">&nbsp;</td>
                                                                                <td height="8" valign="top" colspan="3" width="99%"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td height="23"></td>
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
                                                                                                    <tr> 
                                                                                                        <td width="10%" colspan="5">                                                                                                            
                                                                                                            <table border="0" cellspacing="3" cellpadding="3" bgcolor="#F3F3F3">                                                                                                            
                                                                                                                <%
            String ref_number = "";
            long ref_id = 0;
            if (isLoad) {
                ref_number = referensi_no;
                ref_id = referensi_id;
            }
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td><font face="arial"><b><%=langCT[17]%></b></font></td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td><%=langCT[4]%></td>
                                                                                                                    <td><input size="25" readonly type="text" name="referensi_number" value="<%=ref_number%>"></td>
                                                                                                                    <td><input type="hidden" name="referensi_id" value="<%=ref_id%>">
                                                                                                                        <a href="javascript:cmdSearchKasbon()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr heoght="5">
                                                                                                                    <td colspan="4"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (first) {%>
                                                                                                    <tr>
                                                                                                        <td height="22" colspan="5" valign="middle" class="page"> 
                                                                                                            <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell1" ><%=langNav[4]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" width="100%"> 
                                                                                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td height="2"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>                                                                                                                                                                                                        
                                                                                                    <% if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="3" height="23"><font face="arial"><b><u><%=langNav[6]%></u></b></font></td>
                                                                                                        <td width="9%" height="23">&nbsp;</td>
                                                                                                        <td width="55%" height="23">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td colspan=5 height=10px>&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[4]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
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

     if (cashReceive.getPeriodeId() != 0) {
         try {
             open = DbPeriode.fetchExc(cashReceive.getPeriodeId());
         } catch (Exception e) {
         }
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
                                                                                                            <%=langCT[19]%>
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
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                            <%} else {%>
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_PERIODE_ID]%>" value="<%=openPeriod.getOID()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>  
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[0]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
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
                                                                                                                <%=getAccountRecursif(coa, cashReceive.getCoaId(), isPostableOnly)%>
                                                                                                                <%}
} else {%>
                                                                                                                <option>select ..</option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                            <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_COA_ID) %> 
                                                                                                        </td>
                                                                                                        <td width="12%"><%=langCT[5]%></td>
                                                                                                        <td width="42%"><input name="<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((cashReceive.getTransDate() == null) ? new Date() : cashReceive.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        <%= jspCashReceive.getErrorMsg(jspCashReceive.JSP_TRANS_DATE) %> </td>
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
                                                                                                        <td width="10%"><%=langCT[1]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td width="33%">                                                                                                             
                                                                                                            <input type="text" name="txtEmployee" readonly value="<%=nameEmployee%>">
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_RECEIVE_FROM_NAME]%>" value="<%=nameEmployee%>">
                                                                                                        </td>                                                                                                        
                                                                                                        <td width="12%">
                                                                                                            <%if (jur_num.length() > 0) {%>
                                                                                                            <%=langCT[18]%>
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                            <%}%>   
                                                                                                        </td>                                                                                                                                                                    
                                                                                                        <td width="42%">
                                                                                                            <%if (jur_num.length() > 0) {%>
                                                                                                            <%=jur_num%>
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                            <%}%>    
                                                                                                            <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_REFERENSI_ID]%>" value="<%=cashReceive.getReferensiId()%>" >
                                                                                                            <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_REFERENSI_ID) %>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="10%"><%=langCT[2]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td width="3%"> 
                                                                                                            <div align="right"></div>
                                                                                                        </td>
                                                                                                        <td width="33%"> 
                                                                                                            <input type="text" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkNumber()" class="readonly" readOnly size="50">
                                                                                                        <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_AMOUNT) %></td>
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="42%">
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%" valign="top"><%=langCT[3]%></td>
                                                                                                        <td width="3%">&nbsp;</td>
                                                                                                        <td valign="top"> 
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td><textarea name="<%=JspCashReceive.colNames[JspCashReceive.JSP_MEMO]%>" cols="47" rows="3"><%=cashReceive.getMemo()%></textarea></td>
                                                                                                                    <td valign="top"></td>
                                                                                                                    <td valign="top"><%= jspCashReceive.getErrorMsg(jspCashReceive.JSP_MEMO) %></td>
                                                                                                                </tr>    
                                                                                                            </table>    
                                                                                                        </td>
                                                                                                        <td colspan="2"> 
                                                                                                            <table width="60%" border="0" cellspacing="3" cellpadding="3" bgcolor="#F3F3F3">
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td width="42%"><b><%=langCT[20]%></b></td>
                                                                                                                                <td width="58%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%
     if (segments != null && segments.size() > 0) {
         for (int i = 0; i < segments.size(); i++) {
             Segment segment = (Segment) segments.get(i);
             String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + segment.getOID();
             switch (i + 1) {
                 //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                 //maka akan di tampikan sesuai dengan segment yang ditentukan
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
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment14Id();
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
                                                                                                                                                if (cashReceive.getSegment1Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 2:
                                                                                                                                                if (cashReceive.getSegment2Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 3:
                                                                                                                                                if (cashReceive.getSegment3Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 4:
                                                                                                                                                if (cashReceive.getSegment4Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 5:
                                                                                                                                                if (cashReceive.getSegment5Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 6:
                                                                                                                                                if (cashReceive.getSegment6Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 7:
                                                                                                                                                if (cashReceive.getSegment7Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 8:
                                                                                                                                                if (cashReceive.getSegment8Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 9:
                                                                                                                                                if (cashReceive.getSegment9Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 10:
                                                                                                                                                if (cashReceive.getSegment10Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 11:
                                                                                                                                                if (cashReceive.getSegment11Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 12:
                                                                                                                                                if (cashReceive.getSegment12Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 13:
                                                                                                                                                if (cashReceive.getSegment13Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 14:
                                                                                                                                                if (cashReceive.getSegment14Id() == sd.getOID()) {
                                                                                                                                                    selected = "selected";
                                                                                                                                                }
                                                                                                                                                break;
                                                                                                                                            case 15:
                                                                                                                                                if (cashReceive.getSegment5Id() == sd.getOID()) {
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
                                                                                                    <%}%>
                                                                                                    
                                                                                                </table>                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" width="1%" class="comment">&nbsp;</td>
                                                                                <td height="20" valign="middle" colspan="3" class="comment" width="99%">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td  valign="middle" width="1%">&nbsp;</td>
                                                                                <td  valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td class="boxed1"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">  
                                                                                                    <% if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {%>
                                                                                                    <tr> 	
																	  <td rowspan="2"  class="tablehdr" nowrap width="10%">Segmen</td>																        			
                                                                                                        <td rowspan="2"  class="tablehdr" nowrap width="10%"><%=langCT[6]%></td>
                                                                                                        <td colspan="2" class="tablehdr"><%=langCT[7]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="12%"><%=langCT[10]%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="13%"><%=langCT[11]%> 
                                                                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                        <td rowspan="2" class="tablehdr" width="46%"><%=langCT[12]%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%" class="tablehdr"><%=langCT[8]%></td>
                                                                                                        <td width="13%" class="tablehdr"><%=langCT[9]%></td>
                                                                                                    </tr>                                                                                                   
                                                                                                    <%


     for (int i = 0; i < listCashReceiveDetail.size(); i++) {

         CashReceiveDetail crd = (CashReceiveDetail) listCashReceiveDetail.get(i);

         Coa c = new Coa();
         try {
             c = DbCoa.fetchExc(crd.getCoaId());
         } catch (Exception e) {
             System.out.println("[exception] " + e.toString());
         }

         String cssName = "tablecell";
         if (i % 2 != 0) {
             cssName = "tablecell1";
         }

                                                                                                    %>
                                                                                                    <tr> 
																	  <td>	
																	  <div align="center"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <%
                                                                                                    if (segments != null && segments.size() > 0) {
                                                                                                        for (int xx = 0; xx < segments.size(); xx++) {
                                                                                                            Segment seg = (Segment) segments.get(xx);
                                                                                                            
                                                                                                            String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + seg.getOID();
             switch (i + 1) {
                 //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                 //maka akan di tampikan sesuai dengan segment yang ditentukan
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
                         wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment14Id();
                     }
                     break;
             }
                                                                                                            
                                                                                                            Vector sgDetails = DbSegmentDetail.list(0, 0, wh , "");
                                                                                                                    %>
                                                                                                                    <tr> 
                                                                                                                        <td width="54%" nowrap><%=seg.getName()%></td>
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
                                                                                                                                            if (cashReceiveDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 3:
                                                                                                                                            if (cashReceiveDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 4:
                                                                                                                                            if (cashReceiveDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 5:
                                                                                                                                            if (cashReceiveDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 6:
                                                                                                                                            if (cashReceiveDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 7:
                                                                                                                                            if (cashReceiveDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 8:
                                                                                                                                            if (cashReceiveDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 9:
                                                                                                                                            if (cashReceiveDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 10:
                                                                                                                                            if (cashReceiveDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 11:
                                                                                                                                            if (cashReceiveDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 12:
                                                                                                                                            if (cashReceiveDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 13:
                                                                                                                                            if (cashReceiveDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 14:
                                                                                                                                            if (cashReceiveDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                                                selected = "selected";
                                                                                                                                            }
                                                                                                                                            break;
                                                                                                                                        case 15:
                                                                                                                                            if (cashReceiveDetail.getSegment15Id() == sd.getOID()) {
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
                                                                                                        <td class="<%=cssName%>" nowrap width="10%">
                                                                                                            <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_COA_ID]%>_<%=i%>">                                                                                                            
                                                                                                                <option value="<%=c.getOID()%>"><%=c.getCode() + " - " + c.getName()%></option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="6%" class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>_<%=i%>" onChange="javascript:cmdUpdateExchange(<%=i%>)">
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
                                                                                                        <td width="13%" class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>_<%=i%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange(<%=i%>)" onClick="javascript:cmdClickMe('<%=i%>')">
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td width="12%" class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>_<%=i%>" size="7" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>"  class="readonly rightalign" readOnly>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="13%" class="<%=cssName%>"> 
                                                                                                            <div align="center"> 
                                                                                                                <input type="hidden" name="edit_amount_<%=i%>" value="<%=crd.getAmount()%>">
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>_<%=i%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                                                                            <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_AMOUNT) %> </div>
                                                                                                        </td>
                                                                                                        <td width="46%" class="<%=cssName%>">
                                                                                                            <div align="left">
                                                                                                                <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>_<%=i%>" size="30" value="<%=crd.getMemo()%>">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                    }
                                                                                }
                                                                                                    %>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td colspan="2" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="78%">&nbsp;</td>
                                                                                                        <td width="22%">&nbsp;</td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <%
                                                                                if (cashReceive.getReferensiId() != 0) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="78%"> 
                                                                                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td align="left">
                                                                                                                        <% if (cashReceive.getPostedStatus() == 0) {%>
                                                                                                                        <%if (privUpdate || privAdd) {%>
                                                                                                                        <a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/save2.gif',1)"><img src="../images/save.gif" name="savedoc21" height="22" border="0"></a>
                                                                                                                        <%}%>
                                                                                                                        <%} else {%>
                                                                                                                        &nbsp;
                                                                                                                        <%}%>
                                                                                                                    </td>    
                                                                                                                </tr>
                                                                                                                <%if (msgStringRec != null && msgStringRec.length() > 0) {%>
                                                                                                                <tr>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table border="0" cellpadding="2" cellspacing="0" class="warning" width="293" align="left">                                                                              
                                                                                                                            <tr> 
                                                                                                                                <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                                                                                <td width="253" nowrap><%=msgStringRec%></td>
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
                                                                                                                        <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                                                                                    </td>
                                                                                                                    <td width="64%"> 
                                                                                                                        <div align="right"><b> 
                                                                                                                                <%
                                                                                                        balance = cashReceive.getAmount() - totalDetail;
                                                                                                                                %>
                                                                                                                                <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                                                                            <%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b>
                                                                                                                        </div>
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
                                                                            <%
            } catch (Exception exc) {
                System.out.println("[exception] " + exc.toString());
            }%>
                                                                            
                                                                            <%if (cashReceive.getOID() != 0 && cashReceive.getPostedStatus() == 1) {%>
                                                                            <tr> 
                                                                                <td colspan="5" align="left">      
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td width=5px">&nbsp;</td>    
                                                                                            <td>
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
                                                                                    </table>      
                                                                                </td>
                                                                            </tr>
                                                                            <%
            }
                                                                            %>
                                                                            <%if (cashReceive.getOID() != 0) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="1" valign="middle" width="1%">&nbsp;</td>
                                                                                <td height="1" valign="middle" colspan="3" width="99%"> 
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" width="1%">&nbsp;</td>
                                                                                <td valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="99%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr>
                                                                                            <td width="8%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                                                            <td width="45%">&nbsp;</td>
                                                                                            <td width="41%" nowrap> 
                                                                                                <%if (isSave == true && iErrCodeRec == 0 && iErrCode == 0) {%>
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                        <td width="220" nowrap><%=langCT[14]%></td>
                                                                                                    </tr>
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