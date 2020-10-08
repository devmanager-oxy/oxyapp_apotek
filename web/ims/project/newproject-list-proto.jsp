 
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
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Project</span> 
                        &raquo; <span class="level2">Project Preview<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td>&nbsp; </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <tr > 
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                    <td class="tab" nowrap>Project Detail</td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
									<td class="tabin" nowrap> <b><a href="newproductdetail-proto.jsp" class="tablink">Product 
                                      Detail </a></b></td>
                                    <td nowrap class="tabheader"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                    <td class="tabin" nowrap> <b><a href="newpaymenterm-proto.jsp" class="tablink">Payment 
                                      Term</a></b></td>
                                    <td nowrap class="tabheader"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
									<td class="tabin" nowrap> <b><a href="newpaymenterm-proto.jsp" class="tablink">Order 
                                      Confirmation </a></b></td>
                                    <td nowrap class="tabheader"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
									<td class="tabin" nowrap> <b><a href="newpaymenterm-proto.jsp" class="tablink">Installation</a></b></td>
                                    <td nowrap class="tabheader"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
									<td class="tabin" nowrap> <b><a href="newpaymenterm-proto.jsp" class="tablink">Closing</a></b></td>
                                    <td nowrap class="tabheader"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                    <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                      </font></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td class="page">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Product Group</td>
                                          <td width="22%"> 
                                            <select name="select3">
                                              <option selected>Pemasangan Septic 
                                              Tank</option>
                                              <option>Pemasangan Septic Tank Type 
                                              2</option>
                                              <option>...</option>
                                            </select>
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Date</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield">
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Project Number</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield2" size="30">
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td height="14" width="10%">Project 
                                            Name</td>
                                          <td height="14" width="22%"> 
                                            <input type="text" name="textfield23" size="30">
                                          </td>
                                          <td height="14" width="8%">&nbsp;</td>
                                          <td height="14" width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td height="14" width="10%">Customer</td>
                                          <td height="14" width="22%"> 
                                            <select name="select">
                                              <option selected>PT. Maju Mundur</option>
                                              <option>Mr. Nora</option>
                                              <option>Mr. Sadino Dino</option>
                                            </select>
                                            <input type="submit" name="Submit" value="New">
                                          </td>
                                          <td height="14" width="8%">Company PIC</td>
                                          <td height="14" width="60%"> 
                                            <select name="select2">
                                              <option selected>N001 / Suparman</option>
                                              <option>N002 / Sudino Salim</option>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Address</td>
                                          <td width="22%"> 
                                            <textarea name="textfield4" cols="30" rows="2"></textarea>
                                          </td>
                                          <td width="8%">Phone/Hp</td>
                                          <td width="60%"> 
                                            <input type="text" name="textfield2324" size="30">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">PIC</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield2322" size="30">
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Position</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield232" size="30">
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Phone/Hp</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield2323" size="30">
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Start Date</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield44">
                                          </td>
                                          <td width="8%">End Date</td>
                                          <td width="60%"> 
                                            <input type="text" name="textfield442">
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Project Currency</td>
                                          <td width="22%"> 
                                            <select name="select4">
                                              <option selected>IDR</option>
                                              <option>USD</option>
                                              <option>EUR</option>
                                            </select>
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Total Amount</td>
                                          <td width="22%"> 
                                            <input type="text" name="textfield4422" size="30">
                                          </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"><b><i>Project Description</i></b></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <textarea name="textfield4432" cols="130" rows="6"></textarea>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="14%"> 
                                                  <input type="submit" name="Submit2" value="Approve This Document">
                                                </td>
                                                <td width="5%">&nbsp;</td>
                                                <td width="45%"><img src="../images/back.gif" width="51" height="22"></td>
                                                <td width="18%">&nbsp;</td>
                                                <td width="18%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"><b></b></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp; </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </form>
                        <!-- #EndEditable --> </td>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
