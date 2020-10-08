<%@ page language="java" %>
<%@ page import="java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%
            String invNum = request.getParameter("num_inv");
            double totalPaid = 0;
            String strdata = "";
            double balance = 0;
            long salesId = 0;
            long customerId = 0;
            String name = "";
            String number = "";
            try {
                
                Vector list = SessCreditTransaction.listCreditMember(0, 1,invNum,"");
                if (list != null && list.size() > 0) {
                    Vector rpt = (Vector) list.get(0);
                    try {
                        name = String.valueOf(rpt.get(4));
                    } catch (Exception e) {
                    }

                    try {
                        salesId = Long.parseLong(String.valueOf(rpt.get(0)));
                    } catch (Exception e) {
                    }

                    try {
                        number = String.valueOf(rpt.get(1));
                    } catch (Exception e) {
                    }

                    try {
                        customerId = Long.parseLong(String.valueOf(rpt.get(3)));
                    } catch (Exception e) {
                    }

                    double subTotal = 0;
                    double globalDiskon = 0;
                    double payment = 0;
                    double retur = 0;

                    try {
                        subTotal = Double.parseDouble(String.valueOf(rpt.get(6)));
                    } catch (Exception e) {
                    }

                    try {
                        globalDiskon = Double.parseDouble(String.valueOf(rpt.get(7)));
                    } catch (Exception e) {
                    }

                    try {
                        payment = Double.parseDouble(String.valueOf(rpt.get(8)));
                    } catch (Exception e) {
                    }

                    try {
                        retur = Double.parseDouble(String.valueOf(rpt.get(9)));
                    } catch (Exception e) {
                    }
                    
                    balance = (subTotal - globalDiskon);
                    totalPaid = (payment + retur);                

                }
            } catch (Exception e) {
            }
            try {
                strdata = "CUSTOMERID=" + customerId + "#SALESID=" + salesId + "#NOMOR=" + number + "#CUSTOMER=" + name + "#TOTAL=" + balance + "#PAID=" + totalPaid + "#";
            } catch (Exception e) {
            }
%>
<%=strdata%>