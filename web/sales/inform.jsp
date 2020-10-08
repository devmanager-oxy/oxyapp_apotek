<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="com.dimata.qdep.system.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.harisma.session.admin.*" %>
<%@ page import="com.dimata.harisma.entity.admin.*" %>

<%int  appObjCode = 1;%>

<%
if(isLoggedIn==false)
{
%>
	<script language="javascript">
		 window.location="index.jsp";
	</script>
<%
}
%>

<%
String sic = (request.getParameter("ic")==null) ? "0" : request.getParameter("ic");
int infCode = 0;
String msgAccess = "";
try
{
	infCode = Integer.parseInt(sic);
}
catch(Exception e)
{ 
	infCode = 0;
}

switch(infCode) 
{
	case I_SystemInfo.DATA_LOCKED : 
		msgAccess  = I_SystemInfo.textInfo[infCode];
		break;

	case I_SystemInfo.HAVE_NOPRIV : 
		msgAccess  = I_SystemInfo.textInfo[infCode];
		break;

	case I_SystemInfo.NOT_LOGIN : 
		msgAccess  = I_SystemInfo.textInfo[infCode];
		break;

	default:
%>
		<script language="javascript">
			 window.location="index.jsp";
		</script>
<%
}
%>
<html ><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- #BeginEditable "doctitle" --> 
<title>HRD - </title>
<!-- #EndEditable --> 
<!-- #BeginEditable "styles" --> 
<link rel="stylesheet" href="styles/main.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "stylestab" --> 
<link rel="stylesheet" href="styles/tab.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
</head>

<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr> 
    <td  height="82" align="left" valign="top" background="<%=approot%>/images/header-bg.gif" bgcolor="#e5efcb"> 
      <!-- #BeginEditable "header" --> 
      <%@ include file = "main/header.jsp" %>
      <!-- #EndEditable --> 
	  
    </td>
  </tr>
  <tr>
    <td height="8">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" height="8">
        <!--DWLayoutTable-->
        <tr> 
          <td  align="left" valign="top" bgcolor="#FFFFFF"></td>
          <td align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
        <tr> 
          <td  align="center" valign="middle" bgcolor="#0e273a" class="clock" height="5"></td>
          <td width="100%" align="left" valign="top" bgcolor="#ff8a00" height="5"> 
          </td>
        </tr>
       
		<tr>
			<td  align="left" valign="top" bgcolor="#FFFFFF"></td>
			<td align="left" valign="top" bgcolor="#FFFFFF"></td>
		  </tr>
      </table>
</td>
  </tr>
  <tr> 
    <td height="100%" valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr>
          <td width="182" height="228" valign="top" background="<%=approot%>/images/lmenu-bg.gif" >
            <!-- #BeginEditable "menumain" --> 
      <%@ include file = "main/mnmain.jsp" %>
      <!-- #EndEditable -->			
          </td>
          <td valign="top" class="container"> <!-- #BeginEditable "content" --> 
                                    <form name="form1" method="post" action="">
									<input type="hidden" name="ic">
									<table width="100%" border="0" cellspacing="0">
									  <tr class="comment"> 
										<td align="center">
										<%=msgAccess%> 
										</td>
									  </tr>
									</table>
									</form>
                                    
 
                  System Information
                  <!-- #EndEditable --> 
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="25">
	<!-- #BeginEditable "footer" --> 
      <%@ include file = "main/footer.jsp" %>
      <!-- #EndEditable -->
      
    </td>
  </tr>
</table>

</body>
<!-- #EndTemplate --></html>
