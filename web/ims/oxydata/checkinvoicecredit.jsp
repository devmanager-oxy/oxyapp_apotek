<%@ page language="java" %>
<%@ page import="java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.sql.*" %>

<%
	String invNum = request.getParameter("num_inv");	
	String locId = request.getParameter("location_id");	
	Sales sales = new Sales();
	Customer customer = new Customer();
	double totalPaid = 0;
	try{		
		String where = "number='"+invNum+"'";
		Vector list = DbSales.list(0,0,where,"");
		if(list!=null && list.size()>0){
			sales = (Sales)list.get(0);
			customer = DbCustomer.fetchExc(sales.getCustomerId());
			
			totalPaid = SQLGeneral.getTotalCreditPayment(sales.getOID());
		}else{
			out.println("testing");
		}

	}catch(Exception e){}

try {
	String real_filename = "//srv//tomcat5coco01//webapps//oxysystemcoco01//ims//oxydata//myData_"+locId+".txt";
	//String real_filename = "D://tomcat//webapps//oxyminimarket//ims//oxydata//oxydata//myData_"+locId+".txt";

	FileOutputStream fos = new FileOutputStream(real_filename);
	PrintWriter pw = new PrintWriter(fos);
	pw.println("SALESID="+sales.getOID()+"#NOMOR="+sales.getNumber()+"#CUSTOMER="+customer.getName()+"#TOTAL="+sales.getAmount()+"#PAID="+totalPaid+"#");
	/*pw.println("SALESID="+sales.getOID());
	pw.println("NOMOR="+sales.getNumber());
	pw.println("CUSTOMER="+customer.getName());
	pw.println("TOTAL="+sales.getAmount());
	pw.println("PAID="+totalPaid);*/
	pw.close();
	fos.close();
}catch (Exception e) {
// Handle exceptions
}
%>