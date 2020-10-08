 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%
//jsp content
Ap ap = new Ap();

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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash 
                        </span> &raquo; <span class="level1">Petty Cash</span> 
                        &raquo; <span class="level2">Payment<br>
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
                              <td width="23%">&nbsp;</td>
                              <td width="22%">&nbsp;</td>
                              <td width="55%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="3"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="47%">
                                      <div align="right">&nbsp;Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%> 
                                        <input type="hidden" name="<%=JspAp.colNames[JspAp.JSP_VOUCHER_DATE] %>"  value="<%= JSPFormater.formatDate(new Date(), "dd/MM/yyyy") %>" class="formElemen">
                                        , Operator : Admin</div>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td width="23%">&nbsp;</td>
                              <td width="22%">&nbsp;</td>
                              <td width="55%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="3"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr> 
                                    <td height="21" width="9%" align="left">Journal 
                                      Number</td>
                                    <td height="21" width="16%" align="left">GJ11070001 
                                    </td>
                                    <td width="9%">Transaction Date</td>
                                    <td width="58%"> 
                                      <input name="<%=JspAp.colNames[JspAp.JSP_DATE] %>" value="<%=JSPFormater.formatDate((ap.getDate()==null) ? new Date() : ap.getDate(), "dd/MM/yyyy")%>" size="11">
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.<%=JspAp.colNames[JspAp.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="21" width="9%" align="left">Ref. 
                                      Number</td>
                                    <td height="21" width="16%" align="left"> 
                                      <input type="text" name="textfield">
                                    </td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="21" width="9%" align="left">Memo</td>
                                    <td colspan="3"> 
                                      <input type="text" name="<%=JspJournal.colNames[JspJournal.JSP_MEMO] %>"  value="" class="formElemen" size="120">
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="10%">&nbsp;</td>
                                    <td width="29%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" class="boxed4"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="1%">&nbsp;</td>
                                                <td width="100" bgcolor="#C0D6C0"> 
                                                  <div align="center"><a href="journal-proto.jsp?menu_idx=3">Expense</a></div>
                                                </td>
                                                <td width="100"   class="tablehdr" > 
                                                  <div align="center">Activity</div>
                                                </td>
                                                <td width="74%">&nbsp;&nbsp;[ 
                                                  <a href="#">Predefined Activity</a> 
                                                  ] </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="5%"  class="tablehdr">Code</td>
                                          <td width="30%" class="tablehdr">Activity</td>
                                          <td width="14%" class="tablehdr">Donor</td>
                                          <td width="10%" class="tablehdr">Amount</td>
                                          <td width="41%" class="tablehdr">Memo</td>
                                        </tr>
                                        <tr> 
                                          <td width="5%" class="tablecell"><br>
                                          </td>
                                          <td width="30%" class="tablecell"><br>
                                          </td>
                                          <td width="14%" class="tablecell">&nbsp;</td>
                                          <td width="10%" class="tablecell">&nbsp;</td>
                                          <td width="41%" class="tablecell">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2">&nbsp; </td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="41%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="10%">&nbsp; </td>
                                    <td width="29%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="48%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="2%"><img src="../images/ctr_line/BtnNew.jpg" width="21" height="21"></td>
                                          <td width="3%"><a href="#">New</a></td>
                                          <td width="1%"><img src="../images/ctr_line/print.jpg" width="25" height="26"></td>
                                          <td width="4%"><a href="#">Print</a></td>
                                          <td width="2%"><img src="../images/ctr_line/BtnSave.jpg" width="21" height="21"></td>
                                          <td width="14%"><a href="#">Post Journal</a></td>
                                          <td width="74%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td width="23%">&nbsp;</td>
                              <td width="22%">&nbsp;</td>
                              <td width="55%">&nbsp;</td>
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
