 
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td colspan="7">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="7"><b>Transaction &raquo; <span class="level1">PO</span> 
                                      &raquo; <span class="level2">PO Retur Search 
                                      for Incoming</span></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="24%">&nbsp;</td>
                                    <td width="35%"><font color="#FF0000">cari 
                                      incoming berdasarkan PO(incoming yang po 
                                      id nya ada)</font></td>
                                  </tr>
                                  <tr> 
                                    <td width="5%" nowrap>PO Number</td>
                                    <td width="15%" nowrap> 
                                      <input type="text" name="textfield">
                                    </td>
                                    <td width="4%" nowrap>Supplier</td>
                                    <td width="10%" nowrap> 
                                      <select name="select">
                                        <option selected>All</option>
                                        <option>Supplier 1</option>
                                        <option>Supplier 2</option>
                                      </select>
                                    </td>
                                    <td width="7%" nowrap>Incoming Date</td>
                                    <td width="24%" nowrap> 
                                      <input type="text" name="textfield2" size="20" value="1/11/2008">
                                      to 
                                      <input type="text" name="textfield22" size="20" value="11/11/2008">
                                    </td>
                                    <td width="35%" nowrap>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%" nowrap>DO Number</td>
                                    <td width="15%" nowrap> 
                                      <input type="text" name="textfield3">
                                    </td>
                                    <td width="4%" nowrap>Incoming Number</td>
                                    <td width="10%" nowrap> 
                                      <input type="text" name="textfield32">
                                    </td>
                                    <td width="7%" nowrap>&nbsp;</td>
                                    <td width="24%" nowrap><img src="../images/search.gif" width="59" height="21"> 
                                    </td>
                                    <td width="35%" nowrap>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="7" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="7" height="3" background="../images/line1.gif"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="7" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="7"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="9%" height="17">Date</td>
                                          <td class="tablehdr" width="10%" height="17">PO 
                                            Number</td>
                                          <td class="tablehdr" width="10%" height="17">DO 
                                            Number</td>
                                          <td class="tablehdr" width="14%" height="17">Incoming 
                                            Number </td>
                                          <td class="tablehdr" width="16%" height="17">Incoming 
                                            Date </td>
                                          <td class="tablehdr" width="12%" height="17">Supplier</td>
                                          <td class="tablehdr" width="18%" height="17">Address</td>
                                          <td class="tablehdr" width="11%" height="17">Status</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="9%">10 
                                            Jan 2008</td>
                                          <td class="tablecell1" width="10%">PO001</td>
                                          <td class="tablecell1" width="10%"><a href="poreturdetail-proto.jsp">DO001</a></td>
                                          <td class="tablecell1" width="14%">IN001</td>
                                          <td class="tablecell1" width="16%">&nbsp;</td>
                                          <td class="tablecell1" width="12%">&nbsp;</td>
                                          <td class="tablecell1" width="18%">&nbsp;</td>
                                          <td class="tablecell1" width="11%"> 
                                            <div align="center">CHECKED</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" width="9%">&nbsp;</td>
                                          <td class="tablecell" width="10%">&nbsp;</td>
                                          <td class="tablecell" width="10%"><a href="poreturdetail-proto.jsp">DO002</a></td>
                                          <td class="tablecell" width="14%">IN003</td>
                                          <td class="tablecell" width="16%">&nbsp;</td>
                                          <td class="tablecell" width="12%">&nbsp;</td>
                                          <td class="tablecell" width="18%">&nbsp;</td>
                                          <td class="tablecell" width="11%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" colspan="8" background="../images/line1.gif" height="3"></td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" width="9%">20 
                                            Jan 2008</td>
                                          <td class="tablecell" width="10%">PO002</td>
                                          <td class="tablecell" width="10%"><a href="poreturdetail-proto.jsp">PO003</a></td>
                                          <td class="tablecell" width="14%">IN002</td>
                                          <td class="tablecell" width="16%">&nbsp;</td>
                                          <td class="tablecell" width="12%">&nbsp;</td>
                                          <td class="tablecell" width="18%">&nbsp;</td>
                                          <td class="tablecell" width="11%"> 
                                            <div align="center">CHECKED</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" colspan="8" background="../images/line1.gif" height="3"></td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="9%">21 
                                            Jan 2008</td>
                                          <td class="tablecell1" width="10%">PO003</td>
                                          <td class="tablecell1" width="10%"><a href="poreturdetail-proto.jsp">PO004</a></td>
                                          <td class="tablecell1" width="14%">IN003</td>
                                          <td class="tablecell1" width="16%">&nbsp;</td>
                                          <td class="tablecell1" width="12%">&nbsp;</td>
                                          <td class="tablecell1" width="18%">&nbsp;</td>
                                          <td class="tablecell1" width="11%"> 
                                            <div align="center">CHECKED</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell" colspan="8" background="../images/line1.gif" height="3"></td>
                                        </tr>
                                        <tr> 
                                          <td width="9%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="14%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="24%">&nbsp;</td>
                                    <td width="35%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="6"><font color="#FF0000">retur 
                                      dilakukan pe DO/Incoming yang terjadi, satu 
                                      PO bisa beberapa Incoming !!</font> </td>
                                    <td width="35%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="24%">&nbsp;</td>
                                    <td width="35%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="10%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="24%">&nbsp;</td>
                                    <td width="35%">&nbsp;</td>
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
                          </table>
                        </form>
                        <span class="level2"><br>
                        </span><!-- #EndEditable -->
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
