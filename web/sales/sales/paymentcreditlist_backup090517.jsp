
<%-- 
    Document   : paymentcreditlist
    Created on : Jan 15, 2013, 11:07:52 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");
            String txtCustomer = JSPRequestValue.requestString(request, "txt_customer");
            long customerId = JSPRequestValue.requestLong(request, "JSP_CUSTOMER_ID");
            int selectType = JSPRequestValue.requestInt(request, "select_type");
            String where = "";

            if (selectType == I_Project.INV_STATUS_FULL_PAID) {
                where = DbARInvoice.colNames[DbARInvoice.COL_STATUS] + " = " + I_Project.INV_STATUS_FULL_PAID;                
            } else {
                where = DbARInvoice.colNames[DbARInvoice.COL_STATUS] + " != " + I_Project.INV_STATUS_FULL_PAID;
            }

            if (customerId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }
                where = where + DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] + " = " + customerId;
            }

            Vector listPaymentCredit = new Vector();
            Vector vARInvoice = new Vector();

            vARInvoice = DbARInvoice.list(0, 0, where, DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] + "," + DbARInvoice.colNames[DbARInvoice.COL_DATE]);
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearchMember(){
                window.open("<%=approot%>/sales/srcmember.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function setChecked(val){
                 <%
            for (int k = 0; k < listPaymentCredit.size(); k++) {
                ReportCreditPayment osl = (ReportCreditPayment) listPaymentCredit.get(k);
                %>
                    document.frmpaymentlist.cp_<%=osl.getCpId()%>. checked=val.checked;
            <%
            }
            %>
            }
            
            function cmdPayment(oid){
                document.frmpaymentlist.hidden_ar_invoice_id.value=oid;
                document.frmpaymentlist.command.value="<%=JSPCommand.EDIT%>";
                document.frmpaymentlist.action="paymentcredit.jsp";                
                document.frmpaymentlist.submit();
            }
            
            function cmdResetAll(){
                document.frmpaymentlist.txt_customer.value="";
                document.frmpaymentlist.JSP_CUSTOMER_ID.value="0";                  
            }
            
            function cmdPostJournal(){
                document.all.closecmd.style.display="none";
                document.all.closemsg.style.display="";
                document.frmpaymentlist.command.value="<%=JSPCommand.POST%>";
                document.frmpaymentlist.action="paymentcreditlist.jsp?menu_idx=<%=menuIdx%>";
                document.frmpaymentlist.submit();
            }
            
            function cmdSearch(){
                document.frmpaymentlist.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmpaymentlist.action="paymentcreditlist.jsp?menu_idx=<%=menuIdx%>";
                document.frmpaymentlist.submit();
            }
            
            function cmdSave(){
                document.frmpaymentlist.command.value="<%=JSPCommand.SAVE%>";
                document.frmpaymentlist.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentlist.action="paymentcreditlist.jsp?menu_idx=<%=menuIdx%>";
                document.frmpaymentlist.submit();
            }
            
            function cmdCancel(oidSales){
                document.frmpaymentlist.hidden_sales_id.value=oidSales;
                document.frmpaymentlist.command.value="<%=JSPCommand.EDIT%>";
                document.frmpaymentlist.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentlist.action="paymentcreditlist.jsp?menu_idx=<%=menuIdx%>";
                document.frmpaymentlist.submit();
            }
            
            function cmdBack(){
                document.frmpaymentlist.command.value="<%=JSPCommand.BACK%>";
                document.frmpaymentlist.action="paymentcreditlist.jsp?menu_idx=<%=menuIdx%>";
                document.frmpaymentlist.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
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
                                                                                                        <form name="frmpaymentlist" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="hidden_sales_id" value="<%=oidSales%>">
                                                                                                            <input type="hidden" name="hidden_sales" value="<%=oidSales%>">                                                                                                            
                                                                                                            <input type="hidden" name="hidden_ar_invoice_id" value="<%=0%>">                    
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Accounting 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Credit Payment
                                                                                                                                                <br>
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
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="10" valign="middle" colspan="3"></td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="0"> 
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="300">                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td class="tablecell1" >                                                                                                                                                
                                                                                                                                                <table width="100%" style="border:1px solid #ABA8A8" cellpadding="0" cellspacing="1">  
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="3" height="10"></td>
                                                                                                                                                    </tr>                                                                                                                                                     
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="7"></td>
                                                                                                                                                        <td width="50" class="fontarial">Member</td>
                                                                                                                                                        <td>
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input size="30" readonly type="text" name="txt_customer" value="<%=txtCustomer%>" class="fontarial">
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input type="hidden" name="JSP_CUSTOMER_ID" value="<%=customerId%>">
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        &nbsp;<a href="javascript:cmdSearchMember()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td class="fontarial">
                                                                                                                                                                        &nbsp;<a href="javascript:cmdResetAll()" >Reset</a>
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="7"></td>
                                                                                                                                                        <td width="50" class="fontarial">Status</td>
                                                                                                                                                        <td>
                                                                                                                                                            <select name="select_type" class="fontarial">                                                                                                                                                                
                                                                                                                                                                <option value="<%=I_Project.INV_STATUS_PARTIALY_PAID%>" <%if (selectType == I_Project.INV_STATUS_PARTIALY_PAID) {%> selected <%}%>>NOT FULLY PAID</option>
                                                                                                                                                                <option value="<%=I_Project.INV_STATUS_FULL_PAID%>" <%if (selectType == I_Project.INV_STATUS_FULL_PAID) {%> selected <%}%>>FULLY PAID</option>
                                                                                                                                                            </select>    
                                                                                                                                                        </td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <tr>
                                                                                                                                                        <td colspan="3" height="15"></td>
                                                                                                                                                    </tr>   
                                                                                                                                                </table>    
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="5" valign="middle" colspan="3"></td>
                                                                                                                            </tr>        
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td valign="middle" colspan="3">
                                                                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="25" valign="middle" colspan="3"></td>
                                                                                                                            </tr> 
                                                                                                                            <%
            if (vARInvoice != null && vARInvoice.size() > 0) {
                long cId = 0;
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="1000" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20">
                                                                                                                                            <td width="10%" class="tablearialhdr">Status</td>                                                                                                                                            
                                                                                                                                            <td width="15%" class="tablearialhdr">Member</td>                                                                                                                                            
                                                                                                                                            <td width="10%" class="tablearialhdr">Number</td>  
                                                                                                                                            <td width="15%" class="tablearialhdr">Tansaction Date</td>
                                                                                                                                            <td width="15%" class="tablearialhdr">Amount</td>
                                                                                                                                            <td class="tablearialhdr">Due Date</td>
                                                                                                                                            <td width="10%" class="tablearialhdr">Payment Amount</td>
                                                                                                                                            <td width="10%" class="tablearialhdr">Balance</td>
                                                                                                                                        </tr>    
                                                                                                                                        <%
                                                                                                                                double total = 0;
                                                                                                                                double bal = 0;
                                                                                                                                int available = 0;

                                                                                                                                for (int i = 0; i < vARInvoice.size(); i++) {

                                                                                                                                    ARInvoice ai = (ARInvoice) vARInvoice.get(i);
                                                                                                                                    double npPay = DbARInvoice.posAmount(ai.getProjectId());
                                                                                                                                    double paid = npPay + DbARInvoice.amountPaid(ai.getOID());
                                                                                                                                    double balance = 0;
                                                                                                                                    if (formNumbComp.equals("#,##0")) {
                                                                                                                                        balance = Math.round(ai.getTotal()) - Math.round(paid);
                                                                                                                                    } else {
                                                                                                                                        balance = ai.getTotal() - paid;
                                                                                                                                    }

                                                                                                                                    if (cId != ai.getCustomerId()) {

                                                                                                                                        Customer c = new Customer();
                                                                                                                                        try {
                                                                                                                                            c = DbCustomer.fetchExc(ai.getCustomerId());
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                        if (cId != 0) {%>
                                                                                                                                        <tr height="20">
                                                                                                                                            <td class="tablearialcell1"></td>
                                                                                                                                            <td class="tablearialcell1" colspan="3" align="center"><B>TOTAL</B></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(total, formNumbComp)%></B></td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(bal, formNumbComp)%></B></td>        
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="3">
                                                                                                                                            <td colspan="8" bgcolor="#5A87E3"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%}%>
                                                                                                                                        <tr height="20">
                                                                                                                                            <td class="tablearialcell1"></td>
                                                                                                                                            <td class="tablearialcell1" colspan="3"><%=c.getCode()%> - <%=c.getName().toUpperCase()%></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                                total = 0;
                                                                                                                                                bal = 0;
                                                                                                                                            }

                                                                                                                                            double aiTotal = 0;

                                                                                                                                            if (formNumbComp.equals("#,##0")) {
                                                                                                                                                aiTotal = Math.round(ai.getTotal());
                                                                                                                                                ;
                                                                                                                                                total = total + aiTotal;
                                                                                                                                                bal = bal + Math.round(balance);
                                                                                                                                            } else {
                                                                                                                                                aiTotal = ai.getTotal();
                                                                                                                                                total = total + aiTotal;
                                                                                                                                                bal = bal + balance;
                                                                                                                                            }

                                                                                                                                        %>
                                                                                                                                        
                                                                                                                                        <tr height="22">
                                                                                                                                            <td bgcolor="#F2F2F2" class="readonly">
                                                                                                                                                <div align="center"> 
                                                                                                                                                    <%if (ai.getStatus() == I_Project.INV_STATUS_FULL_PAID) {%>
                                                                                                                                                    <b><font color="#0C690C" face="arial">PAID</font></b>
                                                                                                                                                    <%
} else {
    if (ai.getDueDate().before(new Date())) {
                                                                                                                                                    %>
                                                                                                                                                    <b><font color="#FF0000" face="arial">OVER DUE</font></b> 
                                                                                                                                                    <%}
                                                                                                                                            }%>
                                                                                                                                                </div>                              
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" align="center">
                                                                                                                                                <%
                                                                                                                                            if (npPay > 0) {
                                                                                                                                                available = available + 1;
                                                                                                                                                %>
                                                                                                                                                [available]
                                                                                                                                                <%} else {%>
                                                                                                                                                -
                                                                                                                                                <%}%>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                            <td class="tablearialcell" align="center">
                                                                                                                                                <%if (ai.getTypeAR() == DbARInvoice.TYPE_AR_MEMO) {%>
                                                                                                                                                <%=ai.getJournalNumber()%>
                                                                                                                                                <%} else if (ai.getTypeAR() == DbARInvoice.TYPE_RETUR) {%>
                                                                                                                                                <%=ai.getInvoiceNumber()%>
                                                                                                                                                <%} else {%>
                                                                                                                                                <% if (privAdd || privUpdate || privDelete) {%>
                                                                                                                                                <a href="javascript:cmdPayment('<%=ai.getOID()%>')">
                                                                                                                                                    <%}%>
                                                                                                                                                    <%=ai.getInvoiceNumber()%>
                                                                                                                                                    <% if (privAdd || privUpdate || privDelete) {%>
                                                                                                                                                </a>
                                                                                                                                                <%}%>
                                                                                                                                                <%}%>
                                                                                                                                            </td>  
                                                                                                                                            <td class="tablearialcell" align="center"><%=JSPFormater.formatDate(ai.getDate(), "dd MMM yyyy")%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(aiTotal, formNumbComp)%></td>
                                                                                                                                            <td class="tablearialcell" align="center"><%=JSPFormater.formatDate(ai.getDueDate(), "dd MMM yyyy")%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(paid, formNumbComp)%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(balance, formNumbComp)%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                    cId = ai.getCustomerId();
                                                                                                                                }
                                                                                                                                        %>
                                                                                                                                        <tr height="22">
                                                                                                                                            <td class="tablearialcell1"></td>
                                                                                                                                            <td class="tablearialcell1" colspan="3" align="center"><B>TOTAL</B></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(total, formNumbComp)%></B></td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1">&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(bal, formNumbComp)%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="3">
                                                                                                                                            <td colspan="8" bgcolor="#5A87E3"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="5">
                                                                                                                                            <td colspan="8" ></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="20">
                                                                                                                                            <td colspan="8" bgcolor="#EFE2B4"><font face="arial"><B>&nbsp;&nbsp;Available payment : <%=available%></B></font></td>
                                                                                                                                        </tr> 
                                                                                                                                    </table>
                                                                                                                                </td>    
                                                                                                                            </tr>
                                                                                                                            <%}%>                                                                                                                          
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <script language="JavaScript">
                                                                                                                document.all.closecmd.style.display="";
                                                                                                                document.all.closemsg.style.display="none";
                                                                                                            </script>  
                                                                                                        </form>
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
