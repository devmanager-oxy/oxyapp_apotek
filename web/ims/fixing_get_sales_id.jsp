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
	CONResultSet crs = null;
	try{
		String sql = "select * from pos_sales where unit_usaha_id=504404414236280005 and type=1 "+
					 "and date between '2010-02-01' and '2010-02-28'";
		
		crs = CONHandler.execQueryResult(sql);
		ResultSet rs = crs.getResultSet();
		while(rs.next()){
			out.println("<br>'"+rs.getLong(7));
		}
	}
	catch(Exception e){
	}
	finally{
		CONResultSet.close(crs);
	}
	
	
	
	
	
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
	document.form1.action="fixing_get_sales_id.jsp";
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
    <input type="button" name="Button" value="get sales id" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

