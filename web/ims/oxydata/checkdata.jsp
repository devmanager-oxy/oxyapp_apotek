<%@ page language = "java" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%
	int statusOK = 0;
	String strTable = request.getParameter("valtable");
	String strWhere = request.getParameter("valwhere");
	try{
		statusOK = SQLGeneral.getStatusData(strTable,strWhere);
	}catch(Exception e){
	}
%>
<%=statusOK%>