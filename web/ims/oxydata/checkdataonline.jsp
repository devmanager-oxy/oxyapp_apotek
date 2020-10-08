<%@ page language = "java" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>

<%
	String dbname = request.getParameter("dbname");
	String dataOID = request.getParameter("dataid");
	String fieldname = request.getParameter("fieldname");
	String locOID = request.getParameter("locid");
	
	/*System.out.println("dbname : "+dbname);
	System.out.println("dataOID  : "+dataOID);
	System.out.println("locOID : "+locOID);*/

	int val = 0;
	try{
		val = SQLGeneral.executeCheckDATA(dbname,fieldname,Long.parseLong(dataOID));
	}catch(Exception e){
		val = 0;
	}
%>
<%=val%>