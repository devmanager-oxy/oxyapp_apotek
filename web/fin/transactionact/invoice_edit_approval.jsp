<table width="32%" border="0" cellspacing="1" cellpadding="1">
    <tr> 
        <td width="33%" class="tablearialhdr">Document History</td>
        <td width="34%" class="tablearialhdr"> 
            <div align="center">User</div>
        </td>
        <td width="33%" class="tablearialhdr"> 
            <div align="center">Date</div>
        </td>
    </tr>
    <tr> 
        <td width="33%" class="tablecell1"><i>Prepared by</i></td>
        <td width="34%" class="tablecell1"> 
            <div align="left"> <i> 
                    <%
            User u = new User();
            try {
                u = DbUser.fetch(receive.getUserId());
            } catch (Exception e) {
            }
                    %>
            <%=u.getLoginId()%></i></div>
        </td>
        <td width="33%" class="tablecell1"> 
            <div align="center"><i><%=JSPFormater.formatDate(receive.getDate(), "dd MMMM yy")%></i></div>
        </td>
    </tr>
    <tr> 
        <td width="33%" class="tablecell1"><i>Approved by</i></td>
        <td width="34%" class="tablecell1"> 
            <div align="left"> <i> 
                    <%
            u = new User();
            try {
                u = DbUser.fetch(receive.getApproval1());
            } catch (Exception e) {
            }
                    %>
            <%=u.getLoginId()%></i></div>
        </td>
        <td width="33%" class="tablecell1"> 
            <div align="center"> <i> 
                    <%if (receive.getApproval1() != 0) {%>
                    <%=JSPFormater.formatDate(receive.getApproval1Date(), "dd MMMM yy")%> 
                    <%}%>
            </i></div>
        </td>
    </tr>
    <tr> 
        <td width="33%" class="tablecell1"><i>Checked by </i></td>
        <td width="34%" class="tablecell1"> 
            <div align="left"><i> 
                    <%
            u = new User();
            try {
                u = DbUser.fetch(receive.getApproval2());
            } catch (Exception e) {
            }
                    %>
            <%=u.getLoginId()%></i></div>
        </td>
        <td width="33%" class="tablecell1"> 
            <div align="center"><i> 
                    <%if (receive.getApproval2() != 0) {%>
                    <%=JSPFormater.formatDate(receive.getApproval2Date(), "dd MMMM yy")%> 
                    <%}%>
            </i></div>
        </td>
    </tr>
</table>
