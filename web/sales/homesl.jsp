
<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.main.db.*" %>
<%@ include file="main/javainit.jsp"%>
<%@ include file="main/checksl.jsp"%>
<%
            boolean homePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_HOMEPAGE);

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            int iErrCode = JSPMessage.NONE;
            String msgString = "";
            int recordToGet = 10;
            int vectSize = 0;
            JSPLine ctrLine = new JSPLine();
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=salesSt%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!homePriv) {%>
            window.location="nopriv.jsp";
            <%}%>
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td ><!-- #BeginEditable "title" --> 
                        <%

            String navigator = "<font class=\"lvl1\">Sales System</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Welcome</span></font>";
                                           %>
                        <%@ include file="main/navigatorsl.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frm" method="post" action="">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="68%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="17%">&nbsp;</td>
                                                                                <td width="55%">&nbsp;</td>
                                                                                <td width="28%" colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="17%" valign="top" nowrap><font face="Arial, Helvetica, sans-serif"><b><img src="../general/imagesuser/pic_<%=user.getOID()%>.jpg" height="130" border="0"><img src="images/spacer.gif" width="10" height="8"></b></font></td>
                                                                                <td width="55%" valign="top"> 
                                                                                    <div align="left"><font face="Arial, Helvetica, sans-serif"><b><%=user.getFullName()%></b>, welcome to Sales System. 
                                                                                            Your last login is : <br>
                                                                                            <%=(user.getLastLoginDate1() == null) ? " - " : JSPFormater.formatDate(user.getLastLoginDate1(), "dd MMMM yyyy HH:mm:ss")%><br>
                                                                                            <br>
                                                                                            Please click one of the menu provided 
                                                                                    in menu navigator to select the form.</font></div>
                                                                                </td>
                                                                                <td width="28%" valign="top" align="right" colspan="2"> 
                                                                                    <%@ include file = "main/calendar.jsp" %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="17%">&nbsp;</td>
                                                                                <td width="55%">&nbsp;</td>
                                                                                <td width="28%" colspan="2">&nbsp;</td>
                                                                            </tr>                                                                            
                                                                            <tr> 
                                                                                <td colspan="2"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="13%"><b>Reminder</b> </td>
                                                                                            <td width="87%" bgcolor="#DADADA">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="28%" colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="4"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2"> 
                                                                                    <table class="list" width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td class="tablehdr" width="71%" height="13">Messages</td>
                                                                                            <td class="tablehdr" width="29%" height="13">When</td>
                                                                                        </tr>
                                                                                        <%
            Vector reminders = new Vector();
            try {
            } catch (Exception e) {
            }

            if (reminders != null && reminders.size() > 0) {

                vectSize = reminders.size();

                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                //start = ctrlDepartment.actionList(iJSPCommand, start, vectSize, recordToGet);		
                }

                Vector temp = new Vector();
                switch (CONHandler.CONSVR_TYPE) {
                    case CONHandler.CONSVR_MYSQL:
                        temp = reminders;
                        break;

                    case CONHandler.CONSVR_POSTGRESQL:
                        temp = reminders;
                        break;

                    case CONHandler.CONSVR_SYBASE:
                        temp = reminders;
                        break;

                    case CONHandler.CONSVR_ORACLE:
                        temp = reminders;
                        break;

                    case CONHandler.CONSVR_MSSQL:
                        int loopInt = 0;
                        if ((start + recordToGet) > reminders.size()) {
                            loopInt = recordToGet - ((start + recordToGet) - reminders.size());
                        } else {
                            loopInt = recordToGet;
                        }

                        int count = 0;
                        for (int i = start; (i < reminders.size() && count < loopInt); i++) {
                            Reminder im = (Reminder) reminders.get(i);
                            count = count + 1;
                            temp.add(im);
                        }
                        break;

                    default:
                        temp = reminders;
                        break;
                }

                for (int i = 0; i < temp.size(); i++) {
                    try {
                        Reminder r = (Reminder) temp.get(i);

                        String strClass = "tablecell1";
                        if (i % 2 != 0) {
                            strClass = "tablecell";
                        }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=strClass%>" width="71%"><a href="<%=approot%>/<%=r.getUrl()%>"><%=r.getMessage()%></a></td>
                                                                                            <td class="<%=strClass%>" width="29%"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(r.getWhen(), "dd MMMM yyyy")%></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                    } catch (Exception e) {
                        out.println(e.toString());
                    }
                }
            }%>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="28%" colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="17%"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td height="4"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td> 
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
                                                                                                <% ctrLine.setLocationImg(approot + "/images");
            ctrLine.initDefault();
                                                                                                %>
                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> 
                                                                                                <input type="hidden" name="start" value="<%=start%>">
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="55%">&nbsp;</td>
                                                                                <td width="28%" colspan="2">&nbsp;</td>
                                                                            </tr>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td>&nbsp;</td>
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
            <%@ include file="main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate -->
</html>
