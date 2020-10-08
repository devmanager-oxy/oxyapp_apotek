 
<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="JAVA"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.System"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.*"%>
<%@ page import="com.dimata.qdep.form.*"%>
<%@ page import="com.dimata.util.*"%>
<%@ page import="com.dimata.util.blob.TextLoader" %>
<%@ page import="com.dimata.jkjonline.entity.ppk.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
//boolean datasyncPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);
%>
<!-- JSP Block -->
<%
long oidUpPpk = FRMQueryString.requestLong(request, "id_upload_ppk");
//out.println(oidUpPpk);
if(oidUpPpk!=0){
	oidUpPpk = ParserAndDBProcess.insertAllDataToDbReal(oidUpPpk);
}
%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Finance System</title>
<script language="JavaScript">
<%if(!datasyncPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
</script>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/default.css" rel="stylesheet" type="text/css">
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable --> 
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
  <!--DWLayoutTable-->
  <tr> 
    <td height="76" width="100%" colspan="3" valign="top"> 
      <table height=76 cellspacing=0 cellpadding=0 width="100%" border=0>
        <!--DWLayoutTable-->
        <tr> 
          <td id=TOPTITLE valign=top width="100%" background=../images/menubg.gif 
          bgcolor=#66BB8A height=50> 
            <table cellspacing=0 cellpadding=0 width="100%" border=0>
              <tr> 
                <td width="25%" height=20><img 
                  src="../images/logo1.gif" width=66 height=60 hspace="5"></td>
                <td align=center width="50%"><img src="<%=approot%>/images/jembrana_05.gif" width="255" height="60"></td>
                <td align=right width="25%"><img 
                  src="../images/logo2.gif" width=63 height=60 hspace="5"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td valign=top align=middle height=2><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td height=1 align=middle valign=top class="bordercolor"><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td valign=top align=middle height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td height="17" align=center valign=center class="footer" id=MAINMENU> 
            <!-- #BeginEditable "menumain" --> 
            <%@ include file = "../main/mnmain.jsp" %>
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td align=middle colspan=3 height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td height=1 align=middle class="bordercolor"><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td width="5" rowspan="2" ><img src="<%=approot%>/images/spacer.gif" width="5" height="1"> 
    </td>
    <td width="100%" height="30" valign="middle" class="subtitle" ><img src="<%=approot%>/images/spacer.gif" width="1" height="20"> 
      <!-- #BeginEditable "contenttitle" -->Upload Bukti Pelayanan Pasien <!-- #EndEditable --> 
    </td>
    <td width="5" rowspan="2" align="right" valign="middle" ><img src="<%=approot%>/images/spacer.gif" width="5" height="1"></td>
  </tr>
  <tr> 
    <td valign="top" > 
      <table cellspacing=1 cellpadding=0 width="100%" 
      border=0>
        <tr> 
          <td valign=top bgcolor="#307857" > 
            <table cellspacing=1 cellpadding=12 width="100%" border=0>
              <tr> 
                <td valign="top" bgcolor=#DFF4E4> <!-- #BeginEditable "content" -->&nbsp;
                  <table width="100%" border="0" cellspacing="2" cellpadding="2">
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                    <%if(oidUpPpk!=0){%>
                    <tr> 
                      <td> 
                        <div align="center"><font color="#0000FF" size="3">Proses 
                          upload berhasil dengan sukses ...</font></div>
                      </td>
                    </tr>
                    <%}
					else{%>
                    <tr> 
                      <td> 
                        <div align="center"><font color="#FF0000" size="3">Proses 
                          upload tidak berhasil, terdapat data yang tidak bisa 
                          di proses ...</font></div>
                      </td>
                    </tr>
                    <%}%>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                  <!-- #EndEditable --></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td width="100%" colspan="3" valign="bottom"> 
      <table cellspacing=0 cellpadding=0 width="100%" border=0>
        <!--DWLayoutTable-->
        <tr> 
          <td width="100%" height=5 align=middle valign=top><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td height=1 align=middle valign=top class="bordercolor"><img 
            src="../Templates/home_files/spacer.gif" width=1 height=1 class="bordercolor"></td>
        </tr>
        <tr> 
          <td valign=top align=middle height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td height="20" align=middle valign=center class=footer ><!-- #BeginEditable "footer" --> 
            <%@ include file = "../main/footer.jsp" %>
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign=top align=middle height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
        </tr>
        <tr> 
          <td height=1 align=middle class="bordercolor"><img height=1 src="../Templates/home_files/spacer.gif" 
  width=5></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
