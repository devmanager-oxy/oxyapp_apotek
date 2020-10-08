
<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.fms.master.*" %>
<%@ page import="com.project.general.Company" %>
<%@ page import="com.project.general.DbCompany" %>
<%@ page import="com.project.general.Location" %>
<%@ page import="com.project.general.DbLocation" %>
<%@ include file="javainit-root.jsp"%> 
<%!
    final static int CMD_NONE = 0;
    final static int CMD_LOGIN = 1;
    final static int MAX_SESSION_IDLE = 2500000;
%>

<%
//untuk meng-expired kan session
            response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Cache-Control", "nocache");

            int iCommand = JSPRequestValue.requestCommand(request);
            int dologin = 0;

            try {
                if (session.getValue("ADMIN_LOGIN") != null) {
                    session.removeValue("ADMIN_LOGIN");
                }
            } catch (Exception e) {                
                e.printStackTrace();
            }

            dologin = QrUserSession.DO_LOGIN_OK;
            if (iCommand == CMD_LOGIN) {
                String loginID = JSPRequestValue.requestString(request, "login_id");
                String passwd = JSPRequestValue.requestString(request, "pass_wd");
                String remoteIP = request.getRemoteAddr();
                QrUserSession userQr = new QrUserSession(remoteIP);

                session.putValue("APP_LANG", String.valueOf(JSPRequestValue.requestInt(request, "lang")));
                dologin = userQr.doLogin(loginID, passwd);

                if (dologin == QrUserSession.DO_LOGIN_OK) {
                    session.setMaxInactiveInterval(MAX_SESSION_IDLE);
                    session.putValue("ADMIN_LOGIN", userQr);
                    userQr = (QrUserSession) session.getValue("ADMIN_LOGIN");
                }
            }

            String msg = "";
            Vector v = DbCompany.list(0, 0, "", "");

            if (iCommand == CMD_LOGIN) {
                if (dologin == QrUserSession.DO_LOGIN_OK) {
                    if (v != null && v.size() > 0) {
                        response.sendRedirect("homeapp.jsp");
                    } else {
                        response.sendRedirect(rootapprootx + "/oxyapp");
                    }
                } else {
                    msg = "Login ID or password invalid";
                    response.sendRedirect(rootapprootx);
                }
            }
%>
<html>
    <head>
        <title><%=rootSystemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">        
        <script language="javascript"> 
            function cmdLogin(){	
                document.frmLogin.action = "index.jsp";
                document.frmLogin.command.value="<%=CMD_LOGIN%>";
                document.frmLogin.submit();
            }
        </script>
        <style type="text/css">
            <!--
            html, body, td {
                margin:0;
                padding:0;
                
                font: bold 12px Arial;
            }
            p{
                padding:0;
                margin:0;
            }
            #login {	
                margin-top:60px;
                margin-left:320px;
                text-align:left;
            }
            form {
                margin:0;
                padding:0;
                font: bold 12px Arial;
            }
            #errmsg{
                color:#FF0000;
                margin-top:10px;
                margin-left:320px;
                font:normal 11px Arial, Helvetica, sans-serif;
            }
            input{
                font:12px Arial;
            }
            -->
        </style>
    </head>
    <body  >
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
            <tr>
                <td align="center" valign="middle">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr> 
                            <td align="center">&nbsp;</td>
                        </tr>                       
                        <%if (isSystemActive) {%>
                        <tr> 
                            <td style="background:url(general/images/login_bodybg.jpg) repeat-x left center">
                                <table width="627" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr> 
                                        <td width="627" height="247" style="background:url(general/images/loginbg.jpg) no-repeat"> 
                                            <form  name="frmLogin" method="post" onSubmit="javascript:cmdLogin()">
                                                <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
                                                <input type="hidden" name="sel_top_mn" value="4">
                                                <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
                                                <table border="0" cellspacing="0" cellpadding="0" id="login">
                                                    <tr> 
                                                        <td>Username</td>
                                                    </tr>
                                                    <tr> 
                                                        <td>
                                                            <input type="text" name="login_id" id="textfield" value="" size="25" onClick="this.select()">
                                                        </td>
                                                    </tr>
                                                    <tr> 
                                                        <td>Password</td>
                                                    </tr>
                                                    <tr> 
                                                        <td>
                                                            <input type="password" name="pass_wd"  id="textfield2" value="" size="25" onClick="this.select()">
                                                        </td>
                                                    </tr>
                                                    <tr class="text" align="center"> 
                                                        <td height="10"  valign="top"></td>
                                                    </tr>
                                                    <tr> 
                                                        <td align="right" > 
                                                            <div align="left"> 
                                                                <select name="lang">
                                                                    <option value="<%=LANG_ID%>">Indonesia</option>
                                                                    <option value="<%=LANG_EN%>">English</option>
                                                                </select>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr> 
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td> 
                                                            <input type="button" name="button" id="button" value="   Login   "  onClick="javascript:cmdLogin()">
                                                        </td>
                                                    </tr>
                                                </table>
                                                <p id="errmsg"><%=msg%></p>
                                                <script language="JavaScript">
                                                    document.frmLogin.login_id.focus();
                                                </script>
                                            </form>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%} else {%>
                        <tr> 
                            <td align="center" style="padding-bottom:10px"> 
                                <p>Oxysystem License was Expired<br>
                                please contact your system administrator</p>
                                <p>Eka Ds<br>
                                081338521197 - 0361 8003119<br>
                                ekads3007@gmail.com</p>
                            </td>
                        </tr>
                        <%}%>
                        <tr> 
                            <td align="center" style="padding-bottom:10px">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>
