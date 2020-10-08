
<%-- 
    Document   : reportsalesbylocation
    Created on : Apr 2, 2013, 4:37:31 PM
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
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_LOCATION);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_SALES_REPORT), AppMenu.M2_SAL_REPORT_BY_LOCATION, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_SALES_REPORT), AppMenu.M2_SAL_REPORT_BY_LOCATION, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_SALES_REPORT), AppMenu.M2_SAL_REPORT_BY_LOCATION, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_SALES_REPORT), AppMenu.M2_SAL_REPORT_BY_LOCATION, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%
            int x = (request.getParameter("target_page") == null) ? 0 : Integer.parseInt(request.getParameter("target_page"));
            int salesType = JSPRequestValue.requestInt(request, "sales_type");

            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");
            int status = JSPRequestValue.requestInt(request, "status");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            if (iJSPCommand == JSPCommand.NONE) {
                salesType = -1;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            String whereClause = "";
            String orderClause = "";

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            Vector listSales = new Vector();

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
            document.frmsales.action="rptsalesByLocation.jsp?menu_idx=<%=menuIdx%>";
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
        
        function cmdListFirst(){
            document.frmsales.command.value="<%=JSPCommand.FIRST%>";
            document.frmsales.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmsales.action="rptsalesByLocation.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListPrev(){
            document.frmsales.command.value="<%=JSPCommand.PREV%>";
            document.frmsales.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmsales.action="rptsalesByLocation.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListNext(){
            document.frmsales.command.value="<%=JSPCommand.NEXT%>";
            document.frmsales.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmsales.action="rptsalesByLocation.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdListLast(){
            document.frmsales.command.value="<%=JSPCommand.LAST%>";
            document.frmsales.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmsales.action="rptsalesByLocation.jsp?menu_idx=<%=menuIdx%>";
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
                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                        </font><font class="tit1">&raquo; 
                                                                            <span class="lvl2">Report by Location<br>
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
                                                                            <td colspan="4" height="14">&nbsp;</td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="14" nowrap>Date Between</td>
                                                                            <td colspan="3" height="14"> 
                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                        </td>
                                                                                        <td>
                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                        </td>
                                                                                        <td>
                                                                                            &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                        </td>    
                                                                                        <td>
                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                        </td>
                                                                                        <td>
                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                        </td>
                                                                                    </tr>       
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="14" nowrap>Cashier Location</td>
                                                                            <td width="33%" height="14"> 
                                                                                <%
            Vector vLoc = DbLocation.list(0, 0, "", "name");
                                                                                %>
                                                                                <select name="src_location_id">
                                                                                    <option value="0">-- All --</option>
                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                    %>
                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
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
                                                                            <td colspan="4" height="15">&nbsp;</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                Vector vLoca = new Vector();

                if (locationId == 0) {
                    if (vLoc != null && vLoc.size() > 0) {
                        vLoca = vLoc;
                    }
                } else {
                    vLoca = DbLocation.list(0, 0, " location_id=" + locationId, "");
                }
                for (int a = 0; a < vLoca.size(); a++) {
                    
                    Location loc = new Location();
                    loc = (Location) vLoca.get(a);
                                                            %>
                                                            
                                                            <%
                                                                    whereClause = "";
                                                                    if (chkInvDate == 0) {
                                                                        if (whereClause != "") {
                                                                            whereClause = whereClause + " and ";
                                                                        }
                                                                        whereClause = whereClause + "date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd 00:00:01") + "' and  date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd 23:59:59") + "'";
                                                                    }

                                                                    if (whereClause != "") {
                                                                        whereClause = whereClause + " and ";
                                                                    }
                                                                    whereClause = whereClause + " location_id=" + loc.getOID();


                                                                    if (salesType != -1) {
                                                                        if (whereClause != "") {
                                                                            whereClause = whereClause + " and ";
                                                                        }
                                                                        whereClause = whereClause + " type=" + salesType;
                                                                    }
                                                                    if (whereClause != "") {
                                                                        whereClause = whereClause + " and ";
                                                                    }
                                                                    whereClause = whereClause + " sales_type=" + DbSales.TYPE_NON_CONSIGMENT;

                                                                    listSales = DbSales.list(0, 0, whereClause, "date, number");

                                                                    if (listSales != null && listSales.size() > 0) {

                                                                        try {
                                                            %>
                                                            
                                                            <tr align="left" valign="top"> 
                                                                <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td class="boxed1">
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                    <tr>
                                                                                        <td colspan=2 ><b>Location : </b></td>
                                                                                        <td colspan=3 ><b><%=loc.getName()%></b> </td>
                                                                                    </tr>  
                                                                                    <tr> 
                                                                                        <td class="tablehdr" width="2%">No</td>
                                                                                        <td class="tablehdr" width="5%">Date</td>
                                                                                        <td class="tablehdr" width="7%">Sales No.</td>
                                                                                        <td class="tablehdr" width="17%">Description</td>
                                                                                        <td class="tablehdr" width="11%">Group</td>
                                                                                        <td class="tablehdr" width="11%">Customer</td>
                                                                                        <td class="tablehdr" width="4%">Qty</td>
                                                                                        <td class="tablehdr" width="6%">Price</td>
                                                                                        <td class="tablehdr" width="7%">Amount</td>
                                                                                        <td class="tablehdr" width="6%">Discount%</td>
                                                                                        <td class="tablehdr" width="6%">Discount Amount</td>
                                                                                        <td class="tablehdr" width="6%">PPN</td>
                                                                                        <td class="tablehdr" width="6%">Kwitansi</td>
                                                                                        <td class="tablehdr" width="6%">HPP</td>
                                                                                        <td class="tablehdr" width="6%">Laba</td>
                                                                                        <td class="tablehdr" width="6%">PPH%</td>
                                                                                        <td class="tablehdr" width="6%">PPH Amount</td>
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
                                                                                    totalQty = totalQty + sd.getQty();
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

                                                                                    //untk total semua invoice
                                                                                    if(sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT){ 
                                                                                        grandTotal = grandTotal - (sd.getQty() * sd.getSellingPrice());                                 
                                                                                    }else{
                                                                                        grandTotal = grandTotal + (sd.getQty() * sd.getSellingPrice());                                 
                                                                                    }
                                                                                    if(sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT){ 
                                                                                        totalKwitansi = totalKwitansi - (sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount();
                                                                                    }else{
                                                                                        totalKwitansi = totalKwitansi + (sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount();
                                                                                    }

                                                                                    %>
                                                                                    <tr> 
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="2%"> 
                                                                                            <div align="center"><font size="1"><%=(xx == 0) ? "" + (i + 1) : ""%></font></div>
                                                                                        </td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="5%"><font size="1"><%=(xx == 0) ? JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") : ""%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"><font size="1"><%=(xx == 0) ? sales.getNumber() : ""%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="17%"><font size="1"><%=im.getName()%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="11%"><font size="1"><%=ig.getName()%></font></td>
                                                                                    <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="11%"><font size="1"><%=(xx == 0 && cus.getOID() != 0) ? cus.getName() : ""%></font></td>
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="4%"> 
                                                                                            <div align="right"><font size="1"><%=sd.getQty()%></font></div>
                                                                                        </td>
                                                                                        <td <%if (1 == 0) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                            <div align="right"><font size="1"> 
                                                                                                <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%> 
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="7%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%if(sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT){ %>
                                                                                                <%=JSPFormater.formatNumber((sd.getTotal() + sd.getDiscountAmount()) * -1, "#,###")%> 
                                                                                                <%}else{%>
                                                                                                <%=JSPFormater.formatNumber((sd.getTotal() + sd.getDiscountAmount()), "#,###")%> 
                                                                                                <%}%>
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
                                                                                                <%if(sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT){ %>
                                                                                                <%=JSPFormater.formatNumber((sd.getTotal() + sales.getVatAmount())* -1, "#,###")%> 
                                                                                                <%}else{%>
                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() + sales.getVatAmount(), "#,###")%> 
                                                                                                <%}%>
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                            <%if(sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT){ %>
                                                                                                <%=JSPFormater.formatNumber((sd.getCogs() * sd.getQty())*-1, "#,###")%> 
                                                                                            <%}else{%>    
                                                                                                <%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###")%> 
                                                                                            <%}%>
                                                                                            </font></div>
                                                                                        </td>
                                                                                        <td <%if (temp.size() == 1) {%>class="tablecell1"<%} else {%>class="tablecell"<%}%> width="6%"> 
                                                                                            <div align="right"> 
                                                                                            <font size="1"> 
                                                                                                <%if(sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT){ %>
                                                                                                <%=JSPFormater.formatNumber((sd.getTotal() - (sd.getCogs() * sd.getQty()))*-1, "#,###")%> 
                                                                                                <%}else{%>
                                                                                                <%=JSPFormater.formatNumber(sd.getTotal() - (sd.getCogs() * sd.getQty()), "#,###")%> 
                                                                                                <%}%>
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
                                                                                    <%if (temp.size() > 1) {
                                                                                    %>
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
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getDiscountPercent() + totalDiscountPercent, "#,###.##")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1" width="6%"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalDiscount_invoice, "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1" width="6%"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###")%></font></div>
                                                                                        </td>
                                                                                        <td height="2" class="tablecell1" width="6%"> 
                                                                                            <div align="right"><font size="1"><%=JSPFormater.formatNumber(totalKwitansi, "#,###")%></font></div>
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
                                                                                        <td width="2%">&nbsp;</td>
                                                                                        <td width="5%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="17%">&nbsp;</td>
                                                                                        <td width="11%">&nbsp;</td>
                                                                                        <td width="11%">&nbsp;</td>
                                                                                        <td width="4%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="7%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                        <td width="6%">&nbsp;</td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%  //} 
                                                                } catch (Exception exc) {
                                                                }%>
                                                            <%}
                }
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
