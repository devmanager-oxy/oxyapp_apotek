 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checkmm.jsp"%>
<%
//jsp content


%>
<html >
<!-- #BeginTemplate "/Templates/indexmm.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=spTitle%></title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.imagessp){ if(!d.MM_p) d.MM_p=new Array();
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenumm.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menumm.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Simpan 
                        Pinjam</span><span class="level1"></span> &raquo; <span class="level2">SHU 
                        Anggota <br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="container">
                                <table width="50%" border="0" cellspacing="1" cellpadding="1">
                                  <tr>
                                    <td width="18%">&nbsp;</td>
                                    <td width="82%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="18%"><b>NIK</b></td>
                                    <td width="82%">: <%=loginMember.getNoMember()%></td>
                                  </tr>
                                  <tr> 
                                    <td width="18%"><b>Anggota</b></td>
                                    <td width="82%">: <%=loginMember.getNama()%></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="50%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="42%">&nbsp;</td>
                                    <td width="58%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" class="tablehdr">Bulan</td>
                                    <td width="58%" class="tablehdr">SHU</td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell">Januari 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuJan(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell1">Februari 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell1"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuFeb(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell">Maret 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuMar(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell1">April 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell1"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuApr(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell">Mei 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuMay(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell1">Juni 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell1"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuJun(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell">Juli 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuJul(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell1">Agustus 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell1"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuAug(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell">September 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuSep(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell1">Oktober 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell1"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuOct(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell">November 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuNov(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%" height="20" class="tablecell1">Desember 
                                      2009</td>
                                    <td width="58%" height="20" class="tablecell1"> 
                                      <div align="right"><%=JSPFormater.formatNumber(loginMember.getShuDec(), "#,###")%></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2" height="10"> </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%"><b>T O T A L </b></td>
                                    <td width="58%"> 
                                      <div align="right"><b><%=JSPFormater.formatNumber(loginMember.getShuJan()+loginMember.getShuFeb()+loginMember.getShuMar()+loginMember.getShuApr()+loginMember.getShuMay()+loginMember.getShuJun()+loginMember.getShuJul()+loginMember.getShuAug()+loginMember.getShuSep()+loginMember.getShuOct()+loginMember.getShuNov()+loginMember.getShuDec(), "#,###")%></b></div>
                                    </td>
                                  </tr>
                                  <tr bgcolor="#999999"> 
                                    <td colspan="2" height="2"> </td>
                                  </tr>
                                  <tr> 
                                    <td width="42%">&nbsp;</td>
                                    <td width="58%"> 
                                      <div align="right"></div>
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
            <%@ include file="../main/footermm.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
