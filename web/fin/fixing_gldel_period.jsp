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

	out.println("start --- processing fixing data .. titipan, bymhd");
	System.out.println("start --- processing fixing data .. titipan, bymhd");
	
	Vector v = DbGl.list(0,0, "period_id=504404419396748520", "");
	
	System.out.println("v size : "+v.size());
	
	if(v!=null && v.size()>0){
		
		System.out.println("v.size() "+v.size());
	
		for(int i=0; i<v.size(); i++){
			Gl gl = (Gl)v.get(i);
			
			Vector vx = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");
			for(int x=0; x<vx.size(); x++){
				GlDetail gd = (GlDetail)vx.get(x);
				try{
					DbGlDetail.deleteExc(gd.getOID());
				}
				catch(Exception s){
				}
			}
			
			try{
				DbGl.deleteExc(gl.getOID());
			}
			catch(Exception e){
				System.out.println(e.toString());
			}
		}
	}
	
	out.println("end --- processing fixing data .. ");
	System.out.println("end --- processing fixing data .. ");
	
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
	document.form1.action="fixing_gldel_period.jsp";
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
    <input type="button" name="Button" value="Delete Gl Des 2009" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

