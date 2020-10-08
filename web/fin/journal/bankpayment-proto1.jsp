 
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
                    <td width="23%">&nbsp;</td>
                    <td width="22%">&nbsp;</td>
                    <td width="55%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="23%"><b>Bank &gt; Payment</b></td>
                    <td width="22%">Voucher # : 00120 , Date : 18-11-2007</td>
                    <td width="55%">Operator : Admin</td>
                  </tr>
                  <tr> 
                    <td width="23%">&nbsp;</td>
                    <td width="22%">&nbsp;</td>
                    <td width="55%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td colspan="3">
                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="10%" height="19"><b>Vendor</b></td>
                          <td width="3%" height="19"><b></b></td>
                          <td width="29%" height="19"><b>PT. Maju Jaya</b></td>
                          <td width="10%" height="19">&nbsp;</td>
                          <td width="48%" height="19">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="10%"><b>Total Balance</b></td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"><b>Rp. 10,000,000.-</b></td>
                          <td width="10%">&nbsp;</td>
                          <td width="48%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="10%">&nbsp;</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%">&nbsp;</td>
                          <td width="10%">&nbsp;</td>
                          <td width="48%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="10%">Payment from Account</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <select name="select">
                              <option selected>3-1001 Bank BNI Denpasar Opr</option>
                              <option>3-2002 Bank BNI Labuan Bajo Opr</option>
                              <option>.......</option>
                            </select>
                          </td>
                          <td width="10%">Journal #</td>
                          <td width="48%"> 
                            <input type="text" name="textfield4" value="PPY001">
                          </td>
                        </tr>
                        <tr bgcolor="#FFFFB0"> 
                          <td colspan="5" height="5"></td>
                        </tr>
                        <tr bgcolor="#FFFFB0"> 
                          <td width="10%">Payee</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%" bgcolor="#FFFFB0"> 
                            <select name="select3">
                              <option selected>Yuyun</option>
                              <option>...</option>
                            </select>
                          </td>
                          <td width="10%">&nbsp;</td>
                          <td width="48%">&nbsp;</td>
                        </tr>
                        <tr bgcolor="#FFFFB0"> 
                          <td width="10%">Payment Method</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <select name="select2">
                              <option selected>Bank Transfer</option>
                              <option>Check Request</option>
                            </select>
                          </td>
                          <td width="10%">Check/Tranfer Date</td>
                          <td width="48%"> 
                            <input type="text" name="textfield5" value="18-11-2007">
                          </td>
                        </tr>
                        <tr bgcolor="#FFFFB0"> 
                          <td width="10%">Check/Transfer #</td>
                          <td width="3%"> 
                            <div align="right"></div>
                          </td>
                          <td width="29%"> 
                            <input type="text" name="textfield42" value="CK001">
                          </td>
                          <td width="10%">Amount</td>
                          <td width="48%"> 
                            <input type="text" name="textfield3" value="10,000,000,-">
                          </td>
                        </tr>
                        <tr bgcolor="#FFFFB0"> 
                          <td width="10%">Memo</td>
                          <td width="3%">&nbsp;</td>
                          <td colspan="3"> 
                            <input type="text" name="textfield" size="65">
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
                                <td colspan="5"> 
                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                      <td width="1%">&nbsp;</td>
                                      <td width="100" bgcolor="#C0D6C0"> 
                                        <div align="center"><a href="bankpayment-proto.jsp?menu_idx=1">Expense</a></div>
                                      </td>
                                      <td width="100"   class="tablehdr" > 
                                        <div align="center">Activity</div>
                                      </td>
                                      <td width="74%">&nbsp;&nbsp;[ <a href="#">Generate 
                                        Activity From Predefined Data</a> ] </td>
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
                                <td width="5%" class="tablecell">1.1.0.1.0<br>
                                </td>
                                <td width="30%" class="tablecell"><a href="#" title="Collaborative Management">Col</a> 
                                  - Establish JV (PNK)<br>
                                </td>
                                <td width="14%" class="tablecell">IFC</td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right">Rp. 300,000.-</div>
                                </td>
                                <td width="41%" class="tablecell">Beli ....</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">1.1.0.1.0</td>
                                <td width="30%" class="tablecell"><a href="#"  title="Collaborative Management">Col</a> 
                                  - Establish JV (PNK)</td>
                                <td width="14%" class="tablecell">Donor-1</td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right">Rp. 200.000,-</div>
                                </td>
                                <td width="41%" class="tablecell">Beli ...</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">2.1.1.1.0<br>
                                </td>
                                <td width="30%" class="tablecell"><a href="#"  title="Conservation">Con</a> 
                                  - Review job descriptions to meet the actual 
                                  positions needed in the site (BTNK-PNK Team)<br>
                                </td>
                                <td width="14%" class="tablecell">IFC</td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right">Rp. 100.000,-</div>
                                </td>
                                <td width="41%" class="tablecell">Beli ...</td>
                              </tr>
                              <tr> 
                                <td colspan="2"> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="10%"><img src="../images/ctr_line/BtnNew.jpg" width="21" height="21"></td>
                                      <td width="90%"><a href="#">New</a></td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="14%">&nbsp;</td>
                                <td width="10%">&nbsp;</td>
                                <td width="41%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td width="10%"> 
                            <input type="checkbox" name="checkbox" value="checkbox" checked>
                            Printed </td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%">&nbsp;</td>
                          <td width="10%">&nbsp;</td>
                          <td width="48%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="3%"><img src="../images/ctr_line/print.jpg" width="25" height="26"></td>
                                <td width="5%"><a href="#">Print</a></td>
                                <td width="3%"><img src="../images/ctr_line/BtnSave.jpg" width="21" height="21"></td>
                                <td width="15%"><a href="#">Post Journal</a></td>
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
