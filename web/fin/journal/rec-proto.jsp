 
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
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%"><b><font size="4" face="Geneva, Arial, Helvetica, san-serif"><u>CASH</u></font></b></td>
                    <td width="30%"> 
                      <div align="center"><b><font size="4" face="Geneva, Arial, Helvetica, san-serif"><u> 
                        RECEIPT</u></font></b></div>
                    </td>
                    <td width="21%"> 
                      <div align="right"></div>
                    </td>
                    <td width="21%">Date : 18-11-2007&nbsp;, &nbsp;Operator : 
                      Admin&nbsp;&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="21%"> 
                      <div align="right"></div>
                    </td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td colspan="4"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="10%">Receipt to Account</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <select name="select">
                              <option selected>1-1001 Cash Intransit Labuan Bajo</option>
                              <option>1-2002 Cash Intransit Denpasar</option>
                            </select>
                          </td>
                          <td width="10%">Journal Number</td>
                          <td width="48%"> CR11070001 </td>
                        </tr>
                        <tr> 
                          <td width="10%">Receipt From</td>
                          <td width="3%">&nbsp;</td>
                          <td width="29%"> 
                            <select name="select2">
                              <option selected>Andre</option>
                              <option>Yuyun</option>
                              <option>Siska</option>
                              <option>Jeffrey</option>
                            </select>
                          </td>
                          <td width="10%">Transaction Date</td>
                          <td width="48%"> 
                            <input type="text" name="textfield5" value="18-11-2007">
                          </td>
                        </tr>
                        <tr> 
                          <td width="10%">Amount (Rp.)</td>
                          <td width="3%"> 
                            <div align="right"></div>
                          </td>
                          <td width="29%"> 
                            <input type="text" name="textfield3" value="15,000,000.-">
                          </td>
                          <td width="10%">&nbsp;</td>
                          <td width="48%">&nbsp;</td>
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
                                <td rowspan="2"  class="tablehdr">Account</td>
                                <td rowspan="2" class="tablehdr">Description</td>
                                <td colspan="2" class="tablehdr">Foreign Currency</td>
                                <td rowspan="2" class="tablehdr">Booked Rate</td>
                                <td rowspan="2" class="tablehdr">Amount(Rp)</td>
                                <td rowspan="2" class="tablehdr">Memo</td>
                              </tr>
                              <tr> 
                                <td width="7%" class="tablehdr">Currency</td>
                                <td width="10%" class="tablehdr"> Amount</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">2-10010</td>
                                <td width="19%" class="tablecell">Sales Ticket 
                                  Loh Liang</td>
                                <td width="7%" class="tablecell">USD</td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right">1000</div>
                                </td>
                                <td width="13%" class="tablecell">&nbsp;</td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right">Rp. 10,000,000.-</div>
                                </td>
                                <td width="46%" class="tablecell">Penjualan ....</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">2-20020</td>
                                <td width="19%" class="tablecell">Sales Merchandise 
                                  - Fashion</td>
                                <td width="7%" class="tablecell">-</td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right">-</div>
                                </td>
                                <td width="13%" class="tablecell">&nbsp;</td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right">Rp. 1,000,000,-</div>
                                </td>
                                <td width="46%" class="tablecell">Penjualan ....</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell">2-20020</td>
                                <td width="19%" class="tablecell">Sales Ticket 
                                  Loh Buaya</td>
                                <td width="7%" class="tablecell">-</td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right">-</div>
                                </td>
                                <td width="13%" class="tablecell">&nbsp;</td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right">Rp. 4,000,000.-</div>
                                </td>
                                <td width="46%" class="tablecell">Penjualan ....</td>
                              </tr>
                              <tr> 
                                <td width="5%" class="tablecell"> 
                                  <input type="text" name="textfield22" size="10">
                                </td>
                                <td width="19%" class="tablecell"> 
                                  <input type="text" name="textfield42" size="35">
                                </td>
                                <td width="7%" class="tablecell"> 
                                  <select name="select3">
                                    <option selected>Rp.</option>
                                    <option>USD</option>
                                    <option>EUR</option>
                                  </select>
                                </td>
                                <td width="10%" class="tablecell"> 
                                  <div align="right"> 
                                    <input type="text" name="textfield2" size="10">
                                  </div>
                                </td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right"> 
                                    <input type="text" name="textfield23" size="10">
                                  </div>
                                </td>
                                <td width="13%" class="tablecell"> 
                                  <div align="right"> 
                                    <input type="text" name="textfield4">
                                  </div>
                                </td>
                                <td width="46%" class="tablecell"> 
                                  <input type="text" name="textfield6" size="60">
                                </td>
                              </tr>
                              <tr> 
                                <td width="5%">&nbsp;</td>
                                <td width="19%">&nbsp;</td>
                                <td width="7%">&nbsp;</td>
                                <td width="10%" bgcolor="#9F9F9F"> 
                                  <div align="right"><b>TOTAL :</b></div>
                                </td>
                                <td width="13%" bgcolor="#9F9F9F">&nbsp;</td>
                                <td width="13%" bgcolor="#9F9F9F"> 
                                  <div align="right"><b>Rp. 15,000,000.-</b></div>
                                </td>
                                <td width="46%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td colspan="7" height="5"></td>
                              </tr>
                              <tr> 
                                <td width="2%"><img src="../images/ctr_line/BtnNew.jpg" width="21" height="21"></td>
                                <td width="5%"><a href="#">New</a></td>
                                <td width="2%"><img src="../images/ctr_line/BtnSave.jpg" width="21" height="21"></td>
                                <td width="10%"><a href="#">Post Journal</a></td>
                                <td width="2%"><img src="../images/ctr_line/print.jpg" width="25" height="26"></td>
                                <td width="19%"><a href="#">Print</a></td>
                                <td width="60%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">1. Transaction Date : default current date 
                      editable limited to opened period only</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">2. Journal Number : automatic setted from 
                      master - kode : CR disetup khusus transaksi ini</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">3. Kalau sudah balance Post Journal muncul</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">4. Kalau sudah di Post, Print akan muncul</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="20%">5. Receipt From : di setup sesuai dengan lokasi 
                      system </td>
                    <td width="30%">&nbsp;</td>
                    <td width="29%">&nbsp;</td>
                    <td width="21%">&nbsp;</td>
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
