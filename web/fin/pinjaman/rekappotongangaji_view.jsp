 
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

<%

	if(session.getValue("KONSTAN")!=null){
		session.removeValue("KONSTAN");
	}
	
	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}
	
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidRekapMain = JSPRequestValue.requestLong(request, "hidden_rekap_main_id");
long periodId = JSPRequestValue.requestLong(request, "hidden_periode_id");
long dinasId = JSPRequestValue.requestLong(request, "hidden_dinas_id");;
long unitId = JSPRequestValue.requestLong(request, "hidden_unit_id");


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

//rekap main ----------

RekapMain rekapMain = new RekapMain();
/*try{
	rekapMain = DbRekapMain.fetchExc(oidRekapMain);
}
catch(Exception e){
}
*/

Vector vrm = DbRekapMain.list(0,0, "periode_rekap_id="+periodId+" and dinas_id="+dinasId+" and dinas_unit_id="+unitId, "");
if(vrm!=null && vrm.size()>0){
	rekapMain= (RekapMain)vrm.get(0);
	oidRekapMain = rekapMain.getOID();
}
else{
	oidRekapMain = 0;	
}


Vector periodRekaps = DbPeriodeRekap.list(0,0, "", "start_date desc");

Vector temp = DbDinasUnit.list(0,0,"", "dinas_id, nama");
//unitId =  rekapMain.getDinasUnitId();

//dinasId = rekapMain.getDinasId();

//object for get value
RptPotonganGaji rptKonstan = new RptPotonganGaji();
Vector vTemp = new Vector();


PeriodeRekap prekap = new PeriodeRekap();
try{
	prekap = DbPeriodeRekap.fetchExc(periodId);
}
catch(Exception e){
}

//---------------------

Vector members = DbRekapPotonganGaji.list(0,0, "rekap_main_id="+oidRekapMain, "");

//out.println("members : "+members);
//out.println("rekapMain.getStatus() : "+rekapMain.getStatus());

%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">

<%if(rekapMain.getStatus()!=DbRekapMain.DOCUMENT_STATUS_POSTED){%>
	window.location="rekappotongangaji.jsp?hidden_periode_id=<%=periodId%>&hidden_dinas_id=<%=dinasId%>&hidden_unit_id=<%=unitId%>&menu_idx=<%=menuIdx%>";
<%}%>

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptPotonganGajiXLS?idx=<%=System.currentTimeMillis()%>");
}

function cmdClickMe(obj){
	var x = obj.value;
	//alert(x);
	if(!isNaN(x)){
		document.frmrekappotongangaji.val_temp.value=x;
	}
	obj.select();
}

