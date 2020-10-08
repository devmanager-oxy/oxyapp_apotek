 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");

Vector rptDetails = DbRptFormatDetail.list(0,0, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID]+"="+oidRptFormat,DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]); 

out.println(rptDetails);

/*** LANG ***/
String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
					"Description", "Total"}; //5-6
String[] langNav = {"Financial Report", "Balance Sheet"};

if(lang == LANG_ID) {
	String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
						"Keterangan", "Total"}; //5-6
	langFR = langID;
	
	String[] navID = {"Laporan Keuangan", "Naraca"};
	langNav = navID;
}
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+langNav[1]+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="frmneraca" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="rpt_format_id" value="<%=oidRptFormat%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%" nowrap><b>Select Report&nbsp;&nbsp;</b></td>
                                    <td width="92%">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="92%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
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