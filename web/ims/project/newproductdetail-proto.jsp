 
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
                        &raquo; <span class="level2">New Project<br>
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
                                    <td class="tabin" nowrap><a href="newproject-proto.jsp" class="tablink">Project 
                                      Detail</a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
                                    <td class="tab" nowrap> <b>Product Detail</b></td>
                                    <td nowrap class="tabheader"></td>
									<td class="tabin" nowrap><a href="newproject-proto.jsp" class="tablink">Payment 
                                      Term </a></td>
                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                    </td>
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
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp; </td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%"><b>Project Number</b></td>
                                          <td width="22%"> PNC/PPJ/0908001</td>
                                          <td width="8%"><b>Date</b></td>
                                          <td width="60%">25 September 2008</td>
                                        </tr>
                                        <tr> 
                                          <td height="14" width="10%"><b>Project 
                                            Name</b></td>
                                          <td height="14" width="22%"> Pemasangan 
                                            Septic Tank</td>
                                          <td height="14" width="8%"><b>Customer</b></td>
                                          <td width="60%">PT. Maju Mundur</td>
                                        </tr>
                                        <tr> 
                                          <td height="14" width="10%"><b>Amount</b></td>
                                          <td height="14" width="22%">IDR. 200.000.000,-</td>
                                          <td height="14" width="8%">&nbsp;</td>
                                          <td height="14" width="60%">Jln. Gunung 
                                            Agung 20a, Denpasar</td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="8%">&nbsp;</td>
                                          <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"><b>Product Detail</b></td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="80%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="4%" class="tablehdr">No.</td>
                                                <td width="47%" class="tablehdr">Item 
                                                  Description</td>
                                                <td width="14%" class="tablehdr"><b>Product 
                                                  Group</b></td>
                                                <td width="17%" class="tablehdr">Status</td>
                                                <td width="18%" class="tablehdr">Amount 
                                                  IDR </td>
                                              </tr>
                                              <tr> 
                                                <td width="4%" class="tablecell" height="37"> 
                                                  <div align="center">1</div>
                                                </td>
                                                <td width="47%" class="tablecell" height="37">Item 
                                                  Bio Save 01</td>
                                                <td width="14%" class="tablecell" height="37"> 
                                                  <div align="center">Bio Save 
                                                    01 </div>
                                                </td>
                                                <td width="17%" class="tablecell" height="37"> 
                                                  <div align="center">Deliverd</div>
                                                </td>
                                                <td width="18%" class="tablecell" height="37"> 
                                                  <div align="right">100.000.000,-</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="4%" class="tablecell1" height="32"> 
                                                  <div align="center">2</div>
                                                </td>
                                                <td width="47%" class="tablecell1" height="32">Item 
                                                  Bio Save 02</td>
                                                <td width="14%" class="tablecell1" height="32"> 
                                                  <div align="center">Bio Save 
                                                    02 </div>
                                                </td>
                                                <td width="17%" class="tablecell1" height="32"> 
                                                  <div align="center">Ready To 
                                                    Deliverd </div>
                                                </td>
                                                <td width="18%" class="tablecell1" height="32"> 
                                                  <div align="right">40.000.000,-</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="4%" class="tablecell" height="35"> 
                                                  <div align="center">3</div>
                                                </td>
                                                <td width="47%" class="tablecell" height="35">Item 
                                                  Bio Save 03</td>
                                                <td width="14%" class="tablecell" height="35"> 
                                                  <div align="center">Bio Save 
                                                    03 </div>
                                                </td>
                                                <td width="17%" class="tablecell" height="35"> 
                                                  <div align="center">Manufacturing</div>
                                                </td>
                                                <td width="18%" class="tablecell" height="35"> 
                                                  <div align="right">40.000.000,-</div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="4%" class="tablecell1" height="28"> 
                                                  <div align="center">4</div>
                                                </td>
                                                <td width="47%" class="tablecell1" height="28"> 
                                                  <textarea name="textfield" cols="50" rows="2">Pembayaran sebesar 10% pada saat installasi dilakukan</textarea>
                                                </td>
                                                <td width="14%" class="tablecell1" height="28"> 
                                                  <div align="center"> 
                                                    <select name="select2">
                                                      <option>Bio Save 01</option>
                                                      <option>Bio Save 02</option>
                                                      <option>Bio Save 03</option>
                                                      <option selected>Service</option>
                                                    </select>
                                                  </div>
                                                </td>
                                                <td width="17%" class="tablecell1" height="28"> 
                                                  <div align="center">
                                                    <select name="select">
                                                      <option selected>Manufacturing</option>
                                                      <option>Ready to Deliver</option>
                                                      <option>Delivered</option>
                                                    </select>
                                                  </div>
                                                </td>
                                                <td width="18%" class="tablecell1" height="28"> 
                                                  <div align="right"> 
                                                    <input type="text" name="textfield22" value="20.000.000,-" style="text-align:right">
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="4%" class="tablecell" height="22"> 
                                                  <div align="center"></div>
                                                </td>
                                                <td width="47%" class="tablecell" height="22">&nbsp;</td>
                                                <td width="14%" class="tablecell" height="22">&nbsp;</td>
                                                <td width="17%" class="tablecell" height="22"> 
                                                  <div align="center"><b>Total 
                                                    : </b></div>
                                                </td>
                                                <td width="18%" class="tablecell" height="22"> 
                                                  <div align="right"><b>200.000.000,-</b></div>
                                                </td>
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
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="6%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                                <td width="47%">&nbsp;</td>
                                                <td width="20%">&nbsp;</td>
                                                <td width="20%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="6%"><img src="../images/save.gif" width="55" height="22"></td>
                                                <td width="7%"><img src="../images/delete.gif" width="60" height="22"></td>
                                                <td width="47%"><img src="../images/back.gif" width="51" height="22"></td>
                                                <td width="20%">&nbsp;</td>
                                                <td width="20%">&nbsp;</td>
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