function cmdBlurMe(obj, oid){
	var x = document.frmrekappotongangaji.val_temp.value;
	x = removeChar(x);
	x = cleanNumberFloat(x, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(x);
	//alert("oid : "+oid);
	
	
	
}

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

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

function cmdChange(){
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdPost(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.POST%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdAdd(){
	document.frmrekappotongangaji.hidden_rekap_main_id.value="0";
	document.frmrekappotongangaji.command.value="<%=JSPCommand.ADD%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdAsk(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.ASK%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdConfirmDelete(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.DELETE%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdSave(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.SAVE%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdEdit(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.EDIT%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdCancel(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.EDIT%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdBack(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.BACK%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListFirst(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.FIRST%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListPrev(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.PREV%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListNext(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.NEXT%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListLast(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.LAST%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmrekappotongangaji.action="rekappotongangaji_view.jsp";
	document.frmrekappotongangaji.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidRekapMain){
	document.frmimage.hidden_rekap_main_id.value=oidRekapMain;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="rekappotongangaji_view.jsp";
	document.frmimage.submit();
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Simpan 
                        Pinjam </span> &raquo; <span class="level2">Rekap Potongan 
                        Gaji <br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmrekappotongangaji" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="hidden_rekap_main_id" value="<%=oidRekapMain%>">
						  <input type="hidden" name="val_temp" value="">
                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="26" valign="middle" colspan="3" class="comment"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td colspan="2" nowrap>Daftar 
                                                  Potongan Gaji Pegawai Dinas 
                                                  / Unit 
                                                  <select name="hidden_unit_id" onChange="javascript:cmdChange()">
                                                    <%
												
												if(temp!=null && temp.size()>0){
													for(int i=0;i<temp.size();i++){
														DinasUnit du = (DinasUnit)temp.get(i);
														Dinas din = new Dinas();
														try{
															din = DbDinas.fetchExc(du.getDinasId());
														}
														catch(Exception e){
														}
														
														if(unitId==du.getOID()){
															rptKonstan.setDinas(din.getNama()+" / "+du.getNama());
														}
													%>
                                                    <option value="<%=du.getOID()%>" <%if(unitId==du.getOID()){%>selected<%}%>><%=din.getNama()+" / "+du.getNama()%></option>
                                                    <%
													}
												}
												%>
                                                  </select>
                                                </td>
                                                <td width="7%" nowrap>Tanggal 
                                                  Rekap</td>
                                                <td width="53%"> 
                                                  <input type="text" name="textfield2" value="<%=(rekapMain.getDate()!=null) ? JSPFormater.formatDate(rekapMain.getDate(), "dd MMMM yyyy") : JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>" readonly>
                                                  <%rptKonstan.setTanggal(rekapMain.getDate());%>	
												</td>
                                              </tr>
                                              <tr> 
                                                <td width="5%">Periode</td>
                                                <td width="35%"> 
                                                  <%
												Date currDatex = new Date();
												%>
                                                  <select name="hidden_periode_id" onChange="javascript:cmdChange()">
                                                    <%if(periodRekaps!=null && periodRekaps.size()>0){
														for(int i=0; i<periodRekaps.size(); i++){
															PeriodeRekap pr = (PeriodeRekap)periodRekaps.get(i);
															if(currDatex.after(pr.getStartDate())){
																if(pr.getOID()==periodId){
																	rptKonstan.setPeriode(pr.getName());
																}
													%>
                                                    <option value="<%=pr.getOID()%>" <%if(pr.getOID()==periodId){%>selected<%}%>><%=pr.getName()%></option>
                                                    <%}}}%>
                                                  </select>
                                                </td>
                                                <td width="7%">Nomor</td>
                                                <td width="53%"> 
                                                  <%
												  String  num= rekapMain.getNumber();
												  if(oidRekapMain==0){
												  	 num = DbRekapMain.getNextNumber(DbRekapMain.getNextCounter());
												  }												  
												  %>
                                                  <input type="text" name="textfield" readonly value="<%=num%>">
												  <%rptKonstan.setNomor(num);%>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td class="tablehdr" rowspan="2" width="14%">No</td>
                                                <td class="tablehdr" rowspan="2" width="14%">Nama</td>
                                                <td class="tablehdr" rowspan="2" width="13%">NIK</td>
                                                <td class="tablehdr" colspan="3">Simpanan</td>
                                                <td class="tablehdr" colspan="2">Pinjaman</td>
                                                <td class="tablehdr" rowspan="2" width="12%">Minimarket</td>
                                                <td class="tablehdr" colspan="2">Elektronik</td>
                                                <td class="tablehdr" colspan="2">Mandiri</td>
                                                <td class="tablehdr" rowspan="2" width="14%">Fasjabtel</td>
                                                <td class="tablehdr" rowspan="2" width="14%">TTP/Lain-lain</td>
                                                <td class="tablehdr" rowspan="2" width="14%">Jumlah 
                                                  Potongan</td>
                                                <td class="tablehdr" rowspan="2" width="14%">Disetujui 
                                                </td>
                                                <td class="tablehdr" rowspan="2" width="14%">Keterangan</td>
                                                <td class="tablehdr" rowspan="2" width="7%">Status</td>
                                              </tr>
                                              <tr> 
                                                <td class="tablehdr" width="13%">Pokok</td>
                                                <td class="tablehdr" width="13%">Wajib</td>
                                                <td class="tablehdr" width="11%">Sukarela</td>
                                                <td class="tablehdr" width="10%">Pokok</td>
                                                <td class="tablehdr" width="9%">Bunga</td>
                                                <td class="tablehdr" width="10%">Pokok</td>
                                                <td class="tablehdr" width="10%">Bunga</td>
                                                <td class="tablehdr" width="14%">Pokok</td>
                                                <td class="tablehdr" width="14%">Bunga</td>
                                              </tr>
                                              <%
													
													int docStatus = 0;
													double totalSimPokok = 0;
													double totalSimWajib = 0;
													double totalSimSukarela = 0;
													double totalPinPokok = 0;
													double totalPinBunga = 0;
													double totalMiniMarket = 0;
													double totalElektroPokok = 0;
													double totalElektroBunga = 0;
													double totalManPokok = 0;
													double totalManBunga = 0;
													double totalFast = 0;
													double totalTtp = 0;
													double totalJmlhPotongan = 0;
													double totalDisetujui = 0;
													
													if(members!=null && members.size()>0){
														for(int i=0; i<members.size(); i++){
														
														RekapPotonganGaji rpg = (RekapPotonganGaji)members.get(i);
														
														RptPotonganGajiL detail = new RptPotonganGajiL();
														
														docStatus = rpg.getStatusDocument();
														
														Member member = new Member();
														try{
															member = DbMember.fetchExc(rpg.getMemberId());
														}
														catch(Exception e){
														}
														
														double simPokok = rpg.getSimpananPokok();
														double simWajib  = rpg.getSimpananWajib();
														
														double total = simPokok + simWajib + rpg.getSimpananSukarela() + rpg.getPinjamanPokok() + rpg.getPinjamanBunga()+
															rpg.getMinimarket() + rpg.getElektronikPokok() + rpg.getElektronikBunga() + rpg.getMandiri() + rpg.getMandiriBunga() +
															rpg.getLainlain() + rpg.getFasjabtel();
															
													        totalSimPokok = totalSimPokok + simPokok;
															totalSimWajib = totalSimWajib + simWajib;
															totalSimSukarela = totalSimSukarela + rpg.getSimpananSukarela();
															totalPinPokok = totalPinPokok + rpg.getPinjamanPokok();
															totalPinBunga = totalPinBunga + rpg.getPinjamanBunga();
															totalMiniMarket = totalMiniMarket + rpg.getMinimarket();
															totalElektroPokok = totalElektroPokok + rpg.getElektronikPokok();
															totalElektroBunga = totalElektroBunga + rpg.getElektronikBunga();
															totalManPokok = totalManPokok + rpg.getMandiri();
															totalManBunga = totalManBunga + rpg.getMandiriBunga();
															totalFast = totalFast + rpg.getFasjabtel();
															totalTtp = totalTtp + rpg.getLainlain();
															totalJmlhPotongan = totalJmlhPotongan + total;
															totalDisetujui = totalDisetujui + rpg.getDisetujui();
															
															detail.setNama(member.getNama());
															detail.setNik(member.getNoMember());
															detail.setSimPokok(simPokok);
															detail.setSimWajib(simWajib);
															detail.setSimSukarela(rpg.getSimpananSukarela());
															detail.setPinPokok(rpg.getPinjamanPokok());
															detail.setPinBunga(rpg.getPinjamanBunga());
															detail.setMini(rpg.getMinimarket());
															detail.setElektroPokok(rpg.getElektronikPokok());
															detail.setElektroBunga(rpg.getElektronikBunga());
															detail.setManPokok(rpg.getMandiri());
															detail.setManBunga(rpg.getMandiriBunga());
															detail.setFasjabtel(rpg.getFasjabtel());
															detail.setTtp(rpg.getLainlain());
															detail.setJmlhPotongan(total);
															detail.setKeterangan(rpg.getNote());
															
															vTemp.add(detail);
														
														if(i%2==0){
													%>
                                              <tr> 
                                                <td width="14%" class="tablecell" nowrap><%=i+1%></td>
                                                <td width="14%" class="tablecell" nowrap><%=member.getNama()%></td>
                                                <td width="13%" class="tablecell"><%=member.getNoMember()%></td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(simPokok, "#,###")%> </div>
                                                </td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(simWajib, "#,###")%> </div>
                                                </td>
                                                <td width="11%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getSimpananSukarela(), "#,###")%> </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getPinjamanPokok(), "#,###")%> </div>
                                                </td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getPinjamanBunga(), "#,###")%> </div>
                                                </td>
                                                <td width="12%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getMinimarket(), "#,###")%> </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getElektronikPokok(), "#,###")%> </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getElektronikBunga(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getMandiri(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getMandiriBunga(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getFasjabtel(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getLainlain(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(total, "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getDisetujui(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="center"> <%=(rpg.getNote()==null) ? "" : rpg.getNote()%> </div>
                                                </td>
                                                <td width="7%" class="tablecell"> 
                                                  <div align="center"><%=DbRekapPotonganGaji.strStatus[rpg.getStatus()]%> </div>
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td width="14%" class="tablecell1" nowrap><%=i+1%></td>
                                                <td width="14%" class="tablecell1" nowrap><%=member.getNama()%></td>
                                                <td width="13%" class="tablecell1"><%=member.getNoMember()%></td>
                                                <td width="13%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(simPokok, "#,###")%> </div>
                                                </td>
                                                <td width="13%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(simWajib, "#,###")%> </div>
                                                </td>
                                                <td width="11%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getSimpananSukarela(), "#,###")%> </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getPinjamanPokok(), "#,###")%> </div>
                                                </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getPinjamanBunga(), "#,###")%> </div>
                                                </td>
                                                <td width="12%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getMinimarket(), "#,###")%> </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getElektronikPokok(), "#,###")%> </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getElektronikBunga(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getMandiri(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getMandiriBunga(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getFasjabtel(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getLainlain(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(total, "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(rpg.getDisetujui(), "#,###")%> </div>
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="center"> <%=(rpg.getNote()==null) ? "" : rpg.getNote()%></div>
                                                </td>
                                                <td width="7%" class="tablecell1"> 
                                                  <div align="center"><%=DbRekapPotonganGaji.strStatus[rpg.getStatus()]%> </div>
                                                </td>
                                              </tr>
                                              <%}}}%>
                                              <tr> 
                                                <td width="14%" height="21"> 
                                                  <div align="right"><b><font size="1"></font></b></div>
                                                </td>
                                                <td colspan="2" height="21" bgcolor="#E1E1E1"> 
                                                  <div align="center"><font size="1"><b>T 
                                                    O T A L :</b></font></div>
                                                </td>
                                                <td width="13%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalSimPokok, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalSimPokok(totalSimPokok);%>
                                                </td>
                                                <td width="13%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalSimWajib, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalSimWajib(totalSimWajib);%>
                                                </td>
                                                <td width="11%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalSimSukarela, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalSimSukarela(totalSimSukarela);%>
                                                </td>
                                                <td width="10%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalPinPokok, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalPinPokok(totalPinPokok);%>
                                                </td>
                                                <td width="9%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalPinBunga, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalPinBunga(totalPinBunga);%>
                                                </td>
                                                <td width="12%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalMiniMarket, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalMini(totalMiniMarket);%>
                                                </td>
                                                <td width="10%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalElektroPokok, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalElektroPokok(totalElektroPokok);%>
                                                </td>
                                                <td width="10%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalElektroBunga, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalElektroBunga(totalElektroBunga);%>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalManPokok, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalManPokok(totalManPokok);%>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalManBunga, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalManBunga(totalManBunga);%>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalFast, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalFasjabtel(totalFast);%>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalTtp, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalTtp(totalTtp);%>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalJmlhPotongan, "#,###")%></b></font></div>
												  <%rptKonstan.setTotalJmlhPotongan(totalJmlhPotongan);%>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalDisetujui, "#,###")%></b></font></div>
                                                </td>
                                                <td width="14%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><b><font size="1"></font></b></div>
                                                </td>
                                                <td width="7%" bgcolor="#E1E1E1" height="21"> 
                                                  <div align="right"><b><font size="1"></font></b></div>
                                                </td>
                                              </tr>
                                              <tr>
                                                <td width="14%">&nbsp;</td>
                                                <td colspan="3">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td colspan="3"><b>Document Status 
                                                  : </b></td>
                                                <td width="13%"><b><%=DbRekapMain.docStatus[rekapMain.getStatus()]%></b></td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="19"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="29%" valign="top"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="16%"> 
                                                              <%if(rekapMain.getOID()!=0){%>
                                                              <a href="javascript:cmdPrintXLS()"><img src="../images/print.gif" width="53" height="22" border="0"></a> 
                                                              <%}else{%>
                                                              &nbsp; 
                                                              <%}%>
                                                            </td>
                                                            <td width="29%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                      <td width="71%"> 
                                                        <table width="80%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="30%" height="21" bgcolor="#EEEEEE"> 
                                                              <div align="center"><b>Jurnal 
                                                                Detail</b></div>
                                                            </td>
                                                            <td width="34%" height="21">&nbsp;</td>
                                                            <td width="36%" height="21">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" height="21" bgcolor="#E1E1E1"><b>Keterangan</b></td>
                                                            <td width="34%" height="21" bgcolor="#E1E1E1"><b>Debet</b></td>
                                                            <td width="36%" height="21" bgcolor="#E1E1E1"><b>Kredit</b></td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Simpanan 
                                                              Diterima Pada</td>
                                                            <td width="34%" nowrap bgcolor="#E1E1E1"> 
                                                              <%
															//Vector temp = new Vector();
															if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
																
																temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_DEBET+"'", "");											
																if(temp!=null && temp.size()>0){
																	if(temp.size()>0){
																	%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																				AccLink al = (AccLink)temp.get(i);
																				Coa cx = new Coa();
																				try{
																					cx = DbCoa.fetchExc(al.getCoaId());
																				}
																				catch(Exception e){
																				}
																		  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
																		AccLink al = new AccLink();													
																		al = (AccLink)temp.get(0);
																		Coa cx = new Coa();
																		try{
																			cx = DbCoa.fetchExc(al.getCoaId());
																		}
																		catch(Exception e){
																		}
																	%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
															}else{
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(rekapMain.getSimpananCoaDebetId());
																}
																catch(Exception e){
																}
																out.println(cx.getCode()+" - "+cx.getName());
															}
															%>
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Angsuran 
                                                              Pokok Diterima Pada 
                                                            </td>
                                                            <td width="34%" nowrap bgcolor="#E1E1E1"> 
                                                              <%
											//Vector temp = new Vector();
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_ANGSURAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getAngsuranCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_ANGSURAN_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getAngsuranCoaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"><i>(Pinjaman, 
                                                              Elektronik, Mandiri) 
                                                              </i> </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" nowrap bgcolor="#E1E1E1">Pendapatan 
                                                              Bunga Diterima Pada 
                                                            </td>
                                                            <td width="34%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_BUNGA_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getBungaCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_BUNGA_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getBungaCoaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
												%>
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"><i>(Pinjaman, 
                                                              Elektronik, Mandiri) 
                                                              </i> </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Minimarket 
                                                              Diterima Pada</td>
                                                            <td width="34%" bgcolor="#E1E1E1"> 
                                                              <%	
										  if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
										  
											temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_MINIMARKET_DEBET+"'", "");											
											if(temp!=null && temp.size()>0){
												if(temp.size()>0){
												%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_MINIMARKET_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
													  		AccLink al = (AccLink)temp.get(i);
															Coa cx = new Coa();
															try{
																cx = DbCoa.fetchExc(al.getCoaId());
															}
															catch(Exception e){
															}
													  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getMinimarketCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
													AccLink al = new AccLink();													
													al = (AccLink)temp.get(0);
													Coa cx = new Coa();
													try{
														cx = DbCoa.fetchExc(al.getCoaId());
													}
													catch(Exception e){
													}
												%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_MINIMARKET_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											
										}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getMinimarketCoaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Fasjabtel 
                                                              Diterima Pada</td>
                                                            <td width="34%" bgcolor="#E1E1E1"> 
                                                              <%
											//Vector temp = new Vector();
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_FASJABTEL_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_FASJABTEL_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getFasjabtelCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_FASJABTEL_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getFasjabtelCoaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Titipan 
                                                              Diterima Pada</td>
                                                            <td width="34%" bgcolor="#E1E1E1"> 
                                                              <%
											//Vector temp = new Vector();
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_TITIPAN_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_TITIPAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getTitipanCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_TITIPAN_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getTitipanCoaDebetId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Simpanan 
                                                              Wajib</td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp;</td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_COA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getSimpananCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Simpanan 
                                                              Pokok </td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp;</td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_POKOK_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_POKOK_COA_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananPokokCoaId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_POKOK_COA_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getSimpananPokokCoaId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Simpanan 
                                                              Sukarela </td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp;</td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_SUKARELA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_SUKARELA_COA_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananSukarelaCoaId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_SUKARELA_COA_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getSimpananSukarelaCoaId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Pengurangan 
                                                              Pihutang (AR)</td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp; 
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_ANGSURAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getAngsuranCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_ANGSURAN_COA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getAngsuranCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Pendapatan 
                                                              Bunga </td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp; 
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_BUNGA_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getBungaCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_BUNGA_COA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getBungaCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Pendapatan 
                                                              Mnimarket</td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp; 
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_MINIMARKET_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_MINIMARKET_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getMinimarketCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_MINIMARKET_COA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getMinimarketCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Fasjabtel</td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp; 
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_FASJABTEL_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_FASJABTEL_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getFasjabtelCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_FASJABTEL_COA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getFasjabtelCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%" bgcolor="#E1E1E1">Titipan 
                                                              (AP)</td>
                                                            <td width="34%" bgcolor="#E1E1E1">&nbsp; 
                                                            </td>
                                                            <td width="36%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_TITIPAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_TITIPAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getTitipanCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(al.getCoaId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_TITIPAN_COA_CREDIT_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(rekapMain.getTitipanCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%">&nbsp;</td>
                                                            <td width="34%">&nbsp;</td>
                                                            <td width="36%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="30%">&nbsp;</td>
                                                            <td width="34%">&nbsp;</td>
                                                            <td width="36%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="14%">&nbsp;</td>
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                        </tr>
                                        <% 
						  }catch(Exception exc){ 
						  }%>
                                        <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                            </table>
                                            <span class="command"> </span> </td>
                                        </tr>
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                                    <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table></td>
  </tr>
</table>

                        </form>
						<%
							session.putValue("KONSTAN", rptKonstan);
							session.putValue("DETAIL", vTemp);
						%>
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
