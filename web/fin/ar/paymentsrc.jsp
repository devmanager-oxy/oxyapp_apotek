
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%

            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            int recordToGet = 20;
            JSPLine jspLine = new JSPLine();

            long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
            String inv_number = JSPRequestValue.requestString(request, "inv_number");
            String proj_number = JSPRequestValue.requestString(request, "proj_number");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            Date startDueDate = (JSPRequestValue.requestString(request, "startDueDate") == null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "startDueDate"), "dd/MM/yyyy");
            Date endDueDate = (JSPRequestValue.requestString(request, "endDueDate") == null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "endDueDate"), "dd/MM/yyyy");
            long unitUsahaId = JSPRequestValue.requestLong(request, "src_unit_usaha_id");

            int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
            int chkDueDate = JSPRequestValue.requestInt(request, "chkDueDate");
            int chkOverdue = JSPRequestValue.requestInt(request, "chkOverdue");

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                chkInvDate = 1;
                chkDueDate = 1;
                chkOverdue = 1;
            }

            String whereClause = "";
            String orderClause = "";

            if(oidCustomer != 0) {
                whereClause = "a.customer_id=" + oidCustomer;
            }
            if (inv_number.length() > 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "a.invoice_number like '%" + inv_number + "%'";
            }
            if (proj_number.length() > 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "b.number like '%" + proj_number + "%'";
            }
            if (chkInvDate == 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "a.date between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "'";
            }
            if (chkDueDate == 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "a.due_date between '" + JSPFormater.formatDate(startDueDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDueDate, "yyyy-MM-dd") + "'";
            }
            if (chkOverdue == 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "a.due_date >= '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "'";
            }
            if (unitUsahaId != 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "b.unit_usaha_id = " + unitUsahaId;
            }

            int vectSize = QrAR.getCount(whereClause);
            CmdUnitUsaha cmdUnitUsaha = new CmdUnitUsaha(request);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdUnitUsaha.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            
            Vector vInvList = QrAR.list(start, recordToGet, whereClause, orderClause);
            
            String[] langAR = {"Customer","Project Name","Project Number"};
            String[] langNav = {"Account Receiveable", "Payment List"};

            if (lang == LANG_ID) {
                String[] langID = {"Customer","Nama Proyek","Nomor Proyek"};
                langAR = langID;

                String[] navID = {"Piutang", "Daftar Pembayaran"};
                langNav = navID;
            }

            
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <%if (!masterPriv || !masterPrivView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdListFirst(){
                document.form1.command.value="<%=JSPCommand.FIRST%>";
                document.form1.prev_command.value="<%=JSPCommand.FIRST%>";
                document.form1.action="paymentsrc.jsp";
                document.form1.submit();
            }
            
            function cmdListPrev(){
                document.form1.command.value="<%=JSPCommand.PREV%>";
                document.form1.prev_command.value="<%=JSPCommand.PREV%>";
                document.form1.action="paymentsrc.jsp";
                document.form1.submit();
            }
            
            function cmdListNext(){
                document.form1.command.value="<%=JSPCommand.NEXT%>";
                document.form1.prev_command.value="<%=JSPCommand.NEXT%>";
                document.form1.action="paymentsrc.jsp";
                document.form1.submit();
            }
            
            function cmdListLast(){
                document.form1.command.value="<%=JSPCommand.LAST%>";
                document.form1.prev_command.value="<%=JSPCommand.LAST%>";
                document.form1.action="paymentsrc.jsp";
                document.form1.submit();
            }
            
            function cmdSearch(){
                document.form1.start.value="0";
                document.form1.command.value="<%=JSPCommand.SUBMIT%>";
                document.form1.action="paymentsrc.jsp";
                document.form1.submit();
            }
            
            function cmdInvoice(idProj, idPt){
                document.form1.command.value="<%=JSPCommand.ADD%>";
                document.form1.hidden_project_id.value=idProj;
                document.form1.hidden_project_term_id.value=idPt;
                document.form1.action="arinvoice.jsp";
                document.form1.submit();
            }
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">&nbsp;"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
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
                                                                                                        <form id="form1" name="form1" method="post" action="">
                                                                                                            <input type="hidden" name="command">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td colspan="4" height="3"></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="4" height="25"><b>Please, 
                                                                                                                                        search for invoice 
                                                                                                                                to be paid</b></td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="10%" nowrap height="15">Customer</td>
                                                                                                                                <td colspan="3" nowrap height="15"> 
                                                                                                                                    <%
            Vector cust = DbCustomer.list(0, 0, "", "name");
                                                                                                                                    %>
                                                                                                                                    <select name="customer_id" onChange="javascript:cmdSearch()">
                                                                                                                                        <option value="0">-- 
                                                                                                                                        All --</option>
                                                                                                                                        <%if (cust != null && cust.size() > 0) {
                for (int i = 0; i < cust.size(); i++) {
                    Customer c = (Customer) cust.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=c.getOID()%>" <%if (c.getOID() == oidCustomer) {%>selected<%}%>><%=c.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="15" nowrap>Invoice 
                                                                                                                                Date between</td>
                                                                                                                                <td height="15" nowrap colspan="3"> 
                                                                                                                                <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                and 
                                                                                                                                <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                <input type="checkbox" name="chkInvDate" value="1" <%if (chkInvDate == 1) {%>checked<%}%>>
                                                                                                                                       Ignored</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="15" nowrap>Invoice 
                                                                                                                                Number</td>
                                                                                                                                <td height="15" nowrap> 
                                                                                                                                    <input type="text" name="inv_number" value="<%=(inv_number == null) ? "" : inv_number%>" size="35">
                                                                                                                                </td>
                                                                                                                                <td height="15" nowrap>Due 
                                                                                                                                Date between</td>
                                                                                                                                <td height="15" nowrap> 
                                                                                                                                <input name="startDueDate" value="<%=JSPFormater.formatDate((startDueDate == null) ? new Date() : startDueDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.startDueDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                and 
                                                                                                                                <input name="endDueDate" value="<%=JSPFormater.formatDate((endDueDate == null) ? new Date() : endDueDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.endDueDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                <input type="checkbox" name="chkDueDate" value="1" <%if (chkDueDate == 1) {%>checked<%}%>>
                                                                                                                                       Ignored </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td nowrap height="15">Project 
                                                                                                                                Number</td>
                                                                                                                                <td nowrap height="15"> 
                                                                                                                                    <input type="text" name="proj_number" value="<%=(proj_number == null) ? "" : proj_number%>" size="35">
                                                                                                                                </td>
                                                                                                                                <td nowrap height="15">Overdue</td>
                                                                                                                                <td nowrap height="15"> 
                                                                                                                                <input type="checkbox" name="chkOverdue" value="1" <%if (chkOverdue == 1) {%>checked<%}%>>
                                                                                                                                       Include Overdue</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="15">Unit 
                                                                                                                                Usaha </td>
                                                                                                                                <td height="15"> 
                                                                                                                                    <%
            Vector unitUsh = DbUnitUsaha.list(0, 0, "", "name");
                                                                                                                                    %>
                                                                                                                                    <select name="src_unit_usaha_id">
                                                                                                                                        <option value="0">-- 
                                                                                                                                        All --</option>
                                                                                                                                        <%if (unitUsh != null && unitUsh.size() > 0) {
                for (int i = 0; i < unitUsh.size(); i++) {
                    UnitUsaha us = (UnitUsaha) unitUsh.get(i);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=us.getOID()%>" <%if (us.getOID() == unitUsahaId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td height="15">&nbsp;</td>
                                                                                                                                <td height="15">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="35">&nbsp;</td>
                                                                                                                                <td height="35"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                                                                </td>
                                                                                                                                <td height="35">&nbsp;</td>
                                                                                                                                <td height="35">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="4" class="boxed1"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablehdr" width="3%">No</td>
                                                                                                                                            <td class="tablehdr" width="21%">Customer</td>
                                                                                                                                            <td class="tablehdr" width="10%">Invoice Number</td>
                                                                                                                                            <td class="tablehdr" width="12%">Project Number</td>
                                                                                                                                            <td class="tablehdr" width="10%">Due Date</td>
                                                                                                                                            <td class="tablehdr" width="8%">Currency</td>
                                                                                                                                            <td class="tablehdr" width="13%">Balance</td>
                                                                                                                                        </tr>
                                                                                                                                        <%
            if (vInvList != null && vInvList.size() > 0) {
                for (int i = 0; i < vInvList.size(); i++) {
                    ARInvoice arInv = (ARInvoice) vInvList.get(i);
                    //Load Currency
                    Currency curr = new Currency();
                    try {
                        curr = DbCurrency.fetchExc(arInv.getCurrencyId());
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    //Load Customer
                    Customer customer = new Customer();
                    try {
                        customer = DbCustomer.fetchExc(arInv.getCustomerId());
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    //Load Project
                    //jika asal invoice dari project
                    Project proj = new Project();
                    if (arInv.getSalesSource() == 0) {
                        try {
                            proj = DbProject.fetchExc(arInv.getProjectId());
                        } catch (Exception e) {
                            System.out.println(e);
                        }
                    }

                    Sales sales = new Sales();
                    if (arInv.getSalesSource() == 1) {
                        try {
                            sales = DbSales.fetchExc(arInv.getProjectId());
                        } catch (Exception e) {
                            System.out.println(e);
                        }
                    }

                    //Load Invoice Detail
                    Vector vArDetail = new Vector(1, 1);
                    ARInvoiceDetail arInvDetail = new ARInvoiceDetail();
                    try {
                        vArDetail = DbARInvoiceDetail.list(0, 0, "ar_invoice_id=" + arInv.getOID(), "");
                    } catch (Exception e) {
                        System.out.println();
                    }
                    if (vArDetail != null && vArDetail.size() > 0) {
                        arInvDetail = (ARInvoiceDetail) vArDetail.get(0);
                    }
                    //Load Payment Detail
                    ArPayment arPay = new ArPayment();
                    try {
                    } catch (Exception e) {
                        System.out.println(e);
                    }

                    //Load Class
                    String tableClass = "tablecell1";
                    if (i % 2 != 0) {
                        tableClass = "tablecell";
                    }
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <div align="center"><%=start + i + 1%></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <a href="invoicepayment.jsp?oid=<%=arInv.getOID()%>&menu_idx=<%=menuIdx%>"><%=customer.getName()%></a> 
                                                                                                                                            </td>
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <div align="left"><%=arInv.getInvoiceNumber()%></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <div align="left">
                                                                                                                                                    <%if (arInv.getSalesSource() == 0) {%>
                                                                                                                                                    <%=proj.getNumber()%>
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <%=sales.getNumber()%>
                                                                                                                                                    <%}%>
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <div align="center"><%=JSPFormater.formatDate(arInv.getDueDate(), "dd MMMM yyyy")%></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <div align="center"><%=curr.getCurrencyCode()%></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="14" class="<%=tableClass%>"> 
                                                                                                                                                <%
                                                                                                                                                    /*
                                                                                                                                                    pph dibayar oleh konsumen, jadi total piutang adalah dikurangi dengan pph
                                                                                                                                                     */
                                                                                                                                                %>
                                                                                                                                                <div align="right">
                                                                                                                                                    <%if (arInv.getSalesSource() == 0) {%>
                                                                                                                                                    <%
    double x = arInvDetail.getTotalAmount() - 3;

                                                                                                                                                    %>
                                                                                                                                                    <%=JSPFormater.formatNumber(arInvDetail.getTotalAmount() - proj.getPphAmount(), "#,###.##")%>
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <%=JSPFormater.formatNumber(arInvDetail.getTotalAmount() - sales.getPphAmount(), "#,###.##")%>
                                                                                                                                                    <%}%>
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
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="4"> 
                                                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) || (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevCommand;
                }
            }
            jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();

            jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                                                                    %>
                                                                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td height="15">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td>&nbsp;</td>
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

