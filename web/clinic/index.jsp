<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %> 
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.ccs.posmaster.*" %> 
<%@ include file="main/javainit.jsp"%>

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
                System.out.println(" ==> Exception during remove all menu session");
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
                        response.sendRedirect("home.jsp");
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
        <title><%=titleIS%> - login</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="css/css.css" type="text/css">
        <link rel="stylesheet" href="css/css1.css" type="text/css">
        <script language="javascript">            
            function cmdLogin(){	
                document.frmLogin.action = "index.jsp";
                document.frmLogin.command.value="<%=CMD_LOGIN%>";
                document.frmLogin.submit();
            }
        </script>
    </head>
    <body  >
        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
            <%if (!isSystemActive) {%>
            <tr>
                <td align="center" valign="middle">Your Licence System Expired<br>
                    please contact your system administrator<br>
                    Eka Ds<br>
                    081338521197 - 03618003119<br>
                ekads3007@gmail.com </td>
            </tr>
            <%} else {%>
            <tr> 
                <td align="center" valign="middle"> 
                    <table cellpadding="0" cellspacing="0" >
                        <tr> 
                            
          <td height="87">&nbsp;</td>
                            <td height="87"> 
                                <form  name="frmLogin" method="post" onsubmit="javascript:cmdLogin()">
                                    <input type="hidden" name="sel_top_mn" value="4">
                                    <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
                                    
              <table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
                <tr> 
                  <td align="right" width="37%"> 
                    <div align="left"><b><font size="2" color="#003399">Login 
                      Klinik </font></b></div>
                  </td>
                </tr>
                <tr> 
                  <td align="right" width="37%"> 
                    <div align="left"><strong><font color="#009900"><i>Username</i></font></strong></div>
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
                    <div align="left"><strong><font color="#009900"><i>Password</i></font></strong></div>
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
            <%}%>
        </table>
    </body>
</html>
