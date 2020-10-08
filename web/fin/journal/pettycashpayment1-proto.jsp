 
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

	function cmdOpenIt(){
		window.open("pettycashpredefined.jsp");
	}

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
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">Date : 18-11-2007, Operator : Admin</td>
                            </tr>
                            <tr> 
                              <td colspan="4"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="10%">Payment from Account</td>
                                    <td width="3%">&nbsp;</td>
                                    <td width="29%"> 
                                      <select name="select">
                                        <option selected>1-1001 Petty Cash Labuan 
                                        Bajo</option>
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
                                    <td width="10%">&nbsp;</td>
                                    <td width="3%">&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>Transaction Date</td>
                                    <td> 
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
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="1%">&nbsp;</td>
                                                      <td width="100" bgcolor="#C0D6C0"> 
                                                        <div align="center"><a href="pettycashpayment-proto.jsp?menu_idx=1">Expense</a></div>
                                                      </td>
                                                      <td width="100"   class="tablehdr" > 
                                                        <div align="center">Activity</div>
                                                      </td>
                                                      <td width="74%">&nbsp;&nbsp;[ 
                                                        <a href="javascript:cmdOpenIt()">Predefined 
                                                        Activity </a> ] </td>
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
                                                <td width="30%" class="tablecell"><a href="#"> 
                                                  Establish JV (PNK)<br>
                                                  </a></td>
                                                <td width="14%" class="tablecell">IFC</td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="right">Rp. 300,000.-</div>
                                                </td>
                                                <td width="41%" class="tablecell">Beli 
                                                  ....</td>
                                              </tr>
                                              <tr> 
                                                <td width="5%" class="tablecell">1.1.0.1.0</td>
                                                <td width="30%" class="tablecell"><a href="#"> 
                                                  Establish JV (PNK)</a></td>
                                                <td width="14%" class="tablecell">Donor-1</td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="right">Rp. 200.000,-</div>
                                                </td>
                                                <td width="41%" class="tablecell">Beli 
                                                  ...</td>
                                              </tr>
                                              <tr>
                                                <td width="5%" class="tablecell"> 
                                                  <input type="text" name="textfield2" size="15">
                                                </td>
                                                <td width="30%" class="tablecell">
                                                  <select name="select2">
                                                    <option>Establish JV </option>
                                                    <option>Revuew job desc ...</option>
                                                  </select>
                                                </td>
                                                <td width="14%" class="tablecell">
                                                  <select name="select3">
                                                    <option selected>IFC</option>
                                                    <option>TNC</option>
                                                  </select>
                                                </td>
                                                <td width="10%" class="tablecell">
                                                  <input type="text" name="textfield4">
                                                </td>
                                                <td width="41%" class="tablecell">
                                                  <input type="text" name="textfield6">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="5%" class="tablecell">2.1.1.1.0<br>
                                                </td>
                                                <td width="30%" class="tablecell"><a href="#" title="Review job descriptions to meet the actual positions needed in the site (BTNK-PNK Team)">Review 
                                                  job descriptions to meet the 
                                                  actual positions ...</a><br>
                                                </td>
                                                <td width="14%" class="tablecell">IFC</td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="right">Rp. 100.000,-</div>
                                                </td>
                                                <td width="41%" class="tablecell">Beli 
                                                  ...</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2">&nbsp; </td>
                                                <td width="14%" bgcolor="#CCCCCC"> 
                                                  <div align="right"><b>TOTAL</b></div>
                                                </td>
                                                <td width="10%" bgcolor="#CCCCCC"> 
                                                  <div align="right"><b>Rp. 600,000.-</b></div>
                                                </td>
                                                <td width="41%">&nbsp;</td>
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
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">1. predefined activity mengeluarkan 
                                open window, yang berisi semua default setup dari 
                                expense account yang di link ke activity, tidak 
                                harus semua yang ada pada list activity tersebut 
                                dialokasikan ke expense. tapi bisa diupdate persentase. 
                                apabila persentase diupdate, otomatis akan mengupdate 
                                persentase di master link</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                              <td width="33%">&nbsp;</td>
                              <td width="19%">&nbsp;</td>
                            </tr>
                          </table></td>
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
