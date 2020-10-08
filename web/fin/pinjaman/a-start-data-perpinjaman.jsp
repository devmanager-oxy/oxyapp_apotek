 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.coorp.member.*" %>

<%@ page import = "com.project.fms.report.*" %>

<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/checksp.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long pinjamanId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Number","8%");
		ctrlist.addHeader("Date","8%");
		ctrlist.addHeader("Note","8%");
		ctrlist.addHeader("Total Pinjaman","8%");
		ctrlist.addHeader("Bunga","8%");
		ctrlist.addHeader("Status","8%");
		ctrlist.addHeader("User Id","8%");
		ctrlist.addHeader("Biaya Administrasi","8%");
		ctrlist.addHeader("Jenis Barang","8%");
		ctrlist.addHeader("Detail Jenis Barang","8%");
		ctrlist.addHeader("Bank Id","8%");
		ctrlist.addHeader("Lama Cicilan","8%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Pinjaman pinjaman = (Pinjaman)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(pinjamanId == pinjaman.getOID())
				 index = i;

			rowx.add(pinjaman.getNumber());

			String str_dt_Date = ""; 
			try{
				Date dt_Date = pinjaman.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(pinjaman.getNote());

			rowx.add(String.valueOf(pinjaman.getTotalPinjaman()));

			rowx.add(String.valueOf(pinjaman.getBunga()));

			rowx.add(String.valueOf(pinjaman.getStatus()));

			rowx.add(String.valueOf(pinjaman.getUserId()));

			rowx.add(String.valueOf(pinjaman.getBiayaAdministrasi()));

			rowx.add(String.valueOf(pinjaman.getJenisBarang()));

			rowx.add(pinjaman.getDetailJenisBarang());

			rowx.add(String.valueOf(pinjaman.getBankId()));

			rowx.add(String.valueOf(pinjaman.getLamaCicilan()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(pinjaman.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPinjaman = JSPRequestValue.requestLong(request, "pinjaman_id");
long oidPinjamanDetail = JSPRequestValue.requestLong(request, "hidden_pinjaman_detail_id");

Pinjaman pinjaman = new Pinjaman();

if(oidPinjaman!=0 && iJSPCommand==JSPCommand.START){
	try{
		Pinjaman pinjamanx = DbPinjaman.fetchExc(oidPinjaman);
		DbPinjamanDetail.setupDetailPinjaman(pinjamanx);
		out.println("<br>processing pinjaman :"+pinjamanx.getOID());
	}
	catch(Exception e){
	}
}



%>
<html ><!-- #BeginTemplate "/Templates/indexsp.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript"> 

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptPinjamanAnggotaXLS?idx=<%=System.currentTimeMillis()%>");
}

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx)){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function checkNumber(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber1(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = result;//formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function cmdStartIt(){
	document.frmpinjaman.command.value="<%=JSPCommand.START%>";
	document.frmpinjaman.action="a-start-data-perpinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdUpdateTanggal(oid){
	document.frmpinjaman.pinjaman_id.value="0";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oid;
	document.frmpinjaman.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdUpdateJT(){
	document.frmpinjaman.pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.command.value="<%=JSPCommand.POST%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}



function cmdBayar(oidpd){
	document.frmpinjaman.hidden_bayar_type.value="0";
	document.frmpinjaman.pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidpd;
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="bayarpinjaman.jsp";
	document.frmpinjaman.submit();
}


function cmdBayarDetail(oidpd){
	document.frmpinjaman.hidden_bayar_type.value="0";
	document.frmpinjaman.pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidpd;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="bayarpinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdPelunasanDetail(oidpd){
	document.frmpinjaman.hidden_bayar_type.value="0";
	document.frmpinjaman.pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidpd;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pelunasan.jsp";
	document.frmpinjaman.submit();
}

function cmdPelunasan(oidp){
	document.frmpinjaman.hidden_bayar_type.value="1";
	document.frmpinjaman.pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidp;
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pelunasan.jsp";
	document.frmpinjaman.submit();
}

function cmdAdd(){
	document.frmpinjaman.pinjaman_id.value="0";
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdAsk(oidPinjaman){
	document.frmpinjaman.pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.ASK%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdConfirmDelete(oidPinjaman){
	document.frmpinjaman.pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.DELETE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}
function cmdSave(){
	document.frmpinjaman.command.value="<%=JSPCommand.SAVE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdEdit(oidPinjaman){
	document.frmpinjaman.pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdCancel(oidPinjaman){
	document.frmpinjaman.pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdBack(){
	document.frmpinjaman.command.value="<%=JSPCommand.BACK%>";
	//document.frmpinjaman.action="<%=approot%>/home.jsp?menu_idx=0";
	document.frmpinjaman.action="arsippinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdListFirst(){
	document.frmpinjaman.command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdListPrev(){
	document.frmpinjaman.command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdListNext(){
	document.frmpinjaman.command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdListLast(){
	document.frmpinjaman.command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function getMember(){
	window.open("scrmember.jsp","srcmember","scrollbars=yes,height=400,width=800,addressbar=no,menubar=no,toolbar=no,location=no,");
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusp.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/imagessp/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusp.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Pinjaman Koperasi 
                        <%if(pinjaman.getOID()==0){%>
                        Baru
                        <%}%>
                        <br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpinjaman" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3">pinjaman ID 
                                <input type="text" name="pinjaman_id">
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container">
                                <input type="button" name="Button" value="Start" onClick="javascript:cmdStartIt()">
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
            <%@ include file="../main/footersp.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
