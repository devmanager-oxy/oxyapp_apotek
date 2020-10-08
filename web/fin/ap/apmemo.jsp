
<%-- 
    Document   : apmemo
    Created on : Nov 20, 2012, 3:55:12 PM
    Author     : ROy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_AP_MEMORIAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
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
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");
            String txtvendor = JSPRequestValue.requestString(request, "txt_vendor");
            Date dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DUE_DATE"), "dd/MM/yyyy");
            Date dates = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DATE"), "dd/MM/yyyy");
            String srcCode = JSPRequestValue.requestString(request, "jsp_code_item");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int typePembayaran = JSPRequestValue.requestInt(request, "type_pembayaran");
            long oidItemDmm = 0;
            long oidUom = 0;
            long oidOffice = 0;

            try {
                oidOffice = Long.parseLong(DbSystemProperty.getValueByName("OID_LOCATION_OFFICE"));
            } catch (Exception e) {
            }

            try {
                oidItemDmm = Long.parseLong(DbSystemProperty.getValueByName("OID_ITEM_MEMO"));
            } catch (Exception e) {
            }

            try {
                oidUom = Long.parseLong(DbSystemProperty.getValueByName("OID_UOM_MEMO"));
            } catch (Exception e) {
            }

            boolean commandNone = false;

            if (iJSPCommand == JSPCommand.ADD) {
                oidReceive = 0;
                txtvendor = "";
                vendorId = 0;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("APMEMO_DETAIL");
                commandNone = true;
                iJSPCommand = JSPCommand.ADD;
                oidReceive = 0;
                txtvendor = "";
                vendorId = 0;
            }

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            int iErrCode2 = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdReceiveItemMemo cmdReceiveItemMemo = new CmdReceiveItemMemo(request);

            JspReceiveItemMemo jspReceiveItemMemo = cmdReceiveItemMemo.getForm();
            ReceiveItem receiveItem = cmdReceiveItemMemo.getReceiveItem();

            if ((iJSPCommand == JSPCommand.SAVE)) {
                long coaAp = JSPRequestValue.requestLong(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AP_COA_ID]);

                Coa coax = new Coa();
                try {
                    coax = DbCoa.fetchExc(coaAp);
                } catch (Exception e) {
                }
                if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspReceiveItemMemo.addError(jspReceiveItemMemo.JSP_AP_COA_ID, "postable account type required");
                    iErrCode2 = iErrCode2 + 1;
                }
                double tmpAmount = JSPRequestValue.requestDouble(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]);
                if (tmpAmount == 0) {
                    jspReceiveItemMemo.addError(jspReceiveItemMemo.JSP_AMOUNT, "amount can't 0");
                    iErrCode2 = iErrCode2 + 1;
                }
            }

            CmdReceiveMemo cmdReceiveMemo = new CmdReceiveMemo(request);
            JSPLine ctrLine = new JSPLine();
            JspReceiveMemo jspReceiveMemo = cmdReceiveMemo.getForm();
            iErrCode = cmdReceiveMemo.action(iJSPCommand, oidReceive, iErrCode2);

            Receive receive = cmdReceiveMemo.getReceiveMemo();
            msgString = cmdReceiveMemo.getMessage();

            if (dueDate != null) {
                receive.setDueDate(dueDate);
            }
            if (dates != null) {
                receive.setDate(dates);
            }

            if (oidReceive == 0) {
                oidReceive = receive.getOID();
                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                    receive.setStatus(I_Project.DOC_STATUS_DRAFT);
                } else {
                    receive.setStatus(I_Project.DOC_STATUS_APPROVED);
                }
            }
            if (receive.getVendorId() != 0) {
                try {
                    Vendor vnd = DbVendor.fetchExc(receive.getVendorId());
                    vendorId = receive.getVendorId();
                    txtvendor = vnd.getName();
                } catch (Exception e) {
                }
            }

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];


%> 

