
<%-- 
    Document   : paymentcredit
    Created on : Jan 9, 2013, 5:37:39 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidARInvoice = JSPRequestValue.requestLong(request, "hidden_ar_invoice_id");

            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + "= 0";
            String orderClause = "";

            CmdARInvoice cmdARInvoice = new CmdARInvoice(request);
            JSPLine jspLine = new JSPLine();
            Vector listARInvoice = new Vector(1, 1);

            iErrCode = cmdARInvoice.action(iCommand, oidARInvoice, 0);
            JspARInvoice jspCP = cmdARInvoice.getForm();
            int vectSize = DbARInvoice.getCount(whereClause);
            msgString = cmdARInvoice.getMessage();

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdARInvoice.actionList(iCommand, start, vectSize, recordToGet);
            }

            listARInvoice = DbCreditPayment.list(start, recordToGet, whereClause, orderClause);
            ARInvoice arInvoice = cmdARInvoice.getARInvoice();

            if (listARInvoice.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } else {
                    start = 0;
                    iCommand = JSPCommand.FIRST;
                    prevCommand = JSPCommand.FIRST;
                }
                listARInvoice = DbARInvoice.list(start, recordToGet, whereClause, orderClause);
            }

            Customer customer = new Customer();
            try {
                customer = DbCustomer.fetchExc(arInvoice.getCustomerId());
            } catch (Exception e) {
            }

            Vector vPayment = new Vector();
            Vector vARPayment = new Vector();

            String where = DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID] + " = " + arInvoice.getOID();
            String wherep = DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID] + " = " + arInvoice.getProjectId() + " and " + DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS] + " != 1 ";
            String whereRetur = DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] + " = " + arInvoice.getCustomerId() + " and " + DbARInvoice.colNames[DbARInvoice.COL_STATUS] + " != " + I_Project.INV_STATUS_FULL_PAID + " and " + DbARInvoice.colNames[DbARInvoice.COL_TYPE_AR] + " = " + DbARInvoice.TYPE_RETUR + " and " + DbARInvoice.colNames[DbARInvoice.COL_POSTED_STATUS] + " = 1";

            Vector vRetur = new Vector();
            if (arInvoice.getStatus() != I_Project.INV_STATUS_FULL_PAID) {
                vPayment = DbCreditPayment.list(0, 0, wherep, null);
                vRetur = DbARInvoice.list(0, 0, whereRetur, null);
            }

            if (iCommand == JSPCommand.POST) {
                if (vPayment != null && vPayment.size() > 0) {
                    for (int iP = 0; iP < vPayment.size(); iP++) {
                        CreditPayment cp = (CreditPayment) vPayment.get(iP);
                        int x = JSPRequestValue.requestInt(request, "chkp" + cp.getOID());
                        if (x == 1) {                            
                            DbCreditPayment.creditPayment(sysCompany, cp, user.getOID(), arInvoice.getOID(), customer.getName(), formNumbComp);                                                                                    
                            
                        }
                    }
                }

                if (vRetur != null && vRetur.size() > 0) {
                    for (int iP = 0; iP < vRetur.size(); iP++) {
                        ARInvoice ai = (ARInvoice) vRetur.get(iP);
                        int x = JSPRequestValue.requestInt(request, "chkpm" + ai.getOID());
                        double amount = JSPRequestValue.requestDouble(request, "paymentm" + ai.getOID());
                        if (x == 1) {
                            DbCreditPayment.arMemoPayment(sysCompany, ai, arInvoice.getOID(), amount, formNumbComp);
                        }
                    }
                }
                vPayment = DbCreditPayment.list(0, 0, wherep, null);
                vRetur = DbARInvoice.list(0, 0, whereRetur, null);
            }
            vARPayment = DbArPayment.list(0, 0, where, null);

            double totalAp = 0;
            if (formNumbComp.equals("#,##0")) {
                totalAp = Math.round(arInvoice.getTotal());
            } else {
                totalAp = arInvoice.getTotal();
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function setChecked(val){
                 <%
            for (int k = 0; k < vPayment.size(); k++) {
                CreditPayment cp = (CreditPayment) vPayment.get(k);
                 %>
                     if(val == '<%=cp.getOID()%>'){
                         if(document.frmpaymentcredit.chkp<%=cp.getOID()%>.checked == true){
                             
                             var x = document.frmpaymentcredit.balance<%=cp.getOID()%>.value; 
                             x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                             
                             var tot = document.frmpaymentcredit.total.value;       
                             tot = cleanNumberFloat(tot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                             
                             var vTot1 = parseFloat(x) + parseFloat(tot);                              
                             
                             document.frmpaymentcredit.payment<%=cp.getOID()%>.value=formatFloat(x, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                             document.frmpaymentcredit.total.value = formatFloat(vTot1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                             
                             var t = document.frmpaymentcredit.total_ap.value; 
                             t = cleanNumberFloat(t, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                             
                             var b = parseFloat(t) - parseFloat(vTot1);
                             document.frmpaymentcredit.totbalance.value = formatFloat(b, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                             
                         }else{
                         
                         var x = document.frmpaymentcredit.total_paid.value;                                                         
                         x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);  
                         
                         var y = document.frmpaymentcredit.payment<%=cp.getOID()%>.value;
                         y = cleanNumberFloat(y, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                         
                         var tot = document.frmpaymentcredit.total.value;
                         tot = cleanNumberFloat(tot, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                         
                         var tot1 = parseFloat(tot) - parseFloat(y);
                         
                         document.frmpaymentcredit.payment<%=cp.getOID()%>.value=formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         document.frmpaymentcredit.total.value = formatFloat(tot1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         setBalance();
                     }
                 }
                 <%}%> 
             }            
             
             function setpaym(val){
                 <%
            for (int k = 0; k < vRetur.size(); k++) {
                ARInvoice ar = (ARInvoice) vRetur.get(k);
                 %>                 
                     if(val == '<%=ar.getOID()%>'){
                         
                         var r = document.frmpaymentcredit.hidepaymentm<%=ar.getOID()%>.value; 
                         r = cleanNumberFloat(r, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                         var x = document.frmpaymentcredit.paymentm<%=ar.getOID()%>.value; 
                         x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                         
                         var p = document.frmpaymentcredit.balancem<%=ar.getOID()%>.value; 
                         p = cleanNumberFloat(p, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                         
                         var tot = document.frmpaymentcredit.total.value;       
                         tot = cleanNumberFloat(tot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                         
                         if(x > p) {
                             alert('Payment more than balance');
                             var vTot1 = parseFloat(tot) - parseFloat(r) + parseFloat(p);            
                             
                             document.frmpaymentcredit.hidepaymentm<%=ar.getOID()%>.value=formatFloat(p, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                             document.frmpaymentcredit.paymentm<%=ar.getOID()%>.value=formatFloat(p, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                    
                             document.frmpaymentcredit.total.value = formatFloat(vTot1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                             
                         }else{
                         var vTot1 = parseFloat(tot) - parseFloat(r) + parseFloat(x);            
                         
                         document.frmpaymentcredit.hidepaymentm<%=ar.getOID()%>.value=formatFloat(x, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         document.frmpaymentcredit.paymentm<%=ar.getOID()%>.value=formatFloat(x, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                    
                         document.frmpaymentcredit.total.value = formatFloat(vTot1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                     }
                     setBalance(); 
                 }    
                 <%}%>
             }    
             
             
             function setCheckedm(val){
                 <%
            for (int k = 0; k < vRetur.size(); k++) {
                ARInvoice ar = (ARInvoice) vRetur.get(k);
                 %>
                     if(val == '<%=ar.getOID()%>'){
                         
                         if(document.frmpaymentcredit.chkpm<%=ar.getOID()%>.checked == true){
                             
                             document.frmpaymentcredit.paymentm<%=ar.getOID()%>.disabled=false;
                             
                             var x = document.frmpaymentcredit.balancem<%=ar.getOID()%>.value; 
                             x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                             
                             var tot = document.frmpaymentcredit.total.value;       
                             tot = cleanNumberFloat(tot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                             
                             var vTot1 = parseFloat(x) + parseFloat(tot);            
                             
                             document.frmpaymentcredit.paymentm<%=ar.getOID()%>.value=formatFloat(x, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                             document.frmpaymentcredit.hidepaymentm<%=ar.getOID()%>.value=formatFloat(x, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                             document.frmpaymentcredit.total.value = formatFloat(vTot1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                             
                             var t = document.frmpaymentcredit.total_ap.value; 
                             t = cleanNumberFloat(t, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                             
                             var b = parseFloat(t) - parseFloat(vTot1);
                             document.frmpaymentcredit.totbalance.value = formatFloat(b, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                             
                         }else{
                         
                         document.frmpaymentcredit.paymentm<%=ar.getOID()%>.disabled=true;
                         
                         var y = document.frmpaymentcredit.paymentm<%=ar.getOID()%>.value;
                         y = cleanNumberFloat(y, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                         
                         var tot = document.frmpaymentcredit.total.value;
                         tot = cleanNumberFloat(tot, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                                        
                         
                         var tot1 = parseFloat(tot) - parseFloat(y);                           
                         document.frmpaymentcredit.paymentm<%=ar.getOID()%>.value=formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         document.frmpaymentcredit.hidepaymentm<%=ar.getOID()%>.value=formatFloat(0, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         document.frmpaymentcredit.total.value = formatFloat(tot1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                         setBalance();
                     }
                 }
                 <%}%> 
             } 
             
             function setBalance(){
                 var t = document.frmpaymentcredit.total_ap.value;                                                         
                 t = cleanNumberFloat(t, sysDecSymbol, usrDigitGroup, usrDecSymbol);                                
                 
                 var tot = document.frmpaymentcredit.total.value;
                 tot = cleanNumberFloat(tot, sysDecSymbol, usrDigitGroup, usrDecSymbol);   
                 
                 var b = parseFloat(t) - parseFloat(tot);                                 
                 document.frmpaymentcredit.totbalance.value = formatFloat(b, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
             }
             
             function removeChar(number){                        
                 var ix; var result = "";
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
         
         
         function cmdSave(){
             document.frmpaymentcredit.command.value="<%=JSPCommand.POST%>";
             document.frmpaymentcredit.action="paymentcredit.jsp?menu_idx=<%=menuIdx%>";
             document.frmpaymentcredit.submit();
         }    
         
         function cmdBack(){            
             document.frmpaymentcredit.command.value="<%=JSPCommand.BACK%>";
             document.frmpaymentcredit.action="paymentcreditlist.jsp?menu_idx=<%=menuIdx%>";
             document.frmpaymentcredit.submit();
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
        <!--End Region JavaScript-->
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/new2.gif','../images/savedoc.gif2.gif','../images/savedoc2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <!--Begin Region Content-->
                                                                                                        <form name="frmpaymentcredit" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">                                                                                                            
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <input type="hidden" name="total_ap" value="<%=totalAp%>">
                                                                                                            <input type="hidden" name="hidden_ar_invoice_id" value="<%=oidARInvoice%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Accounting 
                                                                                                                                        </font><font class="tit1">&raquo;<span class="lvl2"> Credit Payment<br>
                                                                                                                                </span></font></b></td>
                                                                                                                                <td width="40%" height="23"> 
                                                                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                              
                                                                                                                <tr> 
                                                                                                                    <td class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8"  colspan="3"> 
                                                                                                                                    <table width="700" border="0" cellspacing="2" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" height="5"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td width="15%" class="tablearialcell">&nbsp;Customer</td>
                                                                                                                                            <td width="30%" class="fontarial">: <%=customer.getName()%></td>
                                                                                                                                            <td width="10%"></td>
                                                                                                                                            <td width="15%" class="tablearialcell">&nbsp;Jurnal Number</td>
                                                                                                                                            <td class="fontarial">: <%=arInvoice.getJournalNumber()%></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell">&nbsp;Invoice Number</td>
                                                                                                                                            <td class="fontarial">: <%=arInvoice.getInvoiceNumber() %></td>
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                            <td class="tablearialcell">&nbsp;Date</td>
                                                                                                                                            <td class="fontarial">: <%=JSPFormater.formatDate(arInvoice.getDate(), "dd MMM yyyy")%></td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell">&nbsp;Memo</td>
                                                                                                                                            <td class="fontarial">: <%=arInvoice.getMemo()%></td>
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                            <td class="tablearialcell">&nbsp;Due Date</td>
                                                                                                                                            <td class="fontarial">: <%=JSPFormater.formatDate(arInvoice.getDueDate(), "dd MMM yyyy")%></td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell">&nbsp;Amount</td>
                                                                                                                                            <td class="fontarial">: <%=JSPFormater.formatNumber(totalAp, formNumbComp)%></td>
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                            <td class="tablearialcell">&nbsp;Paid</td>
                                                                                                                                            <td class="fontarial">: <%=JSPFormater.formatNumber(DbARInvoice.amountPaid(arInvoice.getOID()), "###,###.##")%></td>
                                                                                                                                        </tr> 
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top" > 
                                                                                                                                <td colspan="3" >
                                                                                                                                    <table width="1000" border="0" cellpadding="0" cellspacing="1">
                                                                                                                                        <tr height="25">
                                                                                                                                            <td class="tablearialhdr" width="20"></td>
                                                                                                                                            <td class="tablearialhdr">Status</td>
                                                                                                                                            <td class="tablearialhdr">Payment Type</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Date</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="15%">Merchant</td>
                                                                                                                                            <td class="tablearialhdr" width="15%">Bank</td>
                                                                                                                                            <td class="tablearialhdr" width="13%">Amount Rp.</td>
                                                                                                                                            <td class="tablearialhdr" width="13%">Balance Rp.</td>
                                                                                                                                            <td class="tablearialhdr" width="13%">Payment Rp.</td>
                                                                                                                                        </tr>    
                                                                                                                                        <%if (!((vARPayment != null && vARPayment.size() > 0) || (vPayment != null && vPayment.size() > 0) || (vRetur != null && vRetur.size() > 0))) {%>
                                                                                                                                        <tr height="22">
                                                                                                                                            <td class="tablearialcell1" colspan="9">&nbsp;<i>Payment not available</i></td>
                                                                                                                                        </tr>    
                                                                                                                                        <%}%>
                                                                                                                                        <%
            double totPaid = 0;
            if (vARPayment != null && vARPayment.size() > 0) {
                for (int i = 0; i < vARPayment.size(); i++) {
                    ArPayment ap = (ArPayment) vARPayment.get(i);
                    totPaid = totPaid + ap.getAmount();
                    String ketMerhant = "-";
                    Bank tfBank = new Bank();
                                                                                                                                        %>
                                                                                                                                        <tr height="22">
                                                                                                                                            <td class="tablearialcell1" align="center"></td>
                                                                                                                                            <td class="tablearialcell1" align="center">POSTED</td>
                                                                                                                                            <td class="tablearialcell1" align="left"><B><%if (ap.getRefId() != 0) {
                                                                                                                                                    ARInvoice ar1 = new ARInvoice();
                                                                                                                                                    try {
                                                                                                                                                        ar1 = DbARInvoice.fetchExc(ap.getArInvoiceId());
                                                                                                                                                    } catch (Exception e) {
                                                                                                                                                    }
                                                                                                                                                    %>
                                                                                                                                                    <%if (ar1.getTypeAR() == DbARInvoice.TYPE_AR_MEMO) {%>
                                                                                                                                                    <B>AR MEMO</B>
                                                                                                                                                    <%} else if (ar1.getTypeAR() == DbARInvoice.TYPE_RETUR) {%>
                                                                                                                                                    <B>RETUR</B>
                                                                                                                                                    <%}
} else {

    String ketPayment = "RETUR";
    
    if (ap.getCreditPaymentId() != 0) {
        CreditPayment cp = new CreditPayment();
        try {
            cp = DbCreditPayment.fetchExc(ap.getCreditPaymentId());
            if (cp.getType() == DbPayment.PAY_TYPE_CASH) {
                ketPayment = "CASH";
            } else if (cp.getType() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                ketPayment = "CREDIT CARD";
            } else if (cp.getType() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                ketPayment = "DEBIT CARD";
            } else if (cp.getType() == DbPayment.PAY_TYPE_TRANSFER) {
                ketPayment = "TRANSFER BANK";
            } else if (cp.getType() == DbPayment.PAY_TYPE_GIRO) {
                ketPayment = "GIRO";
            }

            Merchant merchant = new Merchant();

            if (cp.getMerchantId() != 0) {
                try {
                    merchant = DbMerchant.fetchExc(cp.getMerchantId());
                    if (merchant.getOID() != 0) {
                        if (merchant.getBankId() != 0) {
                            Bank b = DbBank.fetchExc(merchant.getBankId());
                            if (b.getOID() != 0) {
                                ketMerhant = b.getName() + " - ";
                            }
                        }
                        ketMerhant = ketMerhant + merchant.getDescription();
                    }
                } catch (Exception e) {
                }
            }            
            
            if(cp.getBankId() != 0){
                try{
                    tfBank = DbBank.fetchExc(cp.getBankId());
                }catch(Exception e){}
            }

        } catch (Exception e) {
        }
    }

                                                                                                                                                    %>
                                                                                                                                                    <%=ketPayment%>
                                                                                                                                            <%}%></B></td>
                                                                                                                                            <td class="tablearialcell1" align="center"><%=JSPFormater.formatDate(ap.getDate(), "dd MMM yyyy") %></td>
                                                                                                                                            <td class="tablearialcell1" align="left"><%=ketMerhant%></td>
                                                                                                                                            <td class="tablearialcell1" align="left"><%=tfBank.getName()%></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(ap.getAmount(), "###,###.##") %></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(0, "###,###.##") %></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(ap.getAmount(), "###,###.##") %></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                }
            }
                                                                                                                                        %>                                                                                                                                        
                                                                                                                                        <input type="hidden" name="total_paid" value="<%=totPaid%>">
                                                                                                                                        <%
            boolean dataExist = false;
            if (vPayment != null && vPayment.size() > 0) {
                for (int i = 0; i < vPayment.size(); i++) {
                    dataExist = true;
                    CreditPayment pay = (CreditPayment) vPayment.get(i);

                    String ketPayment = "";
                    if (pay.getType() == DbPayment.PAY_TYPE_CASH) {
                        ketPayment = "CASH";
                    } else if (pay.getType() == DbPayment.PAY_TYPE_CREDIT_CARD) {
                        ketPayment = "CREDIT CARD";
                    } else if (pay.getType() == DbPayment.PAY_TYPE_DEBIT_CARD) {
                        ketPayment = "DEBIT CARD";
                    } else if (pay.getType() == DbPayment.PAY_TYPE_TRANSFER) {
                        ketPayment = "TRANSFER BANK";
                    }else if (pay.getType() == DbPayment.PAY_TYPE_GIRO) {
                        ketPayment = "GIRO";
                    }

                    Merchant merchant = new Merchant();
                    String ketMerhant = "-";
                    if (pay.getMerchantId() != 0) {
                        try {
                            merchant = DbMerchant.fetchExc(pay.getMerchantId());
                            if (merchant.getOID() != 0) {
                                if (merchant.getBankId() != 0) {
                                    Bank b = DbBank.fetchExc(merchant.getBankId());
                                    if (b.getOID() != 0) {
                                        ketMerhant = b.getName() + " - ";
                                    }
                                }
                                ketMerhant = ketMerhant + merchant.getDescription();
                            }
                        } catch (Exception e) {
                        }
                    }

                    double payment = 0;

                    if (formNumbComp.equals("#,##0")) {
                        payment = Math.round(pay.getAmount());
                    } else {
                        payment = pay.getAmount();
                    }
             
                    Bank tfBank = new Bank();
                                             
                    if(pay.getBankId() != 0){
                try{
                    tfBank = DbBank.fetchExc(pay.getBankId());
                }catch(Exception e){}
            }
                                                                                                                                        %>
                                                                                                                                        <tr height="23">
                                                                                                                                            <td class="tablearialcell1" align="center"><input type="checkbox" name="chkp<%=pay.getOID()%>" value="1" onClick="setChecked('<%=pay.getOID()%>')"></td>
                                                                                                                                            <td class="tablearialcell1" align="center"><B>-</B></td>
                                                                                                                                            <td class="tablearialcell1" align="left"><B><%=ketPayment%></B></td>
                                                                                                                                            <td class="tablearialcell1" align="center"><%=JSPFormater.formatDate(pay.getPay_datetime(), "dd MMM yyyy") %></td>
                                                                                                                                            <td class="tablearialcell1" align="left"><B><%=ketMerhant%></B></td>
                                                                                                                                            <td class="tablearialcell1" align="left"><B><%=tfBank.getName()%></B></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><input type="text" name="amount<%=pay.getOID()%>" value="<%=JSPFormater.formatNumber(payment, formNumbComp) %>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><input type="text" name="balance<%=pay.getOID()%>" value="<%=JSPFormater.formatNumber(payment, formNumbComp) %>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><input type="text" name="payment<%=pay.getOID()%>" value="<%=0%>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                        </tr>    
                                                                                                                                        <%
                }
            }

            if (vRetur != null && vRetur.size() > 0) {
                for (int i = 0; i < vRetur.size(); i++) {
                    dataExist = true;
                    ARInvoice obARInvoice = (ARInvoice) vRetur.get(i);
                    double paid = DbARInvoice.amountPaid(obARInvoice.getOID());
                    double bal = obARInvoice.getTotal() - paid;
                    if (bal != 0) {
                        bal = bal * -1;
                    }

                    double amount = 0;
                    if (formNumbComp.equals("#,##0")) {
                        amount = Math.round(obARInvoice.getTotal());
                    } else {
                        amount = obARInvoice.getTotal();
                    }
                    if (amount != 0) {
                        amount = amount * -1;
                    }
                                                                                                                                        %>
                                                                                                                                        <tr height="20">
                                                                                                                                            <td class="tablearialcell1" align="center">
                                                                                                                                                <input type="checkbox" name="chkpm<%=obARInvoice.getOID()%>" value="1" onClick="setCheckedm('<%=obARInvoice.getOID()%>')">
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell1" align="center"><B>-</B></td>
                                                                                                                                            <td class="tablearialcell1" align="left"><B>RETUR</B></td>
                                                                                                                                            <td class="tablearialcell1" align="center"><%=JSPFormater.formatDate(obARInvoice.getDate(), "dd MMM yyyy") %></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><input type="text" name="amountm<%=obARInvoice.getOID()%>" value="<%=JSPFormater.formatNumber(amount, formNumbComp) %>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><input type="text" name="balancem<%=obARInvoice.getOID()%>" value="<%=JSPFormater.formatNumber(bal, formNumbComp) %>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                            <td class="tablearialcell1" align="right">
                                                                                                                                                <input type="hidden" name="hidepaymentm<%=obARInvoice.getOID()%>" value="<%=0%>">
                                                                                                                                                <input type="text" name="paymentm<%=obARInvoice.getOID()%>" value="<%=0%>" style="text-align:right" disabled onChange="setpaym('<%=obARInvoice.getOID()%>')" class="fontarial">
                                                                                                                                            </td>
                                                                                                                                        </tr> 
                                                                                                                                        <%}
            }%>
                                                                                                                                        <tr height="25">
                                                                                                                                            <td colspan="8"></td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr >
                                                                                                                                            <td colspan="8" align="right" class="fontarial"><B>TOTAL</B></td>                                                                                                                                                                                                                                                                                       
                                                                                                                                            <td align="right"><input type="text" name="total" value="<%=JSPFormater.formatNumber(totPaid, "###,###.##") %>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr >
                                                                                                                                            <td colspan="8" align="right" class="fontarial"><B>BALANCE</B></td>                                                                                                                                                                                                                                                                                       
                                                                                                                                            <td align="right"><input type="text" name="totbalance" value="<%=0%>" style="text-align:right" class="fontarial" readonly></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%if (arInvoice.getStatus() == I_Project.INV_STATUS_FULL_PAID) {%>
                                                                                                                                        <tr >
                                                                                                                                            <td colspan="8" align="left">
                                                                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="15"><img src="../images/success.gif" height="20"></td>
                                                                                                                                                        <td width="100" nowrap>PAID</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                        </tr> 
                                                                                                                                        <%}%>
                                                                                                                                        <%if (dataExist == true) {%>
                                                                                                                                        <tr height="25">
                                                                                                                                            <td colspan="7"></td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr >
                                                                                                                                            <td colspan="7" align="left">
                                                                                                                                                <table>
                                                                                                                                                    <tr>
                                                                                                                                                        <td>
                                                                                                                                                            <%if (privAdd || privUpdate || privDelete) {%>
                                                                                                                                                            <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc','','../images/save2.gif',1)"><img src="../images/save.gif" name="savedoc" height="22" border="0"></a>                                                                                                                        
                                                                                                                                                            <%}%>
                                                                                                                                                        </td>
                                                                                                                                                        <td width="10"></td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0"></a>                                                                                                                        
                                                                                                                                                        </td>
                                                                                                                                                    </tr>    
                                                                                                                                                </table>    
                                                                                                                                            </td>                                                                                                                                                                                                                                                                                       
                                                                                                                                        </tr> 
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr height="25">
                                                                                                                                            <td colspan="7"></td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr >
                                                                                                                                            <td colspan="7" align="left">
                                                                                                                                                <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0"></a>                                                                                                                                                                                                                                                                        
                                                                                                                                            </td>                                                                                                                                                                                                                                                                                       
                                                                                                                                        </tr> 
                                                                                                                                        <%}%>
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>    
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <script language="JavaScript">
                                                                                                                setBalance();
                                                                                                            </script>
                                                                                                        </form>
                                                                                                        <!--End Region Content-->
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
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
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>
