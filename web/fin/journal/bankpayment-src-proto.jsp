 
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
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Bank</span> 
                        &raquo; <span class="level1">Payment</span> &raquo; <span class="level2">Based 
                        On PO<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm_data" method="post" action="">
                          <input type="hidden" name="menu_idx" value="">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="2" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="24" valign="middle" colspan="3" class="comment"><b><font face="Geneva, Arial, Helvetica, san-serif" size="3"><b></b></font>Search 
                                      Purchases</b> </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="top" colspan="3" class="comment"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="3%">Vendor</td>
                                          <td width="13%"> 
                                            <select name="select">
                                              <option selected>All</option>
                                              <option>PT. Laksmana</option>
                                              <option>CV. Bangun Jaya</option>
                                            </select>
                                          </td>
                                          <td width="6%">Due Date </td>
                                          <td width="12%"> 
                                            <input name="a22" value="<%=JSPFormater.formatDate((new Date()==null) ? new Date() : new Date(), "dd/MM/yyyy")%>" size="11">
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.a22);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                          <td width="6%">Over Due </td>
                                          <td width="7%"> 
                                            <input type="checkbox" name="checkbox2" value="checkbox">
                                            Yes </td>
                                          <td width="53%"> 
                                            <input type="button" name="Button" value="Search">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="7" height="5"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr id="listit"> 
                                    <td height="14" valign="middle" colspan="3" class="comment"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="8%">Trans. 
                                            Date</td>
                                          <td class="tablehdr" width="5%">Status</td>
                                          <td class="tablehdr" width="6%">Currency</td>
                                          <td class="tablehdr" width="14%">Vendor</td>
                                          <td class="tablehdr" width="11%">Invoice 
                                            Number</td>
                                          <td class="tablehdr" width="13%">Amount</td>
                                          <td class="tablehdr" width="15%">Payment</td>
                                          <td  class="tablehdr" width="28%">Due 
                                            Date</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" width="8%">10-11-2007</td>
                                          <td class="tablecell" width="5%">&nbsp;</td>
                                          <td class="tablecell" width="6%">&nbsp;</td>
                                          <td class="tablecell" width="14%">PT. 
                                            Maju Jaya</td>
                                          <td class="tablecell" width="11%">&nbsp;</td>
                                          <td class="tablecell" width="13%">&nbsp;</td>
                                          <td class="tablecell" width="15%">&nbsp;</td>
                                          <td class="tablecell" width="28%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="8%">&nbsp;</td>
                                          <td width="5%" bgcolor="#F2F2F2"> 
                                            <div align="center"><font size="1" color="#FF0000"><b>OVERDUE</b></font></div>
                                          </td>
                                          <td width="6%" bgcolor="#F2F2F2"> 
                                            <div align="center">Rp.</div>
                                          </td>
                                          <td width="14%" bgcolor="#F2F2F2"> 
                                            <div align="right"><a href="bankpayment-proto.jsp?menu_idx=2">PO-001/01-11-2007</a></div>
                                          </td>
                                          <td width="11%" bgcolor="#F2F2F2"> 
                                            <div align="right">INV-001/10-11-2007</div>
                                          </td>
                                          <td width="13%" bgcolor="#F2F2F2"> 
                                            <div align="right">Rp. 10,000,000.-</div>
                                          </td>
                                          <td width="15%" bgcolor="#F2F2F2"> 
                                            <div align="right">Rp. 4,000,000.-</div>
                                          </td>
                                          <td width="28%" bgcolor="#F2F2F2">10-11-2007</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="8%">&nbsp;</td>
                                          <td width="5%" bgcolor="#F2F2F2"><font size="1" color="#FF0000"><b>OVERDUE</b></font></td>
                                          <td width="6%" bgcolor="#F2F2F2"> 
                                            <div align="center">Rp.</div>
                                          </td>
                                          <td width="14%" bgcolor="#F2F2F2"> 
                                            <div align="right"><a href="bankpayment-proto.jsp?menu_idx=2">PO-001/01-11-2007</a></div>
                                          </td>
                                          <td width="11%" bgcolor="#F2F2F2"> 
                                            <div align="right">INV-002/15-11-2007</div>
                                          </td>
                                          <td width="13%" bgcolor="#F2F2F2"> 
                                            <div align="right">0,-</div>
                                          </td>
                                          <td width="15%" bgcolor="#F2F2F2">&nbsp;</td>
                                          <td width="28%" bgcolor="#F2F2F2">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="8%">&nbsp;</td>
                                          <td width="5%" bgcolor="#F2F2F2">&nbsp;</td>
                                          <td width="6%" bgcolor="#F2F2F2"> 
                                            <div align="center">USD</div>
                                          </td>
                                          <td width="14%" bgcolor="#F2F2F2"> 
                                            <div align="right"><a href="bankpayment-proto.jsp?menu_idx=2">PO-002/10-11-2007</a></div>
                                          </td>
                                          <td width="11%" bgcolor="#F2F2F2"> 
                                            <div align="right">INV-011/12-11-2007</div>
                                          </td>
                                          <td width="13%" bgcolor="#F2F2F2"> 
                                            <div align="right">USD. 1,000,000.-</div>
                                          </td>
                                          <td width="15%" bgcolor="#F2F2F2"> 
                                            <div align="right">USD. 500,000.-</div>
                                          </td>
                                          <td width="28%" bgcolor="#F2F2F2">23-11-2007</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" width="8%">20-10-2007</td>
                                          <td class="tablecell" width="5%">&nbsp;</td>
                                          <td class="tablecell" width="6%">&nbsp;</td>
                                          <td class="tablecell" width="14%">CV. 
                                            Ramayana</td>
                                          <td class="tablecell" width="11%">&nbsp;</td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="right">Rp. 5,000,000.-</div>
                                          </td>
                                          <td class="tablecell" width="15%"> 
                                            <div align="right">Rp. 4,000,000.-</div>
                                          </td>
                                          <td class="tablecell" width="28%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="8%">&nbsp;</td>
                                          <td width="5%" bgcolor="#F2F2F2">&nbsp;</td>
                                          <td width="6%" bgcolor="#F2F2F2"> 
                                            <div align="center">Rp.</div>
                                          </td>
                                          <td width="14%" bgcolor="#F2F2F2"> 
                                            <div align="right">PO-003/01-11-2007</div>
                                          </td>
                                          <td width="11%" bgcolor="#F2F2F2">&nbsp;</td>
                                          <td width="13%" bgcolor="#F2F2F2"> 
                                            <div align="right">Rp. 5,000,000.-</div>
                                          </td>
                                          <td width="15%" bgcolor="#F2F2F2"> 
                                            <div align="right">Rp. 4,000,000.-</div>
                                          </td>
                                          <td width="28%" bgcolor="#F2F2F2">23-11-2007</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment">List 
                                      1-3 of 3</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
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
