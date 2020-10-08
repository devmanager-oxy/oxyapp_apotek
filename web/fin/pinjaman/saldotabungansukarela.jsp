 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksp.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->

<%
Vector result = DbTabunganSukarela.getSaldoTabungan();
session.putValue("SALDO_TABUNGAN_ANGGOTA", result);
%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdPrintIt(){	
	window.open("<%=printrootsp%>.report.RptSaldoSukarelaXLS?idx=<%=System.currentTimeMillis()%>");
}

function cmdAdd(){
	document.frmtabungansukarela.hidden_tabungan_sukarela_id.value="0";
	document.frmtabungansukarela.command.value="<%=JSPCommand.ADD%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}



function cmdListLast(){
	document.frmtabungansukarela.command.value="<%=JSPCommand.LAST%>";
	document.frmtabungansukarela.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmtabungansukarela.action="tabungansukarela.jsp";
	document.frmtabungansukarela.submit();
}

//-------------- script control line -------------------
	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

function MM_preloadImages() { //v3.0
		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

function MM_findObj(n, d) { //v4.0
		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

</script>
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif','<%=approot%>/images/ctr_line/BtnNewOn.jpg')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Saldo Simpanan Sukarela<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmtabungansukarela" method ="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="vectSize" value="">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="start" value="">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="26" valign="middle" colspan="3" class="comment"> 
                                      <b>Saldo Tabungan Sukarela</b></td>
                                  </tr>
                                  <tr align="left" valign="top">
                                    <td height="22" valign="middle" colspan="3">
                                      <table width="60%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="5%">No</td>
                                          <td class="tablehdr" width="17%">NIK</td>
                                          <td class="tablehdr" width="49%">Nama</td>
                                          <td class="tablehdr" width="29%">Saldo</td>
                                        </tr>
                                        <%
										
										double total = 0;
										
										if(result!=null && result.size()>0){
										for(int i=0; i<result.size(); i++){
											Vector temp = (Vector)result.get(i);
											Member member = (Member)temp.get(0);
											TabunganSukarela tb = (TabunganSukarela)temp.get(1);
											
											total = total + tb.getSaldo();
											
											if(i%2==0){
										%>
                                        <tr> 
                                          <td class="tablecell" width="5%"> 
                                            <div align="right"><%=i+1%></div>
                                          </td>
                                          <td class="tablecell" width="17%"> 
                                            <div align="center"><%=member.getNoMember()%></div>
                                          </td>
                                          <td class="tablecell" width="49%"><%=member.getNama()%></td>
                                          <td class="tablecell" width="29%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getSaldo(), "#,###")%></div>
                                          </td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td class="tablecell1" width="5%"> 
                                            <div align="right"><%=i+1%></div>
                                          </td>
                                          <td class="tablecell1" width="17%"> 
                                            <div align="center"><%=member.getNoMember()%></div>
                                          </td>
                                          <td class="tablecell1" width="49%"><%=member.getNama()%></td>
                                          <td class="tablecell1" width="29%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(tb.getSaldo(), "#,###")%></div>
                                          </td>
                                        </tr>
                                        <%}}}%>
                                        <tr> 
                                          <td width="5%" height="40">&nbsp;</td>
                                          <td width="17%" height="40">&nbsp;</td>
                                          <td width="49%" height="40"> 
                                            <div align="center"><b>T O T A L : 
                                              </b></div>
                                          </td>
                                          <td width="29%" height="40"> 
                                            <div align="right"><b><%=JSPFormater.formatNumber(total, "#,###")%></b></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                 
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="3" class="command"> 
                                      <span class="command"><a href="javascript:cmdPrintIt()"><img src="../images/print.gif" width="53" height="22" border="0"></a> 
                                      </span> </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container">&nbsp; 
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
