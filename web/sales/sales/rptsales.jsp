
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<%
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long salesId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader("Date dd/MM/yy", "5%");
        ctrlist.addHeader("Sales Number", "13%");
        ctrlist.addHeader("Amount", "10%");
        ctrlist.addHeader("Discount", "10%");
        ctrlist.addHeader("Vat", "10%");
        ctrlist.addHeader("Total Amount", "10%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:targetPage('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Sales sales = (Sales) objectClass.get(i);

            Vector rowx = new Vector();
            if (salesId == sales.getOID()) {
                index = i;
            }

            String str_dt_Date = "";
            try {
                Date dt_Date = sales.getDate();
                if (dt_Date == null) {
                    dt_Date = new Date();
                }

                str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yy");
            } catch (Exception e) {
                str_dt_Date = "";
            }

            rowx.add(str_dt_Date);

            rowx.add(sales.getNumber());

            Customer customer = new Customer();
            try {
                customer = DbCustomer.fetchExc(sales.getCustomerId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getAmount(), "#,###") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getDiscountAmount(), "#,###") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getVatAmount(), "#,###") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getAmount() - sales.getDiscountAmount() + sales.getVatAmount(), "#,###") + "</div>");

            String str_dt_StartDate = "";
            try {
                Date dt_StartDate = sales.getStartDate();
                if (dt_StartDate == null) {
                    dt_StartDate = new Date();
                }

                str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd/MM/yy");
            } catch (Exception e) {
                str_dt_StartDate = "";
            }

            String str_dt_EndDate = "";
            try {
                Date dt_EndDate = sales.getEndDate();
                if (dt_EndDate == null) {
                    dt_EndDate = new Date();
                }

                str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd/MM/yy");
            } catch (Exception e) {
                str_dt_EndDate = "";
            }

            Employee em = new Employee();
            try {
                em = DbEmployee.fetchExc(sales.getEmployeeId());
            } catch (Exception e) {
            }

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(sales.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int x = (request.getParameter("target_page") == null) ? 0 : Integer.parseInt(request.getParameter("target_page"));
            int salesType = JSPRequestValue.requestInt(request, "sales_type");

            long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
            String name = JSPRequestValue.requestString(request, "proj_name");
            String number = JSPRequestValue.requestString(request, "proj_number");
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
            int status = JSPRequestValue.requestInt(request, "status");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            int srcGroup = JSPRequestValue.requestInt(request, "src_group");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidSales = JSPRequestValue.requestLong(request, "hidden_sales_id");

            if (iJSPCommand == JSPCommand.NONE) {
                salesType = -1;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            String whereClause = "";
            String whereRetur = "";
            String orderClause = "";

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

//------------------ where ---------------------------
            if (chkInvDate == 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd 00:00:01") + "' and  date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd 23:59:59") + "'";
            }

            if (locationId != 0) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " location_id=" + locationId;
            }

            whereRetur = whereClause;

            if (salesType != -1) {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                    whereRetur = whereRetur + " and ";
                }
                whereClause = whereClause + " type=" + salesType;
                whereRetur = whereRetur + " type=" + salesType;
            } else {
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                    whereRetur = whereRetur + " and ";
                }
                whereClause = whereClause + " ( type= 0 or type=1 ) ";
                whereRetur = whereRetur + " ( type= 2 or type= 3 ) ";
            }

            if (whereClause != "") {
                whereClause = whereClause + " and ";
                whereRetur = whereRetur + " and ";
            }
            whereClause = whereClause + " sales_type=" + DbSales.TYPE_NON_CONSIGMENT;
            whereRetur = whereRetur + " sales_type=" + DbSales.TYPE_NON_CONSIGMENT;

            Vector listSales = DbSales.list(0, 0, whereClause, "date, unit_usaha_id, number");
            Vector listRetur = DbSales.list(0, 0, whereRetur, "date, unit_usaha_id, number");
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=salesSt%></title>
    <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        
        <%if (!masterPriv || !masterPrivView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function targetPage(oidSales){
            <%if (x == 1) {%>
            window.location="newconfirmation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
            <%} else if (x == 2) {%>
            window.location="newinstallation.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
            <%} else if (x == 3) {%>
            window.location="newclosing.jsp?menu_idx=<%=menuIdx%>&oid="+oidSales;
            <%} else {%>
            window.location="sales.jsp?menu_idx=<%=menuIdx%>&command=<%=JSPCommand.LIST%>&hidden_sales_id="+oidSales;
            <%}%>
        }
        
        function cmdSearch(){
            document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdAdd(){
            document.frmsales.hidden_sales_id.value="0";
            document.frmsales.command.value="<%=JSPCommand.ADD%>";
            document.frmsales.prev_command.value="<%=prevJSPCommand%>";
            document.frmsales.action="newsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdAsk(oidSales){
            document.frmsales.hidden_sales_id.value=oidSales;
            document.frmsales.command.value="<%=JSPCommand.ASK%>";
            document.frmsales.prev_command.value="<%=prevJSPCommand%>";
            document.frmsales.action="newsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdConfirmDelete(oidSales){
            document.frmsales.hidden_sales_id.value=oidSales;
            document.frmsales.command.value="<%=JSPCommand.DELETE%>";
            document.frmsales.prev_command.value="<%=prevJSPCommand%>";
            document.frmsales.action="newsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        function cmdSave(){
            document.frmsales.command.value="<%=JSPCommand.SAVE%>";
            document.frmsales.prev_command.value="<%=prevJSPCommand%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdEdit(oidSales, oidProposal){
            document.frmsales.hidden_proposal_id.value=oidProposal;
            document.frmsales.hidden_sales_id.value=oidSales;
            document.frmsales.hidden_sales.value=oidSales;
            document.frmsales.command.value="<%=JSPCommand.LIST%>";
            document.frmsales.prev_command.value="<%=prevJSPCommand%>";
            document.frmsales.action="sales.jsp";
            document.frmsales.submit();
        }
        
        function cmdCancel(oidSales){
            document.frmsales.hidden_sales_id.value=oidSales;
            document.frmsales.command.value="<%=JSPCommand.EDIT%>";
            document.frmsales.prev_command.value="<%=prevJSPCommand%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdBack(){
            document.frmsales.command.value="<%=JSPCommand.BACK%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListFirst(){
            document.frmsales.command.value="<%=JSPCommand.FIRST%>";
            document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListPrev(){
            document.frmsales.command.value="<%=JSPCommand.PREV%>";
            document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListNext(){
            document.frmsales.command.value="<%=JSPCommand.NEXT%>";
            document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListLast(){
            document.frmsales.command.value="<%=JSPCommand.LAST%>";
            document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmsales.action="rptsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
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
                                                                                    <form name="frmsales" method ="post" action="">
                                                                                        <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                        <input type="hidden" name="start" value="<%=start%>">
                                                                                        <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                            <tr> 
                                                                                                <td valign="top"> 
                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                        <tr valign="bottom"> 
                                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">&nbsp;&nbsp;Sales 
                                                                                                                    </font><font class="tit1">&raquo; 
                                                                                                                        <span class="lvl2">Sales 
                                                                                                                            Report<br>
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
                                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                    <tr> 
                                                                                                                        <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                                                                        <td colspan="3" height="14">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr> 
                                                                                                                        <td width="10%" height="14" nowrap>Date 
                                                                                                                        Between</td>
                                                                                                                        <td colspan="3" height="14"> 
                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                            and 
                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <tr> 
                                                                                                                        <td width="10%" height="14" nowrap>Cashier Location </td>
                                                                                                                        <td width="33%" height="14"> 
                                                                                                                            <%
            Vector vloc = DbLocation.list(0, 0, "", "name");
                                                                                                                            %>
                                                                                                                            <select name="src_location_id">
                                                                                                                                <option value="0">-- All --</option>
                                                                                                                                <%if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location us = (Location) vloc.get(i);
                                                                                                                                %>
                                                                                                                                <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                                                <%}
            }%>
                                                                                                                            </select>
                                                                                                                        </td>
                                                                                                                        <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                                                                        <td width="49%" height="14" nowrap>&nbsp; 
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <tr>
                                                                                                                        <td width="10%" height="14">Sales Type</td>
                                                                                                                        <td width="33%" height="14"> 
                                                                                                                            <select name="sales_type">
                                                                                                                                <option value="-1" <%if (salesType == -1) {%>selected<%}%>>-- All --</option>	
                                                                                                                                <option value="0" <%if (salesType == 0) {%>selected<%}%>>CASH</option>
                                                                                                                                <option value="1" <%if (salesType == 1) {%>selected<%}%>>CREDIT</option>
                                                                                                                            </select>
                                                                                                                        </td>
                                                                                                                        <td width="8%" height="14">&nbsp;</td>
                                                                                                                        <td width="49%" height="14">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr> 
                                                                                                                        <td width="10%" height="33">&nbsp;</td>
                                                                                                                        <td width="33%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                        <td width="8%" height="33">&nbsp;</td>
                                                                                                                        <td width="49%" height="33">&nbsp; 
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <tr> 
                                                                                                                        <td width="10%" height="15">&nbsp;</td>
                                                                                                                        <td width="33%" height="15">&nbsp; 
                                                                                                                        </td>
                                                                                                                        <td width="8%" height="15">&nbsp;</td>
                                                                                                                        <td width="49%" height="15">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <tr align="left" valign="top"> 
                                                                                                            <td height="20" valign="middle" colspan="3" class="comment">&nbsp;<b>Sales Report</b></td>
                                                                                                        </tr>
                                                                                                        <%
            try {
                                                                                                        %>
                                                                                                        <tr align="left" valign="top"> 
                                                                                                            <td height="22" valign="middle" colspan="4"> 
                                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                    <tr>
                                                                                                                        <td class="boxed1">
                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                <tr> 
                                                                                                                                    <td class="tablehdr" width="1%">No</td>
                                                                                                                                    <td class="tablehdr" width="5%">Date</td>
                                                                                                                                    <td class="tablehdr" width="7%">Sales No.</td>
                                                                                                                                    <td class="tablehdr" width="17%">Description</td>
                                                                                                                                    <td class="tablehdr" width="11%">Group</td>
                                                                                                                                    <td class="tablehdr" width="11%">Customer</td>
                                                                                                                                    <td class="tablehdr" width="4%">Qty</td>
                                                                                                                                    <td class="tablehdr" width="4%">Price</td>
                                                                                                                                    <td class="tablehdr" width="7%">Amount</td>
                                                                                                                                    <td class="tablehdr" width="3%">Discount%</td>
                                                                                                                                    <td class="tablehdr" width="4%">Discount Amount</td>
                                                                                                                                    <td class="tablehdr" width="4%">PPN</td>
                                                                                                                                    <td class="tablehdr" width="7%">Kwitansi</td>
                                                                                                                                    <td class="tablehdr" width="5%">HPP</td>
                                                                                                                                    <td class="tablehdr" width="4%">Laba</td>
                                                                                                                                    <td class="tablehdr" width="2%">PPH%</td>
                                                                                                                                    <td class="tablehdr" width="4%">PPH Amount</td>
                                                                                                                                </tr>
                                                                                                                                <%
                                                                                                            double totalQty = 0;
                                                                                                            double totalAmount = 0;
                                                                                                            double totalDiscountPercent = 0;
                                                                                                            double totalVat = 0;
                                                                                                            double grandTotal = 0;
                                                                                                            double grandDiscountAmount = 0;
                                                                                                            double grandTotalKwitansi = 0;
                                                                                                            double grandTotalHpp = 0;
                                                                                                            double granTotalLaba = 0;
                                                                                                            double totallaba = 0;
                                                                                                            double grandTotalDiscountPercen = 0;
                                                                                                            double totalhpp = 0;
                                                                                                            double totalKwitansi = 0;
                                                                                                            int no = 1;
                                                                                                            double totalDiscount_invoice = 0;
                                                                                                            
                                                                                                            if (listSales != null && listSales.size() > 0) {
                                                                                                                for (int i = 0; i < listSales.size(); i++) {

                                                                                                                    Sales sales = (Sales) listSales.get(i);
                                                                                                                    Vector temp = DbSalesDetail.list(0, 0, "sales_id=" + sales.getOID(), "");

                                                                                                                    Customer cus = new Customer();
                                                                                                                    try {
                                                                                                                        cus = DbCustomer.fetchExc(sales.getCustomerId());
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                                    totalDiscount_invoice = 0;
                                                                                                                    totalDiscountPercent = 0;
                                                                                                                    totalhpp = 0;
                                                                                                                    totallaba = 0;
                                                                                                                    totalKwitansi = 0;
                                                                                                                    if (temp != null && temp.size() > 0) {
                                                                                                                        for (int xx = 0; xx < temp.size(); xx++) {
                                                                                                                            SalesDetail sd = (SalesDetail) temp.get(xx);
                                                                                                                            ItemMaster im = new ItemMaster();
                                                                                                                            try {
                                                                                                                                im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            ItemGroup ig = new ItemGroup();
                                                                                                                            try {
                                                                                                                                ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            totalAmount = totalAmount + sd.getTotal();
                                                                                                                            totalhpp = totalhpp + (sd.getCogs() * sd.getQty());
                                                                                                                            totallaba = totallaba + (sd.getTotal() - (sd.getCogs() * sd.getQty()));

                                                                                                                            if (sd.getDiscountPercent() == 0 && sd.getDiscountAmount() != 0) {
                                                                                                                                sd.setDiscountPercent(((sd.getDiscountAmount() / (sd.getTotal() + sd.getDiscountAmount())) * 100));
                                                                                                                            }
                                                                                                                            totalVat = totalVat + sales.getVatAmount();
                                                                                                                            totalDiscountPercent = totalDiscountPercent + sd.getDiscountPercent();
                                                                                                                            totalDiscount_invoice = totalDiscount_invoice + sd.getDiscountAmount();

                                                                                                                            grandTotal = grandTotal + sd.getTotal();
                                                                                                                            totalKwitansi = totalKwitansi + sd.getTotal() + sales.getVatAmount();
                                                                                                                                %>
                                                                                                                                <tr> 
                                                                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="2%"> 
                                                                                                                                        <div align="center"><font size="1"><%=(xx == 0) ? "" + no : ""%></font></div>
                                                                                                                                        <%if(xx == 0){
                                                                                                                                            no = no+1 ;
                                                                                                                                        }%>
                                                                                                                                    </td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="5%"><font size="1"><%=(xx == 0) ? JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") : ""%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"><font size="1"><%=(xx == 0) ? sales.getNumber() : ""%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="17%"><font size="1"><%=im.getName()%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="11%"><font size="1"><%=ig.getName()%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="11%"><font size="1"><%=(xx == 0 && cus.getOID() != 0) ? cus.getName() : ""%></font></td>
                                                                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="4%"> 
                                                                                                                                        <div align="right"><font size="1"><%=sd.getQty()%></font></div>
                                                                                                                                        <%totalQty = totalQty + sd.getQty();%>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"><font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getTotal() + sd.getDiscountAmount(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=sd.getDiscountPercent()%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getDiscountAmount(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getTotal() + sales.getVatAmount(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getTotal() - (sd.getCogs() * sd.getQty()), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getPphPercent(), "#,###") : ""%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getPphAmount(), "#,###") : ""%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                                <%}%>
                                                                                                                                <%if (temp.size() > 1) {%>
                                                                                                                                <tr> 
                                                                                                                                    <td height="2" width="2%">&nbsp;</td>
                                                                                                                                    <td height="2" width="5%">&nbsp;</td>
                                                                                                                                    <td height="2" width="7%">&nbsp;</td>
                                                                                                                                    <td height="2" width="17%">&nbsp;</td>
                                                                                                                                    <td height="2" width="11%">&nbsp;</td>
                                                                                                                                    <td height="2" width="11%">&nbsp;</td>
                                                                                                                                    <td height="2" width="4%">&nbsp;</td>
                                                                                                                                    <td height="2" width="6%">&nbsp;</td>
                                                                                                                                    <td height="2" class="tablecell1" width="7%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount() + totalDiscount_invoice, "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getDiscountPercent() + totalDiscountPercent, "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalDiscount_invoice, "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount() + sales.getVatAmount(), "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%">
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalhpp, "#,###")%></font></div>                                                                      
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%">
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(totallaba, "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getPphPercent(), "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecell1" width="6%"> 
                                                                                                                                        <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getPphAmount(), "#,###")%></font></div>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                                <%}%>
                                                                                                                                <tr> 
                                                                                                                                    <td colspan="16" height="2"></td>
                                                                                                                                </tr>
                                                                                                                                <%}

                                                                                                                    grandDiscountAmount = grandDiscountAmount + totalDiscount_invoice + sales.getDiscountAmount();
                                                                                                                    grandTotalDiscountPercen = grandTotalDiscountPercen + totalDiscountPercent + sales.getDiscountPercent();
                                                                                                                    grandTotalKwitansi = grandTotalKwitansi + totalKwitansi;
                                                                                                                    grandTotalHpp = grandTotalHpp + totalhpp;
                                                                                                                    granTotalLaba = granTotalLaba + totallaba;
                                                                                                                }
                                                                                                            }%>
                                                                                                                                <%
                                                                                                                                
                                                                                                                                if (listRetur != null && listRetur.size() > 0) {

                                                                                                                for (int i = 0; i < listRetur.size(); i++) {

                                                                                                                    Sales sales = (Sales) listRetur.get(i);
                                                                                                                    Vector temp = DbSalesDetail.list(0, 0, "sales_id=" + sales.getOID(), "");

                                                                                                                    Customer cus = new Customer();
                                                                                                                    try {
                                                                                                                        cus = DbCustomer.fetchExc(sales.getCustomerId());
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                                    
                                                                                                                    totalDiscount_invoice = 0;
                                                                                                                    totalDiscountPercent = 0;
                                                                                                                    totalhpp = 0;
                                                                                                                    totallaba = 0;
                                                                                                                    totalKwitansi = 0;
                                                                                                                    
                                                                                                                    if (temp != null && temp.size() > 0) {
                                                                                                                        for (int xx = 0; xx < temp.size(); xx++) {
                                                                                                                            SalesDetail sd = (SalesDetail) temp.get(xx);
                                                                                                                            ItemMaster im = new ItemMaster();
                                                                                                                            try {
                                                                                                                                im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            ItemGroup ig = new ItemGroup();
                                                                                                                            try {
                                                                                                                                ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            totalAmount = totalAmount - sd.getTotal();
                                                                                                                            totalhpp = totalhpp + (sd.getCogs() * sd.getQty());
                                                                                                                            totallaba = totallaba + (sd.getTotal() - (sd.getCogs() * sd.getQty()));

                                                                                                                            if (sd.getDiscountPercent() == 0 && sd.getDiscountAmount() != 0) {
                                                                                                                                sd.setDiscountPercent(((sd.getDiscountAmount() / (sd.getTotal() + sd.getDiscountAmount())) * 100));
                                                                                                                            }
                                                                                                                            totalVat = totalVat - sales.getVatAmount();
                                                                                                                            totalDiscountPercent = totalDiscountPercent + sd.getDiscountPercent();
                                                                                                                            totalDiscount_invoice = totalDiscount_invoice + sd.getDiscountAmount();
                                                                                                                            grandTotal = grandTotal - sd.getTotal();
                                                                                                                            totalKwitansi = totalKwitansi + sd.getTotal() + sales.getVatAmount();
                                                                                                                                %>
                                                                                                                                <tr> 
                                                                                                                                    <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="2%"> 
                                                                                                                                        <div align="center"><font size="1"><%=(xx == 0) ? "" + no : ""%></font></div>
                                                                                                                                        <%if(xx == 0){
                                                                                                                                            no = no +1 ;
                                                                                                                                        }%>
                                                                                                                                    </td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="5%"><font size="1"><%=(xx == 0) ? JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") : ""%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="7%"><font size="1"><%=(xx == 0) ? sales.getNumber() : ""%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="17%"><font size="1"><%=im.getName()%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="11%"><font size="1"><%=ig.getName()%></font></td>
                                                                                                                                <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="11%"><font size="1"><%=(xx == 0 && cus.getOID() != 0) ? cus.getName() : ""%></font></td>
                                                                                                                                    <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="4%"> 
                                                                                                                                        <div align="right"><font size="1"><%=sd.getQty()%></font></div>
                                                                                                                                        <%totalQty = totalQty + sd.getQty();%>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (1 == 0) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"><font size="1"> 
                                                                                                                                            <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="7%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%  
                                                                                                                                            double xd = sd.getTotal() + sd.getDiscountAmount();
                                                                                                                                            if(xd > 0){
                                                                                                                                            %>
                                                                                                                                                (<%=JSPFormater.formatNumber(sd.getTotal() + sd.getDiscountAmount(), "#,###")%>)
                                                                                                                                            <%
                                                                                                                                            }else{
                                                                                                                                            %>
                                                                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() + sd.getDiscountAmount(), "#,###")%>) 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%if(sd.getDiscountPercent() > 0){%>
                                                                                                                                                (<%=sd.getDiscountPercent()%>)                                                                                                                                            
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=sd.getDiscountPercent()%>
                                                                                                                                            <%}%> 
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%if(sd.getDiscountAmount() > 0){%>
                                                                                                                                                (<%=JSPFormater.formatNumber(sd.getDiscountAmount(), "#,###")%>)                                                                                                                                            
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=JSPFormater.formatNumber(sd.getDiscountAmount(), "#,###")%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%if(sales.getVatAmount() > 0){%>
                                                                                                                                                (<%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%>)                                                                                                                                            
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%
                                                                                                                                            double xs = sd.getTotal() + sales.getVatAmount();
                                                                                                                                            if(xs > 0){
                                                                                                                                            %>
                                                                                                                                                (<%=JSPFormater.formatNumber(sd.getTotal() + sales.getVatAmount(), "#,###")%>)                                                                                                                                             
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() + sales.getVatAmount(), "#,###")%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1">
                                                                                                                                            <%
                                                                                                                                            xs = sd.getCogs() * sd.getQty();
                                                                                                                                            if(xs > 0){
                                                                                                                                            %>
                                                                                                                                                (<%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###")%>)                                                                                                                                             
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###")%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%
                                                                                                                                            xs = sd.getTotal() - (sd.getCogs() * sd.getQty());
                                                                                                                                            if(xs > 0){
                                                                                                                                            %>
                                                                                                                                                (<%=JSPFormater.formatNumber(sd.getTotal() - (sd.getCogs() * sd.getQty()), "#,###")%>)                                                                                                                                             
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() - (sd.getCogs() * sd.getQty()), "#,###")%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%
                                                                                                                                            xs = sales.getPphPercent();
                                                                                                                                            if(xs > 0){
                                                                                                                                            %>
                                                                                                                                                (<%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getPphPercent(), "#,###") : ""%>)                                                                                                                                             
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getPphPercent(), "#,###") : ""%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                    <td <%if (temp.size() == 1) {%>class="tablecellx1"<%} else {%>class="tablecelxl"<%}%> width="6%"> 
                                                                                                                                        <div align="right"> 
                                                                                                                                        <font size="1"> 
                                                                                                                                            <%
                                                                                                                                            xs = sales.getPphAmount();
                                                                                                                                            if(xs > 0){
                                                                                                                                            %>
                                                                                                                                                (<%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getPphAmount(), "#,###") : ""%>)                                                                                                                                             
                                                                                                                                            <%}else{%>
                                                                                                                                                <%=(temp.size() == 1) ? JSPFormater.formatNumber(sales.getPphAmount(), "#,###") : ""%> 
                                                                                                                                            <%}%>
                                                                                                                                        </font></div>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                                <%}%>
                                                                                                                                <%if (temp.size() > 1) {%>
                                                                                                                                <tr> 
                                                                                                                                    <td height="2" width="2%">&nbsp;</td>
                                                                                                                                    <td height="2" width="5%">&nbsp;</td>
                                                                                                                                    <td height="2" width="7%">&nbsp;</td>
                                                                                                                                    <td height="2" width="17%">&nbsp;</td>
                                                                                                                                    <td height="2" width="11%">&nbsp;</td>
                                                                                                                                    <td height="2" width="11%">&nbsp;</td>
                                                                                                                                    <td height="2" width="4%">&nbsp;</td>
                                                                                                                                    <td height="2" width="6%">&nbsp;</td>
                                                                                                                                    <td height="2" class="tablecellx1" width="7%"> 
                                                                                                                                        <%
                                                                                                                                        double tx = sales.getAmount() + totalDiscount_invoice;
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(sales.getAmount() + totalDiscount_invoice, "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount() + totalDiscount_invoice, "#,###")%></font></div>
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%"> 
                                                                                                                                        <%
                                                                                                                                        tx = sales.getDiscountPercent() + totalDiscountPercent;
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(sales.getDiscountPercent() + totalDiscountPercent, "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getDiscountPercent() + totalDiscountPercent, "#,###")%></font></div>
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%"> 
                                                                                                                                        <%
                                                                                                                                        tx = totalDiscount_invoice;
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(totalDiscount_invoice, "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalDiscount_invoice, "#,###")%></font></div>
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%"> 
                                                                                                                                        <%
                                                                                                                                        tx = sales.getVatAmount();
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%></font></div>
                                                                                                                                        <%}%>    
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%"> 
                                                                                                                                        <%
                                                                                                                                        tx = sales.getAmount() + sales.getVatAmount();
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(sales.getAmount() + sales.getVatAmount(), "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getAmount() + sales.getVatAmount(), "#,###")%></font></div>
                                                                                                                                        <%}%>    
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%">
                                                                                                                                        <%
                                                                                                                                        tx = totalhpp;
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(totalhpp, "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalhpp, "#,###")%></font></div>                                                                      
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%">
                                                                                                                                        <%
                                                                                                                                        tx = totallaba;
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(totallaba, "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totallaba, "#,###")%></font></div>
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%"> 
                                                                                                                                        <%
                                                                                                                                        tx = sales.getPphPercent();
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(sales.getPphPercent(), "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getPphPercent(), "#,###")%></font></div>
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                    <td height="2" class="tablecellx1" width="6%"> 
                                                                                                                                        <%
                                                                                                                                        tx = sales.getPphAmount();
                                                                                                                                        if(tx > 0){%>
                                                                                                                                            <div align="right"><font size="1">(<%=JSPFormater.formatNumber(sales.getPphAmount(), "#,###")%>)</font></div>
                                                                                                                                        <%}else{%>
                                                                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getPphAmount(), "#,###")%></font></div>
                                                                                                                                        <%}%>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                                <%}%>
                                                                                                                                <tr> 
                                                                                                                                    <td colspan="16" height="2"></td>
                                                                                                                                </tr>
                                                                                                                                <%}
                                                                                                                    grandDiscountAmount = grandDiscountAmount + totalDiscount_invoice + sales.getDiscountAmount();
                                                                                                                    grandTotalDiscountPercen = grandTotalDiscountPercen + totalDiscountPercent + sales.getDiscountPercent();
                                                                                                                    grandTotalKwitansi = grandTotalKwitansi + totalKwitansi;
                                                                                                                    grandTotalHpp = grandTotalHpp + totalhpp;
                                                                                                                    granTotalLaba = granTotalLaba + totallaba;
                                                                                                                }
                                                                                                            }%>
                                                                                                                                <tr> 
                                                                                                                                    <td colspan="16" height="5"></td>
                                                                                                                                </tr>
                                                                                                                                <tr> 
                                                                                                                                    <td width="2%" height="19">&nbsp;</td>
                                                                                                                                    <td width="5%" height="19">&nbsp;</td>
                                                                                                                                    <td width="7%" height="19">&nbsp;</td>
                                                                                                                                    <td width="17%" height="19">&nbsp;</td>
                                                                                                                                    <td width="11%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="center"><font color="#FFFFFF" size="1"><b>T O T A L</b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="11%" height="19" bgcolor="#3366CC">&nbsp;</td>
                                                                                                                                    <td width="4%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="center"><font size="1"><b><font color="#FFFFFF"><%=totalQty%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"><font size="1"></font></td>
                                                                                                                                    <td width="7%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalDiscountPercen, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandDiscountAmount, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(totalVat, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalKwitansi, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalHpp, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC"> 
                                                                                                                                        <div align="right"><font size="1"><b><font color="#FFFFFF"><%=JSPFormater.formatNumber(granTotalLaba, "#,###")%></font></b></font></div>
                                                                                                                                    </td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC">&nbsp;</td>
                                                                                                                                    <td width="6%" height="19" bgcolor="#3366CC">&nbsp;</td>
                                                                                                                                </tr>
                                                                                                                                <tr> 
                                                                                                                                    <td colspan="16">&nbsp;</td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <tr> 
                                                                                                                        <td class="boxed1"><img src="../images/printxls.gif" width="120" height="22"></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                                        <tr align="left" valign="top"> 
                                                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                                                <span class="command"> 
                                                                                                            </span> </td>
                                                                                                        </tr>
                                                                                                        <tr align="left" valign="top"> 
                                                                                                            <td height="22" valign="middle" colspan="4"> 
                                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                    <tr> 
                                                                                                                        <td width="97%">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr align="left" valign="top"> 
                                                                                                <td height="8" valign="middle" colspan="3">&nbsp; 
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

