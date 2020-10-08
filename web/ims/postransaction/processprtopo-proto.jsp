 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td width="40%">&nbsp;<b>Export PR to PO was 
                                      completed successfully !</b></td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;2(two) PO documents 
                                      are generated. Please, click the link in 
                                      the list to view the detail.</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="46%" height="20">PO 
                                            Number</td>
                                          <td class="tablehdr" width="54%" height="20">Supplier</td>
                                        </tr>
                                        <tr> 
                                          <td width="46%" class="tablecell1" height="20"><a href="#">PO11080001</a></td>
                                          <td width="54%" class="tablecell1" height="20">Courts</td>
                                        </tr>
                                        <tr> 
                                          <td width="46%" class="tablecell" height="20"><a href="#">PO11080002</a></td>
                                          <td width="54%" class="tablecell" height="20">Tiara 
                                            Dewata </td>
                                        </tr>
                                        <tr> 
                                          <td width="46%">&nbsp;</td>
                                          <td width="54%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%"><font color="#FF0000">catatan 
                                      :<br>
                                      - hasil export di tampilkan dalam list<br>
                                      - masalah message nya biar aku yang atur 
                                      nanti pak de<br>
                                      - kalau di klik link nya akan lari ke form 
                                      PO edit</font></td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="40%">&nbsp;</td>
                                    <td width="60%">&nbsp;</td>
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
                        </form>
                        Transaction 
                        &raquo; <span class="level1">PR</span> &raquo; <span class="level2">Export 
                        PR to PO<br>
                        </span><!-- #EndEditable -->
                      </td>
                    </tr>
                    
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
