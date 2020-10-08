<%@ page language="java" %><%@ page import="java.io.*" %><%@ page import = "java.sql.*" %><%@ page import = "java.util.*" %><%@ page import = "com.project.main.db.*" %><%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.general.*" %><%@ page import = "com.project.ccs.sql.*" %>
<%	
	String locId = request.getParameter("customer_id");	
	Sales sales = new Sales();
	Customer customer = new Customer();
	double totalPaid = 0;
	String strdata = "";
	try{		 
		Vector list = SQLGeneral.getDataCustomerCredit("",0);
		if(list!=null && list.size()>0){
			sales = (Sales)list.get(0);
			totalPaid = SQLGeneral.getTotalCreditPayment(sales.getOID());
		} 
	}catch(Exception e){}
try {
	strdata = "CUSTOMERID="+sales.getCustomerId()+"#SALESID="+sales.getOID()+"#NOMOR="+sales.getNumber()+"#CUSTOMER="+sales.getName()+"#TOTAL="+sales.getAmount()+"#PAID="+totalPaid+"#";
}catch (Exception e) {}
%>
<%=strdata%>