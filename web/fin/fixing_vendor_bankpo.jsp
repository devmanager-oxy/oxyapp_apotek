
<%-- 
    Document   : fixing_vendor_bankpo
    Created on : Nov 24, 2016, 4:40:58 AM
    Author     : Acer
--%>

<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.fms.session.*"%>
<%@ page import="com.project.general.*"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.system.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.main.db.*"%>
<%@ include file = "main/javainit.jsp" %>

<%@ include file = "main/check.jsp" %>
<%!
     public static Vector getList() {
        CONResultSet crs = null;
        Vector result = new Vector();
        try {
            String sql = "select * from bank_payment where type=3 and vendor_id = 0";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                BankPayment gd = new BankPayment();
                gd.setOID(rs.getLong("bank_payment_id"));
                gd.setReferensiId(rs.getLong("referensi_id"));
                result.add(gd);
            }
            rs.close();
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }


    public static long getVendor(long refId) {
        CONResultSet crs = null;
        long vendorId = 0;
        try {
            String sql = "select * from bankpo_group_detail where bankpo_group_id = "+refId+" and vendor_id != 0 limit 1;";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                vendorId = rs.getLong("vendor_id");
            }
            rs.close();
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return vendorId;
    }

    public static void updateVendor(long bankPaymetId,long vendorId) {
        CONResultSet crs = null;
        try {
            String sql = "update bank_payment set vendor_id = "+vendorId+" where bank_payment_id = "+bankPaymetId;
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
    }

  
%>

<%

            int iCommand = JSPRequestValue.requestCommand(request);
            if (iCommand == JSPCommand.ACTIVATE){
                Vector result = getList();
               
                if (result != null && result.size() > 0) {
                    for (int i = 0; i < result.size(); i++) {
                        BankPayment gd = (BankPayment)result.get(i);
                        long vendorId = getVendor(gd.getReferensiId());
                        updateVendor(gd.getOID(),vendorId) ;
                    }
                }                
            }

%>
<html>
    <head>
        <title>fixing Bank</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    </head>
    <script language="JavaScript">
        function cmdPost(){
            document.form1.command.value="<%=JSPCommand.ACTIVATE %>";
            document.form1.action="fixing_vendor_bankpo.jsp";
            document.form1.submit();
        }
        
        function cmdFix(){
            document.form1.command.value="<%=JSPCommand.SUBMIT%>";
            document.form1.action="fixing_vendor_bankpo.jsp";
            document.form1.submit();
        }
    </script>
    <body bgcolor="#FFFFFF" text="#000000">
        <table>
            <form name="form1" method="post" action="">
                <input type="hidden" name="command">
                <tr>
                    <td colspan="3">
                        <input type="button" name="Button" value="Get Sales" onClick="javascript:cmdFix()">
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">
                        <table border="1" width="600" cellpadding="0" cellspacing="0">
                        <tr>
                            <td >Number</td>
                            <td width="150">amount</td>                            
                        </tr>    
                        <%
            if (iCommand == JSPCommand.SUBMIT || iCommand ==JSPCommand.ACTIVATE ) {
                CONResultSet crs = null;
                boolean ok = false;
                try {

                    String sql = "select * from bank_payment where type=3 and vendor_id = 0";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while (rs.next()) {
                        String num = rs.getString("journal_number");
                        double amount = rs.getDouble("amount");                        
                        ok = true;
                        %>
                        <tr>
                            <td><%=num %></td>
                            <td><%=JSPFormater.formatNumber(amount, "###,###.##")%></td>                            
                        </tr>                         
                        <%
                                }

                            } catch (Exception e) {
                            } finally {
                                CONResultSet.close(crs);
                            }
                            //if (ok) {
                        %>
                        <tr>
                            <td colspan="4">
                                <input type="button" name="Button" value="Re-vendor" onClick="javascript:cmdPost()">
                            </td>
                            
                        </tr>
                        <%
                //}
            }
                        %>
                        <table>    
                    </td>
                </tr>
            </form>
        </table>
    </body>
</html>
