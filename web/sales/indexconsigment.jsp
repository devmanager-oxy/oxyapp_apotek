
<%-- 
    Document   : indexconsigment
    Created on : Dec 1, 2011, 11:08:21 AM
    Author     : Roy Andika
--%>

<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.ccs.posmaster.*" %>
<%@ include file="../main/javainit.jsp"%>

<%!
    final static int CMD_NONE = 0;
    final static int CMD_LOGIN = 1;
    final static int MAX_SESSION_IDLE = 2500000;
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int dologin = 0;

            try {
                session.removeValue("ADMIN_LOGIN");
            } catch (Exception e) {
                System.out.println(" ==> Exception during remove all menu session");
            }

            dologin = QrUserSession.DO_LOGIN_OK;
            if (iJSPCommand == CMD_LOGIN) {
                
                String loginID = JSPRequestValue.requestString(request, "login_id");
                String passwd = JSPRequestValue.requestString(request, "pass_wd");
                String remoteIP = request.getRemoteAddr();
                QrUserSession userQr = new QrUserSession(remoteIP);
                dologin = userQr.doLogin(loginID, passwd);
                
                System.out.println(".................." + iJSPCommand + " | " + loginID + " | ******* | " + userQr + " | dologin=" + (dologin == QrUserSession.DO_LOGIN_OK));

                if (dologin == QrUserSession.DO_LOGIN_OK) {

                    session.setMaxInactiveInterval(MAX_SESSION_IDLE);
                    session.putValue("ADMIN_LOGIN", userQr);
                    userQr = (QrUserSession) session.getValue("ADMIN_LOGIN");
                    if (userQr == null) {
                        System.out.println("login ----------------->null");
                    } else {
                        System.out.println("login ----------------->OK");
                    }
                }
            }

            String msg = "";

            Vector v = DbCompany.list(0, 0, "", "");

            if (iJSPCommand == CMD_LOGIN) {
                if (dologin == QrUserSession.DO_LOGIN_OK){                    
                    if (v != null && v.size() > 0) {
                        response.sendRedirect("homeconsigment.jsp");
                    } else {
                        response.sendRedirect("general/company.jsp");
                    }
                } else {
                    msg = "Login ID or password invalid";
                }
            }

%>
<html>
    <head>
        <title><%=titleService%> - login</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="css/css.css" type="text/css">
        <link rel="stylesheet" href="css/css1.css" type="text/css">
        <script language="javascript">             
            function cmdLogin(){	
                document.frmLogin.action = "indexservice.jsp";
                document.frmLogin.command.value="<%=CMD_LOGIN%>";
                document.frmLogin.submit();
            }
        </script>
    </head>
    <body  >
        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
            <tr> 
                <td align="center" valign="middle"> 
                    <table cellpadding="0" cellspacing="0" >
                        <tr> 
                            <td height="87"><img src="images/logout.jpg"></td>
                            <td height="87"> 
                                <form  name="frmLogin" method="post" onsubmit="javascript:cmdLogin()">
                                    <input type="hidden" name="sel_top_mn" value="4">
                                    <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
                                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
                                        <tr> 
                                            <td align="right" width="37%"> 
                                                <div align="left"><b><font size="2">SERVICE SYSTEM LOGIN</font></b></div>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td align="right" width="37%"> 
                                                <div align="left"><strong>Username</strong></div>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td width="37%" align="right"> 
                                                <div align="left"> 
                                                    <input type="text" name="login_id" class="input_text" value="" size="30" onClick="this.select()">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td align="right" width="37%"> 
                                                <div align="left"><strong>Password</strong></div>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td align="right" width="37%"> 
                                                <div align="left"> 
                                                    <input type="password" name="pass_wd" class="input_text" value="" size="30" onClick="this.select()">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="text" align="center"> 
                                            <td height="10" colspan="5" valign="top"></td>
                                        </tr>
                                        <tr class="text" align="center"> 
                                            <td height="22" colspan="5" valign="top"> 
                                                <div align="left"> 
                                                    <input type="submit" name="Submit" value="  LOGIN " class="input_text" onClick="javascript:cmdLogin()">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="text"> 
                                            <td height="10" colspan="5" valign="bottom" align="left"> 
                                                <div align="center"></div>
                                            </td>
                                        </tr>
                                        <%if (msg.length() > 0) {%>
                                        <tr class="text"> 
                                            <td height="10" colspan="5" valign="bottom" align="left"> 
                                                <div align="center"><font color="#FF0000"><%=msg%></font></div>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                        <td height="10" colspan="5" valign="bottom" align="left"> 
                                            <div align="center"></div>
                                        </td>
                                    </table>
                                    <script language="JavaScript">
                                        document.frmLogin.login_id.focus();
                                    </script>
                                </form>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>
