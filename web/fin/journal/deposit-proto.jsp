 
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
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%"><font face="Geneva, Arial, Helvetica, san-serif" size="3"><b><u>BANK</u></b></font></td>
                    <td width="39%"><font face="Geneva, Arial, Helvetica, san-serif" size="3"><b><u>DEPOSIT</u></b></font></td>
                    <td width="35%">Date : 18-11-2007, Operator : Admin</td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td colspan="3"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="10%">Deposit to Account</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <select name="select">
                              <option>3-1001 Bank BIN Denpasar Opr</option>
                              <option selected>3-2002 Bank BNI Labuan Bajo Opr</option>
                              <option>....</option>
                            </select>
                          </td>
                          <td width="9%">Journal Number</td>
                          <td width="49%"> BD11070001</td>
                        </tr>
                        <tr> 
                          <td width="10%">Amount(Rp.)</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <input type="text" name="textfield3" value="15,000,000.-">
                          </td>
                          <td width="9%">Transaction Date</td>
                          <td width="49%"> 
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
                          <td width="9%">&nbsp;</td>
                          <td width="49%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td colspan="5" class="boxed4"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td rowspan="2"  class="tablehdr" width="7%">Account#</td>
                                <td rowspan="2" class="tablehdr" width="15%">Description</td>
                                <td colspan="2" class="tablehdr">Foreign Currency</td>
                                <td rowspan="2" class="tablehdr" width="8%">Booked 
                                  Rate</td>
                                <td rowspan="2" class="tablehdr">Amount</td>
                                <td rowspan="2" class="tablehdr">Memo</td>
                              </tr>
                              <tr> 
                                <td width="8%" class="tablehdr">Currency</td>
                                <td width="7%" class="tablehdr">Amount</td>
                              </tr>
                              <tr> 
                                <td width="7%" class="tablecell">2-10010</td>
                                <td width="15%" class="tablecell">Cash Intransit 
                                  Labuan Bajo</td>
                                <td width="8%" class="tablecell"> 
                                  <select name="select2">
                                    <option selected>Rp.</option>
                                    <option>USD</option>
                                    <option>EUR</option>
                                  </select>
                                </td>
                                <td width="7%" class="tablecell"> 
                                  <div align="right">1,500.-</div>
                                </td>
                                <td width="8%" class="tablecell">&nbsp;</td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right">Rp. 15,000,000.-</div>
                                </td>
                                <td width="42%" class="tablecell">Penjualan ....</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td width="10%">&nbsp; </td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%">&nbsp;</td>
                          <td width="9%">&nbsp;</td>
                          <td width="49%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td width="3%"><img src="../images/ctr_line/BtnNew.jpg" width="21" height="21"></td>
                                <td width="5%"><a href="#">New</a></td>
                                <td width="2%"><img src="../images/ctr_line/print.jpg" width="25" height="26"></td>
                                <td width="6%"><a href="#">Print</a></td>
                                <td width="2%"><img src="../images/ctr_line/BtnSave.jpg" width="21" height="21"></td>
                                <td width="23%"><a href="#">Post Journal</a></td>
                                <td width="59%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">1. jika deposit account adalah Rp maka otomatis 
                      amount adalah rp. jika usd juga</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">2. total pada detail akan mengikuti currency 
                      pada amount</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="26%">&nbsp;</td>
                    <td width="39%">&nbsp;</td>
                    <td width="35%">&nbsp;</td>
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
