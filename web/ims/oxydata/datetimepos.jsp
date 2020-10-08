<%@ page language="java" %><%@ page import="java.io.*" %><%@ page import = "java.util.*" %><%@ page import = "com.project.main.db.*" %><%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.general.*" %><%@ page import = "com.project.ccs.sql.*" %><%@ page import = "com.project.util.JSPFormater" %>
<% 
String strdate = JSPFormater.formatDate(new Date(),"dd/MM/yyyy HH:mm:ss");
%>
out.println(<%=strdate%>);
<input type="hidden" name="str_date" id="str_date" value="<%=strdate%>">
