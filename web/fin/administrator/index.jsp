
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.fms.master.*" %>
<%@ page import="com.project.general.Company" %>
<%@ page import="com.project.general.DbCompany" %>
<%@ page import="com.project.general.Location" %>
<%@ page import="com.project.general.DbLocation" %>
<%@ include file="../main/javainit.jsp"%> 
<%@ include file="../main/check.jsp"%> 
<%
            long oidx = 0;
            try{
                oidx = Long.parseLong(DbSystemProperty.getValueByName("GEN_OID_AMINISTRATOR"));
            }catch(Exception e){}
            
            if(user.getOID()==oidx){
                response.sendRedirect("menu_administrator.jsp");
            }else{
                response.sendRedirect(approot + "/home.jsp");
            }

            
%>

