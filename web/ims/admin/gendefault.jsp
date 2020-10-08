 
<%@ page language="java" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.hanoman.session.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/admin.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Untitled Document</title>
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->Generate 
            Default Security Data<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="form1" method="post" action="gendefault.jsp">
			  <input type="hidden" name="command" value="<%=Command.SUBMIT%>">
              <input type="submit" name="Submit" value="Generate"> 
			  <%
			    if(iCommand==Command.SUBMIT){ 
                                        out.println(" Delete process : "+SessDefaultAccess.deleteSecurity());
					String result = SessDefaultAccess.genSecurity();
					out.println(" Generate : "+result);
				}
			  %>
            </form>
<!-- #EndEditable --></td>
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

