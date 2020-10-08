 
<% ((HttpServletResponse) response).addCookie(new Cookie("JSESSIONID", session.getId()));%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.admin.*" %>
<%@ page import="com.project.system.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %> 
<%@ page import="com.project.main.db.*" %>
<%@ include file="main/javainit.jsp"%>
<%@ include file="main/check.jsp"%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            int iErrCode = JSPMessage.NONE;
            String msgString = "";
            int recordToGet = 10;
            int vectSize = 0;
            JSPLine ctrLine = new JSPLine();
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
<!-- #BeginEditable "javascript" -->  
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
            <%if (!isSystemActive) {%>
            window.location="expired.jsp";
            <%}%>
            
        </script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="main/hmenusl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="main/menusl.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><font color="#990000" class="lvl1"> 
                                      Sistem Klinik </font><font class="tit1">&raquo; 
                                      </font><span class="lvl2">Selamat Datang</span></td>
                                    <td width="40%" height="23"> 
                                      <%@ include file = "main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="2" height="3" background="images/line1.gif" ></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="68%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="17%" valign="top" nowrap><font face="Arial, Helvetica, sans-serif"><b><img src="<%=approot%>/images/<%=user.getEmployeeNum()%>.jpg" height="130" border="0"><img src="images/spacer.gif" width="10" height="8"></b></font></td>
                                    <td width="55%" valign="top"> 
                                      <div align="left"><font face="Arial, Helvetica, sans-serif"><b><%=user.getFullName()%></b>, welcome Inventory System. 
                                        Your last login is : <br>
                                        <%=(user.getLastLoginDate1() == null) ? " - " : JSPFormater.formatDate(user.getLastLoginDate1(), "dd MMMM yyyy HH:mm:ss")%><br>
                                        <br>
                                        Please click one of the menu provided 
                                        in menu navigator to select the form.</font></div>
                                    </td>
                                    <td width="28%" valign="top" align="right" colspan="2"> 
                                      <%@ include file = "main/calendar.jsp" %>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">&nbsp;</td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2">&nbsp; </td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="4"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2">&nbsp; </td>
                                    <td width="28%" colspan="2">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="17%">&nbsp; </td>
                                    <td width="55%">&nbsp;</td>
                                    <td width="28%" colspan="2">&nbsp;</td>
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
                        <!-- #EndEditable --> </td>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="main/footersl.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
