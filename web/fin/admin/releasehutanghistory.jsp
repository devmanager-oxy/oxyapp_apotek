
<%-- 
    Document   : releasehutanghistory
    Created on : Dec 24, 2015, 2:21:05 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_RELEASE_INVOICE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_RELEASE_INVOICE, AppMenu.PRIV_VIEW);
%>

<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            String number = JSPRequestValue.requestString(request, "number");
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            number = number.trim();
            int recordToGet = 30;

            if (iJSPCommand == JSPCommand.NONE) {
                ignore = 1;
            }

            String where = DbBankpoHistory.colNames[DbBankpoHistory.COL_TYPE] + " = " + DbBankpoHistory.TYPE_RELEASE_STATUS;

            if (number != null && number.length() > 0) {
                where = where + " and " + DbBankpoHistory.colNames[DbBankpoHistory.COL_JOURNAL_NUMBER] + " like '%" + number + "%'";
            }

            if (ignore == 0) {
                where = where + " and " + DbBankpoHistory.colNames[DbBankpoHistory.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + " 23:59:59'";
            }
            CmdBankpoPayment cmdBankpoPayment = new CmdBankpoPayment(request);
            JSPLine ctrLine = new JSPLine();
            int vectSize = DbBankpoHistory.getCount(where);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdBankpoPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            Vector listBankpo = DbBankpoHistory.list(start, recordToGet, where, DbBankpoHistory.colNames[DbBankpoHistory.COL_DATE] + " desc");

            if (listBankpo.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listBankpo = DbBankpoHistory.list(start, recordToGet, where, DbBankpoHistory.colNames[DbBankpoHistory.COL_DATE] + " desc");
            }


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="releasehutanghistory.jsp";
                document.form1.submit();
            }
            
            
            function cmdListFirst(){
                document.form1.command.value="<%=JSPCommand.FIRST%>";
                document.form1.prev_command.value="<%=JSPCommand.FIRST%>";
                document.form1.action="releasehutanghistory.jsp";
                document.form1.submit();
            }
            
            function cmdListPrev(){
                document.form1.command.value="<%=JSPCommand.PREV%>";
                document.form1.prev_command.value="<%=JSPCommand.PREV%>";
                document.form1.action="releasehutanghistory.jsp";
                document.form1.submit();
            }
            
            function cmdListNext(){
                document.form1.command.value="<%=JSPCommand.NEXT%>";
                document.form1.prev_command.value="<%=JSPCommand.NEXT%>";
                document.form1.action="releasehutanghistory.jsp";
                document.form1.submit();
            }
            
            function cmdListLast(){
                document.form1.command.value="<%=JSPCommand.LAST%>";
                document.form1.prev_command.value="<%=JSPCommand.LAST%>";
                document.form1.action="releasehutanghistory.jsp";
                document.form1.submit();
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
            String navigator = "<font class=\"lvl1\">Hutang</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Release Hutang (History)</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form id="form1" name="form1" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">    
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>                                                                                                                                                        
                                                                            <tr> 
                                                                                <td width="90" class="tablecell1" style="padding:3px;">Tanggal</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td >
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>                                                                                            
                                                                                            <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.invStartDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                            <td class="fontarial">&nbsp;&nbsp;to&nbsp;</td>
                                                                                            <td>&nbsp;<input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.invEndDate);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                            <td class="fontarial"><input type="checkbox" name="ignore" value="1" <%if(ignore==1){%> checked<%}%> ></td>
                                                                                            <td class="fontarial">Ignore</td>
                                                                                        </tr>
                                                                                    </table> 
                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="90" class="tablecell1" style="padding:3px;">Number</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td ><input type="text" name="number" value="<%=number%>" size="25"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>  
                                                                <tr> 
                                                                    <td height="6" class="container">
                                                                        <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                              
                                                                            <tr> 
                                                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    
                                                                    <td class="container"> 
                                                                        <table border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="25">&nbsp;</td>
                                                                </tr>  
                                                                <%if (listBankpo != null && listBankpo.size() > 0) {%>
                                                                <tr> 
                                                                    <td class="container">
                                                                        <table border="0" cellpadding="0" cellspacing="1" width="700">
                                                                            <tr height="24">
                                                                                <td class="tablehdr" width="15">No</td>
                                                                                <td class="tablehdr" width="150">Number</td>
                                                                                <td class="tablehdr" width="160">Date</td>                                                                                
                                                                                <td class="tablehdr" >Release By</td>                                                                                
                                                                            </tr>    
                                                                            <%
    for (int i = 0; i < listBankpo.size(); i++) {

        BankpoHistory bp = (BankpoHistory) listBankpo.get(i);

        String style = "tablecell1";
        if (i % 2 == 0) {
            style = "tablecell1";
        } else {
            style = "tablecell";
        }

        String name = "";
        try {
            User u = DbUser.fetch(bp.getUserId());
            name = u.getFullName();
        } catch (Exception e) {
        }




                                                                            %>
                                                                            <tr height="23" >
                                                                                <td class="<%=style%>" style="padding:3px;" align="center"><%=(start + i + 1)%></td>
                                                                                <td class="<%=style%>" style="padding:3px;" align="center"><%=bp.getJournalNumber()%></td>
                                                                                <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(bp.getDate(), "dd MMM yyyy HH:mm:ss")%></td>                                                                                
                                                                                <td class="<%=style%>" style="padding:3px;"><%=name%></td>                                                                                                                                                                  
                                                                            </tr>        
                                                                            <%}%>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>     
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" align="left" class="command"> 
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
                                                                            <% ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
                                                                            %>
                                                                    <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span></td>
                                                                </tr>
                                                                <%} else {%>
                                                                <tr > 
                                                                    <td class="container">
                                                                        <table>
                                                                            <tr>
                                                                                <td class="fontarial"><i>History tidak ditemukan</i></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                                <%}%>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>