<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr> 
    <td width="526">
      <table border="0" cellspacing="0" cellpadding="0" width="526">
        <tr> 
          <td rowspan="2"><img src="<%=approot%>/images/logo-finance1.jpg" width="216" height="144" /></td>
          <td><img src="<%=approot%>/images/logotxt-finance.gif" width="343" height="94" /></td>
        </tr>
        <tr> 
          <td style="background:url(<%=approot%>/images/head-line.gif) repeat-x"><img src="<%=approot%>/images/head-corner.gif" width="119" height="50" /></td>
        </tr>
      </table>
    </td>
    <td width="100%" valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td valign="top" style="background:url(<%=approot%>/images/head-bg.gif) repeat-x">
            <table border="0" align="right" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="31" align="right" valign="top" >&nbsp;</td>
                <td rowspan="2" height="74"></td>
                <td rowspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td align="right" valign="top" >&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td style="background:url(<%=approot%>/images/head-icon-bg.gif) repeat-x">
            <script language="JavaScript">
			function cmdEnterApp(idx){
				if(parseInt(idx)==1){ window.location="<%=approotx%>/btdc-fin?login_id=<%=user.getLoginId()%>&pass_wd=<%=user.getPassword()%>&command=1"; }
				if(parseInt(idx)==2){ window.location="<%=approotx%>/btdc-crm?login_id=<%=user.getLoginId()%>&pass_wd=<%=user.getPassword()%>&command=1"; }
				if(parseInt(idx)==3){ window.location="<%=approotx%>/sipadu-inv/indexsl.jsp?login_id=<%=user.getLoginId()%>&pass_wd=<%=user.getPassword()%>&command=1"; }
				if(parseInt(idx)==4){ window.location="<%=approotx%>/sipadu-inv/indexpg.jsp?login_id=<%=user.getLoginId()%>&pass_wd=<%=user.getPassword()%>&command=1"; }
				if(parseInt(idx)==5){ window.location="<%=approotx%>/sipadu-fin/indexsp.jsp?login_id=<%=user.getLoginId()%>&pass_wd=<%=user.getPassword()%>&command=1"; }
			}
			</script>
            <table border="0" align="right" cellpadding="0" cellspacing="0">
              <tr> 
                  <td><a href="<%=approot%>/home.jsp" title="Finance System - Home"><img src="<%=approot%>/images/button-finance2.gif" width="50" height="45" border="0" /></a></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
			
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
