<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.ccs.posmaster.*"%>
<%@ page import="com.project.crm.project.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.main.db.*"%>
<%

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.SUBMIT){

	out.println("start --- update cogs");
	
	Vector temp = DbProjectProductDetail.list(0,0, "", "");
	
	if(temp!=null && temp.size()>0){
		
		for(int i=0; i<temp.size(); i++){
			
			ProjectProductDetail ppd = (ProjectProductDetail)temp.get(i);
			out.println("<br>--------- processing -- "+i+", "+ppd.getOID());
			
			ItemMaster im = new ItemMaster();
			try{
				im = DbItemMaster.fetchExc(ppd.getProductMasterId());
				ppd.setCogs(im.getCogs());
				DbProjectProductDetail.updateExc(ppd);
				out.println("<br>------------- success-----");
			}
			catch(Exception e){
				out.println("<br>------------- error-----");
			}
			
			
		}
	}
	
	out.println("<br>end --- processing fixing data .. ");
	System.out.println("<br>end --- processing fixing data .. ");
	
}



%>

<html>
<head>
<title>fixing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<script language="JavaScript">
function cmdFix(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="fixing_project_cogs.jsp";
	document.form1.submit();
}

function cmdFixBymd(){
	document.form1.command.value="<%=JSPCommand.START%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdAbc(){
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdCek1(){
	document.form1.command.value="<%=JSPCommand.POST%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}

function cmdUpdatGl(){
	document.form1.command.value="<%=JSPCommand.ASK%>";
	document.form1.action="fixing.jsp";
	document.form1.submit();
}
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p> 
    <input type="hidden" name="command">
    <input type="button" name="Button" value="update cogs" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

