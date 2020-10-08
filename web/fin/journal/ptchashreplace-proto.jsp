 
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
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%"><font face="Geneva, Arial, Helvetica, san-serif" size="3"><b><u>CASH 
                      - PETTY CASH</u></b></font></td>
                    <td width="34%"><font face="Geneva, Arial, Helvetica, san-serif" size="3"><b><u>REPLENISHMENT</u></b></font></td>
                    <td width="46%">Date : 18-11-2007, Operator : Admin</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td colspan="3"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr> 
                          <td width="12%" nowrap>Replenishment for Account</td>
                          <td colspan="4"> 
                            <select name="select">
                              <option selected>1-1001 Petty Cash Labuan Bajo</option>
                              <option>1-2002 Petty Cash Denpasar</option>
                            </select>
                          </td>
                        </tr>
                        <tr> 
                          <td width="12%"><b><i>Expenses</i></b></td>
                          <td width="1%">&nbsp;</td>
                          <td width="13%">&nbsp;</td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%"><a href="#" title="click to view detail">PP11070001</a></td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right">10,000.-</div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%"><a href="#">PP11070002</a></td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right">10,000.-</div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%"><a href="#">PP11070003</a></td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right">10,000.-</div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%"><a href="#">PP11070004</a></td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right">100,000.-</div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%"><a href="#">PP11070005</a></td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right">30,000.-</div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%"><a href="#">PP11070006</a></td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right">150,000.-</div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%">&nbsp;</td>
                          <td width="1%">&nbsp;</td>
                          <td width="13%">&nbsp;</td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%" nowrap> 
                            <div align="left">Amount to be replaced </div>
                          </td>
                          <td width="1%">Rp.</td>
                          <td width="13%"> 
                            <div align="right"><b> 
                              <input type="text" name="textfield2" value="310,000.-" style="text-align:right">
                              </b></div>
                          </td>
                          <td width="11%">&nbsp;</td>
                          <td width="63%">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="12%">From Account</td>
                          <td colspan="4"> 
                            <select name="select2">
                              <option selected>1-1001 Bank BNI Labuan Bajo Opr</option>
                              <option>1-2002-2001 Bank BNI Denpasar Opr</option>
                            </select>
                            &nbsp;&nbsp;Journal Number : PR11070001</td>
                        </tr>
                        <tr> 
                          <td width="12%">Memo</td>
                          <td colspan="4"> 
                            <input type="text" name="textfield" size="120">
                          </td>
                        </tr>
                        <tr> 
                          <td colspan="5" >&nbsp; </td>
                        </tr>
                        <tr> 
                          <td colspan="5"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                              <tr> 
                                <td width="2%"><img src="../images/ctr_line/print.jpg" width="25" height="26"></td>
                                <td width="6%"><a href="#">Print</a></td>
                                <td width="2%"><img src="../images/ctr_line/BtnSave.jpg" width="21" height="21"></td>
                                <td width="16%"><a href="#">Post Journal</a></td>
                                <td width="74%">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">1. expense diperlihatkan yang pada periode 
                      open dengan status belum di replanisment</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">2. pertama kali hanya bisa di print dulu untuk 
                      mendapat persetujuan atasan</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">3. setelah di print dan di approve dan diterima 
                      orang lapangan baru bisa di posted</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">4. setelah di posted status expense dirubah 
                      ke replaneshed dan tidak muncul pada proses replanisment 
                      selanjutnya </td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="20%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="46%">&nbsp;</td>
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
