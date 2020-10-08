<%@ page language="java" %>

<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.dimata.hanoman.entity.admin.*" %>
 
<!-- JSP Block -->
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/admin.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->   
<title>Prochain - System Administrator</title> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td colspan="2" background="<%=approot%>/image/bg2.jpg" height=59> 
      <img  height="60" src="<%=approot%>/image/main2.jpg">
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="topmenu" height="20">       
      <!-- #BeginEditable "menu_main" --> 
      <%@ include file = "../main/menumain.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
  <tr> 
    <td width="200" valign="top" align="left" >
      
      <!-- #BeginEditable "menu_purchasing" --> 
      <%@ include file = "../main/menuadmin.jsp" %> 
      <!-- #EndEditable --> 
    </td>
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->System<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->Here you may defined 
            user management data who will use the system.<!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <div align="center"> copyright Bali Information Technologies 2002</div>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>

