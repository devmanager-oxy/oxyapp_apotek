 
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                      <!--DWLayoutTable-->
                                      <tr> 
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                              <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                                            </tr>
                                            <tr> 
                                              <td valign="top"> 
                                                <form id="form1" name="form1" method="post" action="">
                                                  <input type="hidden" name="command">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td class="container" valign="top"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td>s</td>
                                                          </tr>
                                                          <tr> 
                                                            <td valign="top"> 
                                                              <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                <tr> 
                                                                  <td rowspan="2" class="tablehdr" height="45" width="242"> 
                                                                    <div align="center"><b><font color="#FFFFFF">Expense</font></b></div>
                                                                  </td>
                                                                  <td rowspan="2" class="tablehdr" height="45" width="155">Amount 
                                                                    IDR</td>
                                                                  <td colspan="16" class="tablehdr" height="22">%</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="154" class="tablehdr" height="22">F&amp;A</td>
                                                                  <td width="154" class="tablehdr" height="22">Logistic</td>
                                                                  <td width="154" class="tablehdr" height="22">COL1</td>
                                                                  <td width="154" class="tablehdr" height="22">COL2</td>
                                                                  <td width="154" class="tablehdr" height="22">CONS1</td>
                                                                  <td width="154" class="tablehdr" height="22">CONS2</td>
                                                                  <td width="154" class="tablehdr" height="22">CONS3</td>
                                                                  <td width="154" class="tablehdr" height="22">CONS4</td>
                                                                  <td width="154" class="tablehdr" height="22">CONS5</td>
                                                                  <td width="154" class="tablehdr" height="22">TM1</td>
                                                                  <td width="154" class="tablehdr" height="22">TM2</td>
                                                                  <td width="154" class="tablehdr" height="22">CD1</td>
                                                                  <td width="154" class="tablehdr" height="22">CD2</td>
                                                                  <td width="154" class="tablehdr" height="22">CD3</td>
                                                                  <td width="154" class="tablehdr" height="22">ME1</td>
                                                                  <td width="154" class="tablehdr" height="22">ME2</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="242" class="tablecell" nowrap height="17">51001 
                                                                    - Advertising 
                                                                    Media & Journal</td>
                                                                  <td width="155" class="tablecell" nowrap height="17"> 
                                                                    <div align="right">1,000,000.-</div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" nowrap height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="fa_504404353099418270" size="3" maxlength="3" style="text-align:center" value="15" onClick="this.select()" onChange="javascript:cmdUpdateData('504404353099418270', '0')" class="readonly" readOnly>
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="log_504404353099418270" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()" onChange="javascript:cmdUpdateData('504404353099418270', '0')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="COL1_504404353099418270" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567599411')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="COL2_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600052')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS1_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600130')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS2_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600161')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS3_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600208')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS4_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600286')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS5_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600380')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="TM1_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600552')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="TM2_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600598')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CD1_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600661')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CD2_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600708')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CD3_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600739')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="ME1_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600817')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="ME2_504404353099418270" size="3" maxlength="3" style="text-align:center" value="5" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099418270', '504404359567600864')">
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="242" class="tablecell1" nowrap height="17"> 
                                                                    <div align="right">IFC</div>
                                                                  </td>
                                                                  <td width="155" class="tablecell1" nowrap height="17"> 
                                                                    <div align="right"> 
                                                                      <input type="text" name="textfield">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" nowrap height="17"> 
                                                                    <input type="text" name="textfield3">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield5">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield7">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield9">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield11">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield13">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield15">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield17">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield19">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield21">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield22">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield23">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield24">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield25">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield26">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield27">
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="242" class="tablecell1" nowrap height="17"> 
                                                                    <div align="right">TNC</div>
                                                                  </td>
                                                                  <td width="155" class="tablecell1" nowrap height="17"> 
                                                                    <div align="right"> 
                                                                      <input type="text" name="textfield2">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" nowrap height="17"> 
                                                                    <input type="text" name="textfield4">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield6">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield8">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield10">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield12">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield14">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield16">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield18">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <input type="text" name="textfield20">
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                  <td width="154" class="tablecell1" height="17">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="242" class="tablecell1" nowrap height="17">51002 
                                                                    - Brochures/Reprint/Leaflet/Banner/Printing</td>
                                                                  <td width="155" class="tablecell1" nowrap height="17"> 
                                                                    <div align="right"></div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" nowrap height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="fa_504404353099319708" size="3" maxlength="3" style="text-align:center" value="" onClick="this.select()" onChange="javascript:cmdUpdateData('504404353099319708', '0')" class="readonly" readOnly>
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="log_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()" onChange="javascript:cmdUpdateData('504404353099319708', '0')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="COL1_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567599411')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="COL2_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600052')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS1_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600130')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS2_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600161')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS3_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600208')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS4_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600286')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CONS5_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600380')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="TM1_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600552')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="TM2_504404353099319708" size="3" maxlength="3" style="text-align:center" value="10" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600598')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CD1_504404353099319708" size="3" maxlength="3" style="text-align:center" value="" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600661')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CD2_504404353099319708" size="3" maxlength="3" style="text-align:center" value="" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600708')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="CD3_504404353099319708" size="3" maxlength="3" style="text-align:center" value="" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600739')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="ME1_504404353099319708" size="3" maxlength="3" style="text-align:center" value="" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600817')">
                                                                    </div>
                                                                  </td>
                                                                  <td width="154" class="tablecell1" height="17"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="ME2_504404353099319708" size="3" maxlength="3" style="text-align:center" value="" onClick="this.select()"  onChange="javascript:cmdUpdateData('504404353099319708', '504404359567600864')">
                                                                    </div>
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
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
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
                                  <td height="25">&nbsp; </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
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
