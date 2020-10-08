
<%-- 
    Document   : armemolist
    Created on : Nov 9, 2012, 2:51:46 PM
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
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long arInvoiceId = JSPRequestValue.requestLong(request, "hidden_ar_invoice_id");
            long customerId = JSPRequestValue.requestLong(request, "JSP_CUSTOMER_ID");
            String txtMember = JSPRequestValue.requestString(request, "txt_customer");
            String txtNumber = JSPRequestValue.requestString(request, "txt_number");
            String dateStart = JSPRequestValue.requestString(request, "date_start");
            String dateEnd = JSPRequestValue.requestString(request, "date_end");
            int ignore = JSPRequestValue.requestInt(request, "ignore");

            if (iJSPCommand == JSPCommand.NONE) {
                customerId = 0;
                txtMember = "";
                ignore = 1;
                txtNumber = "";
            }

            Date dtStart = new Date();
            Date dtEnd = new Date();

            if (ignore == 0) {
                dtStart = JSPFormater.formatDate(dateStart, "dd/MM/yyyy");
                dtEnd = JSPFormater.formatDate(dateEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String orderClause = "";

            CmdARInvoiceMemo cmdARInvoiceMemo = new CmdARInvoiceMemo(request);
            JSPLine ctrLine = new JSPLine();

            iErrCode = cmdARInvoiceMemo.action(iJSPCommand, arInvoiceId, 0);
            Vector listAR = new Vector();
            String where = "";

            if (iJSPCommand != JSPCommand.NONE) {

                where = where + DbARInvoice.colNames[DbARInvoice.COL_TYPE_AR] + " = " + DbARInvoice.TYPE_AR_MEMO;

                if (txtNumber.length() > 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + DbARInvoice.colNames[DbARInvoice.COL_JOURNAL_NUMBER] + " like '%" + txtNumber + "%'";
                }

                if (customerId > 0) {

                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] + " = " + customerId;
                }

                if (ignore == 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + DbARInvoice.colNames[DbARInvoice.COL_DATE] + " between '" + JSPFormater.formatDate(dtStart, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(dtEnd, "yyyy-MM-dd") + "'";
                }

                orderClause = DbARInvoice.colNames[DbARInvoice.COL_JOURNAL_NUMBER];

            }

            int vectSize = 0;

            if (iJSPCommand != JSPCommand.NONE) {
                vectSize = DbARInvoice.getCount(where);
            }

            msgString = cmdARInvoiceMemo.getMessage();
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {

                start = cmdARInvoiceMemo.actionList(iJSPCommand, start, vectSize, recordToGet);

            }
            /* end switch list*/

            /* get record to display */
            listAR = new Vector();
            if (iJSPCommand != JSPCommand.NONE) {
                listAR = DbARInvoice.list(start, recordToGet, where, orderClause);
            }

            if (listAR.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listAR = DbARInvoice.list(start, recordToGet, where, orderClause);
            }

            String[] langAP = {"Date", "Member", "Number", "Period", "Date", "Member", "Invoice", "Amount", "Memo", "Amount", "Number", "Date", "Member", "Status", "Click search button to searching the data", "Data not found"};
            String[] langNav = {"Account Receivable", "AR Memo", "Record", "Editor"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Member", "Number", "Periode", "Tanggal", "Member", "Faktur", "Jumlah", "Memo", "Jumlah", "Number", "Date", "Member", "Status", "Klik tombol search untuk mencari data", "Data tidak ditemukan"};
                langAP = langID;

                String[] navID = {"Piutang", "AR Memo", "Record", "Editor"};
                langNav = navID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        
        function cmdSearchMember(){
            window.open("<%=approot%>/ar/srcmember.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdSearch(){ 
                document.frmarapmemo.command.value="<%=JSPCommand.SEARCH%>";            
                document.frmarapmemo.action="armemolist.jsp";
                document.frmarapmemo.submit();
            }   
            
            function cmdToRecord(){
                document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
                document.frmarapmemo.action="armemo.jsp";
                document.frmarapmemo.submit();
            }    
            
            function cmdResetAll(){
                document.frmarapmemo.txt_customer.value="";
                document.frmarapmemo.JSP_CUSTOMER_ID.value="0";
            }
            
            function cmdEdit(arInvoiceId){
                document.frmarapmemo.hidden_ar_invoice_id.value=arInvoiceId;
                document.frmarapmemo.command.value="<%=JSPCommand.ASSIGN  %>";
                document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                document.frmarapmemo.select_idx.value="<%=-1%>";
                document.frmarapmemo.action="armemo.jsp";
                document.frmarapmemo.submit();
            }
            
            function cmdCancel(arInvoiceId){
                document.frmarapmemo.hidden_ar_invoice_id.value=arInvoiceId;
                document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
                document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                document.frmarapmemo.action="armemolist.jsp";
                document.frmarapmemo.submit();
            }
            
            function cmdListFirst(){
                document.frmarapmemo.command.value="<%=JSPCommand.FIRST%>";
                document.frmarapmemo.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmarapmemo.action="armemolist.jsp";
                document.frmarapmemo.submit();
            }
            
            function cmdListPrev(){
                document.frmarapmemo.command.value="<%=JSPCommand.PREV%>";
                document.frmarapmemo.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmarapmemo.action="armemolist.jsp";
                document.frmarapmemo.submit();
            }
            
            function cmdListNext(){
                document.frmarapmemo.command.value="<%=JSPCommand.NEXT%>";
                document.frmarapmemo.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmarapmemo.action="armemolist.jsp";
                document.frmarapmemo.submit();
            }
            
            function cmdListLast(){
                document.frmarapmemo.command.value="<%=JSPCommand.LAST%>";
                document.frmarapmemo.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmarapmemo.action="armemolist.jsp";
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
        <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
        <!-- #EndEditable --> </td>
    </tr>
    <tr> 
        <td valign="top"> 
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <!--DWLayoutTable-->
            <tr> 
            <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                  <%@ include file="../calendar/calendarframe.jsp"%>
            <!-- #EndEditable --> </td>
            <td width="100%" valign="top"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">&nbsp;" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                        <td><!-- #BeginEditable "content" --> 
                            <form name="frmarapmemo" method ="post" action="">
                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                            
                            <input type="hidden" name="hidden_ar_invoice_id" value="<%=arInvoiceId%>">    
                            <input type="hidden" name="select_idx" value="<%=-1%>">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3" class="container"> 
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr> 
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                        <tr> 
                                                            <td> 
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr> 
                                                                        <td width="100%" > 
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                <tr> 
                                                                                    <td colspan="6"> 
                                                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                            <tr > 
                                                                                                <td width="100%" nowrap>
                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr > 
                                                                                                            <td class="tab" nowrap> 
                                                                                                                <div align="center">&nbsp;&nbsp;<%=langNav[2]%>&nbsp;&nbsp;</div>
                                                                                                            </td>
                                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                            <td class="tabin" nowrap> 
                                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><%=langNav[3]%></a>&nbsp;&nbsp;</div>
                                                                                                            </td>
                                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>                                                                                                                                
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td height="20">&nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                <td>
                                                                                    <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr> 
                                                                                        <td width="15%">Number</td>
                                                                                        <td width="1%">:</td>
                                                                                        <td width="35%">
                                                                                            <input name="txt_number" value="<%=txtNumber%>" size="15">
                                                                                        </td>
                                                                                        <td width="10%"><%=langAP[4]%></td>
                                                                                        <td width="1%">:</td>
                                                                                        <td width="48%">                                                                                                                                    
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <input name="date_start" value="<%=JSPFormater.formatDate((dtStart == null) ? new Date() : dtStart, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.date_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                    </td> 
                                                                                                    <td>
                                                                                                        &nbsp;To&nbsp;
                                                                                                    </td> 
                                                                                                    <td>
                                                                                                        <input name="date_end" value="<%=JSPFormater.formatDate((dtEnd == null) ? new Date() : dtEnd, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.date_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                    </td> 
                                                                                                    <td><input type="checkbox" name="ignore" checked value="1" <%if (ignore == 1) {%>checked<%}%>></td>
                                                                                                    <td>&nbsp;Ignore</td>
                                                                                                </tr>
                                                                                            </table> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td ><%=langAP[5]%></td>
                                                                                        <td >:</td>
                                                                                        <td >
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input size="30" readonly type="text" name="txt_customer" value="<%=txtMember%>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input type="hidden" name="JSP_CUSTOMER_ID" value="<%=customerId%>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<a href="javascript:cmdSearchMember()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" border="0" height="17" style="padding:0px"></a>
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<a href="javascript:cmdResetAll()">Reset</a>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <td ></td><td ></td><td></td>
                                                                                    </tr>     
                                                                                    <tr> 
                                                                                    <td valign="top" colspan="6">&nbsp;</td>
                                                                                </td>    
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6"><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search" border="0"></a></td>
                                                                                </tr>
                                                                                <%if (iJSPCommand == JSPCommand.NONE) {%>
                                                                                <tr> 
                                                                                    <td colspan = "6" >&nbsp;</td>
                                                                                </tr>    
                                                                                <tr> 
                                                                                    <td colspan = "6" height="22" valign="middle" class="page">
                                                                                        <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                            <tr> 
                                                                                                <td class="tablecell1" ><%=langAP[14]%></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>    
                                                                                <%}%>
                                                                                <%if (iJSPCommand == JSPCommand.SEARCH && listAR.size() <= 0) {%>
                                                                                <tr> 
                                                                                    <td colspan = "6" >&nbsp;</td>
                                                                                </tr>    
                                                                                <tr> 
                                                                                    <td colspan = "6" height="22" valign="middle" class="page">
                                                                                        <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                            <tr> 
                                                                                                <td class="tablecell1" ><%=langAP[15]%></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>    
                                                                                <%}%>
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6">&nbsp;</td>
                                                                                </tr> 
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="90%" border="0" cellpadding="0" cellspacing="1">                                                                                               
                                                                                <%
            int number = start + 1;
            if (listAR != null && listAR.size() > 0) {
                                                                                %>
                                                                                <tr>
                                                                                    <td colspan="4">&nbsp;</td>
                                                                                </tr> 
                                                                                <tr>
                                                                                    <td class="tablehdr" width="5%">No.</td>
                                                                                    <td class="tablehdr" width="15%"><%=langAP[10]%></td>
                                                                                    <td class="tablehdr" width="15%"><%=langAP[11]%></td>
                                                                                    <td class="tablehdr"><%=langAP[12]%></td>
                                                                                    <td class="tablehdr" width="20%"><%=langAP[7]%></td>
                                                                                    <td class="tablehdr" width="10%"><%=langAP[13]%></td>
                                                                                </tr> 
                                                                                <%
                                                                                    for (int i = 0; i < listAR.size(); i++) {
                                                                                        ARInvoice objArInvoice = (ARInvoice) listAR.get(i);

                                                                                        Customer customer = new Customer();
                                                                                        try {
                                                                                            customer = DbCustomer.fetchExc(objArInvoice.getCustomerId());
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        double amount = DbARInvoiceDetail.getTotalAmount(objArInvoice.getOID());
                                                                                        if (amount != 0) {
                                                                                            amount = amount * -1;
                                                                                        }
                                                                                %>
                                                                                <tr>
                                                                                    <td class="tablecell" align="center"><%=number%></td>
                                                                                    <td class="tablecell" align="center"><a href="javascript:cmdEdit('<%=objArInvoice.getOID()%>')"><%=objArInvoice.getJournalNumber()%></a></td>
                                                                                    <td class="tablecell" align="center"><%=JSPFormater.formatDate(objArInvoice.getDate(), "yyyy-MM-dd")%></td>
                                                                                    <td class="tablecell" ><%=customer.getName()%></td>
                                                                                    <td class="tablecell" align="right"><%=JSPFormater.formatNumber(amount, "#,###")%>&nbsp;</td>
                                                                                    <td class="tablecell" align="center">
                                                                                        <%if (objArInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_DRAFT) {%>
                                                                                        DRAFT
                                                                                        <%} else if (objArInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_APPROVED) {%>
                                                                                        APPROVE
                                                                                        <%} else {%>
                                                                                        POSTED
                                                                                        <%}%>
                                                                                    </td>
                                                                                </tr> 
                                                                                <%
                                                                                        number++;
                                                                                    }%>
                                                                                <%}%>
                                                                                <tr align="left" valign="top"> 
                                                                                    <td height="8" align="left" colspan="6" class="command"> 
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
                                                                                            <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                            %>
                                                                                    <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
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
                                    <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                </form>
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
            <%@ include file = "../main/footer.jsp" %>
    <!-- #EndEditable --> </td>
</tr>
</table>
</body>
<!-- #EndTemplate --></html>
