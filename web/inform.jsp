
<%@ page language="java" %>  
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.main.entity.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ include file = "javainit-root.jsp" %>
<html>
    <head>
        <title><%=appxTitle%> - Logout</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="css/css.css" type="text/css">
        <script language="JavaScript">
            function cmdHome(){
                window.location="<%=rootLogout%>";
            }            
        </script>
    </head>
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
            <tr>
                <td height="100%">
                    <table width="33%" border="0" cellspacing="0" cellpadding="0" align="center">
                        <tr> 
                            <td height="130" width="52%"><img src="general/images/logout.jpg" width="200" height="236"></td>
                            <td height="130" width="48%" nowrap><font face="arial" size="2" color="#000000"><b>System Logout</b><br>
                                    <br>
                                    You are logout from system.<br>
                                    Thank you for using our system. <br>
                                    <br>
                                    <b><a href="javascript:cmdHome()">Login</a></b> <br>
                                    <br>
                            </font></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>