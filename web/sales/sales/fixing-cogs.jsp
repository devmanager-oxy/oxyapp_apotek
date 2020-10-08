<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.POST){
	Vector temp = DbSalesDetail.list(0,0, "", "");
	if(temp!=null && temp.size()>0){
		for(int i=0; i<temp.size(); i++){
			SalesDetail sd = (SalesDetail)temp.get(i);
			
			out.println("---sd ..... : "+i+", id : "+sd.getOID());
			
			ItemMaster im = new ItemMaster();
			try{
				im = DbItemMaster.fetchExc(sd.getProductMasterId());
				sd.setCogs(im.getCogs());
				DbSalesDetail.updateExc(sd);
			}
			catch(Exception e){
			}
		}
	}
}

out.println("---end .....");

%>
<html>
<head>
<title>fixing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<script language="JavaScript">
	function cmdOk(){
		document.form1.command.value="<%=JSPCommand.POST%>";
		document.form1.action="fixing-cogs.jsp";
		document.form1.submit();
	}
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
	<input type="hidden" name="command">
  <input type="button" name="Button" value="update cogs" onClick="javascript:cmdOk()">
</form>
</body>
</html>
