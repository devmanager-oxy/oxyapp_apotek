<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="java" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%//@ page import="com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
//boolean datasyncPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);
%>
<!-- JSP Block -->
<%
session.putValue("MENU_IDX", ""+menuIdx);

/*** LANG ***/
String[] langAT = {"Please, browse file *.txt containt of new data transaction."};

String[] langNav = {"Data Synchronization", "Upload", "Upload Data"};

//if (lang == LANG_ID) {
	String[] langID = {"Silahkan buka file *.txt yang berisi data transaksi baru."};
	langAT = langID;

	String[] navID = {"Data Singkronisasi", "Upload", "Upload Data"};
	langNav = navID;
//}

%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Oxy-Sales</title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if(!datasyncPriv){%>
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
            <%@ include file="../main/hmenusl.jsp"%>
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
                  <%@ include file="../main/menusl.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><%
            String navigator = "<font class=\"lvl1\">" + langNav[0]+"</font><font class=\"level2\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[2] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" -->  
					    <form name="form1" method="post" action="preview_data.jsp" enctype="multipart/form-data">
						
                          <table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <!--DWLayoutTable-->
                            <tr>
                              <td width="5" ><img src="<%=approot%>/images/spacer.gif" width="5" height="1"> 
                              </td>
                              <td valign="top" > 
                                <table cellspacing=1 cellpadding=0 width="100%" 
      border=0>
                                  <tr> 
                                    <td valign=top> 
                                      <table width="100%" border=0>
                                        <tr> 
                                          <td valign="top"> 
                                            <table width="71%" border="0" cellspacing="2" cellpadding="2">
                                              <tr> 
                                                <td colspan="2" height="16"><%=langAT[0]%></td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>&nbsp;</td>
                                                <td width="86%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>Upload File</td>
                                                <td width="86%"> 
                                                  <input type="file" name="file" size="40">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>&nbsp;</td>
                                                <td width="86%"> 
                                                  <input type="submit" name="Submit" value="Upload Data" class="formElemen">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2" nowrap>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>&nbsp;</td>
                                                <td width="86%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>&nbsp;</td>
                                                <td width="86%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>&nbsp;</td>
                                                <td width="86%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                              <td width="5" align="right" valign="middle" ><img src="<%=approot%>/images/spacer.gif" width="5" height="1"></td>
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
