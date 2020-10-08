 
                          <table width="100%%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap>
      <div align="right"><font face="Arial, Helvetica, sans-serif"><b><%=user.getFullName().toUpperCase()%> , Login : <%=JSPFormater.formatDate(user.getLastLoginDate(), "dd/MM/yyyy HH:mm:ss")%>&nbsp; </b>[ <a href="<%=approot%>/logout.jsp">Logout</a> , <a href="<%=approot%>/admin/userupdatepasswd.jsp?menu_idx=4">Change 
                            Password</a> ]<b>&nbsp;&nbsp;&nbsp;</b></font></div></td>
  </tr>
</table>

                        