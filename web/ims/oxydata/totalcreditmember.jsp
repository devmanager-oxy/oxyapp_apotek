
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.util.JSPFormater" %>
<%
            String customerId = request.getParameter("customer_id");            
            if(customerId.compareToIgnoreCase("")==0){
		 customerId = "0";  	
	    }	 
            double balance = 0;
            double creditLimit = 0;
            String strdata = "";
            if (customerId.compareToIgnoreCase("0") != 0) {
                try {
                    balance = SessCreditTransaction.totalCredit(Long.parseLong(String.valueOf(customerId.trim())));
                } catch (Exception e) {
                }
                creditLimit = SessCreditTransaction.getCreditLimit(Long.parseLong(String.valueOf(customerId.trim())));
            }
            strdata = "CUSTOMERBALANCE=" + JSPFormater.formatNumber(balance,"###.##")+ "#CREDITLIMIT="+ JSPFormater.formatNumber(creditLimit,"###.##")+"#";
%>
<%=strdata%>
