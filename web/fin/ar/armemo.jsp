
<%-- 
    Document   : armemo
    Created on : Nov 9, 2012, 2:45:55 PM
    Author     : Roy Andika
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
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
            long oidARInvoice = JSPRequestValue.requestLong(request, "hidden_ar_invoice_id");
            long oidARInvoiceDetail = JSPRequestValue.requestLong(request, "hidden_ar_invoice_detail_id");
            long customerId = JSPRequestValue.requestLong(request, "JSP_CUSTOMER_ID");
            String txtCustomer = JSPRequestValue.requestString(request, "txt_customer");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");

            boolean commandNone = false;

            if (iJSPCommand == JSPCommand.ADD) {
                oidARInvoice = 0;
                txtCustomer = "";
                customerId = 0;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                if (session.getValue("ARMEMO_TITTLE") != null) {
                    session.removeValue("ARMEMO_TITTLE");
                }
                if (session.getValue("ARMEMO_DETAIL") != null) {
                    session.removeValue("ARMEMO_DETAIL");
                }
                commandNone = true;
                iJSPCommand = JSPCommand.ADD;
                oidARInvoice = 0;
                txtCustomer = "";
                customerId = 0;
            }

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            int iErrCode2 = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdARInvoiceDetail cmdARInvoiceDetail = new CmdARInvoiceDetail(request);

            JspARInvoiceDetail jspARInvoiceDetail = cmdARInvoiceDetail.getForm();
            ARInvoiceDetail arInvoicDetail = cmdARInvoiceDetail.getARInvoiceDetail();

            if ((iJSPCommand == JSPCommand.SUBMIT)) {

                long coaAr = JSPRequestValue.requestLong(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_COA_ID]);

                Coa coax = new Coa();
                try {
                    coax = DbCoa.fetchExc(coaAr);
                } catch (Exception e) {
                }
                if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspARInvoiceDetail.addError(jspARInvoiceDetail.JSP_COA_ID, "postable account type required");
                    iErrCode2 = iErrCode2 + 1;
                }
                double tmpAmount = JSPRequestValue.requestDouble(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]);
                if (tmpAmount == 0) {
                    jspARInvoiceDetail.addError(jspARInvoiceDetail.JSP_TOTAL_AMOUNT, "amount can't 0");
                    iErrCode2 = iErrCode2 + 1;
                }
            }

            CmdARInvoiceMemo cmdARInvoice = new CmdARInvoiceMemo(request);
            JSPLine ctrLine = new JSPLine();
            JspARInvoiceMemo jspARInvoice = cmdARInvoice.getForm();

            iErrCode = cmdARInvoice.action(iJSPCommand, oidARInvoice, iErrCode2);

            ARInvoice arInvoice = cmdARInvoice.getARInvoice();
            msgString = cmdARInvoice.getMessage();
            
            if (arInvoice.getCustomerId() != 0) {
                try {
                    Customer cst = DbCustomer.fetchExc(arInvoice.getCustomerId());
                    customerId = arInvoice.getCustomerId();
                    txtCustomer = cst.getName();
                } catch (Exception e) {
                }
            }
%> 

