<%@ page language="java" %>  
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.main.entity.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ include file = "main/javainit.jsp" %>
<%@ include file = "main/checkmm.jsp" %>

<%

try{
	//if(appSessUser!=null){// && appSessUser.isLoggedIn()==true){
		System.out.println("doLogout"); 
		//appSessUser.printAppUser();
		if(session.getValue("MEMBER_LOGIN")!=null){
			//appSessUser.doLogout(); 
			session.removeValue("MEMBER_LOGIN");
		}
	//}


} catch (Exception exc){
  System.out.println(" ==> Exception during logout user");
}
	

%>


<html>
<head>
<title><%=spTitle%> - Log Out</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="css/css.css" type="text/css">
<script language="JavaScript">
<!--
function cmdHome(){
	window.location="<%=approotx%>/sipadu-fin/indexmm.jsp";
}

//-->
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td height="100%">
      <table width="33%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="130" width="52%"><img src="images/logout.jpg" width="200" height="236"></td>
          <td height="130" width="48%" nowrap><font size="2" color="#000000"><b>SYSTEM 
            LOGUT</b><br>
            <br>
            You are logout from system.<br>
            Thank you for using our system. <br>
            <br>
            <b><a href="javascript:cmdHome()">LOGIN</a></b> <br>
            <br>
            </font></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
