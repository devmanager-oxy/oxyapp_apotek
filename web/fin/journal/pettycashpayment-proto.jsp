 
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
                <input type="hidden" name="menu_idx" value="">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%"><font face="Geneva, Arial, Helvetica, san-serif" size="3"><b><u>CASH 
                      - PETTY CASH</u></b></font></td>
                    <td width="28%"> 
                      <div align="center"><font size="3"><b><font face="Geneva, Arial, Helvetica, san-serif"><u>PAYMENT</u></font></b></font></div>
                    </td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">Date : 18-11-2007, Operator : Admin</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td colspan="4"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="10%">Payment from Account</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <select name="select">
                              <option selected>1-1001 Pertty Cash Labuan Bajo</option>
                              <option>1-2002 Petty Cash Denpasar</option>
                            </select>
                          </td>
                          <td width="10%"><b>Account Balance</b></td>
                          <td width="48%"><b>Rp. 400,000.-</b></td>
                        </tr>
                        <tr> 
                          <td width="10%">Amount (Rp.)</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <input type="text" name="textfield3" value="600,000,-">
                          </td>
                          <td width="10%">Journal Number</td>
                          <td width="48%">PP11070001 </td>
                        </tr>
                        <tr> 
                          <td width="10%" height="16">&nbsp;</td>
                          <td width="3%" height="16">&nbsp;</td>
                          <td width="29%" height="16">&nbsp;</td>
                          <td width="10%" height="16">Transaction Date</td>
                          <td width="48%" height="16"> 
                            <input type="text" name="textfield5" value="18-11-2007">
                          </td>
                        </tr>
                        <tr> 
                          <td width="10%">Memo</td>
                          <td width="3%">&nbsp;</td>
                          <td colspan="3"> 
                            <input type="text" name="textfield" size="120">
                          </td>
                        </tr>
                        <tr> 
                          <td width="10%">&nbsp;</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%">&nbsp;</td>
                          <td width="10%">&nbsp;</td>
                          <td width="48%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td colspan="5" class="boxed4"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td colspan="4">
								  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                      <td width="1%">&nbsp;</td>
                                      <td class="boxed4"> 
                                        <div align="center"></div>
                                        </td>
                                      <td width="74%">&nbsp;</td>
                                    </tr>
                                  </table> 
                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                      <td width="1%">&nbsp;</td>
                                      <td width="100"  class="tablehdr"> 
                                        <div align="center">Expense</div>
                                      </td>
                                      <td width="100" bgcolor="#C0D6C0"> 
                                        <div align="center"><a href="pettycashpayment1-proto.jsp?menu_idx=1">Activity</a></div>
                                      </td>
                                      <td width="74%">&nbsp;</td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr> 
                                <td width="5%"  class="tablehdr">Account</td>
                                <td width="22%" class="tablehdr">Description</td>
                                <td width="13%" class="tablehdr">Amount</td>
                                <td width="60%" class="tablehdr">Memo</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">2-10010</td>
                                <td width="22%" class="tablecell">Fuel for Boat</td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right">Rp.500,000.-</div>
                                </td>
                                <td width="60%" class="tablecell">Beli ....</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">2-20020</td>
                                <td width="22%" class="tablecell">Fuel for Car</td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right">Rp.100,000,-</div>
                                </td>
                                <td width="60%" class="tablecell">Beli ....</td>
                              </tr>
                              <tr> 
                                <td colspan="2" bgcolor="#CCCCCC"> 
                                  <div align="right"><b>TOTAL </b></div>
                                </td>
                                <td width="13%" bgcolor="#CCCCCC"> 
                                  <div align="right"><b>Rp. 600,000.-</b></div>
                                </td>
                                <td width="60%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td width="2%"><img src="../images/ctr_line/BtnNew.jpg" width="21" height="21"></td>
                                <td width="4%"><a href="#">New</a></td>
                                <td width="2%"><img src="../images/ctr_line/print.jpg" width="25" height="26"></td>
                                <td width="5%"><a href="#">Print</a></td>
                                <td width="2%"><img src="../images/ctr_line/BtnSave.jpg" width="21" height="21"></td>
                                <td width="20%"><a href="#">Post Journal</a></td>
                                <td width="65%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">1. tidak implementasi multicurrency Rp. only</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="18%">&nbsp;</td>
                    <td width="28%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="24%">&nbsp;</td>
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