<%
            String msgString2 = "";
            msgString2 = cmdARInvoice.getMessage();
            whereClause = DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID] + "=" + oidARInvoice;
            orderClause = "";
            Vector arInvoiceItems = new Vector();

            if (commandNone || iJSPCommand == JSPCommand.ACTIVATE || iJSPCommand == JSPCommand.ASSIGN) {
                arInvoiceItems = DbARInvoiceDetail.list(whereClause, null);
            } else {
                if (session.getValue("ARMEMO_DETAIL") != null) {
                    arInvoiceItems = (Vector) session.getValue("ARMEMO_DETAIL");
                }
            }

            double subTotal = 0;

            if (iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.SUBMIT) {
                boolean isEdt = false;
                
                if (arInvoiceItems != null && arInvoiceItems.size() > 0) {
                    for (int i = 0; i < arInvoiceItems.size(); i++) {
                        ARInvoiceDetail ri = (ARInvoiceDetail) arInvoiceItems.get(i);
                        if (recIdx == i) {
                            isEdt = true;
                            ri.setCoaId(JSPRequestValue.requestLong(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_COA_ID ]));                            
                            ri.setTotalAmount(JSPRequestValue.requestDouble(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]));
                            ri.setMemo(JSPRequestValue.requestString(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_MEMO]));
                            ri.setArInvoiceId(arInvoice.getOID());
                        }
                        subTotal = subTotal + ri.getTotalAmount();
                    }
                }
                
                if (isEdt == false && iJSPCommand != JSPCommand.SAVE) {
                    
                    ARInvoiceDetail ri = new ARInvoiceDetail();
                    ri.setOID(0);
                    ri.setCoaId(JSPRequestValue.requestLong(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_COA_ID]));
                    ri.setQty(1);                    
                    ri.setPrice(JSPRequestValue.requestDouble(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]));                    
                    ri.setTotalAmount(JSPRequestValue.requestDouble(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]));                    
                    ri.setMemo(JSPRequestValue.requestString(request, jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_MEMO]));
                    ri.setDiscount(0);
                    ri.setDepartmentId(0);
                    ri.setCompanyId(0);
                    
                    subTotal = subTotal + ri.getTotalAmount();
                    
                    if (iErrCode == 0 && iErrCode2 == 0) {
                        arInvoiceItems.add(ri);
                    } else {
                        arInvoicDetail.setTotalAmount(ri.getTotalAmount());                        
                        arInvoicDetail.setMemo(ri.getMemo());
                        arInvoicDetail.setCoaId(ri.getCoaId());
                    }
                }
                
                recIdx = -1;
            } else {
                subTotal = DbARInvoiceDetail.getTotalAmount(oidARInvoice);
            }
            if ((iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE)) {
                DbARInvoiceDetail.insertARItem(arInvoice.getOID(), arInvoiceItems);                
                recIdx = -1;
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0){
                if (arInvoiceItems != null && arInvoiceItems.size() > 0) {
                    for (int i = 0; i < arInvoiceItems.size(); i++) {
                        ARInvoiceDetail ri = (ARInvoiceDetail) arInvoiceItems.get(i);
                        if (i == recIdx) {
                            if (ri.getOID() != 0) {
                                DbARInvoiceDetail.deleteExc(ri.getOID());
                            }
                            arInvoiceItems.remove(i);
                            break;
                        }
                    }
                }
                
                double tmpAmount = DbARInvoiceDetail.getTotalAmount(arInvoice.getOID());
                tmpAmount = tmpAmount * -1;
                DbARInvoiceDetail.updateAmount(arInvoice.getOID(),tmpAmount);
                arInvoice.setTotal(tmpAmount);
                
            }

            String[] langAR = {"Date", "Member", "Doc Number", "Period", "Date", "Member", "Invoice", "Amount", "Memo", "Amount", "Status", "Saved", "Delete Success", "Location", "Account", "Amount", "Memo", "Note"};
            String[] langNav = {"Account Receivable", "AR Memo", "Record", "Editor", "Chose member first", "Delete data ?", "Number"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Member", "Doc Number", "Periode", "Tanggal", "Member", "Faktur", "Jumlah", "Memo", "Jumlah", "Status", "Data Tersimpan", "Hapus data berhasil", "Lokasi", "Perkiraan", "Jumlah", "Keterangan", "Catatan"};
                langAR = langID;

                String[] navID = {"Piutang", "AR Memo", "Record", "Editor", "Pilih member terlebih dahulu", "Hapus data ?", "Nomor"};
                langNav = navID;
            }

            Vector accARLinks = DbAccLink.list(0, 0, "type='" + I_Project.ALL_LINK_ACCOUNT_RECEIVABLE + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ALL_LINK_ACCOUNT_RECEIVABLE_PAY_RECEIVER + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");

            long currencyId = 0;
            try {
                currencyId = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
            } catch (Exception e) {
            }

            session.putValue("ARMEMO_DETAIL", arInvoiceItems);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
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
            
            function cmdSearchMember(){
                window.open("<%=approot%>/ar/srcmember.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function cmdUpdateExchange(){       
                    var famount = document.frmarapmemo.<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]%>.value;                
                    famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);                      
                    
                    var total = document.frmarapmemo.<%=jspARInvoice.colNames[jspARInvoice.JSP_TOTAL]%>.value;                   
                    total = removeChar(total)
                    total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);                  
                    var htotal = document.frmarapmemo.hidden_amount.value;                
                    htotal = cleanNumberFloat(htotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);                  
                    total = parseFloat(total) - parseFloat(htotal) + parseFloat(famount);
                    
                    document.frmarapmemo.<%=jspARInvoice.colNames[jspARInvoice.JSP_TOTAL]%>.value= formatFloat(parseFloat(total), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                    
                    if(!isNaN(famount)){
                        document.frmarapmemo.<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]%>.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                        
                        document.frmarapmemo.hidden_amount.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                        
                    }            
                }
                
                function checkNumber(){
                    var st = document.frmarapmemo.<%=jspARInvoice.colNames[jspARInvoice.JSP_TOTAL]%>.value;		                        
                    result = removeChar(st);                        
                    result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    document.frmarapmemo.<%=jspARInvoice.colNames[jspARInvoice.JSP_TOTAL]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                }            
                
                
                function cmdToRecord(){
                    document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";
                    document.frmarapmemo.action="armemolist.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdResetAll(){
                    document.frmarapmemo.txt_customer.value="";
                    document.frmarapmemo.JSP_CUSTOMER_ID.value="0";                  
                }
                
                function cmdAskDoc(){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value="0";
                    document.frmarapmemo.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdDelete(arInvoiceId,idx){
                    var cfrm = confirm('Delete data ?');                    
                    if( cfrm==true){    
                        document.frmarapmemo.hidden_ar_invoice_id.value=arInvoiceId;
                        document.frmarapmemo.select_idx.value = idx;
                        document.frmarapmemo.hidden_ar_invoice_detail_id.value="0";
                        document.frmarapmemo.command.value="<%=JSPCommand.DELETE%>";
                        document.frmarapmemo.action="armemo.jsp";
                        document.frmarapmemo.submit();
                    }
                }
                
                function cmdCancelDoc(){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value="0";
                    document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdSaveDoc(){
                    document.frmarapmemo.command.value="<%=JSPCommand.POST%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdAdd(){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value="0";
                    document.frmarapmemo.command.value="<%=JSPCommand.ADD%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdAddDetail(arInvoiceId){
                    document.frmarapmemo.hidden_ar_invoice_id.value=arInvoiceId;
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value="0";
                    document.frmarapmemo.command.value="<%=JSPCommand.ACTIVATE%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdAsk(oidReceiveItem){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value=oidReceiveItem;
                    document.frmarapmemo.command.value="<%=JSPCommand.ASK%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdAskMain(oidARInvoice){
                    document.frmarapmemo.hidden_ar_invoice_id.value=oidARInvoice;
                    document.frmarapmemo.command.value="<%=JSPCommand.ASK%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="receive.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdConfirmDelete(oidReceiveItem){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value=oidReceiveItem;
                    document.frmarapmemo.command.value="<%=JSPCommand.DELETE%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdSave(){         
                    document.frmarapmemo.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();             
                }
                
                function cmdSubmitCommand(oidARInvoice){                    
                    document.frmarapmemo.hidden_ar_invoice_id.value=oidARInvoice;
                    document.frmarapmemo.command.value="<%=JSPCommand.SAVE%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();             
                }
                
                function cmdEdit(oidARInvoice){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value=oidARInvoice;
                    document.frmarapmemo.select_idx.value = oidARInvoice;
                    document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdCancel(oidARInvoice){
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value=oidARInvoice;
                    document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdBack(){
                    document.frmarapmemo.command.value="<%=JSPCommand.BACK%>";
                    document.frmarapmemo.select_idx.value = -1;
                    document.frmarapmemo.action="armemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdNewJournal(){
                    document.frmarapmemo.hidden_ar_invoice_id.value=0;
                    document.frmarapmemo.hidden_ar_invoice_detail_id.value=0;
                    document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
                    document.frmarapmemo.action="armemo.jsp";
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
                                                            <input type="hidden" name="hidden_ar_invoice_detail_id" value="<%=oidARInvoiceDetail%>">
                                                            <input type="hidden" name="hidden_ar_invoice_id" value="<%=oidARInvoice%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_CREATE_ID]%>" value="<%=appSessUser.getUserOID()%>">                                                           
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                                                      
                                                            <input type="hidden" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_TYPE_AR]%>" value="<%=DbARInvoice.TYPE_AR_MEMO%>">                                                            
                                                            <input type="hidden" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>">
                                                            <input type="hidden" name="select_idx" value="<%=recIdx%>">
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
            String navigator = "<font class=\"lvl1\">&nbsp;" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
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
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;AR Memo &nbsp;&nbsp;</div>
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
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" valign="middle" width="12%">&nbsp;</td>                                                                
                                                                                                        <td height="21" valign="middle" width="37%">&nbsp;</td>                                                                
                                                                                                        <td height="21" valign="middle" width="9%">&nbsp;</td>                                                                
                                                                                                        <td height="21" colspan="2" width="42%" class="comment" valign="top"> 
                                                                                                            <div align="right"><i>Date : 
                                                                                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                                                                                    <%if (arInvoice.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(arInvoice.getCreateId());
    } catch (Exception e) {
    }
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                  
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" width="12%">&nbsp;</td>
                                                                                                        <td height="5" width="37%">*) data required</td>
                                                                                                        <td height="5" colspan="2"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="4"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;<%=langAR[2]%></td>                                                                                                        
                                                                                                        <td height="20" width="37%"> 
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
            if (arInvoice.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(arInvoice.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (preClosedPeriod.getOID() != 0) {
                    open = DbPeriode.getPreClosedPeriod();
                } else {
                    open = DbPeriode.getOpenPeriod();
                }
            }

            int counterJournal = DbSystemDocNumber.getNextCounterArMemo(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberArMemo(counterJournal, open.getOID());
            if (arInvoice.getOID() != 0 || oidARInvoice != 0) {
                strNumber = arInvoice.getJournalNumber();
            }
                                                                                                            %>
                                                                                                            <%=strNumber%>                                                                    
                                                                                                        </td>               
                                                                                                        <%

                                                                                                        %>
                                                                                                        <td height="20" width="9%"><%=langAR[3]%></td>                                                                                                        
                                                                                                        <td height="20" colspan="2" width="42%" class="comment"> 
                                                                                                            <select name="<%=jspARInvoice.colNames[jspARInvoice.JSP_PERIODE_ID]%>">
                                                                                                                <%
            if (periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);

                                                                                                                %>
                                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == arInvoice.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                <%}%><%}%>
                                                                                                            </select>  
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%" valign="middle">&nbsp;&nbsp;<%=langAR[1]%></td>                                                                                                        
                                                                                                        <td height="20" width="37%"> 
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input size="30" readonly type="text" name="txt_customer" value="<%=txtCustomer%>">
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <input type="hidden" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_CUSTOMER_ID]%>" value="<%=customerId%>">
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;<a href="javascript:cmdSearchMember()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;<a href="javascript:cmdResetAll()" >Reset</a>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;<%=jspARInvoice.getErrorMsg(jspARInvoice.JSP_CUSTOMER_ID)%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="9%" height="20"><%=langAR[0]%></td>
                                                                                                        <td colspan="2" class="comment" width="42%" height="20"> 
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="<%=jspARInvoice.colNames[jspARInvoice.JSP_DATE]%>" value="<%=JSPFormater.formatDate((arInvoice.getDate() == null) ? new Date() : arInvoice.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.<%=jspARInvoice.colNames[jspARInvoice.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        &nbsp;<%=jspARInvoice.getErrorMsg(jspARInvoice.JSP_DATE)%>                                                                                                                                                                                                                                  
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                            </table>     
                                                                                                        </td>
                                                                                                    </tr>                                                                                                  
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Invoice Number</td>                                                                                                        
                                                                                                        <td height="21" width="37%"> 
                                                                                                            <input type="text" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_INVOICE_NUMBER]%>" value="<%=arInvoice.getInvoiceNumber() %>" size="20">
                                                                                                        </td>
                                                                                                        <td width="9%"><%=langAR[7]%> Rp.</td>
                                                                                                        <td colspan="2" class="comment" width="42%">
                                                                                                            <input type="text" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_TOTAL]%>" value="<%=JSPFormater.formatNumber(arInvoice.getTotal(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkNumber()" class="readonly" readOnly size="20">
                                                                                                            <input type="hidden" name = "<%=jspARInvoice.colNames[jspARInvoice.JSP_CURRENCY_ID]%>" value = "<%=currencyId%>">                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">&nbsp;&nbsp;<%=langAR[14]%></td>
                                                                                                        <td height="21" valign="top">
                                                                                                            <select name="<%=jspARInvoice.colNames[jspARInvoice.JSP_COA_AR_ID]%>">
                                                                                                                <%if (accARLinks != null && accARLinks.size() > 0) {
                for (int i = 0; i < accARLinks.size(); i++) {
                    AccLink accLink = (AccLink) accARLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                    }

                    if (arInvoice.getCoaARId() == 0 && i == 0) {
                        arInvoice.setCoaARId(accLink.getCoaId());
                    }
                                                                                                                %>
                                                                                                                <option <%if (arInvoice.getCoaARId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                <%=getAccountRecursif(coa.getLevel() * -1, coa, arInvoice.getCoaARId(), isPostableOnly)%> 
                                                                                                                <%}
} else {%>
                                                                                                                <option><%=langNav[3]%></option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                            <%= jspARInvoice.getErrorMsg(jspARInvoice.JSP_COA_AR_ID) %>
                                                                                                        </td>
                                                                                                        <td width="9%" valign="top"><%=langAR[13]%></td>
                                                                                                        <td colspan="2" class="comment" width="42%" valign="top">
                                                                                                             <select name="<%=jspARInvoice.colNames[jspARInvoice.JSP_LOCATION_ID]%>">
                                                                                                                <%
            Vector locations;
            
            locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (arInvoice.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">&nbsp;&nbsp;<%=langAR[17]%></td>
                                                                                                        <td height="21" > 
                                                                                                            <textarea name="<%=jspARInvoice.colNames[jspARInvoice.JSP_MEMO]%>" cols="40" rows="2"><%=arInvoice.getMemo()%></textarea>
                                                                                                            <%= jspARInvoice.getErrorMsg(jspARInvoice.JSP_MEMO) %>                                                                                                            
                                                                                                        </td>
                                                                                                        <td width="9%"></td>
                                                                                                        <td colspan="2" class="comment" width="42%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">&nbsp;&nbsp;<%=langAR[10]%></td>
                                                                                                        <td height="21" > 
                                                                                                            <%if (arInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_POSTED) {%>                                                                                                            
                                                                                                            <input type="hidden" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_DOC_STATUS]%>" value="<%=arInvoice.getDocStatus()%>" >
                                                                                                            POSTED
                                                                                                            <%} else {%>                                                                                                                                                                                                                        
                                                                                                            <select name="<%=jspARInvoice.colNames[jspARInvoice.JSP_DOC_STATUS]%>">
                                                                                                                <option value="<%=DbARInvoice.TYPE_STATUS_DRAFT%>" <%if (arInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_DRAFT) {%> selected <%}%> >DRAFT</option>
                                                                                                                <option value="<%=DbARInvoice.TYPE_STATUS_APPROVED%>" <%if (arInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_APPROVED) {%> selected <%}%> >APPROVED</option>
                                                                                                            </select>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="9%"></td>
                                                                                                        <td colspan="2" class="comment" width="42%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">
                                                                                                            <table width="800" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr>
                                                                                                                    <td class="tablehdr" width="40%"><font size="1"><%=langAR[14]%></font></td>
                                                                                                                    <td class="tablehdr" width="20%"><font size="1"><%=langAR[15]%></font></td>
                                                                                                                    <td class="tablehdr" width="40%"><font size="1"><%=langAR[16]%></font></td>
                                                                                                                </tr>
                                                                                                                <%
            boolean isEdit = false;
            boolean isEditor = false;

            if (arInvoiceItems != null && arInvoiceItems.size() > 0) {

                for (int r = 0; r < arInvoiceItems.size(); r++) {
                    ARInvoiceDetail rItem = (ARInvoiceDetail) arInvoiceItems.get(r);

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(rItem.getCoaId());
                    } catch (Exception e) {
                    }

                                                                                                                %>        
                                                                                                                
                                                                                                                <%
                                                                                                                        if (recIdx == r) {
                                                                                                                            isEdit = true;
                                                                                                                            isEditor = true;
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td align="left" class="tablecell1">&nbsp;&nbsp;
                                                                                                                        <select name="<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_COA_ID]%>">
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                                        for (int i = 0; i < accLinks.size(); i++) {
                                                                                                                            AccLink accLink = (AccLink) accLinks.get(i);
                                                                                                                            Coa coa = new Coa();
                                                                                                                            try {
                                                                                                                                coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            if (rItem.getCoaId() == 0 && i == 0) {
                                                                                                                                rItem.setCoaId(accLink.getCoaId());
                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <option <%if (rItem.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, rItem.getCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%= jspARInvoiceDetail.getErrorMsg(jspARInvoiceDetail.JSP_COA_ID) %>
                                                                                                                    </td>
                                                                                                                    <td align="right" class="tablecell1">
                                                                                                                        <input type="hidden" name="hidden_amount" size="20" value="<%=JSPFormater.formatNumber(rItem.getTotalAmount(), "#,###.##")%>" >
                                                                                                                        <input type="text" name="<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]%>" size="20" value="<%=JSPFormater.formatNumber(rItem.getTotalAmount(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchange()">&nbsp;<%if (iJSPCommand != JSPCommand.REFRESH) {%><%=jspARInvoiceDetail.getErrorMsg(jspARInvoiceDetail.JSP_TOTAL_AMOUNT) %> <%}%>
                                                                                                                    </td>
                                                                                                                    <td align="laft" class="tablecell1">
                                                                                                                        &nbsp;&nbsp;<input type="text" size="50" name="<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_MEMO]%>" size="15" value="<%=rItem.getMemo()%>" >
                                                                                                                    </td>                                                                                                                    
                                                                                                                </tr> 
                                                                                                                <%
                                                                                                                } else {
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" >&nbsp;&nbsp;
                                                                                                                        <%if (arInvoice.getDocStatus() != DbARInvoice.TYPE_STATUS_POSTED) {%>
                                                                                                                        <a href="javascript:cmdEdit('<%=r%>')">
                                                                                                                            <%}%>
                                                                                                                            <%=c.getCode()%>-<%=c.getName()%>
                                                                                                                            <%if (arInvoice.getDocStatus() != 1) {%>
                                                                                                                        </a>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(rItem.getTotalAmount(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                                    <td class="tablecell1" >&nbsp;&nbsp;<%=rItem.getMemo()%></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <%
                    }
                }
            }
                                                                                                                %>
                                                                                                                <%
            if (isEdit == false && iJSPCommand != JSPCommand.ASSIGN && iJSPCommand != JSPCommand.BACK && iJSPCommand != JSPCommand.DELETE) {
                if (!(iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE)) {
                    isEditor = true;
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td align="left" class="tablecell1">
                                                                                                                        <select name="<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_COA_ID]%>">
                                                                                                                            <%if (accLinks != null && accLinks.size() > 0) {
                                                                                                                            for (int i = 0; i < accLinks.size(); i++) {
                                                                                                                                AccLink accLink = (AccLink) accLinks.get(i);
                                                                                                                                Coa coa = new Coa();
                                                                                                                                try {
                                                                                                                                    coa = DbCoa.fetchExc(accLink.getCoaId());
                                                                                                                                } catch (Exception e) {
                                                                                                                                }

                                                                                                                                if (arInvoicDetail.getCoaId() == 0 && i == 0) {
                                                                                                                                    arInvoicDetail.setCoaId(accLink.getCoaId());
                                                                                                                                }
                                                                                                                            %>
                                                                                                                            <option <%if (arInvoicDetail.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coa.getLevel() * -1, coa, arInvoicDetail.getCoaId(), isPostableOnly)%> 
                                                                                                                            <%}
} else {%>
                                                                                                                            <option><%=langNav[3]%></option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%= jspARInvoiceDetail.getErrorMsg(jspARInvoiceDetail.JSP_COA_ID) %>
                                                                                                                    </td>
                                                                                                                    <td align="right" class="tablecell1">
                                                                                                                        <input type="hidden" name="hidden_amount" size="20" value="<%=JSPFormater.formatNumber(arInvoicDetail.getTotalAmount(), "#,###.##")%>" >
                                                                                                                        <input type="text" name="<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_TOTAL_AMOUNT]%>" size="20" value="<%=JSPFormater.formatNumber(arInvoicDetail.getTotalAmount(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchange()">&nbsp;<%if (iJSPCommand != JSPCommand.REFRESH) {%><%=jspARInvoiceDetail.getErrorMsg(jspARInvoiceDetail.JSP_TOTAL_AMOUNT) %> <%}%>
                                                                                                                    </td>
                                                                                                                    <td align="left" class="tablecell1">
                                                                                                                        <input type="text" size="50" name="<%=jspARInvoiceDetail.colNames[jspARInvoiceDetail.JSP_MEMO]%>" size="15" value="<%=arInvoicDetail.getMemo()%>" >
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td colspan="5" height="25" valign="top">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <%if (arInvoice.getDocStatus() != DbARInvoice.TYPE_STATUS_POSTED) {%>
                                                                                                    <tr align="left"> 
                                                                                                        <td colspan="5" height="35" valign="top">
                                                                                                            <table>                                                                                                                
                                                                                                                <tr>
                                                                                                                    <%if (isEditor) {%>
                                                                                                                    <td><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/save2.gif',1)"><img src="../images/save.gif" name="savedoc21" height="22" border="0"></a></td>                                                                                                                   
                                                                                                                    <%} else {%>                                                                                                                
                                                                                                                    <td><a href="javascript:cmdAddDetail('<%=arInvoice.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','../images/add2.gif',1)"><img src="../images/add.gif" name="add" height="22" border="0"></a></td>                                                                                                                
                                                                                                                    <%}%>                                                                                                                    
                                                                                                                    <%if (isEdit) {%>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:cmdDelete('<%=arInvoice.getOID()%>','<%=recIdx%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del','','../images/del2.gif',1)"><img src="../images/del.gif" name="del" border="0"></a>
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
                                                                                                    <%if (arInvoiceItems != null && arInvoiceItems.size() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="35" valign="top">
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td><a href="javascript:cmdSubmitCommand('<%=arInvoice.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                                                                                    <td width="10">&nbsp;</td>
                                                                                                                    <td><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newdox','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="newdox" height="22" border="0"></a></td>
                                                                                                                </tr>    
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>       
                                                                                                    <%}%>
                                                                                                    <%} else {%>
                                                                                                    <tr>
                                                                                                        <td colspan="5">
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr> 
                                                                                                                    <td width="15"><img src="../images/success.gif" height="20"></td>
                                                                                                                    <td width="100" nowrap>POSTED</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="5" height="4"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td colspan="5">
                                                                                                            <a href="javascript:cmdToRecord()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0"></a>
                                                                                                        </td>                                                                                                
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if (arInvoice.getOID() != 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="25" valign="top">&nbsp;</td>
                                                                                                    </tr>    
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="35" valign="top">
                                                                                                            
                                                                                                            <table width="500" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><b><u>Document History</u></b></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>User</u></b></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>Date</u></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Prepared By</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(arInvoice.getCreateId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <%if (arInvoice.getDate() != null) {%>
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(arInvoice.getCreateDate(), "dd MMMM yy")%></i></div>
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
        u = DbUser.fetch(arInvoice.getApproval1Id());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (arInvoice.getApproval1Id() != 0 && arInvoice.getApproval1Date() != null) {%>
                                                                                                                                <%=JSPFormater.formatDate(arInvoice.getApproval1Date(), "dd MMMM yy")%> 
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
        u = DbUser.fetch(arInvoice.getPostedId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%if (arInvoice.getPeriodeId() != 0 && arInvoice.getPostedDate() != null) {%>
                                                                                                                                <%=JSPFormater.formatDate(arInvoice.getPostedDate(), "dd MMMM yy")%> 
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
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
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
