<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.coorp.member.*" %>
<%@ include file="../main/javainit.jsp"%>
 
<%!
 final static int CMD_NONE =0;
 final static int CMD_LOGIN=1;
 final static int MAX_SESSION_IDLE=2500000;
%>
  
<%
	int iCommand = JSPRequestValue.requestCommand(request);
	int dologin = 0;

	try{
		//remove session on menu
		session.removeValue("ADMIN_LOGIN_HOME");
	}
	catch(Exception e){
		System.out.println(" ==> Exception during remove all menu session");
	}	
  
    dologin = QrUserSession.DO_LOGIN_OK ; 
	String loginID = JSPRequestValue.requestString(request,"login_id");
    
    if(iCommand==CMD_LOGIN){   
		//out.println("1");
        String passwd  = JSPRequestValue.requestString(request,"pass_wd");    
        String remoteIP = request.getRemoteAddr();
        //Member userQr = new QrUserSession(remoteIP);
		
		//out.println("loginID : "+loginID);
		//out.println("passwd : "+passwd);
		
		//System.out.println("2");
        Member member = DbMember.doLogin(loginID, passwd);
		
		//System.out.println("3");
        System.out.println(".................."+iCommand+" | "+loginID+" | ******* | dologin="+ (dologin==QrUserSession.DO_LOGIN_OK));
		
        if(member.getOID()!=0){//==QrUserSession.DO_LOGIN_OK){   
			
			dologin = QrUserSession.DO_LOGIN_OK;
			
            session.setMaxInactiveInterval(MAX_SESSION_IDLE);
            session.putValue("MEMBER_LOGIN", member);
            member = (Member)session.getValue("MEMBER_LOGIN");
            if(member.getOID()==0)
                    System.out.println("login ----------------->null");
                else
                    System.out.println("login ----------------->OK");
        }  
		
		//System.out.println("4");
    }
	
	String msg = "";
	
		 
	if (iCommand==CMD_LOGIN){
		if(dologin == QrUserSession.DO_LOGIN_OK) {
			response.sendRedirect("homemm.jsp");
		}
		else{
			msg = "Username or password incorect";
		}
	}
	
	
	
	
	
  
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu Login Page</title>
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
<script language="javascript"> 


	function cmdLogin()
	{	
	  document.frmLogin.action = "indexmm.jsp";
	  document.frmLogin.command.value="<%=CMD_LOGIN%>";
	  document.frmLogin.submit();
	}
</script>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td align="center" valign="middle"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center"><img src="imagesmm/login_kopegtel.gif" width="168" height="98"></td>
      </tr>
      <tr>
        <td style="background:url(imagesmm/login_bodybg.jpg) repeat-x left center"><table width="627" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
              <td width="627" height="247" style="background:url(imagesmm/loginbg.jpg) no-repeat">
			  <form name="frmLogin" method="post" action="">
			  <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
                <table border="0" cellspacing="0" cellpadding="0" id="login">
                    <tr>
                        <td>NIK</td>
                    </tr>
                    <tr>
                      <td><input type="text" name="login_id" id="textfield" value="<%=loginID%>" size="25" onClick="this.select()"></td>
                    </tr>
                    <tr>
                        <td>NIK ULANG</td>
                    </tr>
                    <tr>
                      <td><input type="password" name="pass_wd"  id="textfield2" value="" size="25" onClick="this.select()"></td>
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
              </form></td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td align="center" style="padding-bottom:10px"><img src="imagesmm/login_telkom.gif" width="55" height="66"></td>
      </tr>
    </table></td>
  </tr>
</table>

</body>
</html>
