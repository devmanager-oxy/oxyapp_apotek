
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
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_MEMBER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_MEMBER, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_BY_MEMBER, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_MEMBER") != null) {
                session.removeValue("REPORT_MEMBER");
            }
            String code_member = JSPRequestValue.requestString(request, "member_code");
            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int chkInvDate = 0;
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long cstId = JSPRequestValue.requestLong(request, "src_customer_id");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            Vector result = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH) {
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setIgnore(chkInvDate);
                rp.setMember(code_member);
                rp.setCustomerId(cstId);
                session.putValue("REPORT_MEMBER", rp);
                try {
                    result = SessReportSales.ReportSalesByMember(invStartDate, invEndDate, chkInvDate, code_member, locationId, cstId);
                } catch (Exception e) {
                }
            }
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
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptSalesMemberPDF?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdPrintJournalXLS(){	                       
                    window.open("<%=printroot%>.report.RptSalesMemberXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdSearch(){
                        document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                        document.frmsales.action="rptsalesbymember.jsp?menu_idx=<%=menuIdx%>";
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
                        document.frmsales.action="rptsalesbymember.jsp?menu_idx=<%=menuIdx%>";
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
                        document.frmsales.action="rptsalesbymember.jsp?menu_idx=<%=menuIdx%>";
                        document.frmsales.submit();
                    }
                    
                    function cmdBack(){
                        document.frmsales.command.value="<%=JSPCommand.BACK%>";
                        document.frmsales.action="rptsalesbymember.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                <span class="lvl2">Report By Member<br></span></font></b></td>
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
                                                                                                                                            <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="14" class="tablearialcell1">&nbsp;Date Between</td>
                                                                                                                                            <td colspan="3">
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td>:&nbsp;</td>
                                                                                                                                                        <td > 
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
                                                                                                                                            <td width="8%" height="14" class="tablearialcell1">&nbsp;Member</td>
                                                                                                                                            <td colspan="2">: 
                                                                                                                                                <%
            Vector vCustomer = DbCustomer.list(0, 0, "", "" + DbCustomer.colNames[DbCustomer.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_customer_id" class="fontarial">
                                                                                                                                                    <option value="0">All Member</option>
                                                                                                                                                    <%if (vCustomer != null && vCustomer.size() > 0) {
                for (int i = 0; i < vCustomer.size(); i++) {
                    Customer cst = (Customer) vCustomer.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=cst.getOID()%>" <%if (cst.getOID() == cstId) {%>selected<%}%>><%=cst.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14" class="tablearialcell1">&nbsp;Location</td>
                                                                                                                                            <td width="38%" height="14">: 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id" class="fontarial">
                                                                                                                                                    <%if (vLoc.size() == totLocationxAll) {%>
                                                                                                                                                    <option value="0"> - All Location -</option>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="33">&nbsp;</td>
                                                                                                                                            <td width="38%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td width="54%" height="33">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="15">&nbsp;</td>
                                                                                                                                            <td width="38%" height="15">&nbsp; 
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%





                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialhdr">Member</td>
                                                                                                                                            <td class="tablearialhdr" width="15%">Store</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Invoice Date</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Invoice No</td>
                                                                                                                                            <td class="tablearialhdr" width="8%">Total</td>
                                                                                                                                            <td class="tablearialhdr" width="8%">Cash</td>
                                                                                                                                            <td class="tablearialhdr" width="8%">Debit</td>
                                                                                                                                            <td class="tablearialhdr" width="8%">Credit</td>
                                                                                                                                            <td class="tablearialhdr" width="8%">Receivable</td>
                                                                                                                                        </tr>   
                                                                                                                                        <%
            if (iJSPCommand == JSPCommand.SEARCH) {
                try {
                    if (result != null && result.size() > 0) {


                        long memberId = 0;
                        long locId = 0;
                        Date invDt = null;

                        double totAmountMember = 0;
                        double totAmount = 0;
                        int totMember = 0;
                        int grandTotMember = 0;

                        for (int i = 0; i < result.size(); i++) {

                            ReportSalesMember rsm = (ReportSalesMember) result.get(i);

                                                                                                                                        %>
                                                                                                                                        <%if (memberId != rsm.getCustomerId() && memberId != 0) {%>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell" colspan="4" align="center"><b>Total by Member : <%=totMember%> Invoice &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(totAmountMember, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B&nbsp;>/td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B&nbsp;>/td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B&nbsp;>/td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(totAmountMember, "#,###") %></B>&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td colspan="9" align="center">&nbsp;</td>
                                                                                                                                        </tr>    
                                                                                                                                        <%
                                                                                                                                                        }
                                                                                                                                                        if (memberId != rsm.getCustomerId()) {
                                                                                                                                                            locId = 0;
                                                                                                                                                            invDt = null;
                                                                                                                                                            totAmountMember = 0;
                                                                                                                                                            totMember = 0;
                                                                                                                                                        }

                                                                                                                                                        double amount = 0;
                                                                                                                                                        if (rsm.getType() == DbSales.TYPE_CASH || rsm.getType() == DbSales.TYPE_CREDIT) {
                                                                                                                                                            amount = rsm.getAmount();
                                                                                                                                                        } else {
                                                                                                                                                            amount = rsm.getAmount() * -1;
                                                                                                                                                        }

                                                                                                                                                        totAmount = totAmount + amount;
                                                                                                                                                        totAmountMember = totAmountMember + amount;
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell">&nbsp;<%if (memberId != rsm.getCustomerId()) {%>  <%=rsm.getNameCustomer()%> <%}%></td>
                                                                                                                                            <td class="tablecell">&nbsp;
                                                                                                                                                <%if (locId != rsm.getLocationId()) {%>
                                                                                                                                                <%=rsm.getLocationName()%>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" align="center">&nbsp;
                                                                                                                                                <%if (invDt == null || invDt.compareTo(rsm.getDateTransaction()) != 0) {%>
                                                                                                                                                <%=JSPFormater.formatDate(rsm.getDateTransaction(), "yyyy-MM-dd")%>
                                                                                                                                                <%}%>    
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell"><%=rsm.getNumber()%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(amount, "#,###") %>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(0, "#,###") %>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(0, "#,###") %>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(0, "#,###") %>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(amount, "#,###") %>&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                                        totMember = totMember + 1;
                                                                                                                                                        grandTotMember = grandTotMember + 1;
                                                                                                                                        %>
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                                        memberId = rsm.getCustomerId();
                                                                                                                                                        invDt = rsm.getDateTransaction();
                                                                                                                                                        locId = rsm.getLocationId();

                                                                                                                                                    }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell" colspan="4" align="center"><b>Total by Member : <%=totMember%> Invoice &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(totAmountMember, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell" align="right"><B><%=JSPFormater.formatNumber(totAmountMember, "#,###") %></B>&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="10">
                                                                                                                                            <td colspan="9"></td>
                                                                                                                                        </tr>     
                                                                                                                                        <tr height="25"> 
                                                                                                                                            <td class="tablearialcell1" colspan="4" align="center"><b>Grand Total : <%=grandTotMember%> Invoice &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(totAmount, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(0, "#,###") %></B>&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(totAmount, "#,###") %></B>&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="9"> 
                                                                                                                                                
                                                                                                                                            </td>     
                                                                                                                                        </tr> 
                                                                                                                                        <%if(privPrint){%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="9"> 
                                                                                                                                                <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                                                &nbsp;&nbsp;&nbsp;<a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" height="22" border="0"></a>
                                                                                                                                            </td>     
                                                                                                                                        </tr> 
                                                                                                                                        <%}%>
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="9" class="tablearialcell1"> 
                                                                                                                                                <i>Data not found</i>
                                                                                                                                            </td>     
                                                                                                                                        </tr> 
                                                                                                                                        <%}
                                                                                                                                            } catch (Exception exc) {
                                                                                                                                            }

                                                                                                                                        } else {%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td height="22" valign="middle" colspan="9" class="tablearialcell1"> 
                                                                                                                                                <i>Click search button to searching the data</i>
                                                                                                                                            </td>     
                                                                                                                                        </tr> 
                                                                                                                                        
                                                                                                                                        <%}
                                                                                                                                        %>         
                                                                                                                                        
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

