<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
	//get open period id
	Periode p = new Periode();
	try{
		p = DbPeriode.getOpenPeriod();
	}catch(Exception e){
		System.out.println(e);
	}
	
	String whereQry = "trans_date between '"+JSPFormater.formatDate(p.getStartDate(), "yyyy-MM-dd")+"' and '"+JSPFormater.formatDate(p.getEndDate(), "yyyy-MM-dd")+"' ";
	Vector pcPayment = DbPettycashPayment.list(0,0, whereQry + "and activity_status <> 'Posted' ", "");
	Vector pcReplenishment = DbPettycashReplenishment.list(0,0, whereQry + "and status <> 'Posted' ", "");	
	Vector bankNonPO = DbBanknonpoPayment.list(0,0, whereQry + "and activity_status <> 'Posted' and type<>"+I_Project.TYPE_INT_EMPLOYEE_ADVANCE, "");
	Vector bankPO = DbBankpoPayment.list(0,0, whereQry + "and status <> 'Posted' ", "");
	Vector inv = DbInvoice.list(0,0, whereQry + "and (status <> 'Posted' or activity_status <> 'Posted') and status <> 'closed'", "");
	Vector gl = DbGl.list(0,0, whereQry + "and activity_status <> 'Posted'", "");

	if((pcPayment!=null && pcPayment.size()>0) || (pcReplenishment!=null && pcReplenishment.size()>0) || (bankPO!=null && bankPO.size()>0) || (bankNonPO!=null && bankNonPO.size()>0) || (inv!=null && inv.size()>0) || (gl!=null && gl.size()>0)){
		response.sendRedirect("../incomplete/closinglist.jsp?menu_idx=7");			
	}
	else{
		//response.sendRedirect("periode.jsp?menu_idx=13&cmd="+JSPCommand.ADD);
		response.sendRedirect("backup.jsp?menu_idx=7");
	}	
	
%>
