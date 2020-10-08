
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true; boolean privUpdate = true; boolean privDelete = true;
%>
<!-- Jsp Block -->
<%@ include file = "invoice_edit_function.jsp" %>
<%

            if (session.getValue("PURCHASE_TITTLE") != null) {
                session.removeValue("PURCHASE_TITTLE");
            }

            if (session.getValue("PURCHASE_DETAIL") != null) {
                session.removeValue("PURCHASE_DETAIL");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            
            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdReceive cmdReceive = new CmdReceive(request);
            JSPLine ctrLine = new JSPLine();
            JspReceive jspReceive = cmdReceive.getForm();
            Receive receive = cmdReceive.getReceive();
            msgString = cmdReceive.getMessage();

            if (oidReceive == 0) {
                oidReceive = receive.getOID();
                receive.setStatus(I_Project.DOC_STATUS_DRAFT);
            }

            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");

            /*variable declaration*/
            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            SessIncomingGoods ig = new SessIncomingGoods();

            CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);
            JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
            ReceiveItem receiveItem = cmdReceiveItem.getReceiveItem();
            msgString2 = cmdReceiveItem.getMessage();

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
            Vector purchItems = DbReceiveItem.list(0, 0, whereClause, orderClause);
            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (receive.getVendorId() == 0) {
                if (vendors != null && vendors.size() > 0) {
                    Vendor vx = (Vendor) vendors.get(0);
                    receive.setVendorId(vx.getOID());
                }
            }

            String whereCls = ""; Vector vendorItems = new Vector();

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE){
                iJSPCommand = JSPCommand.ADD;
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0){
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                //delete item, load receive
                try {
                    receive = DbReceive.fetchExc(oidReceive);
                } catch (Exception e) {
                }
            }

            double subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);
            Vector errorx = new Vector();

            if (iJSPCommand == JSPCommand.ACTIVATE){

                boolean isError = false;
                long unitUsahaId = JSPRequestValue.requestLong(request, JspReceive.colNames[JspReceive.JSP_UNIT_USAHA_ID]);
                UnitUsaha us = new UnitUsaha();
                
                try {
                    us = DbUnitUsaha.fetchExc(unitUsahaId);
                } catch (Exception e) {}

                if (purchItems != null && purchItems.size() > 0){
                    for (int i = 0; i < purchItems.size(); i++) {
                        ReceiveItem ri = (ReceiveItem) purchItems.get(i);
                        long oidx = us.getCoaApId();
                        if (oidx != 0) {
                            try {
                                Coa coa = DbCoa.fetchExc(oidx);
                                if (coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                                    if (coa.getAccountClass() != DbCoa.ACCOUNT_CLASS_SP){
                                        ri = DbReceiveItem.fetchExc(ri.getOID());
                                        ri.setApCoaId(oidx);
                                        DbReceiveItem.updateExc(ri);
                                        errorx.add("");
                                    } else {
                                        isError = true;
                                        errorx.add("<span class=\"errfont\">non SP account required</span>");
                                    }
                                } else {
                                    isError = true;
                                    errorx.add("<span class=\"errfont\">non postable account</span>");
                                }
                            } catch (Exception e) {
                            }
                        } else {
                            isError = true;
                            errorx.add("<span class=\"errfont\">account AP required</span>");
                        }
                    }
                }

                if (!isError) {

                    iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                    jspReceive = cmdReceive.getForm();
                    receive = cmdReceive.getReceive();
                    msgString = cmdReceive.getMessage();
                    //jika sudah diapprove, lakukan posting jurnal
                    
                    if (receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){
                        //out.println("start - posting journal");
                        DbReceive.postJournal(receive);
                    }
                    
                } else {
                    //kalau error batalkan proses update
                    iJSPCommand = JSPCommand.EDIT;
                    iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                    jspReceive = cmdReceive.getForm();
                    receive = cmdReceive.getReceive();
                    msgString = "incompleted data input, please check again";
                }

            } else {
                iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                jspReceive = cmdReceive.getForm();
                receive = cmdReceive.getReceive();
                msgString = cmdReceive.getMessage();
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            
            function cmdPrintDoc(){
                
                window.open("<%=printrootinv%>.report.RptIncomingGoodsPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                var usrDigitGroup = "<%=sUserDigitGroup%>";
                var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                
                function removeChar(number){
                    
                    var ix;
                    var result = "";
                    for(ix=0; ix<number.length; ix++){
                        var xx = number.charAt(ix);
                        //alert(xx);
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
                
                function parserMaster(){
                    var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value;
         <%if (vendorItems != null && vendorItems.size() > 0) {
                for (int i = 0; i < vendorItems.size(); i++) {
                    //Vector v = (Vector)vendorItems.get(i);				
                    //ItemMaster imx = (ItemMaster)v.get(0);			
                    //Uom uom = (Uom)v.get(3);
                    //VendorItem vix = (VendorItem)v.get(4);
                    ItemMaster im = (ItemMaster) vendorItems.get(i);
                    Uom uom = new Uom();
                    try {
                        uom = DbUom.fetchExc(im.getUomPurchaseId());
                    } catch (Exception e) {
                    }
         %>
             if('<%=im.getOID()%>'==str){
                 document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value = formatFloat('<%=im.getCogs()%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                 document.frmreceive.unit_code.value="<%=uom.getUnit()%>";
             }
         <%}
            }%>
            
            calculateSubTotal();
            
        }
        
        function calculateSubTotal(){
            var amount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value;
            var qty = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value;
            var discount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value;
            
            amount = removeChar(amount);
            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            qty = removeChar(qty);
            qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value = qty;
            
            discount = removeChar(discount);
            discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
            document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var subtot = document.frmreceive.sub_tot.value;
            subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            //alert("amount : "+amount);
            //alert("subtot : "+subtot);
            //alert("(amount + subtot) : "+(parseFloat(amount) + parseFloat(subtot)));
            
         <%
            //add
            if (oidReceiveItem == 0) {%>
                    document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                    <%} else {%>
                    var tempAmount = document.frmreceive.temp_item_amount.value;
                    document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
         <%}
         %>
             
             calculateAmount();
         }
         
         
         function cmdVatEdit(){
             var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
             if(parseInt(vat)==0){
                 document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";				
             }else{
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
         }
         
         calculateAmount();
     }
     
     function calculateAmount(){
         
         var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
         var taxPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value;
         taxPercent = removeChar(taxPercent);
         taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var discPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>.value;	
         discPercent = removeChar(discPercent);
         discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var subTotal = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
         subTotal = removeChar(subTotal);
         subTotal = cleanNumberFloat(subTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         //alert("********* calculate grand session *******");
         //alert("subTotal :"+subTotal);
         
         var totalDiscount = 0;
         if(parseFloat(discPercent)>0){
             totalDiscount = parseFloat(discPercent)/100 * parseFloat(subTotal);
         }
         
         var totalTax = 0;
         
         if(parseInt(vat)==0){
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";		
             //document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value="0.00";		
             totalTax = 0;
         }else{
         document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
         totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
     }
     
     var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
     
     
     
     document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
     document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
     document.frmreceive.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
     
 }
 
 function cmdClosedReason(){
     var st = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>.value;
     if(st=='CLOSED'){
         document.all.closingreason.style.display="";
     }
     else{
         document.all.closingreason.style.display="none";		
     }
 }
 
 function cmdVendor(){
     <%if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
     if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all receive item based on vendor item master. ')){
         document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
         document.frmreceive.action="invoice_edit.jsp";
         document.frmreceive.submit();
     }
     <%} else {%>
     document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
     document.frmreceive.action="invoice_edit.jsp";
     document.frmreceive.submit();
     //cmdVendorChange();
     <%}%>
 }
 
 function cmdToRecord(){
     document.frmreceive.command.value="<%=JSPCommand.NONE%>";
     document.frmreceive.action="invoicesrc.jsp";
     document.frmreceive.submit();
 }
 
 function cmdVendorChange(){
     var oid = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>.value;
         <%
            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor v = (Vendor) vendors.get(i);
                         %>
                             if('<%=v.getOID()%>'==oid){
                                 document.frmreceive.vnd_address.value="<%=v.getAddress()%>";
                             }
                         <%
                }
            }
         %>
             
         }
         
         
         function cmdCloseDoc(){
             document.frmreceive.action="<%=approot%>/home.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAskDoc(){
             document.frmreceive.hidden_receive_request_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdDeleteDoc(){
             document.frmreceive.hidden_receive_request_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdCancelDoc(){
             document.frmreceive.hidden_receive_request_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdSaveDoc(){
             document.frmreceive.command.value="<%=JSPCommand.ACTIVATE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAdd(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.ADD%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAsk(oidReceiveItem){
             document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
             document.frmreceive.command.value="<%=JSPCommand.ASK%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAskMain(oidReceive){
             document.frmreceive.hidden_receive_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.ASK%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receive.jsp";
             document.frmreceive.submit();
         }
         
         function cmdConfirmDelete(oidReceiveItem){
             document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
             document.frmreceive.command.value="<%=JSPCommand.DELETE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         function cmdSaveMain(){
             document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receive.jsp";
             document.frmreceive.submit();
         }
         
         function cmdSave(){
             document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdEdit(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdCancel(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdBack(){
             document.frmreceive.command.value="<%=JSPCommand.BACK%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListFirst(){
             document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListPrev(){
             document.frmreceive.command.value="<%=JSPCommand.PREV%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListNext(){
             document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListLast(){
             document.frmreceive.command.value="<%=JSPCommand.LAST%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
             document.frmreceive.action="invoice_edit.jsp";
             document.frmreceive.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/print2.gif','../images/close2.gif','../images/savedoc2.gif')">
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
            String navigator = "<font class=\"lvl1\">Account Payable</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Incoming Goods</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmreceive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_receive_item_id" value="<%=oidReceiveItem%>">
                                                            <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                                                            <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                                                                <div align="center">&nbsp;Incoming 
                                                                                                Goods &nbsp;&nbsp;</div>
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
                                                                                                        <td height="21" valign="middle" width="30%">&nbsp;</td>
                                                                                                        <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                                                                        <td height="21" colspan="2" class="comment" valign="top"> 
                                                                                                            <div align="right"><i>Date : 
                                                                                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                                                                                    <%if (receive.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(receive.getUserId());
    } catch (Exception e) {
    }
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <%
            Purchase purchase = new Purchase();
            if (receive.getPurchaseId() != 0) {
                ig.setOidGoods(receive.getPurchaseId());
                try {
                    purchase = DbPurchase.fetchExc(receive.getPurchaseId());
                } catch (Exception e) {
                }
                                                                                                    %>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;PO 
                                                                                                        Number</td>
                                                                                                        <td height="20" width="30%"> <b><%=purchase.getNumber()%> 
                                                                                                                <%ig.setPoNumber(purchase.getNumber());%>
                                                                                                        </b></td>
                                                                                                        <td height="20" width="11%">&nbsp;</td>
                                                                                                        <td height="20" colspan="2" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;PO 
                                                                                                        Date </td>
                                                                                                        <td height="20" width="30%"> <b><%=JSPFormater.formatDate(purchase.getPurchDate(), "dd/MM/yyyy")%> 
                                                                                                                <%ig.setPoDate(purchase.getPurchDate());%>
                                                                                                        </b></td>
                                                                                                        <td height="20" width="11%">&nbsp;</td>
                                                                                                        <td height="20" colspan="2" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;Vendor</td>
                                                                                                        <td height="20" width="30%"> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PURCHASE_ID]%>" value="<%=purchase.getOID()%>">
                                                                                                            <%

            Vendor vnd = new Vendor();

            if (receive.getVendorId() == 0) {%>
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                                                                                <%
                                                                                                                if (vendors != null && vendors.size() > 0) {
                                                                                                                    for (int i = 0; i < vendors.size(); i++) {
                                                                                                                        Vendor d = (Vendor) vendors.get(i);
                                                                                                                        if (receive.getVendorId() == d.getOID()) {
                                                                                                                            ig.setVendor(d.getCode() + " - " + d.getName());
                                                                                                                            ig.setAddress(d.getAddress());
                                                                                                                        }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (receive.getVendorId() == d.getOID()) {%>selected<%}%>><%=d.getCode() + " - " + d.getName()%></option>
                                                                                                                <%}
                                                                                                                }%>
                                                                                                            </select>
                                                                                                            <%} else {
                                                                                                                try {
                                                                                                                    vnd = DbVendor.fetchExc(receive.getVendorId());
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            %>
                                                                                                            <b><%=vnd.getCode() + " - " + vnd.getName()%></b> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" value="<%=receive.getVendorId()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td height="20" width="11%">Receive 
                                                                                                        In</td>
                                                                                                        <td height="20" colspan="2" class="comment"> 
                                                                                                            <%if (receive.getLocationId() == 0) {%>
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>">
                                                                                                                <%
    Vector locations = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_TYPE] + "='" + DbLocation.TYPE_WAREHOUSE + "'", "code");
    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            if (receive.getLocationId() == d.getOID()) {
                ig.setReceiveIn(d.getCode() + " - " + d.getName());
            }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (receive.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getCode() + " - " + d.getName()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>
                                                                                                            <%} else {
    Location loc = new Location();
    try {
        loc = DbLocation.fetchExc(receive.getLocationId());
    } catch (Exception e) {
    }
                                                                                                            %>
                                                                                                            <b><%=loc.getCode() + " - " + loc.getName()%></b> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>" value="<%=receive.getLocationId()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;Address</td>
                                                                                                        <td height="20" width="30%"> 
                                                                                                            <%//if(receive.getLocationId()==0){%>
                                                                                                            <textarea name="vnd_address" rows="2" cols="45" readOnly class="readOnly"><%=vnd.getAddress()%></textarea>
                                                                                                            <%//}else{%>
                                                                                                            <%//=vnd.getAddress()%>
                                                                                                            <%//}%>
                                                                                                        </td>
                                                                                                        <td width="11%" height="20">Incoming 
                                                                                                        Number</td>
                                                                                                        <td colspan="2" class="comment" height="20"> 
                                                                                                            <b> 
                                                                                                                <%
            String number = "";
            if (receive.getOID() == 0) {
                int ctr = DbReceive.getNextCounter();
                number = DbReceive.getNextNumber(ctr);
                ig.setDocNumber(number);
            } else {
                number = receive.getNumber();
                ig.setDocNumber(number);
            }
                                                                                                                %>
                                                                                                        <%=number%> </b></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;DO 
                                                                                                        Number</td>
                                                                                                        <td height="21" width="30%"> 
                                                                                                            <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DO_NUMBER]%>" value="<%=receive.getDoNumber()%>">
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_DO_NUMBER)%> 
                                                                                                            <%ig.setDoNumber(receive.getDoNumber());%>
                                                                                                        </td>
                                                                                                        <td width="11%">Currency</td>
                                                                                                        <td colspan="2" class="comment"><b> 
                                                                                                                <%
            Currency curr = new Currency();
            try {
                curr = DbCurrency.fetchExc(receive.getCurrencyId());
            } catch (Exception e) {
            }
            out.println(curr.getCurrencyCode());
                                                                                                                %>
                                                                                                                <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_CURRENCY_ID]%>" value="<%=receive.getCurrencyId()%>">
                                                                                                        </b></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Invoice 
                                                                                                        Number </td>
                                                                                                        <td height="21" width="30%"> 
                                                                                                            <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_INVOICE_NUMBER]%>" value="<%=receive.getInvoiceNumber()%>">
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_INVOICE_NUMBER)%> 
                                                                                                            <%
            Vector currs = DbCurrency.list(0, 0, "", "");
            Vector exchange_value = new Vector(1, 1);
            Vector exchange_key = new Vector(1, 1);
            String sel_exchange = "" + receive.getCurrencyId();
            if (currs != null && currs.size() > 0) {
                for (int i = 0; i < currs.size(); i++) {
                    Currency d = (Currency) currs.get(i);
                    exchange_key.add("" + d.getOID());
                    exchange_value.add(d.getCurrencyCode());
                }
            }
                                                                                                            %>
                                                                                                            <%//= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_CURRENCY_ID],null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %>
                                                                                                            <%ig.setInvoiceNumber(receive.getInvoiceNumber());%>
                                                                                                        </td>
                                                                                                        <td width="11%">Doc Status</td>
                                                                                                        <td colspan="2" class="comment"> 
                                                                                                            <%
            if (receive.getStatus() == null || receive.getStatus().length() == 0) {                
                receive.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
                                                                                                            %>
                                                                                                            <input type="text" class="readOnly" name="stt" value="<%=(receive.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%>" size="15" readOnly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                                                                        <td height="21" width="30%"> 
                                                                                                            <input name="<%=JspReceive.colNames[JspReceive.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%ig.setDate(receive.getDate());%>
                                                                                                        </td>
                                                                                                        <td width="11%">Applay VAT</td>
                                                                                                        <td colspan="2" class="comment"> 
                                                                                                            <%
            Vector include_value = new Vector(1, 1);
            Vector include_key = new Vector(1, 1);
            String sel_include = "" + receive.getIncluceTax();
            ig.setApplayVat(receive.getIncluceTax());
            include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_NO]);
            include_key.add("" + DbReceive.INCLUDE_TAX_NO);
            include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_YES]);
            include_key.add("" + DbReceive.INCLUDE_TAX_YES);
                                                                                                            %>
                                                                                                        <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX], null, sel_include, include_key, include_value, "onChange=\"javascript:cmdVatEdit()\"", "formElemen") %></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Payment 
                                                                                                        Type </td>
                                                                                                        <td height="21" width="30%"> 
                                                                                                            <%
            Vector payment_value = new Vector(1, 1);
            Vector payment_key = new Vector(1, 1);
            String sel_payment = "" + receive.getPaymentType();
            ig.setPaymentType("" + receive.getPaymentType());
            payment_key.add(I_Project.PAYMENT_TYPE_CASH);
            payment_value.add(I_Project.PAYMENT_TYPE_CASH);
            payment_key.add(I_Project.PAYMENT_TYPE_CREDIT);
            payment_value.add(I_Project.PAYMENT_TYPE_CREDIT);
                                                                                                            %>
                                                                                                        <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_PAYMENT_TYPE], null, sel_payment, payment_key, payment_value, "", "formElemen") %> </td>
                                                                                                        <td width="11%">Term Of Payment</td>
                                                                                                        <td colspan="2" class="comment"> 
                                                                                                            <input name="<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDueDate() == null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%ig.setTermOfPayment(receive.getDueDate());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                    <td height="10" colspan="5"></td>
                                                                                                    <tr align="left"> 
                                                                                                    <td height="21" width="12%">&nbsp;&nbsp;Notes</td>
                                                                                                    <td height="21" width="30%"> 
                                                                                                        <textarea name="<%=JspReceive.colNames[JspReceive.JSP_NOTE]%>" cols="55" rows="3"><%=receive.getNote()%></textarea>
                                                                                                        <%ig.setNotes(receive.getNote());%>
                                                                                                    </td>
                                                                                                    <td height="21" width="11%">&nbsp;</td>
                                                                                                    <td height="21" width="35%" bgcolor="#FF9900"> 
                                                                                                        <div align="center">&nbsp;&nbsp;<b>AP 
                                                                                                            for Unit Usaha</b> 
                                                                                                            <%
            Vector unitUsh = DbUnitUsaha.list(0, 0, "", "name");
                                                                                                            %>
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_UNIT_USAHA_ID]%>">
                                                                                                                <%if (unitUsh != null && unitUsh.size() > 0){
                for (int i = 0; i < unitUsh.size(); i++) {
                    UnitUsaha us = (UnitUsaha) unitUsh.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=us.getOID()%>" <%if (us.getOID() == receive.getUnitUsahaId()) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                    <td height="21" width="12%">&nbsp;</td>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspReceiveItem, receiveItem, purchItems, oidReceiveItem, approot, receive.getVendorId(), iErrCode2, receive.getStatus(), errorx);
            String strList = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strList%> 
                                                                                                            <% session.putValue("PURCHASE_DETAIL", rptObj);%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <%@ include file = "invoice_edit_total.jsp" %>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (receive.getOID() != 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4"> 
                                                                                                                        <%if (receive.getOID() != 0 && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="14%">&nbsp;</td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%if ((!receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) || iErrCode != 0)) {%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%"><b>Set 
                                                                                                                                Status to</b> </td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                                                                                        <!--option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option-->
                                                                <%//if(posApprove1Priv){%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                                        <%//}%>
                                                                                                                                        <%//if(posApprove2Priv && 1==2){%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>selected<%}%>>CHECKED 
                                                                                                                                                AS INVOICE 
                                                                                                                                                <%//=I_Project.DOC_STATUS_CHECKED%>
                                                                                                                                                </option>
                                                                                                                                        <%//}%>
                                                                                                                                        <%//if(posApprove4Priv && 1==2){%>
                                                                                                                                        <!--option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option-->
                                                                                                                                        <%//}%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td width="74%">&nbsp; </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="14%">&nbsp;</td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="closingreason">
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="88%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%if (receive.getOID() != 0){
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" class="errfont"><%=msgString%></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <%if (!receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) || iErrCode != 0) {%>
                                                                                                                    <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <td width="102" > 
                                                                                                                        <div align="left"><a href="javascript:cmdPrintDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (receive.getOID() != 0){%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <%@ include file="invoice_edit_approval.jsp"%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
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
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%
            session.putValue("PURCHASE_TITTLE", ig);
                                                            %>
                                                        </form>
                                                        <span class="level2"><br>
                                                    </span><!-- #EndEditable --> </td>
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
