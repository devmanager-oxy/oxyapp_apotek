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

	out.println("start --- delete gl");
	
	String str = JSPRequestValue.requestString(request, "gl_number");
	
	out.println("str : "+str);
		
	Vector v = new Vector();
	StringTokenizer strtok = new StringTokenizer(str, ",");
	while(strtok.hasMoreElements()){
		v.add((String)strtok.nextToken());
	}
	
	if(v!=null && v.size()>0){
		
		for(int i=0; i<v.size(); i++){
			
			String num = (String)v.get(i);
			//num = num.trim();
			out.println("<br>processing : "+num);
			
			Vector temp = DbGl.list(0,0,"journal_number ='"+num+"'", "");
			if(temp!=null && temp.size()>0){
				Gl gl = (Gl)temp.get(0);
				
				try{
					CONHandler.execUpdate("delete from gl_detail where gl_id="+gl.getOID());
				}
				catch(Exception e){
					System.out.println(e.toString());
				}
				try{
					DbGl.deleteExc(gl.getOID());
				}
				catch(Exception e){
					System.out.println(e.toString());
				}
				
				out.println("<br>&nbsp;&nbsp;&nbsp;      sukses delete : "+num);
			}
			else{
				out.println("<br>&nbsp;&nbsp;&nbsp;      error not found : "+num);
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
	document.form1.action="fixing_gl_delete.jsp";
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
    journal number (no1,no2, ...) 
    <input type="text" name="gl_number" size="40">
    <input type="button" name="Button" value="delete gl" onClick="javascript:cmdFix()">
    <br>
  </p>
  <p>&nbsp; </p>
</form>
</body>
</html>

