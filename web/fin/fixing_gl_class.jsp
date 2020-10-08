
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

/*
jika terjadi tidak balance antara SP dan NSP
maka disini ada yang cross jenis account class ....
*/

int iCommand = JSPRequestValue.requestCommand(request);
long periodeId = JSPRequestValue.requestLong(request, "periode_id");

out.println("periodeId : "+periodeId);

if(iCommand==JSPCommand.SUBMIT && periodeId!=0){

	Periode periode = new Periode();
	try{
		periode = DbPeriode.fetchExc(periodeId);
	}
	catch(Exception e){
	}
	
	System.out.println("-- > reset date transaction periode : "+periode.getName());
	
	Date periodDate = periode.getStartDate();

	out.println("start --- processing fixing data<br>");
	System.out.println("start --- processing fixing data");
	
	Vector v = DbGl.list(0,0, "period_id="+periodeId, "");
	
	
	if(v!=null && v.size()>0){
		
	
		for(int i=0; i<v.size(); i++){
			
			Gl gl = (Gl)v.get(i);
			Vector vx = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");
			boolean found = false;
			int cl = 0;
			for(int x=0; x<vx.size(); x++){
				GlDetail gd = (GlDetail)vx.get(x);
				Coa coa = new Coa();
				try{
					coa = DbCoa.fetchExc(gd.getCoaId());
					if(x==0){
						cl = coa.getAccountClass();
					}
					else{
						if(!found && cl!=coa.getAccountClass()){
							found = true;
						}
					}
				}
				catch(Exception e){
				}				
			}
			
			if(found){
				out.println("<br>Period : "+periode.getName()+", journal : "+gl.getJournalNumber());
			}			
			
		}
	}
	
	out.println("<br>end --- processing fixing data .. ");
	System.out.println("end --- processing fixing data .. ");
	
}
%>

<html>
<head>
<title>update date</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<script language="JavaScript">
function updateX(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="fixing_gl_class.jsp";
	document.form1.submit();
}
</script>
<body bgcolor="#FFFFFF" text="#000000"> 
<form name="form1" method="post" action="fixing_gldate.jsp">
<input type="hidden" name="command" value="<%=JSPCommand.SUBMIT%>">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td>
      
      
    </td>
  </tr>
  <tr>
    <td>
        <input type="button" name="Button" value="check and list, account class" onClick="javascript:updateX()">
		<%Vector pers = DbPeriode.list(0,0,"","");%>
        <select name="periode_id">
			<%
			for(int i=0; i<pers.size(); i++){
				Periode p = (Periode)pers.get(i);
			%>
          <option value="<%=p.getOID()%>" <%if(periodeId==p.getOID()){%>selected<%}%>><%=p.getName()%></option>
		  <%}%>
          
        </select>
      </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
  </form>
</body>
</html>
