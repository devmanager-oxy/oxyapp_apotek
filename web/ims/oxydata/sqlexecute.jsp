
<%@ page language="java" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            long oidx = 0;
            try {
                oidx = Long.parseLong(DbSystemProperty.getValueByName("GEN_OID_AMINISTRATOR"));
            } catch (Exception e) {
                oidx = 0;
            }
            String sql = request.getParameter("txtquery");
            if (sql == null) {
                sql = "";
            }
%>
<html>
    <head>
        <title>Query Execute</title>
        <script language="JavaScript">  
            <%if (oidx == 0) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function executeQuery(idx){
                if(document.frmexecute.txtquery.value !=''){
                    document.frmexecute.command.value =idx;                    
                    document.frmexecute.submit();
                }    
            }
        </script>     
    </head>
    <body>
        <form name="frmexecute" method="post" action="">
            <input type="hidden" name="command" value="">    
            <table width="100%" border="0">
                <tr>
                    <td width="53%" bgcolor="#CCCCCC">SQL Execute ... </td>
                    <td width="47%">&nbsp;</td>
                </tr>
                <tr>
                    <td valign="top">
                        <label>
                            <textarea name="txtquery" cols="80" rows="20"><%=sql%></textarea>
                        </label>    
                    </td>
                    <td valign="top">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2">
                        <label>
                            <table border="0">
                                <tr>
                                    <td width="50"><input type="button" name="Submitxx" value="Execute Query" onclick="javascript:executeQuery(1)" /></td>
                                    <td width="300">Execute for select &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td width="50"><input type="button" name="Submit" value="Execute Update" onclick="javascript:executeQuery(2)" /></td>
                                    <td width="200">Execute for update or delete</td>
                                </tr>
                            </table>     
                        </label> 
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2">Result Query ... </td>
                </tr>
                <tr>
                    <td colspan="2"><hr width="100%"></td>
                </tr>
                <tr>
                    <td colspan="2">                        
                        <%

            if (sql != null && sql.length() > 0) {
                out.println("<table width=\"100%\" border=\"1\">");
                if (iCommand == 1) {
                    CONResultSet dbrs = null;
                    try {
                        dbrs = CONHandler.execQueryResult(sql);
                        ResultSet rs = dbrs.getResultSet();
                        int i = 0;
                        while (rs.next()) {
                            ResultSetMetaData meta = rs.getMetaData();
                            int col = meta.getColumnCount();
                            if (i == 0) {
                                out.println("<tr>");
                                for (int k = 0; k < col; k++) {
                                    out.println("<td bgcolor=\"#CCCCCC\" width=\"10%\">");
                                    out.println(meta.getColumnName(k + 1));
                                    out.println("</td>");
                                }
                                out.println("</tr>");
                            }

                            out.println("<tr>");
                            for (int k = 0; k < col; k++) {

                                out.println("<td>" + rs.getObject(meta.getColumnName(k + 1)) + "</td>");

                            }
                            out.println("</tr>");
                            i++;
                        }

                    } catch (Exception e) {
                    } finally {
                        CONResultSet.close(dbrs);
                    }

                } else if (iCommand == 2) {
                    int xx = CONHandler.execUpdateSQL(sql);
                    out.println("<tr>");
                    out.println("<td>OK</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
                    %>    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
