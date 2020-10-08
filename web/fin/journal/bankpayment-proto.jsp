 
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
                                  <tr> 
                                    <td width="23%">&nbsp;</td>
                                    <td width="22%">&nbsp;</td>
                                    <td width="55%"> 
                                      <div align="right">Operator : Admin, Date 
                                        : 18-11-2007</div>
                                    </td>
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
                                          <td colspan="3" height="19"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="47%"><b>VENDOR</b></td>
                                                <td width="33%"><b>Total Balance</b></td>
                                                <td width="20%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="47%"><b>PT. Maju Jaya</b></td>
                                                <td width="33%"><b>Rp. 6,000,000.-</b></td>
                                                <td width="20%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="47%">Jln Teuku Umar 
                                                  20x. <br>
                                                  Denpasar - Bali<br>
                                                  Phone 123455, Fax 2334849</td>
                                                <td width="33%">&nbsp;</td>
                                                <td width="20%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="10%" height="19">&nbsp;</td>
                                          <td width="48%" height="19">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="29%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">Payment from Account</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="29%"> 
                                            <select name="select">
                                              <option selected>3-1001 Bank BNI 
                                              Denpasar Opr</option>
                                              <option>3-2002 Bank BNI Labuan Bajo 
                                              Opr</option>
                                              <option>.......</option>
                                            </select>
                                          </td>
                                          <td width="10%"><b>Account Balance</b></td>
                                          <td width="48%"><b> Rp. 100,000,000,-</b></td>
                                        </tr>
                                        <tr bgcolor="#FFFFB0"> 
                                          <td colspan="5" height="5"></td>
                                        </tr>
                                        <tr bgcolor="#FFFFB0"> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="29%">&nbsp;</td>
                                          <td width="10%">Journal Number</td>
                                          <td width="48%"> BB11070001</td>
                                        </tr>
                                        <tr bgcolor="#FFFFB0"> 
                                          <td width="12%">Payment Method</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="29%"> 
                                            <select name="select2">
                                              <option selected>Bank Transfer</option>
                                              <option>Check Request</option>
                                            </select>
                                          </td>
                                          <td width="10%">Cheque/Tranfer Date</td>
                                          <td width="48%"> 
                                            <input type="text" name="textfield5" value="18-11-2007">
                                          </td>
                                        </tr>
                                        <tr bgcolor="#FFFFB0"> 
                                          <td width="12%">Cheque/Transfer Number</td>
                                          <td width="1%"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="29%"> 
                                            <input type="text" name="textfield42">
                                          </td>
                                          <td width="10%">Amount IDR</td>
                                          <td width="48%"> 
                                            <input type="text" name="textfield3" value="6,000,000,-">
                                          </td>
                                        </tr>
                                        <tr bgcolor="#FFFFB0"> 
                                          <td width="12%">Memo</td>
                                          <td width="1%">&nbsp;</td>
                                          <td colspan="3"> 
                                            <textarea name="textfield" cols="120" rows="2"></textarea>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="29%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="5" class="boxed4"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="9%"  class="tablehdr" height="24">Invoice 
                                                  Number</td>
                                                <td width="5%" class="tablehdr" height="24"> 
                                                  Currency </td>
                                                <td width="8%" class="tablehdr" height="24">Balance</td>
                                                <td width="12%" class="tablehdr" height="24">Booked 
                                                  Rate</td>
                                                <td width="8%" class="tablehdr" height="24">Amount 
                                                  IDR </td>
                                                <td width="18%" class="tablehdr" height="24">Payment 
                                                  IDR </td>
                                                <td width="15%" class="tablehdr" height="24">Payment 
                                                  By PO Currency</td>
                                                <td width="25%" class="tablehdr" height="24">Description</td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" class="tablecell">INV-001</td>
                                                <td width="5%" class="tablecell"> 
                                                  <div align="center">IDR</div>
                                                </td>
                                                <td width="8%" class="tablecell"> 
                                                  <div align="right"> 6,000,000.-</div>
                                                </td>
                                                <td width="12%" class="tablecell"> 
                                                  <div align="right">
                                                    <input type="text" name="textfield63" value="1"   style="text-align:right" size="20">
                                                  </div>
                                                </td>
                                                <td width="8%" class="tablecell"> 
                                                  <div align="right"> 6,000,000.-</div>
                                                </td>
                                                <td width="18%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="textfield2" value="4,000,000.-" style="text-align:right">
                                                  </div>
                                                </td>
                                                <td width="15%" class="tablecell"> 
                                                  <input type="text" name="textfield22" value="4,000,000.-" style="text-align:right">
                                                </td>
                                                <td width="25%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="textfield7" size="35"  style="text-align:right">
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="9%" class="tablecell">INV-002</td>
                                                <td width="5%" class="tablecell"> 
                                                  <div align="center">USD</div>
                                                </td>
                                                <td width="8%" class="tablecell"> 
                                                  <div align="right">500.-</div>
                                                </td>
                                                <td width="12%" class="tablecell"> 
                                                  <div align="right">
                                                    <input type="text" name="textfield632" value="10000"   style="text-align:right" size="20">
                                                  </div>
                                                </td>
                                                <td width="8%" class="tablecell"> 
                                                  <div align="right"> 5,000,000,-</div>
                                                </td>
                                                <td width="18%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="textfield6" value="2,000,000.-"   style="text-align:right">
                                                  </div>
                                                </td>
                                                <td width="15%" class="tablecell"> 
                                                  <input type="text" name="textfield62" value="500"   style="text-align:right">
                                                </td>
                                                <td width="25%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="textfield8" size="35">
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="51%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="50%">&nbsp;</td>
                                                      <td width="50%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="50%"><b>Balance</b></td>
                                                      <td width="50%"> 
                                                        <div align="right"><b>Rp. 
                                                          6,000,000.-</b></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="50%"><b>Payment</b></td>
                                                      <td width="50%"> 
                                                        <div align="right"><b>Rp. 
                                                          6,000,000.-</b></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="50%"><b>Out Of 
                                                        Balance</b></td>
                                                      <td width="50%"> 
                                                        <div align="right"><b>Rp. 
                                                          0.-</b></div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="50%">&nbsp;</td>
                                                      <td width="50%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td width="8%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="15%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp; </td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="29%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="48%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="5"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="3%"><img src="../images/print.gif" width="53" height="22"></td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="3%"><img src="../images/post_journal.gif" width="92" height="22"></td>
                                                <td width="15%">&nbsp;</td>
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
