
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file="main/javainit.jsp"%>
<%@ include file="main/check.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><%=titleIS%></title>
        <link href="css/css.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <!--DWLayoutTable-->
            <tr> 
                <td  valign="middle"> 
                    <table width="40%" border="0" cellspacing="3" cellpadding="2" height="100%" align="center">
                        <tr> 
                            <td height="50" width="44%"><img src="images/logout.jpg" width="200" height="236"></td>
                            <td colspan="2" height="50" width="56%"> 
                                <div align="center">
                                    <p align="left"><font color="#FF0000" size="2">You have no priviledge 
                                            to access the page,<br>
                                            please contact your administrator for more information,<br>
                                            <br><br>
                                    </font></p>
                                    <p align="left"><font color="#FF0000" size="2"><br>
                                            <u><a href="home.jsp"><font color="#0000FF"><b>Homepage</b></font></a></u> 
                                            <font color="#0000CC">|</font> <u><a href="../index.jsp"><font color="#0000FF"><b>Login</b></font></a><br>
                                                <br><br><br><br>
                                    </u></font></p>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
    </body>
</html>
