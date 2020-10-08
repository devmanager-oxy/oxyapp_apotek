
<%
menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
//out.println(idx1);
%>
<script language="JavaScript">

function cmdHelp(){
	window.open("<%=approot%>/help.htm");
}

</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="<%=approot%>/imagessp/logo-finance2.jpg" width="216" height="32" /></td>
        </tr>
        <tr> 
          <td><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td style="padding-left:10px"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="5"> </td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="4"></td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr id="pinjaman1"> 
                <td class="menu0" height="20"> 
                  Pinjaman Anggota</td>
              </tr>
			  <tr><td>
			      <table class="submenu" width="93%" border="0" cellspacing="0" cellpadding="0">                    
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/memberacs/arsippinjaman.jsp">Pinjaman 
                        Koperasi</a></td>
                    </tr>                    
                    <tr> 
                      <td class="menu1"><a href="<%=approot%>/memberacs/arsippinjamanbank.jsp">Pinjaman 
                        Bank</a></td>
                    </tr> 
					<tr> 
                      <td class="menu1"><a href="<%=approot%>/memberacs/saldominimarket.jsp">Pinjaman 
                        Minimarket</a></td>
                    </tr>                    
                    <tr> 
                      <td class="menu1">&nbsp;</td>
                    </tr>
                  </table>
			  </td></tr>
              <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr id="simpanan1"> 
                <td class="menu0"> <a href="<%=approot%>/memberacs/simpananmember.jsp?hidden_member_id=<%=loginMember.getOID()%>">Simpanan 
                  Anggota </a></td>
              </tr>
			  <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr id="simpanan2"> 
                <td class="menu0"> <a href="<%=approot%>/memberacs/shu.jsp">SHU</a></td>
              </tr>
			  <tr> 
                <td ><img src="<%=approot%>/imagessp/spacer.gif" width="1" height="2"></td>
              </tr>
              
              <tr> 
                <td class="menu0"><a href="<%=approot%>/logoutmm.jsp">Logout</a></td>
              </tr>
              <tr> 
                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

