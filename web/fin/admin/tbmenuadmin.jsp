<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr > 
        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="5" height="10"></td>
        <%if(subMenuAdmIdx == 0){%>        
        <td class="tab" nowrap width="80" align="center">Login-ID</td>
        <%}else{%>
        <td class="tabin" nowrap width="80" align="center"><a href="javascript:cmdLoginId('<%=appUser.getOID()%>')" class="tablink">Login-ID</a></td>
        <%}%>
        <td class="tabheader" nowrap><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
        <%if(subMenuAdmIdx == 1){%>        
        <td class="tab" nowrap width="45" align="center">Password</td>
        <%}else{%>
        <td class="tabin" nowrap width="45" align="center"><a href="javascript:cmdPassword('<%=appUser.getOID()%>')" class="tablink">Password</a></td>
        <%}%>       
        <td class="tabheader" nowrap><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>        									
        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
    </tr>
</table>