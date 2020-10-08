<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.crm.project.*"%>
<%@ page import="com.project.main.db.*"%>
<%

//menghapus project 2009, reset ar

int iCommand = JSPRequestValue.requestCommand(request);
if(iCommand==JSPCommand.ASK){
	
	Vector v = DbProject.list(0,0, "status=4", "");
	
	if(v!=null && v.size()>0){
	
		//dt.setYears(2009);
		for(int i=0; i<v.size(); i++){
			Project p = (Project)v.get(i);
			
			try{
				Vector temp = DbProjectTerm.list(0,0, "project_id="+p.getOID(), "");
				for(int x=0; x<temp.size(); x++){
					ProjectTerm pt = (ProjectTerm)temp.get(x);
					DbProjectTerm.deleteExc(pt.getOID());
				}
				
				temp = DbProjectProductDetail.list(0,0, "project_id="+p.getOID(), "");
				for(int x=0; x<temp.size(); x++){
					ProjectProductDetail pt = (ProjectProductDetail)temp.get(x);
					DbProjectProductDetail.deleteExc(pt.getOID());
				}
				
				temp = DbProjectOrderConfirmation.list(0,0, "project_id="+p.getOID(), "");
				for(int x=0; x<temp.size(); x++){
					ProjectOrderConfirmation pt = (ProjectOrderConfirmation)temp.get(x);
					DbProjectOrderConfirmation.deleteExc(pt.getOID());
				}
				
				DbProject.deleteExc(p.getOID());
				
			}
			catch(Exception e){
			}
		}
		
		
	}
	
	out.println("end update date ...");
	 
}

%>

<html>
<head>
<title>fixing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<script language="JavaScript">

function cmdUpdatGl(){
	document.form1.command.value="<%=JSPCommand.ASK%>";
	document.form1.action="fixing_del_ar09.jsp";
	document.form1.submit();
}
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p>
    <input type="hidden" name="command">
  </p>
  <p>
    <input type="button" name="Button" value="Delete Project 2009" onClick="javascript:cmdUpdatGl()">
  </p>
</form>
</body>
</html>