<%
            String msgString2 = "";
            SessIncomingGoods ig = new SessIncomingGoods();
            msgString2 = cmdReceiveItemMemo.getMessage();
            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
            Vector receiveItems = new Vector();

            if (commandNone || iJSPCommand == JSPCommand.ACTIVATE || iJSPCommand == JSPCommand.ASSIGN) {
                receiveItems = DbReceiveItem.list(whereClause, orderClause);
            } else {
                if (session.getValue("APMEMO_DETAIL") != null) {
                    receiveItems = (Vector) session.getValue("APMEMO_DETAIL");
                }
            }

            double subTotal = 0;

            if (iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.SUBMIT) {
                boolean isEdt = false;
                if (receiveItems != null && receiveItems.size() > 0) {
                    for (int i = 0; i < receiveItems.size(); i++) {
                        ReceiveItem ri = (ReceiveItem) receiveItems.get(i);
                        if (recIdx == i) {
                            isEdt = true;
                            ri.setApCoaId(JSPRequestValue.requestLong(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AP_COA_ID]));
                            ri.setTotalAmount(JSPRequestValue.requestDouble(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]));
                            ri.setAmount(JSPRequestValue.requestDouble(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]));
                            ri.setMemo(JSPRequestValue.requestString(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_MEMO]));
                            ri.setReceiveId(receive.getOID());
                        }
                        subTotal = subTotal + ri.getAmount();
                    }
                }

                if (isEdt == false && iJSPCommand != JSPCommand.SUBMIT) {
                    ReceiveItem ri = new ReceiveItem();

                    ri.setOID(0);
                    ri.setApCoaId(JSPRequestValue.requestLong(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AP_COA_ID]));

                    ri.setQty(1);
                    ri.setDeliveryDate(new Date());
                    ri.setTotalDiscount(0);
                    ri.setTotalAmount(JSPRequestValue.requestDouble(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]));
                    ri.setAmount(JSPRequestValue.requestDouble(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]));
                    ri.setIsBonus(DbReceiveItem.NON_BONUS);
                    ri.setMemo(JSPRequestValue.requestString(request, jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_MEMO]));
                    ri.setReceiveId(receive.getOID());
                    ri.setItemMasterId(oidItemDmm);
                    ri.setUomId(oidUom);
                    ri.setPurchaseItemId(0);
                    ri.setExpiredDate(new Date());
                    ri.setType(0);
                    subTotal = subTotal + ri.getAmount();

                    if (iErrCode == 0 && iErrCode2 == 0) {
                        receiveItems.add(ri);
                    } else {
                        //if(receiveItems == null || receiveItems.size() <=0){
                        receiveItem.setAmount(ri.getAmount());
                        receiveItem.setTotalAmount(ri.getAmount());
                        receiveItem.setMemo(ri.getMemo());
                        receiveItem.setApCoaId(ri.getApCoaId());
                    //}
                    }
                }
                recIdx = -1;
            } else {
                subTotal = DbReceiveItem.getTotalRecAmount(oidReceive);
            }

            if ((iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SUBMIT)) {
                DbReceiveItem.inesertReceiveItem(receive.getOID(), receiveItems);
                recIdx = -1;
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                if (receiveItems != null && receiveItems.size() > 0) {
                    for (int i = 0; i < receiveItems.size(); i++) {
                        ReceiveItem ri = (ReceiveItem) receiveItems.get(i);
                        if (i == recIdx) {
                            if (ri.getOID() != 0) {
                                DbReceiveItem.deleteExc(ri.getOID());
                            }
                            receiveItems.remove(i);
                            break;
                        }
                    }
                }
            }

            receive.setTotalAmount(subTotal);

            String[] langAP = {"Date", "Vendor", "Document Number", "Period", "Date", "Vendor", "Invoice", "Amount", "Memo", "Amount", "Status", "Saved", "Delete Success", "Location", "Account", "Amount", "Memo", "Note"};
            String[] langNav = {"Account Payble", "AP Memo", "Record", "Editor", "Chose suplier first", "Delete data ?", "Number", "Payment Type"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Suplier", "Nomor Dokumen", "Periode", "Tanggal", "Suplier", "Faktur", "Jumlah", "Memo", "Jumlah", "Status", "Data Tersimpan", "Hapus data berhasil", "Lokasi", "Perkiraan", "Jumlah", "Keterangan", "Catatan"};
                langAP = langID;

                String[] navID = {"Hutang", "AP Memo", "Record", "Editor", "Pilih suplier terlebih dahulu", "Hapus data ?", "Nomor", "Tipe Pembayaran"};
                langNav = navID;
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_OTHER_REVENUE + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            Vector accApLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_OTHER_REVENUE_AP + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");

            long currencyId = 0;
            try {
                currencyId = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
            } catch (Exception e) {
            }

            session.putValue("APMEMO_DETAIL", receiveItems);
            Vector listVendor = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            <!--
            function cmdUpdateExchange(){       
                var famount = document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_AMOUNT]%>.value;
                //famount = removeChar(famount)
                famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);                      
                
                var total = document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value;                   
                total = removeChar(total)
                total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);                  
                var htotal = document.frmarapmemo.hidden_amount.value;
                //htotal = removeChar(htotal)
                htotal = cleanNumberFloat(htotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);                  
                total = parseFloat(total) - parseFloat(htotal) + parseFloat(famount);
                document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value= formatFloat(parseFloat(total), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                
                if(!isNaN(famount)){
                    document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                        
                    document.frmarapmemo.hidden_amount.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                        
                }            
            }
            
            function checkNumber(){
                var st = document.frmarapmemo.<%=jspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value;		                        
                result = removeChar(st);                        
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmcashreceivedetail.<%=jspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }            
            
            function cmdSearchVendor(){
                window.open("<%=approot%>/ap/srcvendor.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function cmdResetAll(){
                    document.frmarapmemo.txt_vendor.value="";
                    document.frmarapmemo.JSP_VENDOR_ID.value="0";                  
                }
                
                function cmdPrintXLS(){	 
                    window.open("<%=printroot%>.report.RptIncomingGoodsXLS?idx=<%=System.currentTimeMillis()%>");
                    }
                    function cmdPrintDoc(){                
                        window.open("<%=printroot%>.report.RptIncomingGoodsPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                        
                        
                        function calculateSubTotal(){   
                            
                            var amount = document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_AMOUNT]%>.value;
                            var qty = document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_QTY]%>.value;
                            var discount = document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_TOTAL_DISCOUNT]%>.value;
                            
                            amount = removeChar(amount);
                            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                            document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                            
                            qty = removeChar(qty);
                            qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                            document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_QTY]%>.value = qty;
                            
                            discount = removeChar(discount);
                            discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                            document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                            
                            var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
                            document.frmarapmemo.<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                            
                            var subtot = document.frmarapmemo.sub_tot.value;
                            subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                            
         <%

            if (oidReceiveItem == 0) {%>
                    document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                    <%} else {%>
                    var tempAmount = document.frmarapmemo.temp_item_amount.value;
                    document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
         <%}
         %>
             
             calculateAmount();
         }
         
         function calculateAmount(){
             
             var vat = document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_INCLUDE_TAX]%>.value;
             var taxPercent = document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TAX_PERCENT]%>.value;
             taxPercent = removeChar(taxPercent);
             taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
             
             var discPercent = document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DISCOUNT_PERCENT]%>.value;	
             discPercent = removeChar(discPercent);
             discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
             
             var subTotal = document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>.value;
             subTotal = removeChar(subTotal);
             subTotal = cleanNumberFloat(subTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
             
             var totalDiscount = 0;
             if(parseFloat(discPercent)>0){
                 totalDiscount = parseFloat(discPercent)/100 * parseFloat(subTotal);
             }
             
             var totalTax = 0;
             
             if(parseInt(vat)==0){
                 document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TAX_PERCENT]%>.value="0.0";		
                 totalTax = 0;
             }else{
             document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
             totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
         }
         
         var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
         
         document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
         document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
         document.frmarapmemo.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
         
     }
     
     
     function cmdToRecord(){
         document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";
         document.frmarapmemo.action="apmemolist.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdAskDoc(){
         document.frmarapmemo.hidden_receive_item_id.value="0";
         document.frmarapmemo.command.value="<%=JSPCommand.SUBMIT%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdDelete(receiveId,idx){
         var cfrm = confirm('Delete data ?');                    
         if( cfrm==true){    
             document.frmarapmemo.hidden_receive_id.value=receiveId;
             document.frmarapmemo.select_idx.value = idx;
             document.frmarapmemo.hidden_receive_item_id.value="0";
             document.frmarapmemo.command.value="<%=JSPCommand.DELETE%>";
             document.frmarapmemo.action="apmemo.jsp";
             document.frmarapmemo.submit();
         }
     }
     
     function cmdCancelDoc(){
         document.frmarapmemo.hidden_receive_item_id.value="0";
         document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdSaveDoc(){
         document.frmarapmemo.command.value="<%=JSPCommand.POST%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdAdd(){
         document.frmarapmemo.hidden_receive_item_id.value="0";
         document.frmarapmemo.command.value="<%=JSPCommand.ADD%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdAddDetail(receiveId){
         document.frmarapmemo.hidden_receive_id.value=receiveId;
         document.frmarapmemo.hidden_receive_item_id.value="0";
         document.frmarapmemo.command.value="<%=JSPCommand.ACTIVATE%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdAsk(oidReceiveItem){
         document.frmarapmemo.hidden_receive_item_id.value=oidReceiveItem;
         document.frmarapmemo.command.value="<%=JSPCommand.ASK%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdAskMain(oidReceive){
         document.frmarapmemo.hidden_receive_id.value=oidReceive;
         document.frmarapmemo.command.value="<%=JSPCommand.ASK%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="receive.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdConfirmDelete(oidReceiveItem){
         document.frmarapmemo.hidden_receive_item_id.value=oidReceiveItem;
         document.frmarapmemo.command.value="<%=JSPCommand.DELETE%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdSave(oidReceive){
         document.frmarapmemo.hidden_receive_item_id.value=oidReceive;
         document.frmarapmemo.command.value="<%=JSPCommand.SAVE%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();             
     }
     
     function cmdSubmitCommand(oidReceive){
         document.frmarapmemo.hidden_receive_item_id.value=oidReceive;
         document.frmarapmemo.command.value="<%=JSPCommand.SUBMIT%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();             
     }
     
     function cmdEdit(oidReceive){
         document.frmarapmemo.hidden_receive_item_id.value=oidReceive;
         document.frmarapmemo.select_idx.value = oidReceive;
         document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdCancel(oidReceive){
         document.frmarapmemo.hidden_receive_item_id.value=oidReceive;
         document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
         document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdBack(){
         document.frmarapmemo.command.value="<%=JSPCommand.BACK%>";
         document.frmarapmemo.select_idx.value = -1;
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
     }
     
     function cmdSelect(){
        var st = document.frmarapmemo.type_pembayaran.value;
        if(parseFloat(st)==1){
            document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";
            document.frmarapmemo.action="apmemobudget.jsp";
            document.frmarapmemo.submit();
        }
    }
     
     function cmdNewJournal(){
         document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
         document.frmarapmemo.action="apmemo.jsp";
         document.frmarapmemo.submit();
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
     
     function MM_swapImage() { //v3.0
         var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
         if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
     }
     
     function MM_findObj(n, d) { //v4.01
         var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
             d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
         if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
         for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
         if(!x && d.getElementById) x=d.getElementById(n); return x;
     }
     //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftmenu-bg.gif"> 
                                            <%@ include file="../main/menu.jsp"%>
                                            <%@ include file="../calendar/calendarframe.jsp"%>
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmarapmemo" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_receive_item_id" value="<%=oidReceiveItem%>">
                                                            <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                                                            <input type="hidden" name="<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_code_delete" value="<%=0%>">                                    
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspReceiveItemMemo.colNames[JspReceiveItemMemo.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_PURCHASE_ID]%>" value="0">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TYPE_AP]%>" value="<%=DbReceive.TYPE_AP_YES%>">
                                                            <input type="hidden" name="hidden_item_code" value="<%= srcCode %>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_INCLUDE_TAX]%>" value="<%=DbReceive.INCLUDE_TAX_NO%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_PAYMENT_TYPE]%>" value="<%=I_Project.PAYMENT_TYPE_CASH%>">
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                            <% if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                                                            <% }%>
                                                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_INVOICE_NUMBER]%>" value="-">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <script language="JavaScript">
                                                                    parserMaster(); 
                                                                </script>
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                                                <!-- #EndEditable --></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td height="8"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><font face="arial">Records</font></a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center"><font face="arial">&nbsp;Memorial &nbsp;&nbsp;</font></div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">                                                                                                        
                                                                                                    <tr align="left" > 
                                                                                                        <td valign="top">
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td height="20" colspan="6"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td class="fontarial" colspan="6">
                                                                                                                        <table>
                                                                                                                            <tr>
                                                                                                                                <td><%=langNav[7]%></td>
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
                                                                                                                    <td height="10" colspan="6"></td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="6">
                                                                                                                        <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                               
                                                                                                                            <tr> 
                                                                                                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr align="left"> 
                                                                                                                    <td height="21" valign="middle" width="120">&nbsp;</td>                                                                
                                                                                                                    <td height="21" valign="middle" width="5">&nbsp;</td>                                                                
                                                                                                                    <td height="21" valign="middle" width="350">&nbsp;</td>                                                                
                                                                                                                    <td height="21" width="120"></td>
                                                                                                                    <td height="21" ></td>
                                                                                                                    <td height="21" ></td>
                                                                                                                </tr> 
                                                                                                                <tr align="left"> 
                                                                                                                    <td height="5" >&nbsp;</td>
                                                                                                                    <td height="5" colspan="5" classs="fontarial"><i>*) data required</i></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <tr align="left"> 
                                                                                                                    <td height="5" colspan="4"></td>
                                                                                                                </tr>
                                                                                                                <tr height="24"> 
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[2]%></td>         
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <%
            Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            String strNumber = "";
            Periode open = new Periode();
            if (receive.getPeriodId() != 0) {
                try {
                    open = DbPeriode.fetchExc(receive.getPeriodId());
                } catch (Exception e) {
                }
            } else {
                if (periods != null && periods.size() > 0) {
                    open = (Periode) periods.get(0);
                }
            }

            int counterJournal = DbSystemDocNumber.getNextCounterApMemo(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberApMemo(counterJournal, open.getOID());
            if (receive.getOID() != 0 || oidReceive != 0) {
                strNumber = receive.getNumber();
            }
                                                                                                                        %>
                                                                                                                        <%=strNumber%>                                                                    
                                                                                                                    </td>               
                                                                                                                    <%

                                                                                                                    %>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%if (periods.size() > 1) {%><font face="arial"><%=langAP[3]%></font><%} else {%>&nbsp;<%}%></td> 
                                                                                                                    <td class="fontarial"><%if (periods.size() > 1) {%>:<%} else {%>&nbsp;<%}%></td>
                                                                                                                    <td > 
                                                                                                                        <%if (open.getStatus().equals("Closed")) {%>
                                                                                                                        <%=open.getName()%>
                                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>" value="<%=open.getOID()%>">
                                                                                                                        <%} else {%>
                                                                                                                        <%if (periods.size() > 1) {%>
                                                                                                                        <select name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>" class="fontarial">
                                                                                                                            <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                                                                                            %>
                                                                                                                            <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == receive.getPeriodId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                            <%}%><%}%>
                                                                                                                        </select>  
                                                                                                                        <%} else {%>
                                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>" value="<%=open.getOID()%>">
                                                                                                                        <%}%>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[1]%></td>   
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_VENDOR_ID]%>">
                                                                                                                            <option value="0">- select suplier -</option>
                                                                                                                            <%if (listVendor != null && listVendor.size() > 0) {
                for (int i = 0; i < listVendor.size(); i++) {
                    Vendor v = (Vendor) listVendor.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=v.getOID()%>" <%if (receive.getVendorId() == v.getOID()) {%> selected<%}%> ><%=v.getName()%> - <%=v.getCode()%></option>
                                                                                                                            <%
                }
            }
                                                                                                                            %>
                                                                                                                            
                                                                                                                        </select>
                                                                                                                        <%=jspReceiveMemo.getErrorMsg(JspReceiveMemo.JSP_VENDOR_ID)%>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[0]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    &nbsp;<%=jspReceiveMemo.getErrorMsg(JspReceiveMemo.JSP_DATE)%>
                                                                                                                                    <%ig.setDate(receive.getDate());%>                                                                                                            
                                                                                                                                </td>
                                                                                                                            </tr>    
                                                                                                                        </table>     
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                  
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[14]%></td>  
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td > 
                                                                                                                        <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_COA_ID]%>">
                                                                                                                            <%if (accApLinks != null && accApLinks.size() > 0) {
                for (int i = 0; i < accApLinks.size(); i++) {
                    AccLink accLink = (AccLink) accApLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                    }

                    if (receive.getCoaId() == 0 && i == 0) {
                        receive.setCoaId(accLink.getCoaId());
                    }
                                                                                                                            %>
                                                                                                                            <option <%if (receive.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, receive.getCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%= jspReceiveMemo.getErrorMsg(jspReceiveMemo.JSP_COA_ID) %>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1">&nbsp;&nbsp;<%=langAP[7]%> Rp.</td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td >
                                                                                                                        <input type="text" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TOTAL_AMOUNT]%>" value="<%=JSPFormater.formatNumber(receive.getTotalAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkNumber()" class="readonly" readOnly size="15">
                                                                                                                        <input type="hidden" name = "<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_CURRENCY_ID]%>" value = "<%=currencyId%>">                                                                                                            
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablecell1" valign="top">&nbsp;&nbsp;<%=langAP[10]%></td>
                                                                                                                    <td class="fontarial" valign="top">:</td>
                                                                                                                    <td valign="top"> 
                                                                                                                        <%if (!receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>
                                                                                                                        <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_STATUS]%>" class="fontarial">
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%> selected <%}%> >DRAFT</option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%> selected <%}%> >APPROVE</option>
                                                                                                                        </select>
                                                                                                                        <%} else {%>
                                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_POSTED%>">
                                                                                                                        POSTED
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" valign="top">&nbsp;&nbsp;<%=langAP[13]%></td>
                                                                                                                    <td class="fontarial" valign="top">:</td>
                                                                                                                    <td valign="top"> 
                                                                                                                        <select name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_LOCATION_ID]%>" class="fontarial">
                                                                                                                            <%
            Vector locations;
            locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_CODE]);
            if (commandNone) {
                receive.setLocationId(oidOffice);
            }
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    if (receive.getLocationId() == d.getOID()) {
                        ig.setReceiveIn(d.getCode() + " - " + d.getName());
                    }
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (receive.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                </tr>     
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablecell1" valign="top">&nbsp;&nbsp;<%=langAP[17]%></td>
                                                                                                                    <td class="fontarial" valign="top">:</td>
                                                                                                                    <td valign="top"> 
                                                                                                                        <textarea name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_NOTE]%>" cols="25" rows="2"><%=receive.getNote()%></textarea>                                                                                                            
                                                                                                                        <%= jspReceiveMemo.getErrorMsg(jspReceiveMemo.JSP_NOTE) %>                                                                                                            
                                                                                                                        <%ig.setNotes(receive.getNote());%>
                                                                                                                    </td>
                                                                                                                    <td valign="top" valign="top">&nbsp;&nbsp;</td>
                                                                                                                    <td class="fontarial" valign="top"></td>
                                                                                                                    <td valign="top"></td>
                                                                                                                </tr>                                                                                                                                                                                                                                
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                    </tr>        
                                                                                                    <tr align="left"> 
                                                                                                        <td valign="top">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr align="left" > 
                                                                                                        <td valign="top">
                                                                                                            <table width="1000" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr height="26">
                                                                                                                    <td class="tablehdr" ><%=langAP[14]%></td>
                                                                                                                    <td class="tablehdr" width="150"><%=langAP[15]%></td>
                                                                                                                    <td class="tablehdr" width="350"><%=langAP[16]%></td>
                                                                                                                </tr>
                                                                                                                <%
            boolean isEdit = false;
            boolean isEditor = false;
            if (receiveItems != null && receiveItems.size() > 0) {

                for (int r = 0; r < receiveItems.size(); r++) {
                    ReceiveItem rItem = (ReceiveItem) receiveItems.get(r);

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(rItem.getApCoaId());
                    } catch (Exception e) {
                    }

                                                                                                                %>        
                                                                                                                
                                                                                                                <%
                                                                                                                        if (recIdx == r) {
                                                                                                                            isEdit = true;
                                                                                                                            isEditor = true;
                                                                                                                %>
                                                                                                                <tr height="26">
                                                                                                                    <td align="left" class="tablecell1">
                                                                                                                        <select name="<%=jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AP_COA_ID]%>">
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                                        for (int i = 0; i < accLinks.size(); i++) {
                                                                                                                            AccLink accLink = (AccLink) accLinks.get(i);
                                                                                                                            Coa coa = new Coa();
                                                                                                                            try {
                                                                                                                                coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            if (rItem.getApCoaId() == 0 && i == 0) {
                                                                                                                                rItem.setApCoaId(accLink.getCoaId());
                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <option <%if (rItem.getApCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, rItem.getApCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%= jspReceiveItemMemo.getErrorMsg(jspReceiveItemMemo.JSP_AP_COA_ID) %>
                                                                                                                    </td>
                                                                                                                    <td align="right" class="tablecell1">
                                                                                                                        <input type="hidden" name="hidden_amount" size="20" value="<%=JSPFormater.formatNumber(rItem.getAmount(), "#,###.##")%>" >
                                                                                                                        <input type="text" name="<%=jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]%>" size="20" value="<%=JSPFormater.formatNumber(rItem.getAmount(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchange()">&nbsp;<%if (iJSPCommand != JSPCommand.REFRESH) {%><%=jspReceiveItemMemo.getErrorMsg(jspReceiveItemMemo.JSP_AMOUNT) %> <%}%>&nbsp;&nbsp;
                                                                                                                    </td>
                                                                                                                    <td align="left" class="tablecell1">
                                                                                                                        &nbsp;&nbsp;<input type="text" size="50" name="<%=jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_MEMO]%>" size="15" value="<%=rItem.getMemo()%>" >
                                                                                                                    </td>                                                                                                                    
                                                                                                                </tr> 
                                                                                                                <%
                                                                                                                } else {
                                                                                                                %>
                                                                                                                <tr height="26">
                                                                                                                    <td class="tablecell1" >&nbsp;&nbsp;
                                                                                                                        <%if (receive.getStatus().compareTo(I_Project.DOC_STATUS_CHECKED) != 0) {%>
                                                                                                                        <a href="javascript:cmdEdit('<%=r%>')">
                                                                                                                            <%}%>
                                                                                                                            <%=c.getCode()%>-<%=c.getName()%>
                                                                                                                            <%if (receive.getStatus().compareTo(I_Project.DOC_STATUS_CHECKED) != 0) {%>
                                                                                                                        </a>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(rItem.getAmount(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                                    <td class="tablecell1" >&nbsp;&nbsp;<%=rItem.getMemo()%></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <%
                    }
                }
            }
                                                                                                                %>
                                                                                                                <%
            if (isEdit == false && iJSPCommand != JSPCommand.ASSIGN && iJSPCommand != JSPCommand.BACK && iJSPCommand != JSPCommand.DELETE) {
                if (!(iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SUBMIT)) {
                    isEditor = true;
                                                                                                                %>
                                                                                                                <tr height="26">
                                                                                                                    <td align="left" class="tablecell1" align="left">
                                                                                                                        <select name="<%=jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AP_COA_ID]%>">
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                                            for (int i = 0; i < accLinks.size(); i++) {
                                                                                                                                AccLink accLink = (AccLink) accLinks.get(i);
                                                                                                                                Coa coa = new Coa();
                                                                                                                                try {
                                                                                                                                    coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                                } catch (Exception e) {
                                                                                                                                }

                                                                                                                                if (receiveItem.getApCoaId() == 0 && i == 0) {
                                                                                                                                    receiveItem.setApCoaId(accLink.getCoaId());
                                                                                                                                }
                                                                                                                            %>
                                                                                                                            <option <%if (receiveItem.getApCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, receiveItem.getApCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%= jspReceiveItemMemo.getErrorMsg(jspReceiveItemMemo.JSP_AP_COA_ID) %>
                                                                                                                    </td>
                                                                                                                    <td align="right" class="tablecell1">
                                                                                                                        <input type="hidden" name="hidden_amount" size="20" value="<%=JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##")%>" >
                                                                                                                        <input type="text" name="<%=jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_AMOUNT]%>" size="20" value="<%=JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchange()">&nbsp;<%if (iJSPCommand != JSPCommand.REFRESH) {%><%=jspReceiveItemMemo.getErrorMsg(jspReceiveItemMemo.JSP_AMOUNT) %> <%}%>
                                                                                                                    </td>
                                                                                                                    <td align="left" class="tablecell1">
                                                                                                                        <input type="text" size="50" name="<%=jspReceiveItemMemo.colNames[jspReceiveItemMemo.JSP_MEMO]%>" size="15" value="<%=receiveItem.getMemo()%>" >
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="25" valign="top">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <%if (receive.getStatus().compareTo(I_Project.DOC_STATUS_CHECKED) != 0) {%>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="35" valign="top">
                                                                                                            <table>                                                                                                                
                                                                                                                <tr>
                                                                                                                    <%if (isEditor) {%>
                                                                                                                    <td><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/save2.gif',1)"><img src="../images/save.gif" name="savedoc21" height="22" border="0"></a></td>                                                                                                                   
                                                                                                                    <%} else {%>                                                                                                                
                                                                                                                    <td><a href="javascript:cmdAddDetail('<%=receive.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','../images/add2.gif',1)"><img src="../images/add.gif" name="add" height="22" border="0"></a></td>                                                                                                                
                                                                                                                    <%}%>                                                                                                                    
                                                                                                                    <%if (isEdit) {%>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:cmdDelete('<%=receive.getOID()%>','<%=recIdx%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del','','../images/del2.gif',1)"><img src="../images/del.gif" name="del" border="0"></a>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%if (isEditor) {%>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('can','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="can" border="0"></a>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                </tr>    
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>  
                                                                                                    <%if (receiveItems != null && receiveItems.size() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr> 
                                                                                                        <td height="35" valign="top">
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                                                                                    <td width="20">&nbsp;</td>
                                                                                                                    <td><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="newdox" height="22" border="0"></a></td>
                                                                                                                </tr>    
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>       
                                                                                                    <%}%>
                                                                                                    <%} else {%>
                                                                                                    <tr>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr> 
                                                                                                                    <td width="15"><img src="../images/success.gif" height="20"></td>
                                                                                                                    <td width="100" nowrap>POSTED</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="4"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td >
                                                                                                            <a href="javascript:cmdToRecord()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0"></a>
                                                                                                        </td>                                                                                                
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if (receive.getOID() != 0) {%>
                                                                                                    <tr> 
                                                                                                        <td height="25" valign="top">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr> 
                                                                                                        <td height="35" valign="top">                                                                                                            
                                                                                                            <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><b><u>Document 
                                                                                                                    History</u></b></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>User</u></b></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>Date</u></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Prepared 
                                                                                                                    By</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(receive.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <%if (receive.getDate() != null) {%>
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(receive.getDate(), "dd MMMM yy")%></i></div>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Approved by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(receive.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (receive.getApproval1() != 0 && receive.getApproval1Date() != null) {%>
                                                                                                                                <%=JSPFormater.formatDate(receive.getApproval1Date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Posted by</i> </td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(receive.getApproval3());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%if (receive.getApproval3() != 0 && receive.getApproval3Date() != null) {%>
                                                                                                                                <%=JSPFormater.formatDate(receive.getApproval3Date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="35" valign="top">&nbsp;</td>
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
                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>                                                        
                                                    </td>
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
