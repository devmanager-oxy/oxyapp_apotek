<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.coorp.member.*" %>

<%@ page import = "com.project.fms.report.*" %>

<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksp.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.POST){
	Vector temp = DbPinjaman.list(0,0, "type=1", "");
	for(int i=0; i<temp.size(); i++){
		Pinjaman pinjaman = (Pinjaman)temp.get(i);
		Vector vct = DbPinjamanDetail.list(0,0, "pinjaman_id="+pinjaman.getOID(), "");
		for(int x=0; x<vct.size(); x++){
			PinjamanDetail pd = (PinjamanDetail)vct.get(x);
			pd.setBungaBankPercent(1.17);
			pd.setBungaKoperasiPercent(1.33);
			try{
				System.out.println("--- proceeding update bunga anuitas -> i : "+i+", detail : "+x);
				DbPinjamanDetail.updateExc(pd);
			}
			catch(Exception e){
			}
		}
	}
}

out.println("DONE:");

%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
 <input type="hidden" name="command" value="<%=JSPCommand.POST%>">
  <input type="submit" name="Submit" value="proceed">
</form>
</body>
</html>
