 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean closingPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_YEARLY);
boolean closingPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_YEARLY, AppMenu.PRIV_VIEW);
boolean closingPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_YEARLY, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%
int cmdx = JSPRequestValue.requestInt(request, "cmd");
int iJSPCommand = JSPRequestValue.requestCommand(request);
int prevJSPCommand = 0;

Periode per13 = DbPeriode.getOpenPeriod13();

boolean ok = false;
if(iJSPCommand==JSPCommand.SUBMIT){	
	ok = DbPeriode.closePeriod13(per13);
}

//out.println(ok);
	
/*** LANG ***/
String[] langMD = {"Name", "Start Date", "End Date", "Input Tolerance", "Status", "required", 
				   "Period 13 successfully closed.\nAll correction journals in period 13, has been copied into current open period as journals correction.", 
				   "Closing process failed, please contact your system administrator for detail error"}; //0-5
String[] langNav = {"Close Period 13", "Close Period 13", "Yearly Closing"};
if(lang == LANG_ID) {
	String[] langID = {"Nama", "Tanggal Mulai", "Tanggal Berakhir", "Batas Akhir Memasukkan Data", "Status", "harus diisi"};
	langMD = langID;
	String[] navID = {"Tutup Periode 13", "Tutup Periode 13", "Tutup Tahunan", 
					"Periode 13 sudah ditutup.\nSemua koreksi yang terjadi di periode 13, sudah dipindahkan ke periode terakhir sebagai jurnal koreksi.",
					"Proses gagal, silahkan hubungi administrator untuk detail error"};
	langNav = navID;
}
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!closingPriv || !closingPrivView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdAdd(){
	document.frmperiode.hidden_periode_id.value="0";
	document.frmperiode.command.value="<%=JSPCommand.ADD%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}

function cmdAsk(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.ASK%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}

function cmdConfirmDelete(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.DELETE%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}
function cmdSave(){
	document.frmperiode.command.value="<%=JSPCommand.SAVE%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
	}

function cmdEdit(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
	}

function cmdCancel(oidPeriode){
	document.frmperiode.hidden_periode_id.value=oidPeriode;
	document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
	document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}

function cmdBack(){
	document.frmperiode.command.value="<%=JSPCommand.BACK%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
	}

function cmdListFirst(){
	document.frmperiode.command.value="<%=JSPCommand.FIRST%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}

function cmdListPrev(){
	document.frmperiode.command.value="<%=JSPCommand.PREV%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
	}

function cmdListNext(){
	document.frmperiode.command.value="<%=JSPCommand.NEXT%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}

function cmdListLast(){
	document.frmperiode.command.value="<%=JSPCommand.LAST%>";
	document.frmperiode.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmperiode.action="periode13.jsp";
	document.frmperiode.submit();
}

function cmdClose(){
	if(confirm('Are you sure to do this action ?\nthis action is unrecoverable, all transaction in this period will be locked for update')){
		document.frmperiode.action = "periode13.jsp";
		document.frmperiode.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmperiode.submit();
		//alert('sorry, close period is under construction ...');
	}
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
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/closeperiode2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">"+langNav[0]+"</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">"+((!isYearlyClose) ? langNav[1] : langNav[2])+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmperiode" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top">
                                    <td height="8"  colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"><b>PERIODE : <%=per13.getName()%></b></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <%if(closingPrivUpdate && iJSPCommand!=JSPCommand.SUBMIT){%>
                                      <a href="javascript:cmdClose()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/closeperiode2.gif',1)"><img src="../images/closeperiode.gif" name="new211" border="0"></a> 
                                      <%}
									  else if(ok){%>
                                      <font color="#009900"><%=langNav[3]%> </font>
<%}
									  else{%>
                                      <font color="#FF0000"><%=langNav[4]%></font>
<%}%>
                                    </td>
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
