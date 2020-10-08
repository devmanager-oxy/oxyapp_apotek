
<%-- 
    Document   : checksalesopening
    Created on : Jun 23, 2015, 4:35:20 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %> 
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_VIEW);
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            Date startDate = new Date();
            Date endDate = new Date();
            String strStartDate = JSPRequestValue.requestString(request, "start_date");
            String strEndDate = JSPRequestValue.requestString(request, "end_date");
            long locationId = JSPRequestValue.requestLong(request, "location_id");

            if (strStartDate != null && strStartDate.length() > 0) {
                startDate = JSPFormater.formatDate(strStartDate, "dd/MM/yyyy");
            }
            if (strEndDate != null && strEndDate.length() > 0) {
                endDate = JSPFormater.formatDate(strEndDate, "dd/MM/yyyy");
            }
%>
<html>
    <head>
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    </head>
    <script language="JavaScript">
        <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
        
        function cmdCek(){
            document.form1.command.value="<%=JSPCommand.SUBMIT%>";
            document.form1.action="checksalesopening.jsp";
            document.form1.submit();
        }
        
    </script>
    <body bgcolor="#FFFFFF" text="#000000">
        <form name="form1" method="post" action="">
            <input type="hidden" name="command">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <table width="100%">                           
                            <tr>
                                <td>Date</td>
                                <td>
                                    <table border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                            <td nowrap> 
                                                <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            </td>
                                            <td > 
                                                <div align="center">To</div>
                                            </td>
                                            <td nowrap> 
                                                <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            </td>                                            
                                        </tr>
                                    </table>
                                </td>
                            </tr>    
                        </table>    
                    </td>        
                </tr>    
                <tr> 
                    <td class="container" valign="top">
                        <input type="button" name="Button" value="Cek Sales Opening" onClick="javascript:cmdCek()">
                    </td> 
                </tr>   
                <tr>
                    <td>&nbsp;</td>
                </tr>    
                <tr>
                    <td>
                        <table border = "1" width="100%">
                            <tr>
                                <td align="center">Location</td>
                                <td align="center">Sales Id</td>
                                <td align="center">Number</td>
                                <td align="center">Amount</td>
                                <td align="center">Date</td>
                                <td align="center">Date Open</td>
                            </tr>    
                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                String where = " where to_days(s.date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";

                if (locationId != 0) {
                    where = where + " and s.location_id = " + locationId;
                }

                try {
                    CONResultSet crs = null;
                    String sql = "select l.name as name,s.sales_id as sales_id,s.number as number,s.amount as amount,s.date as date,c.date_open as date_open,c.cash_master_id,to_days(s.date) as dt_transaction,to_days(c.date_open) as dt_open from pos_sales s inner join pos_cash_cashier c on s.cash_cashier_id = c.cash_cashier_id inner join pos_location l on s.location_id = l.location_id " + where + " having(dt_transaction != dt_open) order by s.date ";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while (rs.next()) {
                        String name = rs.getString("name");
                        long salesId = rs.getLong("sales_id");
                        String number = rs.getString("number");
                        double amount = rs.getDouble("amount");
                        Date date = rs.getDate("date");
                        Date dateOpen = rs.getDate("date_open");
                        %>
                            <tr>
                                <td align="left"><%=name%></td>
                                <td align="left"><%=salesId%></td>                                
                                <td align="center"><%=number%></td>
                                <td align="right"><%=JSPFormater.formatNumber(amount,"###,###.##") %></td>
                                <td align="center"><%=JSPFormater.formatDate(date, "yyyy-MM-dd") %></td>
                                <td align="center"><%=JSPFormater.formatDate(dateOpen, "yyyy-MM-dd") %></td>
                            </tr> 
                            
                            <%
                    }
                } catch (Exception e) {
                }
            }
                            %>
                        </table>    
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>    
                 
            </table>
        </form>
    </body>
</html>
