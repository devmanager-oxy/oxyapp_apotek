<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.main.db.*"%>
<%

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.SUBMIT){

	out.println("start --- processing fixing data ..");
	System.out.println("start --- processing fixing data .. ");
	
	Vector xx = DbPeriode.list(0,0, "", "");
	if(xx!=null && xx.size()>0){
		
		Periode periode = (Periode)xx.get(0);
		
		Vector v = DbGl.list(0,0, "period_id<>"+periode.getOID(), "");
		
		System.out.println("v.size() "+v.size());
	
		for(int i=0; i<v.size(); i++){
			Gl gl = (Gl)v.get(i);
			out.println("<br>deleting gl id = "+gl.getOID());
			System.out.println("deleting gl id = "+gl.getOID());
			String sql = "delete from gl_detail where gl_id = "+gl.getOID();
			try{
				CONHandler.execUpdate(sql);
				DbGl.deleteExc(gl.getOID());
			}
			catch(Exception e){
			}
			
		}
	}
	
	out.println("end --- processing fixing data");
	System.out.println("end --- processing fixing");
	
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
	document.form1.action="fixing_bugis.jsp";
	document.form1.submit();
}

function cmdFixBymd(){
	document.form1.command.value="<%=JSPCommand.START%>";
	document.form1.action="fixing_bugis.jsp";
	document.form1.submit();
}

function cmdAbc(){
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.action="fixing_bugis.jsp";
	document.form1.submit();
}

function cmdCek1(){
	document.form1.command.value="<%=JSPCommand.POST%>";
	document.form1.action="fixing_bugis.jsp";
	document.form1.submit();
}

function cmdUpdatGl(){
	document.form1.command.value="<%=JSPCommand.ASK%>";
	document.form1.action="fixing_bugis.jsp";
	document.form1.submit();
}
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p>
    <input type="hidden" name="command">
    <input type="button" name="Button" value="Delete Feb Journal" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

