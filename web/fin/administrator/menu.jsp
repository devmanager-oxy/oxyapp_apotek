<%-- 
    Document   : menu.jsp
    Created on : Jun 8, 2014, 1:37:40 PM
    Author     : Roy Andika
--%>

<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
            
            String strAccountPeriod = "Account Period";
            String strAdministrator = "Administrator";            

            if (lang == LANG_ID) {            
                strAccountPeriod = "Periode Perkiraan";                   
                strAdministrator = "Administrator";
            }
%>
<table width="100%" border="0" cellspacing="1" cellpadding="0" height="100%">
    <tr> 
        <td style="border-right:1px solid #A3B78E" bgcolor="B8CEA8" valign="top" align="center" >            
            <table border="0" cellspacing="0" cellpadding="0" width="170">
                <tr> 
                    <%
            Periode periodeXXX = DbPeriode.getOpenPeriod();
            String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");
                    %>
                    <td height="49"> 
                        <div align="center"><font face="sans-serif" color="D4391A"><b><%=strAccountPeriod%> : <br> <%=openPeriodXXX%><br></b></font></div>
                    </td>
                </tr>
                <tr> 
                    <td >
                        <div class="hovermenu">
                            <ul>
                                <la><a href="menu_administrator.jsp?menu_idx=15"><%=strAdministrator%></a></la>                                                                
                                <li><a href="<%=approot%>/logout.jsp">Logout</a></li>
                            </ul>
                        </div>
                    </td>
                </tr>                
            </table>
        </td>        
    </tr>      
</table>

