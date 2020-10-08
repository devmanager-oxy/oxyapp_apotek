<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="java" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<!-- JSP Block -->
<%

String approot="/oxy-retail";
String imageroot ="/oxy-retail/";

/*** LANG ***/
String[] langAT = {"Please, browse file *.txt containt of new data transaction."};
String[] langNav = {"Data Synchronization", "Upload", "Upload Data"};
	String[] langID = {"Silahkan buka file *.txt yang berisi data transaksi baru."};
	langAT = langID;

	String[] navID = {"Data Singkronisasi", "Upload", "Upload Data"};
	langNav = navID;
%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Finance System</title>
<link href="../css/csssl.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
</script>
<!-- #EndEditable -->
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" >&nbsp;
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
								<td width="9%" nowrap></td>	
                                                <td height="16"><%=langAT[0]%></td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap></td>
                                                <td width="86%"> 
                                                  <input type="file" name="file" size="40">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" nowrap>&nbsp;</td>
                                                <td width="86%"> 
                                                  <input type="submit" name="Submit" value=" Upload File " class="formElemen">
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
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
