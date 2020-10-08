 
<%@ page language="java" %>

<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.dimata.hanoman.entity.admin.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_ADMIN, AppObjInfo.G2_ADMIN_USER, AppObjInfo.OBJ_ADMIN_USER_USER); %>
<%@ include file = "../main/checkuser.jsp" %>


<!-- JSP Block -->
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/admin.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Prochain - System Administrator</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td colspan="2" background="<%=approot%>/image/bg2.jpg" height=59> 
      <img  height="60" src="<%=approot%>/image/main2.jpg">
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="topmenu" height="20">       
      <!-- #BeginEditable "menu_main" --> 
      <%@ include file = "../main/menumain.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
  <tr> 
    <td width="200" valign="top" align="left" >
      
      <!-- #BeginEditable "menu_purchasing" --> 
      <%@ include file = "../main/menuadmin.jsp" %>
      <!-- #EndEditable --> 
    </td>
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->System 
            &gt; Object Locking<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --><form name="form1" method="post" action="">
		      <table width="100%">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
                <tr> 
                  <td width="14%">Status </td>
                  <td width="86%">Off</td>
                </tr>
                <tr> 
                  <td width="14%">Control</td>
                  <td width="86%"><a href="#">Start</a></td>
                </tr>
                <tr> 
                  <td width="14%">&nbsp;</td>
                  <td width="86%">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="txtheading1" colspan="2">Locked Object list</td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table width="65%" border="0" cellspacing="1" cellpadding="1" class="listgen">
                      <tr> 
                        <td width="11%" class="listgentitle"> OID</td>
                        <td width="19%" class="listgentitle">Start Locking</td>
                        <td width="13%" class="listgentitle">Duration </td>
                        <td width="24%" class="listgentitle">Locked By</td>
                        <td width="33%" class="listgentitle">Task</td>
                      </tr>
                      <tr> 
                        <td width="11%" class="listgensell">109909</td>
                        <td width="19%" class="listgensell">12 Feb 2002 12:30</td>
                        <td width="13%" class="listgensell">5</td>
                        <td width="24%" class="listgensell">Admin Administrator</td>
                        <td width="33%" class="listgensell">Edit User</td>
                      </tr>
                      <tr> 
                        <td width="11%" class="listgensell">234455</td>
                        <td width="19%" class="listgensell">13Feb 2002 11:10</td>
                        <td width="13%" class="listgensell">5</td>
                        <td width="24%" class="listgensell">Robert</td>
                        <td width="33%" class="listgensell">Edit Privilege</td>
                      </tr>
                      <tr> 
                        <td width="11%" class="listgensell">&nbsp;</td>
                        <td width="19%" class="listgensell">&nbsp;</td>
                        <td width="13%" class="listgensell">&nbsp;</td>
                        <td width="24%" class="listgensell">&nbsp;</td>
                        <td width="33%" class="listgensell">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="11%" class="listgensell">&nbsp;</td>
                        <td width="19%" class="listgensell">&nbsp;</td>
                        <td width="13%" class="listgensell">&nbsp;</td>
                        <td width="24%" class="listgensell">&nbsp;</td>
                        <td width="33%" class="listgensell">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="11%" class="listgensell">&nbsp;</td>
                        <td width="19%" class="listgensell">&nbsp;</td>
                        <td width="13%" class="listgensell">&nbsp;</td>
                        <td width="24%" class="listgensell">&nbsp;</td>
                        <td width="33%" class="listgensell">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="11%" class="listgensell">&nbsp;</td>
                        <td width="19%" class="listgensell">&nbsp;</td>
                        <td width="13%" class="listgensell">&nbsp;</td>
                        <td width="24%" class="listgensell">&nbsp;</td>
                        <td width="33%" class="listgensell">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="14%">&nbsp;</td>
                  <td width="86%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="14%">&nbsp;</td>
                  <td width="86%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="14%">&nbsp;</td>
                  <td width="86%">&nbsp;</td>
                </tr>
              </table>
</form>
<!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <div align="center"> copyright Bali Information Technologies 2002</div>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>

