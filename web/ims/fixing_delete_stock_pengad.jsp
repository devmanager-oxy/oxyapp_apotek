<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.ccs.posmaster.*"%>
<%@ page import="com.project.ccs.postransaction.stock.*"%>
<%@ page import="com.project.crm.project.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.main.db.*"%>
<%

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.SUBMIT){

	out.println("start --- update cogs");
	CONResultSet crs = null;
	try{
		String sql = "select s.stock_id from pos_stock s "+
					 "inner join pos_item_master im on im.item_master_id=s.item_master_id "+
					 "where im.item_group_id=504404414977754208";

		crs = CONHandler.execQueryResult(sql);
		ResultSet rs = crs.getResultSet();
		while(rs.next()){
			long oid = rs.getLong(1);
			out.println("<br>--------------- delete stock id : "+oid);
			DbStock.deleteExc(oid);
		}
		
	}
	catch(Exception e){
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
	document.form1.action="fixing_delete_stock_pengad.jsp";
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
    <input type="button" name="Button" value="delete stock pengad" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

