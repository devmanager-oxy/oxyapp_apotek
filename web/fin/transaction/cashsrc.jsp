 
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
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if(!cashPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
</script>
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
              <%@ include file="../main/menu.jsp"%>
              <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash </span> &raquo; 
                        <span class="level1">Petty Cash</span> &raquo; <span class="level2">Payment<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="frm_data" method="post" action="">
                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                  <tr> 
                    <td width="12%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">Transaction Type</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">Input Date</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">Transaction Date</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">Journal Number</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">Memo</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="12%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="12%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="56%">&nbsp;</td>
                  </tr>
                </table>
              </form>
              <!-- #EndEditable -->
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
