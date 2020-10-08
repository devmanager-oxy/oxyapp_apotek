
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true; boolean privUpdate = true; boolean privDelete = true; boolean masterPriv = true; boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidARInvoice = JSPRequestValue.requestLong(request, "hidden_ar_invoice_id");
            long oidProject = JSPRequestValue.requestLong(request, "hidden_project_id");
            long oidProjectTerm = JSPRequestValue.requestLong(request, "hidden_project_term_id");
            String detailDesc = JSPRequestValue.requestString(request, "detail_desc");

            Project project = new Project();
            ProjectTerm projectTerm = new ProjectTerm();
            try {
                project = DbProject.fetchExc(oidProject);
                projectTerm = DbProjectTerm.fetchExc(oidProjectTerm);
            } catch (Exception e) {
            }

            Vector list = DbBankAccount.list(0, 0, "currency_id=" + projectTerm.getCurrencyId(), "");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            String whereClause = "";
            String orderClause = "";

            Company company = new Company();
            try {
                company = DbCompany.getCompany();
            } catch (Exception ex) {
            }

            CmdARInvoice ctrlARInvoice = new CmdARInvoice(request);
            JSPLine ctrLine = new JSPLine();
            Vector listARInvoice = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlARInvoice.action(iJSPCommand, oidARInvoice, company.getOID());
            /* end switch*/
            JspARInvoice jspARInvoice = ctrlARInvoice.getForm();

            /*count list All ARInvoice*/
            int vectSize = DbARInvoice.getCount(whereClause);

            ARInvoice aRInvoice = ctrlARInvoice.getARInvoice();
            ARInvoiceDetail aRInvoiceDetail = new ARInvoiceDetail();
            msgString = ctrlARInvoice.getMessage();

            if (oidARInvoice == 0) {
                oidARInvoice = aRInvoice.getOID();
            }

            if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0 && oidARInvoice != 0) {
                aRInvoiceDetail = DbARInvoiceDetail.executeDetailData(aRInvoice, project, projectTerm, detailDesc);
            }

            if (detailDesc.length() < 1) {
                iErrCode = 1;
                msgString = "Item detail required";
            }


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlARInvoice.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listARInvoice = DbARInvoice.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listARInvoice.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listARInvoice = DbARInvoice.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" /><script language="JavaScript">
            
            <%if (!masterPriv || !masterPrivView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdChange(){
                var val = document.frmarinvoice.<%=jspARInvoice.colNames[JspARInvoice.JSP_BANK_ACCOUNT_ID]%>.value;
         <%
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    BankAccount bc = (BankAccount) list.get(i);
         %>
             if('<%=bc.getOID()%>'==val){
                 document.frmarinvoice.acc_number.value='<%=bc.getAccNumber()%>';
                 document.frmarinvoice.acc_name.value='<%=bc.getName()%>';
             }
         <%}
            }%>
        }
        
        function cmdPrintXLS(){	 
            window.open("<%=printroot%>.report.RptAccReceivableXLS?oid=<%=oidARInvoice%>");
            }
            
            function cmdAdd(){
                document.frmarinvoice.hidden_ar_invoice_id.value="0";
                document.frmarinvoice.command.value="<%=JSPCommand.ADD%>";
                document.frmarinvoice.prev_command.value="<%=prevJSPCommand%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdAsk(oidARInvoice){
                document.frmarinvoice.hidden_ar_invoice_id.value=oidARInvoice;
                document.frmarinvoice.command.value="<%=JSPCommand.ASK%>";
                document.frmarinvoice.prev_command.value="<%=prevJSPCommand%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdConfirmDelete(oidARInvoice){
                document.frmarinvoice.hidden_ar_invoice_id.value=oidARInvoice;
                document.frmarinvoice.command.value="<%=JSPCommand.DELETE%>";
                document.frmarinvoice.prev_command.value="<%=prevJSPCommand%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            function cmdSave(){
                document.frmarinvoice.command.value="<%=JSPCommand.SAVE%>";
                document.frmarinvoice.prev_command.value="<%=prevJSPCommand%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdEdit(oidARInvoice){
                <%if (masterPrivUpdate) {%>
                document.frmarinvoice.hidden_ar_invoice_id.value=oidARInvoice;
                document.frmarinvoice.command.value="<%=JSPCommand.EDIT%>";
                document.frmarinvoice.prev_command.value="<%=prevJSPCommand%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
                <%}%>
            }
            
            function cmdCancel(oidARInvoice){
                document.frmarinvoice.hidden_ar_invoice_id.value=oidARInvoice;
                document.frmarinvoice.command.value="<%=JSPCommand.EDIT%>";
                document.frmarinvoice.prev_command.value="<%=prevJSPCommand%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdBack(){
                document.frmarinvoice.command.value="<%=JSPCommand.BACK%>";
                document.frmarinvoice.action="newarsrc.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdListFirst(){
                document.frmarinvoice.command.value="<%=JSPCommand.FIRST%>";
                document.frmarinvoice.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdListPrev(){
                document.frmarinvoice.command.value="<%=JSPCommand.PREV%>";
                document.frmarinvoice.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdListNext(){
                document.frmarinvoice.command.value="<%=JSPCommand.NEXT%>";
                document.frmarinvoice.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
            }
            
            function cmdListLast(){
                document.frmarinvoice.command.value="<%=JSPCommand.LAST%>";
                document.frmarinvoice.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmarinvoice.action="arinvoice.jsp";
                document.frmarinvoice.submit();
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
        
        <script type="text/javascript">
            <!--
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif','../images/printxls2.gif','../images/back2.gif')">
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
            String navigator = "<font class=\"lvl1\">Account Receivable</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">New Invoice</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
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
                                                                                                        <form name="frmarinvoice" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="hidden_project_id" value="<%=oidProject%>">
                                                                                                            <input type="hidden" name="hidden_project_term_id" value="<%=oidProjectTerm%>">
                                                                                                            <input type="hidden" name="hidden_ar_invoice_id" value="<%=oidARInvoice%>">
                                                                                                            <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_PROJECT_ID] %>"  value="<%=oidProject%>" class="formElemen">
                                                                                                            <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_PROJECT_TERM_ID] %>"  value="<%=oidProjectTerm%>" class="formElemen">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container">&nbsp; 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="21" width="11%">&nbsp;</td>
                                                                                                                                <td height="21" width="20%">&nbsp;</td>
                                                                                                                                <td height="21" width="11%">&nbsp;</td>
                                                                                                                                <td height="21" colspan="2" width="58%" class="comment"><b><i>&nbsp;</i></b></td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="21" width="11%"><b>Invoice 
                                                                                                                                To </b></td>
                                                                                                                                <td height="21" width="20%"> 
                                                                                                                                    <%
            Customer c = new Customer();
            try {
                c = DbCustomer.fetchExc(project.getCustomerId());
            } catch (Exception e) {
            }
            out.println(c.getCode() + " / " + c.getName());
                                                                                                                                    %>
                                                                                                                                    <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_CUSTOMER_ID] %>"  value="<%= project.getCustomerId() %>" class="formElemen">
                                                                                                                                </td>
                                                                                                                                <td height="21" width="11%"><b>Date</b></td>
                                                                                                                                <td height="21" colspan="2" width="58%" class="comment"><%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="21" width="11%">&nbsp;</td>
                                                                                                                                <td height="21" width="20%"><%=c.getAddress1()%></td>
                                                                                                                                <td height="21" width="11%"><b>Invoice Number</b></td>
                                                                                                                                <td height="21" colspan="2" width="58%" class="comment"> 
                                                                                                                                    <%
            String s = "";
            if (aRInvoice.getOID() == 0) {
                int count = DbARInvoice.getNextCounter(company.getOID());
                s = DbARInvoice.getNextNumber(count, company.getOID());
            } else {
                s = aRInvoice.getJournalNumber();
            }
                                                                                                                                    %>
                                                                                                                                    <input type="text" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_JOURNAL_NUMBER] %>"  value="<%=s%>" class="readonly" readOnly>
                                                                                                                                    <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_JOURNAL_PREFIX] %>"  value="<%= aRInvoice.getJournalPrefix() %>" class="formElemen">
                                                                                                                                    <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_JOURNAL_COUNTER] %>"  value="<%= aRInvoice.getJournalCounter() %>" class="formElemen">
                                                                                                                                    <input type="hidden" name="<%=jspARInvoice.colNames[jspARInvoice.JSP_OPERATOR_ID] %>"  value="<%= appSessUser.getUserOID() %>" class="formElemen">
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="10" width="11%"><b></b></td>
                                                                                                                                <td height="10" width="20%">&nbsp;</td>
                                                                                                                                <td height="10" width="11%"><b></b></td>
                                                                                                                                <td height="10" colspan="2" width="58%" class="comment">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="21" width="11%"><b>Project Number</b></td>
                                                                                                                                <td height="21" width="20%"><%=project.getNumber()%></td>
                                                                                                                                <td height="21" width="11%"><b>Project Date</b></td>
                                                                                                                                <td height="21" colspan="2" width="58%" class="comment"><%=JSPFormater.formatDate(project.getStartDate(), "dd MMMM yyyy")%></td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="21" width="11%" nowrap><b>Trans. Currency</b></td>
                                                                                                                                <td height="21" width="20%"> 
                                                                                                                                    <%
            Currency cx = new Currency();
            try {
                cx = DbCurrency.fetchExc(projectTerm.getCurrencyId());
            } catch (Exception e) {
            }
                                                                                                                                    %>
                                                                                                                                    <%=cx.getCurrencyCode()%> 
                                                                                                                                    <input type="hidden" name="<%=jspARInvoice.colNames[JspARInvoice.JSP_CURRENCY_ID]%>" value="<%=projectTerm.getCurrencyId()%>">
                                                                                                                                </td>
                                                                                                                                <td height="21" width="11%"><b>Due Date</b></td>
                                                                                                                                <td height="21" colspan="2" width="58%" class="comment"> 
                                                                                                                                    <!--<input name="<%=jspARInvoice.colNames[JspARInvoice.JSP_DUE_DATE] %>" value="<%=JSPFormater.formatDate((aRInvoice.getDueDate() == null) ? new Date() : aRInvoice.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly>-->
                                                                                                                                    <input name="<%=jspARInvoice.colNames[JspARInvoice.JSP_DUE_DATE] %>" value="<%=JSPFormater.formatDate((aRInvoice.getDueDate() == null) ? projectTerm.getDueDate() : aRInvoice.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarinvoice.<%=jspARInvoice.colNames[JspARInvoice.JSP_DUE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                            <td height="21" width="11%">&nbsp;</td>
                                                                                                                            <td height="21" width="20%">&nbsp; 
                                                                                                                            </td>
                                                                                                                            <td height="21" width="11%">&nbsp;</td>
                                                                                                                            <td height="21" colspan="2" width="58%">&nbsp; 
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="21" colspan="5"> 
                                                                                                                                    <table width="60%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                        <td class="boxed1"> 
                                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="4%" class="tablehdr" height="16">No</td>
                                                                                                                                                    <td width="54%" class="tablehdr" height="16">Item 
                                                                                                                                                    Description</td>
                                                                                                                                                    <td width="4%" class="tablehdr" height="16">Qty</td>
                                                                                                                                                    <td width="19%" class="tablehdr" height="16">Amount</td>
                                                                                                                                                    <td width="19%" class="tablehdr" height="16">Total</td>
                                                                                                                                                </tr>
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="4%" class="tablecell1" valign="top"> 
                                                                                                                                                        <div align="center">1</div>
                                                                                                                                                    </td>
                                                                                                                                                    <td width="54%" class="tablecell1"> 
                                                                                                                                                        <%
            String str = "";
            str = projectTerm.getDescription();
                                                                                                                                                        %>
                                                                                                                                                        <textarea name="detail_desc" cols="50" rows="5"><%=str%></textarea>
                                                                                                                                                    </td>
                                                                                                                                                    <td width="4%" class="tablecell1" valign="top"> 
                                                                                                                                                        <div align="center">1</div>
                                                                                                                                                    </td>
                                                                                                                                                    <td width="19%" class="tablecell1" valign="top"> 
                                                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(projectTerm.getAmount(), "#,###.##")%></div>
                                                                                                                                                    </td>
                                                                                                                                                    <td width="19%" class="tablecell1" valign="top"> 
                                                                                                                                                        <div align="right"><%=JSPFormater.formatNumber(projectTerm.getAmount(), "#,###.##")%></div>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="4%" class="tablecell1">&nbsp;</td>
                                                                                                                                                    <td width="54%" class="tablecell1">&nbsp;</td>
                                                                                                                                                    <td width="4%" class="tablecell1">&nbsp;</td>
                                                                                                                                                    <td width="19%" class="tablecell1">&nbsp;</td>
                                                                                                                                                    <td width="19%" class="tablecell1">&nbsp;</td>
                                                                                                                                                </tr>
                                                                                                                                                <tr> 
                                                                                                                                                    <td colspan="4" class="tablecell"> 
                                                                                                                                                        <div align="center"><b>T 
                                                                                                                                                                O 
                                                                                                                                                                T 
                                                                                                                                                                A 
                                                                                                                                                                L 
                                                                                                                                                                : 
                                                                                                                                                        </b></div>
                                                                                                                                                    </td>
                                                                                                                                                    <td width="19%" class="tablecell"> 
                                                                                                                                                        <div align="right"><b><%=JSPFormater.formatNumber(projectTerm.getAmount(), "#,###.##")%></b></div>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                            </table>
                                                                                                                                        </td>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left"> 
                                                                                                                            <td height="21" colspan="5"></td>
                                                                                                                            <tr align="left"> 
                                                                                                                            <tr align="left"> 
                                                                                                                            <td height="21" colspan="5"><b>Notes 
                                                                                                                            :</b></td>
                                                                                                                            <tr align="left"> 
                                                                                                                            <td height="21" colspan="5"> 
                                                                                                                                <textarea name="<%=jspARInvoice.colNames[JspARInvoice.JSP_MEMO] %>" class="formElemen" cols="124" rows="3"><%= aRInvoice.getMemo() %></textarea>
                                                                                                                            </td>
                                                                                                                            <tr align="left"> 
                                                                                                                            <td height="21" width="11%">&nbsp;</td>
                                                                                                                            <td height="21" width="20%">&nbsp;</td>
                                                                                                                            <td height="21" width="11%">&nbsp;</td>
                                                                                                                            <td height="21" colspan="2" width="58%">&nbsp; 
                                                                                                                            <tr align="left"> 
                                                                                                                            <td height="21" colspan="5"> 
                                                                                                                                <table width="70%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                    <tr> 
                                                                                                                                        <td width="16%"><b>Transfer 
                                                                                                                                        By :</b></td>
                                                                                                                                        <td width="84%">&nbsp;</td>
                                                                                                                                    </tr>
                                                                                                                                    <tr> 
                                                                                                                                        <td width="16%">Bank 
                                                                                                                                        Account</td>
                                                                                                                                        <td width="84%"> 
                                                                                                                                            <%if (list != null && list.size() > 0) {%>
                                                                                                                                            <select name="<%=jspARInvoice.colNames[JspARInvoice.JSP_BANK_ACCOUNT_ID]%>" onChange="javascript:cmdChange()">
                                                                                                                                                <%	for (int i = 0; i < list.size(); i++) {
        BankAccount bc = (BankAccount) list.get(i);
                                                                                                                                                %>
                                                                                                                                                <option value="<%=bc.getOID()%>" <%if (bc.getOID() == aRInvoice.getBankAccountId()) {%>selected<%}%>><%=bc.getBankName()%></option>
                                                                                                                                                <%}%>
                                                                                                                                            </select>
                                                                                                                                            <%} else {%>
                                                                                                                                            <input type="text" name="textfield2" size="50">
                                                                                                                                            <%}%>
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                    <tr> 
                                                                                                                                        <td width="16%">Account Number</td>
                                                                                                                                        <td width="84%"> 
                                                                                                                                            <input type="text" name="acc_number" size="50" readOnly class="readonly">
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                    <tr> 
                                                                                                                                        <td width="16%">Name</td>
                                                                                                                                        <td width="84%"> 
                                                                                                                                            <input type="text" name="acc_name" size="50" readOnly class="readonly">
                                                                                                                                        </td>
                                                                                                                                    </tr>
                                                                                                                                    <tr> 
                                                                                                                                        <td width="16%">&nbsp;</td>
                                                                                                                                        <td width="84%">&nbsp;</td>
                                                                                                                                    </tr>
                                                                                                                                </table>
                                                                                                                            </td>
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="8" valign="middle" width="11%">&nbsp;</td>
                                                                                                                                <td height="8" valign="middle" width="20%">&nbsp;</td>
                                                                                                                                <td height="8" valign="middle" width="11%">&nbsp;</td>
                                                                                                                                <td height="8" colspan="2" width="58%" valign="top">&nbsp; 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%if (oidARInvoice == 0) {%>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" class="command" valign="top"> 
                                                                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidARInvoice + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidARInvoice + "')";
    String scancel = "javascript:cmdEdit('" + oidARInvoice + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("");

    ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //ctrLine.setOnMouseOut("MM_swapImgRestore()");
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
    ctrLine.setAddCaption("");

    //out.println("msgString : "+msgString);

                                                                                                                                    %>
                                                                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="11%">&nbsp;</td>
                                                                                                                                <td width="20%">&nbsp;</td>
                                                                                                                                <td width="11%">&nbsp;</td>
                                                                                                                                <td width="58%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%} else {%>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" valign="top"> 
                                                                                                                                    <div align="left"> 
                                                                                                                                        <table width="40%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                            <tr> 
                                                                                                                                                <%
                                                                                                                                                if (oidARInvoice == 0) {
                                                                                                                                                %>
                                                                                                                                                <td width="18%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/save2.gif',1)"><img src="../images/save.gif" name="new22" border="0" height="22"></a></td>
                                                                                                                                                <%}%>
                                                                                                                                                <td width="33%"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="new21" border="0"></a></td>
                                                                                                                                                <td width="29%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new23','','../images/back2.gif',1)"><img src="../images/back.gif" name="new23" border="0" width="51" height="22"></a></td>
                                                                                                                                                <td width="0%">&nbsp;</td>
                                                                                                                                                <td width="0%">&nbsp;</td>
                                                                                                                                            </tr>
                                                                                                                                        </table>
                                                                                                                                    </div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="5" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
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
                                                                        <tr> 
                                                                            <td height="25"> 
                                                                                <script language="JavaScript">
                                                                                    cmdChange();
                                                                                </script>
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

