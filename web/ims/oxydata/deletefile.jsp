<%@ page language="java" %>
<%
	String locId = request.getParameter("location_id");
	 java.io.File f = new java.io.File("D://jakarta-tomcat-5.5.7//webapps//oxy-retail//oxydata//myData_"+locId+".txt");
        if (f.exists()){
               f.delete();
        }
%>