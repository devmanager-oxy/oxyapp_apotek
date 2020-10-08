
<%@ page import="com.project.admin.*"%>
<%@ page import="com.project.fms.activity.*"%>
<%@ page import="com.project.admin.*"%>

<% 
session.setMaxInactiveInterval(2500000);
QrUserSession appSessUser =  new QrUserSession();
User user = new User();	
try{	
	if(session.getValue("ADMIN_LOGIN")!=null){
		appSessUser = (QrUserSession)session.getValue("ADMIN_LOGIN"); 	user = appSessUser.getUser(); 	try{ user = DbUser.fetch(user.getOID()); } catch(Exception e){}
	}    
	else{ appSessUser = null; response.sendRedirect(rootapproot+"/inform.jsp");}
} catch (Exception exc){
  	appSessUser = null; response.sendRedirect(rootapproot+"/index.jsp");	
}

java.util.Vector userLocations = DbSegmentUser.userLocations(user.getOID()); 
int totLocationxAll = com.project.general.DbLocation.getCount("");

%>
